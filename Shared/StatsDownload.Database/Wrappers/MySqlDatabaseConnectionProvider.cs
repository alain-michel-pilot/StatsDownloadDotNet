﻿namespace StatsDownload.Database.Wrappers
{
    using System.Collections.Generic;
    using System.Data;
    using System.Data.Common;
    using System.Linq;
    using Core.Interfaces;
    using MySql.Data.MySqlClient;

    // TODO: Need to finish converting DB scheme and testing with this provider
    public class MySqlDatabaseConnectionProvider : IDatabaseConnectionService
    {
        private readonly int? commandTimeout;

        private bool disposed;

        private DbConnection sqlConnection;

        public MySqlDatabaseConnectionProvider(string connectionString, int? commandTimeout = null)
        {
            // This class is instantiated by a Castle.Windsor TypedFactory. NULL is not a valid
            // argument for typed factories and is ignored. Leaving it a required parameter
            // throws an unresolved dependency exception. Marking it as optional lets be created
            // with the NULL value when that's the argument.
            sqlConnection = new MySqlConnection(connectionString);
            this.commandTimeout = commandTimeout;
        }

        public ConnectionState ConnectionState => sqlConnection.State;

        public void Close()
        {
            sqlConnection.Close();
        }

        public DbCommand CreateDbCommand()
        {
            DbCommand command = sqlConnection.CreateCommand();
            SetCommandTimeout(command);
            return command;
        }

        public DbParameter CreateParameter(string parameterName, DbType dbType, ParameterDirection direction)
        {
            using (DbCommand command = CreateDbCommand())
            {
                DbParameter parameter = command.CreateParameter();
                parameter.ParameterName = parameterName;
                parameter.DbType = dbType;
                parameter.Direction = direction;
                return parameter;
            }
        }

        public DbParameter CreateParameter(string parameterName, DbType dbType, ParameterDirection direction, int size)
        {
            using (DbCommand command = CreateDbCommand())
            {
                DbParameter parameter = command.CreateParameter();
                parameter.ParameterName = parameterName;
                parameter.DbType = dbType;
                parameter.Direction = direction;
                parameter.Size = size;
                return parameter;
            }
        }

        public DbTransaction CreateTransaction()
        {
            return sqlConnection.BeginTransaction();
        }

        public void Dispose()
        {
            if (!disposed)
            {
                sqlConnection.Dispose();
                sqlConnection = null;
                disposed = true;
            }
        }

        public DbDataReader ExecuteReader(string commandText)
        {
            using (DbCommand command = CreateDbCommand())
            {
                command.CommandText = commandText;
                return command.ExecuteReader();
            }
        }

        public object ExecuteScalar(string commandText)
        {
            using (DbCommand command = CreateDbCommand())
            {
                command.CommandText = commandText;
                return command.ExecuteScalar();
            }
        }

        public void ExecuteStoredProcedure(string storedProcedure, IEnumerable<DbParameter> parameters,
            DataTable dataTable)
        {
            using (DbCommand command = CreateStoredProcedureCommand(storedProcedure))
            {
                command.Parameters.AddRange(parameters?.ToArray() ?? new DbParameter[0]);
                using (IDataReader reader = command.ExecuteReader())
                {
                    dataTable.Load(reader);
                }
            }
        }

        public int ExecuteStoredProcedure(string storedProcedure, IEnumerable<DbParameter> parameters)
        {
            using (DbCommand command = CreateStoredProcedureCommand(storedProcedure))
            {
                command.Parameters.AddRange(parameters?.ToArray() ?? new DbParameter[0]);
                return command.ExecuteNonQuery();
            }
        }

        public int ExecuteStoredProcedure(DbTransaction transaction, string storedProcedure,
            IEnumerable<DbParameter> parameters)
        {
            using (DbCommand command = CreateStoredProcedureCommand(storedProcedure))
            {
                command.Transaction = transaction;
                command.Parameters.AddRange(parameters?.ToArray() ?? new DbParameter[0]);
                return command.ExecuteNonQuery();
            }
        }

        public int ExecuteStoredProcedure(string storedProcedure)
        {
            return ExecuteStoredProcedure(storedProcedure, (IEnumerable<DbParameter>) null);
        }

        public void ExecuteStoredProcedure(string storedProcedure, DataTable dataTable)
        {
            using (IDbCommand command = CreateStoredProcedureCommand(storedProcedure))
            using (IDataReader reader = command.ExecuteReader())
            {
                dataTable.Load(reader);
            }
        }

        public void Open()
        {
            sqlConnection.Open();
        }

        public DbCommand CreateStoredProcedureCommand(string storedProcedure)
        {
            DbCommand command = CreateDbCommand();
            command.CommandText = storedProcedure;
            command.CommandType = CommandType.StoredProcedure;
            return command;
        }

        private void SetCommandTimeout(DbCommand command)
        {
            if (commandTimeout.HasValue)
            {
                command.CommandTimeout = commandTimeout.Value;
            }
        }
    }
}
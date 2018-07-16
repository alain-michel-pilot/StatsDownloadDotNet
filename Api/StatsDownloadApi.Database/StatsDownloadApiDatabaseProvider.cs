﻿namespace StatsDownloadApi.Database
{
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Data.Common;
    using Interfaces;
    using Interfaces.DataTransfer;
    using StatsDownload.Core.Interfaces;

    public class StatsDownloadApiDatabaseProvider : IStatsDownloadApiDatabaseService
    {
        private readonly IStatsDownloadDatabaseService statsDownloadDatabaseService;

        public StatsDownloadApiDatabaseProvider(IStatsDownloadDatabaseService statsDownloadDatabaseService)
        {
            this.statsDownloadDatabaseService = statsDownloadDatabaseService ??
                                                throw new ArgumentNullException(nameof(statsDownloadDatabaseService));
        }

        public IList<DistroUser> GetFoldingUsers(DateTime startDate, DateTime endDate)
        {
            var users = new List<DistroUser>();
            statsDownloadDatabaseService.CreateDatabaseConnectionAndExecuteAction(service =>
            {
                DbParameter startDateParameter =
                    service.CreateParameter("@StartDate", DbType.Date, ParameterDirection.Input);
                DbParameter endDateParameter =
                    service.CreateParameter("@EndDate", DbType.Date, ParameterDirection.Input);

                startDateParameter.Value = startDate;
                endDateParameter.Value = endDate;

                var dataTable = new DataTable();
                service.ExecuteStoredProcedure(Constants.StatsDownloadApiDatabase.GetFoldingUsersProcedureName,
                    new[] { startDateParameter, endDateParameter },
                    dataTable);

                foreach (DataRow row in dataTable.Rows)
                {
                    users.Add(new DistroUser(row["BitcoinAddress"] as string,
                        (row["PointsGained"] as long?).GetValueOrDefault(),
                        (row["WorkUnitsGained"] as long?).GetValueOrDefault()));
                }
            });
            return users;
        }

        public bool IsAvailable()
        {
            return statsDownloadDatabaseService.IsAvailable();
        }
    }
}
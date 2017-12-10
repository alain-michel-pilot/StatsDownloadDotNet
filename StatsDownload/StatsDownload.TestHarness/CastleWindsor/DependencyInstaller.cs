﻿namespace StatsDownload.TestHarness
{
    using Castle.MicroKernel.Registration;
    using Castle.MicroKernel.SubSystems.Configuration;
    using Castle.Windsor;

    using StatsDownload.Core;

    public class DependencyInstaller : IWindsorInstaller
    {
        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Register(
                Component.For<IFileDownloadLoggingService>().ImplementedBy<TestHarnessLoggingProvider>(),
                Component.For<IDatabaseConnectionSettingsService>()
                    .ImplementedBy<TestHarnessDatabaseConnectionSettingsProvider>(),
                Component.For<IDatabaseConnectionService>().ImplementedBy<SqlDatabaseConnectionProvider>(),
                Component.For<IDatabaseConnectionServiceFactory>().ImplementedBy<SqlDatabaseConnectionProviderFactory>(),
                Component.For<IFileDownloadDataStoreService>().ImplementedBy<FileDownloadDataStoreProvider>(),
                Component.For<IFileDownloadService>().ImplementedBy<FileDownloadProvider>());
        }
    }
}
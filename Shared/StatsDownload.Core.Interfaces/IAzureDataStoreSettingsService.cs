﻿namespace StatsDownload.Core.Interfaces
{
    public interface IAzureDataStoreSettingsService
    {
        string ConnectionString { get; }

        string ContainerName { get; }
    }
}
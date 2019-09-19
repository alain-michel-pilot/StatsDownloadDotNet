﻿namespace StatsDownloadApi.Interfaces
{
    using System;

    using StatsDownloadApi.Interfaces.DataTransfer;

    public interface IStatsDownloadApiDataStoreService
    {
        FoldingUser[] GetFoldingMembers(DateTime startDate, DateTime endDate);

        Member[] GetMembers(DateTime minValue, DateTime endDate);

        Team[] GetTeams();

        bool IsAvailable();
    }
}
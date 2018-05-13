﻿namespace StatsDownload.Core
{
    using System;
    using System.Collections.Generic;
    using System.Linq;

    public class StatsUploadProvider : IStatsUploadService
    {
        private readonly IStatsUploadLoggingService loggingService;

        private readonly IStatsFileParserService statsFileParserService;

        private readonly IStatsUploadDatabaseService statsUploadDatabaseService;

        private readonly IStatsUploadEmailService statsUploadEmailService;

        public StatsUploadProvider(IStatsUploadDatabaseService statsUploadDatabaseService,
                                   IStatsUploadLoggingService loggingService,
                                   IStatsFileParserService statsFileParserService,
                                   IStatsUploadEmailService statsUploadEmailService)
        {
            if (statsUploadDatabaseService == null)
            {
                throw new ArgumentNullException(nameof(statsUploadDatabaseService));
            }

            if (loggingService == null)
            {
                throw new ArgumentNullException(nameof(loggingService));
            }

            if (statsFileParserService == null)
            {
                throw new ArgumentNullException(nameof(statsFileParserService));
            }

            if (statsUploadEmailService == null)
            {
                throw new ArgumentNullException(nameof(statsUploadEmailService));
            }

            this.statsUploadDatabaseService = statsUploadDatabaseService;
            this.loggingService = loggingService;
            this.statsFileParserService = statsFileParserService;
            this.statsUploadEmailService = statsUploadEmailService;
        }

        public StatsUploadResults UploadStatsFiles()
        {
            try
            {
                LogVerbose($"{nameof(UploadStatsFiles)} Invoked");
                if (DataStoreUnavailable())
                {
                    var results = new StatsUploadResults(FailedReason.DataStoreUnavailable);
                    loggingService.LogResults(results);
                    statsUploadEmailService.SendEmail(results);
                    return results;
                }

                List<int> uploadFiles = statsUploadDatabaseService.GetDownloadsReadyForUpload();
                var statsUploadResults = new List<StatsUploadResult>();

                foreach (int downloadId in uploadFiles)
                {
                    UploadStatsFile(statsUploadResults, downloadId);
                }

                return new StatsUploadResults(statsUploadResults);
            }
            catch (Exception exception)
            {
                var results = new StatsUploadResults(FailedReason.UnexpectedException);
                loggingService.LogException(exception);
                statsUploadEmailService.SendEmail(results);
                return results;
            }
        }

        private bool DataStoreUnavailable()
        {
            return !statsUploadDatabaseService.IsAvailable();
        }

        private void HandleFailedUsersData(int downloadId, IEnumerable<FailedUserData> failedUsersData)
        {
            if (failedUsersData.Any())
            {
                statsUploadEmailService.SendEmail(failedUsersData);
            }

            foreach (FailedUserData failedUserData in failedUsersData)
            {
                statsUploadDatabaseService.AddUserRejection(downloadId, failedUserData);
                loggingService.LogFailedUserData(downloadId, failedUserData);
            }
        }

        private void LogVerbose(string message)
        {
            loggingService.LogVerbose(message);
        }

        private StatsUploadResult NewFailedStatsUploadResult(int downloadId)
        {
            return new StatsUploadResult(downloadId, FailedReason.InvalidStatsFileUpload);
        }

        private void UploadStatsFile(List<StatsUploadResult> statsUploadResults, int downloadId)
        {
            try
            {
                LogVerbose($"Starting stats file upload. DownloadId: {downloadId}");
                statsUploadDatabaseService.StartStatsUpload(downloadId);
                string fileData = statsUploadDatabaseService.GetFileData(downloadId);
                ParseResults results = statsFileParserService.Parse(fileData);
                IEnumerable<UserData> usersData = results.UsersData;
                IEnumerable<FailedUserData> failedUsersData = results.FailedUsersData;
                HandleFailedUsersData(downloadId, failedUsersData);
                UploadUserData(downloadId, usersData);
                statsUploadDatabaseService.StatsUploadFinished(downloadId);
                LogVerbose($"Finished stats file upload. DownloadId: {downloadId}");
            }
            catch (InvalidStatsFileException)
            {
                StatsUploadResult failedStatsUploadResult = NewFailedStatsUploadResult(downloadId);
                loggingService.LogResult(failedStatsUploadResult);
                statsUploadEmailService.SendEmail(failedStatsUploadResult);
                statsUploadDatabaseService.StatsUploadError(failedStatsUploadResult);
                statsUploadResults.Add(failedStatsUploadResult);
            }
        }

        private void UploadUserData(int downloadId, IEnumerable<UserData> usersData)
        {
            foreach (UserData userData in usersData)
            {
                statsUploadDatabaseService.AddUserData(downloadId, userData);
            }
        }
    }
}
﻿namespace StatsDownload.Core
{
    using System;
    using System.Collections.Generic;

    using StatsDownload.Email;

    public class StatsDownloadEmailProvider : IStatsDownloadEmailService
    {
        private const string FileDownloadFailedSubject = "File Download Failed";

        private const string StatsUploadFailedSubject = "Stats Upload Failed";

        private const string UserDataFailedParsingSubject = "User Data Failed Parsing";

        private readonly IEmailService emailService;

        private readonly IErrorMessageService errorMessageService;

        public StatsDownloadEmailProvider(IEmailService emailService, IErrorMessageService errorMessageService)
        {
            if (emailService == null)
            {
                throw new ArgumentNullException(nameof(emailService));
            }

            if (errorMessageService == null)
            {
                throw new ArgumentNullException(nameof(errorMessageService));
            }

            this.emailService = emailService;
            this.errorMessageService = errorMessageService;
        }

        public void SendEmail(FileDownloadResult fileDownloadResult)
        {
            FailedReason failedReason = fileDownloadResult.FailedReason;

            string errorMessage = errorMessageService.GetErrorMessage(failedReason, fileDownloadResult.FilePayload);

            SendEmail(FileDownloadFailedSubject, errorMessage);
        }

        public void SendEmail(StatsUploadResult statsUploadResult)
        {
            FailedReason failedReason = statsUploadResult.FailedReason;

            string errorMessage = errorMessageService.GetErrorMessage(failedReason);

            SendEmail(StatsUploadFailedSubject, errorMessage);
        }

        public void SendEmail(StatsUploadResults statsUploadResults)
        {
            FailedReason failedReason = statsUploadResults.FailedReason;

            string errorMessage = errorMessageService.GetErrorMessage(failedReason);

            SendEmail(StatsUploadFailedSubject, errorMessage);
        }

        public void SendEmail(List<FailedUserData> failedUsersData)
        {
            string errorMessage = errorMessageService.GetErrorMessage(failedUsersData);

            SendEmail(UserDataFailedParsingSubject, errorMessage);
        }

        private void SendEmail(string subject, string body)
        {
            emailService.SendEmail(subject, body);
        }
    }
}
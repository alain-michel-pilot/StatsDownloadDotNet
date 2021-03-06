﻿namespace StatsDownload.Core.Interfaces.DataTransfer
{
    using System.Collections.Generic;

    using StatsDownload.Core.Interfaces.Enums;

    public class StatsUploadResults
    {
        public StatsUploadResults(IEnumerable<StatsUploadResult> uploadResults)
            : this(true, FailedReason.None, uploadResults)
        {
        }

        public StatsUploadResults(FailedReason failedReason)
            : this(false, failedReason, null)
        {
        }

        private StatsUploadResults(bool success, FailedReason failedReason,
                                   IEnumerable<StatsUploadResult> uploadResults)
        {
            Success = success;
            FailedReason = failedReason;
            UploadResults = uploadResults;
        }

        public FailedReason FailedReason { get; }

        public bool Success { get; }

        public IEnumerable<StatsUploadResult> UploadResults { get; }
    }
}
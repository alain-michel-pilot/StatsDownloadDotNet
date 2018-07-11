﻿namespace StatsDownloadApi.Core
{
    using System;
    using System.Collections.Generic;
    using Interfaces;
    using StatsDownload.Core.Interfaces;

    public class StatsDownloadApiProvider : IStatsDownloadApiService
    {
        private readonly IDateTimeService dateTimeService;

        private readonly IStatsDownloadApiDatabaseService statsDownloadApiDatabaseService;

        public StatsDownloadApiProvider(IStatsDownloadApiDatabaseService statsDownloadApiDatabaseService,
            IDateTimeService dateTimeService)
        {
            this.statsDownloadApiDatabaseService = statsDownloadApiDatabaseService ??
                                                   throw new ArgumentNullException(
                                                       nameof(statsDownloadApiDatabaseService));
            this.dateTimeService = dateTimeService ?? throw new ArgumentNullException(nameof(dateTimeService));
        }

        public DistroResponse GetDistro(DateTime? startDate, DateTime? endDate)
        {
            IList<DistroError> errors = new List<DistroError>();

            if (NotAbleToQueryForDistro(startDate, endDate, errors))
            {
                return new DistroResponse(errors);
            }

            return new DistroResponse(statsDownloadApiDatabaseService.GetDistroUsers(startDate.Value, endDate.Value));
        }

        private bool NotAbleToQueryForDistro(DateTime? startDate, DateTime? endDate, IList<DistroError> errors)
        {
            ValidateStartDate(startDate, errors);
            ValidateEndDate(endDate, errors);
            ValidateDatabaseIsAvailable(errors);

            return errors.Count > 0;
        }

        private void ValidateDatabaseIsAvailable(IList<DistroError> errors)
        {
            if (!statsDownloadApiDatabaseService.IsAvailable())
            {
                errors.Add(Constants.DistroErrors.DatabaseUnavailable);
            }
        }

        private void ValidateDate(DateTime? date, IList<DistroError> errors, DistroError noDate,
            DistroError dateUnsearchable)
        {
            if (date == null)
            {
                errors.Add(noDate);
                return;
            }

            if (date.Value.Date >= dateTimeService.DateTimeNow().Date)
            {
                errors.Add(dateUnsearchable);
            }
        }

        private void ValidateEndDate(DateTime? endDate, IList<DistroError> errors)
        {
            ValidateDate(endDate, errors, Constants.DistroErrors.NoEndDate, Constants.DistroErrors.EndDateUnsearchable);
        }

        private void ValidateStartDate(DateTime? startDate, IList<DistroError> errors)
        {
            ValidateDate(startDate, errors, Constants.DistroErrors.NoStartDate,
                Constants.DistroErrors.StartDateUnsearchable);
        }
    }
}
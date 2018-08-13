﻿namespace StatsDownloadApi.Core
{
    using System;
    using System.Collections.Generic;
    using Interfaces;
    using Interfaces.DataTransfer;
    using StatsDownload.Core.Interfaces;

    public class StatsDownloadApiProvider : IStatsDownloadApiService
    {
        private readonly IDateTimeService dateTimeService;

        private readonly IStatsDownloadApiDatabaseService statsDownloadApiDatabaseService;

        private readonly IStatsDownloadApiTokenDistributionService statsDownloadApiTokenDistributionService;

        public StatsDownloadApiProvider(IStatsDownloadApiDatabaseService statsDownloadApiDatabaseService,
            IStatsDownloadApiTokenDistributionService statsDownloadApiTokenDistributionService,
            IDateTimeService dateTimeService)
        {
            this.statsDownloadApiDatabaseService = statsDownloadApiDatabaseService ??
                                                   throw new ArgumentNullException(
                                                       nameof(statsDownloadApiDatabaseService));
            this.statsDownloadApiTokenDistributionService = statsDownloadApiTokenDistributionService ??
                                                            throw new ArgumentNullException(
                                                                nameof(statsDownloadApiTokenDistributionService));
            this.dateTimeService = dateTimeService ?? throw new ArgumentNullException(nameof(dateTimeService));
        }

        public GetDistroResponse GetDistro(DateTime? startDate, DateTime? endDate, int? amount)
        {
            IList<ApiError> errors = new List<ApiError>();

            if (IsNotPreparedToRunDistro(startDate, endDate, amount, errors))
            {
                return new GetDistroResponse(errors);
            }

            IList<FoldingUser> foldingMembers = GetFoldingMembers(startDate, endDate);
            IList<DistroUser> distro = GetDistro(amount, foldingMembers);

            return new GetDistroResponse(distro);
        }

        public GetMemberStatsResponse GetMemberStats(DateTime? startDate, DateTime? endDate)
        {
            IList<ApiError> errors = new List<ApiError>();

            if (IsNotPreparedToGetMemberStats(startDate, endDate, errors))
            {
                return new GetMemberStatsResponse(errors);
            }

            IList<Member> members =
                statsDownloadApiDatabaseService.GetMembers(startDate.GetValueOrDefault(),
                    endDate.GetValueOrDefault());

            return new GetMemberStatsResponse(members);
        }

        public GetTeamsResponse GetTeams()
        {
            var errors = new List<ApiError>();

            if (IsNotPreparedToGetTeams(errors))
            {
                return new GetTeamsResponse(errors);
            }

            IList<Team> teams = statsDownloadApiDatabaseService.GetTeams();

            return new GetTeamsResponse(teams);
        }

        private IList<DistroUser> GetDistro(int? amount, IList<FoldingUser> foldingUsers)
        {
            return statsDownloadApiTokenDistributionService.GetDistro(amount.GetValueOrDefault(), foldingUsers);
        }

        private IList<FoldingUser> GetFoldingMembers(DateTime? startDate, DateTime? endDate)
        {
            return statsDownloadApiDatabaseService.GetFoldingMembers(startDate.GetValueOrDefault(),
                endDate.GetValueOrDefault());
        }

        private bool IsNotPreparedToGetMemberStats(DateTime? startDate, DateTime? endDate, IList<ApiError> errors)
        {
            ValidateStartDate(startDate, errors);
            ValidateEndDate(endDate, errors);
            ValidateDateRange(startDate, endDate, errors);
            ValidateDatabaseIsAvailable(errors);

            return errors.Count > 0;
        }

        private bool IsNotPreparedToGetTeams(IList<ApiError> errors)
        {
            ValidateDatabaseIsAvailable(errors);

            return errors.Count > 0;
        }

        private bool IsNotPreparedToRunDistro(DateTime? startDate, DateTime? endDate, int? amount,
            IList<ApiError> errors)
        {
            ValidateStartDate(startDate, errors);
            ValidateEndDate(endDate, errors);
            ValidateDateRange(startDate, endDate, errors);
            ValidateAmount(amount, errors);
            ValidateDatabaseIsAvailable(errors);

            return errors.Count > 0;
        }

        private void ValidateAmount(int? amount, IList<ApiError> errors)
        {
            if (amount == null)
            {
                errors.Add(Constants.ApiErrors.NoAmount);
                return;
            }

            if (amount == 0)
            {
                errors.Add(Constants.ApiErrors.ZeroAmount);
            }

            if (amount < 0)
            {
                errors.Add(Constants.ApiErrors.NegativeAmount);
            }
        }

        private void ValidateDatabaseIsAvailable(IList<ApiError> errors)
        {
            if (!statsDownloadApiDatabaseService.IsAvailable())
            {
                errors.Add(Constants.ApiErrors.DatabaseUnavailable);
            }
        }

        private void ValidateDate(DateTime? date, IList<ApiError> errors, ApiError noDate,
            ApiError dateUnsearchable)
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

        private void ValidateDateRange(DateTime? startDate, DateTime? endDate, IList<ApiError> errors)
        {
            if (startDate > endDate)
            {
                errors.Add(Constants.ApiErrors.InvalidDateRange);
            }
        }

        private void ValidateEndDate(DateTime? endDate, IList<ApiError> errors)
        {
            ValidateDate(endDate, errors, Constants.ApiErrors.NoEndDate, Constants.ApiErrors.EndDateUnsearchable);
        }

        private void ValidateStartDate(DateTime? startDate, IList<ApiError> errors)
        {
            ValidateDate(startDate, errors, Constants.ApiErrors.NoStartDate,
                Constants.ApiErrors.StartDateUnsearchable);
        }
    }
}
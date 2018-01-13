﻿namespace StatsDownload.Email
{
    using System;
    using System.Collections.Generic;
    using System.Net;
    using System.Net.Mail;
    using System.Text;

    using StatsDownload.Logging;

    public class EmailProvider : IEmailService
    {
        private readonly IEmailSettingsValidatorService emailSettingsValidatorService;

        private readonly ILoggingService loggingService;

        private readonly IEmailSettingsService settingsService;

        public EmailProvider(
            IEmailSettingsService settingsService,
            IEmailSettingsValidatorService emailSettingsValidatorService,
            ILoggingService loggingService)
        {
            if (settingsService == null)
            {
                throw new ArgumentNullException(nameof(settingsService));
            }

            if (emailSettingsValidatorService == null)
            {
                throw new ArgumentNullException(nameof(emailSettingsValidatorService));
            }

            if (loggingService == null)
            {
                throw new ArgumentNullException(nameof(loggingService));
            }

            this.settingsService = settingsService;
            this.emailSettingsValidatorService = emailSettingsValidatorService;
            this.loggingService = loggingService;
        }

        public EmailResult SendEmail(string subject, string body)
        {
            var sb = new StringBuilder();

            try
            {
                MailAddress fromAddress = NewMailAddress(
                    settingsService.GetFromAddress(),
                    settingsService.GetFromDisplayName());

                IEnumerable<string> receivers = ParseReceivers(settingsService.GetReceivers());

                using (SmtpClient smtpClient = NewSmtpClient(sb, fromAddress))
                {
                    sb.AppendLine("Sending email:");
                    sb.AppendLine($"Subject: {subject}");
                    sb.AppendLine($"Body: {body}");
                    sb.AppendLine();

                    foreach (string address in receivers)
                    {
                        MailAddress toAddress = NewMailAddress(address);
                        SendMessage(sb, smtpClient, fromAddress, toAddress, subject, body);
                    }
                }

                LogVerbose(sb);
                return NewEmailResult();
            }
            catch (Exception ex)
            {
                LogVerbose(sb);
                LogException(ex);
                return NewEmailResult(ex);
            }
        }

        private void LogException(Exception exception)
        {
            loggingService.LogException(exception);
        }

        private void LogVerbose(StringBuilder sb)
        {
            loggingService.LogVerbose(sb.ToString());
        }

        private EmailResult NewEmailResult()
        {
            return new EmailResult();
        }

        private EmailResult NewEmailResult(Exception exception)
        {
            return new EmailResult(exception);
        }

        private MailAddress NewMailAddress(string address, string displayName)
        {
            return new MailAddress(address, displayName);
        }

        private MailAddress NewMailAddress(string address)
        {
            return new MailAddress(address);
        }

        private MailMessage NewMailMessage(MailAddress fromAddress, MailAddress toAddress, string subject, string body)
        {
            return new MailMessage(fromAddress, toAddress) { Subject = subject, Body = body };
        }

        private ICredentialsByHost NewNetworkCredential(string userName, string password)
        {
            return new NetworkCredential(userName, password);
        }

        private SmtpClient NewSmtpClient(StringBuilder sb, MailAddress fromAddress)
        {
            string host = settingsService.GetSmtpHost();
            int port = ParsePort(settingsService.GetPort());
            string password = settingsService.GetPassword();
            ICredentialsByHost credentials = NewNetworkCredential(fromAddress.Address, password);
            var deliveryMethod = SmtpDeliveryMethod.Network;
            var enableSsl = true;
            var useDefaultCredentials = false;

            sb.AppendLine("Preparing Smtp client:");
            sb.AppendLine($"Host: {host}");
            sb.AppendLine($"Port: {port}");
            sb.AppendLine($"From Address: {fromAddress}");
            sb.AppendLine($"Delivery Method: {deliveryMethod}");
            sb.AppendLine($"Enable Ssl: {enableSsl}");
            sb.AppendLine($"Use Default Credentials: {useDefaultCredentials}");
            sb.AppendLine();

            return new SmtpClient
                       {
                           Host = host, Port = port, EnableSsl = enableSsl, DeliveryMethod = deliveryMethod,
                           UseDefaultCredentials = useDefaultCredentials, Credentials = credentials
                       };
        }

        private int ParsePort(string unsafePort)
        {
            return emailSettingsValidatorService.ParsePort(unsafePort);
        }

        private IEnumerable<string> ParseReceivers(string unsafeReceivers)
        {
            return emailSettingsValidatorService.ParseReceivers(unsafeReceivers);
        }

        private void SendMessage(
            StringBuilder sb,
            SmtpClient smtpClient,
            MailAddress fromAddress,
            MailAddress toAddress,
            string subject,
            string body)
        {
            sb.AppendLine($"Sending message to {toAddress.Address}");

            using (MailMessage mailMessage = NewMailMessage(fromAddress, toAddress, subject, body))
            {
                smtpClient.Send(mailMessage);
            }
        }
    }
}
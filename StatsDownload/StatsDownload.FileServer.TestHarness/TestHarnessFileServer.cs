﻿namespace StatsDownload.FileServer.TestHarness
{
    using System;
    using System.Configuration;
    using System.IO;
    using System.Reflection;
    using System.Text;
    using System.Threading;

    public class TestHarnessFileServer : ITestHarnessFileServer
    {
        public Stream GetDecompressableFile()
        {
            var memoryStream = new MemoryStream();
            const string Decompressable = "decompressable";
            byte[] decompressableBytes = Encoding.ASCII.GetBytes(Decompressable);
            memoryStream.Write(decompressableBytes, 0, decompressableBytes.Length);
            memoryStream.Flush();
            memoryStream.Position = 0;
            return memoryStream;
        }

        public Stream GetFailDownloadFile()
        {
            throw new NotImplementedException();
        }

        public Stream GetFile()
        {
            string filePath = GetFilePath();
            return new FileStream(filePath, FileMode.Open);
        }

        public Stream GetTimeoutFile()
        {
            int sleepInSeconds = GetSleepInSeconds();
            Thread.Sleep(sleepInSeconds * 1000);
            return GetFile();
        }

        private string GetFilePath()
        {
            return ConfigurationManager.AppSettings["FilePath"]
                   ?? Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), "MockFile",
                       "TestHarnessStatsFile.txt.bz2");
        }

        private int GetSleepInSeconds()
        {
            int sleepInSeconds;
            int.TryParse(ConfigurationManager.AppSettings["SleepInSeconds"], out sleepInSeconds);
            return sleepInSeconds == 0 ? 100 : sleepInSeconds;
        }
    }
}
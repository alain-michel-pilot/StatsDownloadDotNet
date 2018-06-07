﻿namespace StatsDownload.FileDownload.Console.CastleWindsor
{
    using System.Reflection;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor.Installer;
    using Core.Extensions;

    internal static class DependencyRegistration
    {
        private static string AssemblyDirectory => Assembly.GetExecutingAssembly().GetCodebaseDirectory();

        internal static void Register()
        {
            WindsorContainer.Instance.Install(FromAssembly.InDirectory(new AssemblyFilter(AssemblyDirectory)));
        }
    }
}
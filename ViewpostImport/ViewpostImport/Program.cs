using System;
using DI_Interface;
using Riskmaster.Security;



namespace ViewpostImport
{
    class Program : ViewpostBase
    {
       
        public static UserLogin oUserLogin = null;
        public static DICommandLine arguments = null;
        static void Main(string[] args)
        {
            try
            {
                //mkaur24  VP-RM Integartion 10/25/2018 RMA-54503	

                InfoMessage = "Started with ViewPost Import of Data.";

                 arguments = new DICommandLine();
                arguments.Parse(args);

                oUserLogin = new UserLogin(sUser, sDSN, ClientId);

                if (oUserLogin.DatabaseId <= 0)
                {
                    InfoMessage = "Authentication failure";
                    Console.WriteLine("0 ^*^*^ Authentication failure.");
                    throw new Exception("Authentication failure.");
                }

                GetSystemSettings(oUserLogin);

                if (string.IsNullOrEmpty(sVPAuthToken) || string.IsNullOrEmpty(sVPApiURL) || (iVPEnable == 0))
                {
                    ExitCode = JobStatus.JOB_FAILED;
                    FatalError = ("Error encountered, missing information in Utilities settings.Please Enable Viewpost Settings.");
                }
                else
                {
                    GetVPData();

                    if  (ExitCode != JobStatus.JOB_FAILED)
                         ExitCode = JobStatus.SUCCESS;

                }
            }
            catch (Exception e)
            {
                FatalError = InfoMessage = e.Message;
                Console.WriteLine(FatalError);
                
                ExitCode = JobStatus.JOB_FAILED;

            }
            finally
            {
                CreateOutputDirectory();
                WriteLogFile();
                CreateZip();
                GetMessage();
                LogToDatabase();
                DeleteDirectory();
                WrtieFatalError();
                arguments = null;
                oUserLogin = null;
              
            }
        }

    }
}

using Microsoft.Win32;
using Riskmaster.Db;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DAapp
{
    class Generic
    {
        public static void writeLog(string p_strLogText, string path)
        {

            string sMessage = string.Format("[{0}] {1}", System.DateTime.Now.ToString(), p_strLogText);

            try
            {
                File.WriteAllText(path, sMessage);

            }
            catch (Exception exp)
            {
                throw new Exception("Error Logging Exception :" + exp.Message.ToString(), exp.InnerException);
            }

        }
        static string m_ErrMsg = string.Empty;
        static string m_OutputMsg = string.Empty;
        static string m_ProcessMessage = string.Empty;
        const string SQL_SERVER_FILTER = "SQL Server";
        const string SQL_NATIVE_CLIENT_FILTER = "SQL Native Client";
        const string SQL_SERVER_NATIVE_CLIENT_FILTER = "SQL Server Native Client";
        const string ORACLE_FILTER = "Oracle in";


        static public string ErrorMessage
        {
            get { return m_ErrMsg; }
            set { m_ErrMsg += value + "\r\n"; }
        }

        static public string OutputMessage
        {
            get { return m_OutputMsg; }
            set { m_OutputMsg += value + "\r\n"; }
        }

        static public string ProcessMessage
        {
            get { return m_ProcessMessage; }
            set { m_ProcessMessage += value + "\r\n"; }
        }
        

        public static bool VerifyConnection(string strConnString)
        {
            bool blnValidated = false;

            try
            {
                using (DbConnection dbConn = DbFactory.GetDbConnection(strConnString))
                {
                    dbConn.Open();
                    dbConn.Close();
                }


                blnValidated = true;
                DAapp.Generic.ProcessMessage = "Check DB connection for" + strConnString + ".";
            }
            catch (Exception ex)
            {
                blnValidated = false;
                DAapp.Generic.OutputMessage = "Unable to connect to Database of connection string:" + DAapp.Program.TaskManagerConnc;
                DAapp.Generic.writeLog(DAapp.Generic.OutputMessage, Path.Combine(DAapp.Program.logfilepath));
                throw;
            }

            return blnValidated;
        }
        public static string[] GetODBCDrivers()
        {
            List<string> arrFilteredDrivers = new List<string>();
            const string ODBC_DRIVERS = @"SOFTWARE\ODBC\ODBCINST.INI\ODBC Drivers";

            RegistryKey regODBCKey = Registry.LocalMachine.OpenSubKey(ODBC_DRIVERS);
            string[] arrODBCDrivers = regODBCKey.GetValueNames();

            foreach (string strODBCDriver in arrODBCDrivers)
            {
                if (strODBCDriver.Contains(SQL_SERVER_FILTER) || strODBCDriver.Contains(SQL_NATIVE_CLIENT_FILTER)
                    || strODBCDriver.Contains(SQL_SERVER_NATIVE_CLIENT_FILTER) || strODBCDriver.Contains(ORACLE_FILTER))
                {
                    arrFilteredDrivers.Add(strODBCDriver);
                } // if
            }//foreach

            return arrFilteredDrivers.ToArray();
        }

    }



   
}

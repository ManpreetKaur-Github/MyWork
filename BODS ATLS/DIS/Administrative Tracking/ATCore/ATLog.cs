using System;
using System.Collections.Generic;
using System.Text;
using System.Configuration;
using System.IO;
using rmx.DA2.At;


namespace rmx.DA2.At
{
    [CLSCompliant(true)]
             
    public class ATLog
    {
        private bool debug = false;
        private bool displayOnConsole = false;
        private bool generateLogFile = false;
        private string logFileName;
        private string logDir;
        private StreamWriter logFile;
        
        public ATLog() {}

        public void setConfig(string uniqueId, bool debugOnConsole, bool debugInLogFile, string dir)
        {

            this.displayOnConsole = debugOnConsole;
            this.generateLogFile = debugInLogFile;


            if (displayOnConsole || generateLogFile)
            {
                debug = true;
            }

            
            if (debug)

            {
                Console.WriteLine(">>>> Logging is enabled [On Screen: " + displayOnConsole + " / Generate Log File: "+ generateLogFile+"] <<<<\n");

 

                if (generateLogFile)
                {


                    checkLogDir(dir);
                    logFileName = uniqueId + ".log";
                    logFileName = logDir + "\\" + logFileName;

                    writeDebug("Log file: log\\" + logFileName);
                                        
                }

              


            }
            
        }

        public void writeDebug(string debugMsg)
        {
            if (debug)
            {
                debugMsg = ">>>>\n" + debugMsg + "\n<<<<\n";

                if (displayOnConsole)
                {
                    Console.WriteLine(debugMsg);
                }

                if (generateLogFile)
                {
                    writeFile(debugMsg);
                }
            }


        }

        public void displayError(Exception e)
        {

            writeDebug("APPLICATION ERROR:\nMESSAGE: " + e.Message + "\nDETAILS: " + e.ToString() + "\n");

        }

        private void checkLogDir(string dir)


        {
            logDir = dir;

            if (!Directory.Exists(logDir))
            { Directory.CreateDirectory(logDir); }
            
        }

        private void writeFile(string debugMsg)
        {

            try
            {
                debugMsg = debugMsg.Replace("\n", Environment.NewLine);
                logFile = new StreamWriter(logFileName, true);
                logFile.WriteLine(debugMsg);
                logFile.Close();
                

            }
            finally
            {
                logFile = null;
            }


        }

    }
}

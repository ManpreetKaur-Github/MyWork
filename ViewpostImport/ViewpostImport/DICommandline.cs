using ViewpostImport;
using System;
using Riskmaster.Security;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Riskmaster.Common;

namespace DI_Interface
{
    /// <summary>
    /// The CommandLine class works closely with the the inherited DIBase class to 
    /// automatically populate the static variables in the DIBase class from the 
    /// values passed to the calling program via the command line.
    /// </summary>
    public class DICommandLine : ViewpostBase
    {
        /// <summary>
        /// Ctor
        /// </summary>
        public DICommandLine() { }
        protected static UserLogin oUserLogin = null;
        static public UserLogin objUserLogin
        {
            get { return oUserLogin; }
            set { oUserLogin = value; }
        }

        public virtual void Parse(string[] args)
        {

            ViewpostBase.ExitCode = JobStatus.RUNNING;

            if (args.Length > 0)
            {
                ViewpostBase.JobId = args[0];
                ViewpostBase.sDSN = args[1];
                ViewpostBase.sUser = args[2];
               ViewpostBase.sPassword = args[3];
                ViewpostBase.ClientId = Convert.ToInt32(args[4]);
                //ViewpostBase.ClientId = Conversion.ConvertObjToInt(args[4],0);

            }           
        }

    }
}

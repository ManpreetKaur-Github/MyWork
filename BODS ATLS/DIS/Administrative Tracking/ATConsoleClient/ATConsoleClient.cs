using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using rmx.DA2.At;

namespace ATConsoleClient
{
    class ATConsoleClient
    {

        private ATCore objATCore;
        private string rmxConnectionString;
        
                
        static void Main(string[] args)
        {

            writeHeader();

            if (args.Length == 4)
            {

                ATConsoleClient objATConsoleClient = new ATConsoleClient();
             

                objATConsoleClient.generateJob(args);
            }
            else
            {
                Console.WriteLine("[ATConsoleClient message]");
                Console.WriteLine("The following parameters are required:\n");
                Console.WriteLine("1. TABLE_NAME");
                Console.WriteLine("2. FRIENDLY_TABLE_NAME");
                Console.WriteLine("3. PK_FIELD");
                Console.WriteLine("4. MATCHING_FIELD");

                // Pause the app
                Console.ReadKey(true);


            }
        }
        
        private void generateJob(string[] args)
        {
                        

            rmxConnectionString = "Provider=SQLOLEDB;Data Source=127.0.0.1;Initial Catalog=RMX;User Id=RMX;Password=RMX;";


            ATCore objATCore = new ATCore();

            objATCore.setRmxTableInfo(args[0], args[1], args[2], args[3]);
            objATCore.setLogInfo(true, true, "c:\\at\\logs");
            objATCore.setJobInfo("c:\\at\\jobs", "J_DIS");
            objATCore.setTemplateInfo("c:\\at\\templates", "J_DIS_AT_TEMPLATE.xml");
            objATCore.setRmxDbConfig(rmxConnectionString);

            bool result = objATCore.generateJob();

            if (result)
            { Console.Write("The job file was generated sucessfully.");

            Console.ReadKey(true);
            Environment.Exit(0);
            
            }
            else
            { Console.Write("The job file can not be generated due an error.");
            Console.ReadKey(true);
            Environment.Exit(1);
 
            }

            
 

            // Pause the app
            

        }

        private static void writeHeader()
        {
            Console.WriteLine("\nATConsoleClient starting....\n");
        }

    }
}

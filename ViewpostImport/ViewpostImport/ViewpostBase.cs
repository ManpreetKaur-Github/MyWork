using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Riskmaster.Security;
using System.Threading.Tasks;
using Riskmaster.Db;
using Riskmaster.Common;
using System.Xml.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Net;
using System.Xml;
//using System.Data.SqlClient;
using C1.C1Zip;
using System.Data;
using System.IO;
using System.Xml.Serialization;
using System.Threading;

namespace ViewpostImport
{
    public partial class ViewpostBase
    {
        static protected string sUser = string.Empty;
        static protected string sPassword = string.Empty;
        static private int m_iClientId = 0;
        static protected string sDSN = string.Empty;
        static protected string m_JobId = string.Empty;
        static protected string m_InfoMsg = string.Empty;
        static protected string sStatusMsg = string.Empty;
        static protected JobStatus m_ExitCode = JobStatus.NO_STATUS_SET;
        static protected string sConnectionString = string.Empty;
        static protected int iVPEnable = 0;
        static protected string sVPApiURL = string.Empty;
        static protected string sVPAuthToken = string.Empty;
        static protected int iCatchErr = 0;
        static protected string m_FatalError = string.Empty;
        static protected StringBuilder sSql;
        static protected string CHECK_POINT = string.Empty;
        static public string FilePath = string.Empty;
        static protected bool m_TaskManDBIsGood = false;
        static protected int errCount = 0;
        static protected string m_TaskManDBCon = string.Empty;

        static public string TaskDatabase
        {
            get { return m_TaskManDBCon; }
            set { m_TaskManDBCon = value; }
        }

        static public string FatalError
        {
            get { return m_FatalError; }
            set { m_FatalError += value + "\n"; }
        }
        static public string InfoMessage
        {
            get { return m_InfoMsg; }
            set { m_InfoMsg += value + "\n"; }
        }

        static public string StatusMsg
        {
            get { return sStatusMsg; }
            set { sStatusMsg += value + "\n"; }
        }

        public enum JobStatus
        {
            NO_STATUS_SET = -1,
            RUNNING = 2,
            SUCCESS = 3,
            JOB_FAILED = 4,
            SETUP_FAILED = 7,
            VALIDATION_FAILED = 8,
            PENDING_USER_VERIFICATION = 9
        };

        static public JobStatus ExitCode
        {
            get { return m_ExitCode; }
            set
            {
                m_ExitCode = value; Environment.ExitCode = (int)value;
            }
        }
        public static int ClientId
        {
            get { return m_iClientId; }
            set { m_iClientId = value; }
        }

        static public string ConnectionString
        {
            get { return sConnectionString; }
            set { sConnectionString = value; }
        }

        static public string JobId
        {
            get { return m_JobId; }
            set { m_JobId = value; }
        }
        public static void GetSystemSettings(UserLogin objUserLogin)
        {
            DbReader objReader = null;
            string output = string.Empty;
            sSql = new StringBuilder();
            string[] ParmName = { "RMX_VP_ENABLE", "VP_API_URL", "VP_AUTH_TOKEN" };
            try
            {
                sConnectionString = objUserLogin.objRiskmasterDatabase.ConnectionString;

                foreach (var value in ParmName)
                {
                    sSql.Remove(0, sSql.Length);
                    sSql.Append(" SELECT STR_PARM_VALUE FROM PARMS_NAME_VALUE WHERE PARM_NAME = '" + value + "'");
                    objReader = DbFactory.GetDbReader(sConnectionString, sSql.ToString());
                    if (objReader != null)
                    {
                        while (objReader.Read())
                        {
                            output = Conversion.ConvertObjToStr(objReader.GetValue(0));
                        }
                    }
                    if (value == "RMX_VP_ENABLE")
                    {
                        iVPEnable = Conversion.ConvertStrToInteger(output);
                        InfoMessage = AppConfigError((iVPEnable).ToString(), "VP_AUTH_TOKEN");
                    }
                    else if (value == "VP_API_URL")
                    {
                        sVPApiURL = output;
                        InfoMessage = AppConfigError(sVPApiURL, "VP_API_URL");
                    }
                    else if (value == "VP_AUTH_TOKEN")
                    {
                        sVPAuthToken = output;
                        InfoMessage = AppConfigError(sVPAuthToken, "VP_AUTH_TOKEN");
                    }


                }

                FilePath = GetExecutionPath();
                InfoMessage = AppConfigError(FilePath, "filepath");
                TaskDatabase = RMConfigurationManager.GetConnectionString("TaskManagerDataSource", m_iClientId);
                if (!string.IsNullOrEmpty(TaskDatabase))
                {
                    m_TaskManDBIsGood = true;
                }

            }
            catch (Exception e)
            {
                iCatchErr++;
                Console.WriteLine("0 ^*^*^ " + "Error encountered while retreiving Viewpost's settings." + e.Message);
                InfoMessage = "Error encountered while retreiving Viewpost's settings." + e.Message;
            }
        }
        public static string GetExecutionPath()
        {
            return System.IO.Path.GetDirectoryName(System.Windows.Forms.Application.ExecutablePath) + "\\";
        }
        static public string AppConfigError(string KeyValue, string keyName)
        {
            string ErrorMessage = string.Empty;

            if (string.IsNullOrEmpty(KeyValue) || KeyValue == "0")
            {
                if (keyName == "RMX_VP_ENABLE")
                    ErrorMessage = "Error:Please enable Viewpost Settings on the General System Parameters Setup to import Viewpost data.";
                ErrorMessage = "Error:Please provide the key: " + keyName + " on the General System Parameters Setup .";
            }
            else
            {
                if (keyName == "TaskDatabase")
                {
                    m_TaskManDBIsGood = true;
                    TaskDatabase = TaskDatabase.Replace("\"", "");
                }
            }
            if (!string.IsNullOrEmpty(ErrorMessage))
            {
                errCount += 1;
                ExitCode = JobStatus.JOB_FAILED;
            }

            return (ErrorMessage == null ? string.Empty : ErrorMessage);
        }


        public static void GetVPData()
        {
            XDocument xmlElem = null;
            Dictionary<string, string> Vendorpayment = null;
            XmlDocument doc = null;
            XmlNodeList elemList = null;
            HttpResponseMessage t2 = null;
            try
            {
                int Counter = 0;
                string GetPaymentReq = string.Empty;
                string CHECK_POINT = Getcheckpoint();
                if (string.IsNullOrEmpty(CHECK_POINT))
                    CHECK_POINT = "000000000000000000";
                GetPaymentReq = "<?xml version=\"1.0\"?><request xmlns = \"http://www.viewpost.com/interchange/request\" requestCreationTime=\"2013-01-15T21:32:52Z\" requestIdModifier = \"1\"><export>";
                GetPaymentReq = GetPaymentReq + "<vendorPayments checkpointToken =\"" + CHECK_POINT + "\"/></export></request>";

                xmlElem = XDocument.Parse(GetPaymentReq);
                System.Net.ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;
                using (var Client3 = new HttpClient())
                {
                    System.Net.ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;
                    Uri url1 = new Uri(sVPApiURL);

                    t2 = CallVPServiceNew("", "P", xmlElem.LastNode.ToString(), url1, 1);
                    if (t2.IsSuccessStatusCode)
                    {
                     
                        string URL2 = t2.Headers.Location.AbsoluteUri;
                        t2 = null;
                        t2 = CallVPServiceNew(URL2, "G", xmlElem.LastNode.ToString(), url1, 1);
                        if (t2.IsSuccessStatusCode)
                        {
                            string URL3 = t2.Headers.Location.AbsoluteUri;
                            t2 = null;
                            t2 = CallVPServiceNew(URL3, "G", xmlElem.LastNode.ToString(), url1, 0);
                            if (t2.IsSuccessStatusCode)
                            {
                                string dataObjects = t2.Content.ReadAsStringAsync().Result;
                                doc = new XmlDocument();
                                doc.LoadXml(dataObjects);
                                var list = doc.LastChild.LastChild;
                                foreach (XmlNode node in list)
                                {
                                    int Count = doc.GetElementsByTagName("vendorPayment").Count;
                                    if (Count != 0)
                                    {
                                        for (var i = 0; i < Count; i++)
                                        {
                                            Vendorpayment = new Dictionary<string, string>();
                                            elemList = null;

                                            elemList = doc.GetElementsByTagName("vendorPayments");
                                            Vendorpayment.Add("checkpointToken", elemList[0].Attributes["checkpointToken"].Value);

                                            elemList = doc.GetElementsByTagName("vendorPayment");
                                            Vendorpayment.Add("refId", elemList[i].Attributes["refId"].Value);
                                            Vendorpayment.Add("viewpostId", elemList[i].Attributes["viewpostId"].Value);

                                            foreach (XmlNode xlist in node.ChildNodes[i])
                                            {
                                                Vendorpayment.Add(xlist.Name, xlist.InnerText);
                                            }

                                            UpdatePaymentResp(Vendorpayment, Counter);
                                            Counter++;
                                        }
                                    }
                                    else
                                        InfoMessage = StatusMsg = "No Transactions found at Viewpost for updating the status.";
                                }
                            }
                            else
                            {
                                ExitCode = JobStatus.JOB_FAILED;
                                InfoMessage = FatalError = "Error:Response not found  while fetching Viewpost data VP's Bulk API.Reason:  " + t2.ReasonPhrase;
                            }
                        }
                        else
                        {
                            ExitCode = JobStatus.JOB_FAILED;
                            InfoMessage = FatalError = "Error:Response not found  while fetching Viewpost data VP's Bulk API.Reason:  " + t2.ReasonPhrase;
                        }
                    }
                    else
                    {
                        ExitCode = JobStatus.JOB_FAILED;
                        InfoMessage = FatalError = "Error:Response not found  while fetching Viewpost data VP's Bulk API.Reason:  " + t2.ReasonPhrase;
                        //FatalError = "Error:No Taskmanager Connection found for Error logging.";
                    }
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
                doc = null;
                Vendorpayment = null;
                elemList = null;
                xmlElem = null;
            }

        }



        public static HttpResponseMessage CallVPServiceNew(string URL, string type, string xmlElem, Uri iurl, int Call)
        {
            HttpResponseMessage response = null;
            try
            {
                using (HttpClient client = new HttpClient())
                {
                   // client.Timeout = new TimeSpan(0, 90, 0);
                   // client.DefaultRequestHeaders.Clear();
                    if (type == "P")
                    {
                        var buffer1 = System.Text.Encoding.UTF8.GetBytes(xmlElem);
                        var byteContent1 = new ByteArrayContent(buffer1);
                        byteContent1.Headers.ContentType = new MediaTypeHeaderValue("application/xml");
                        client.DefaultRequestHeaders.Add("Authorization", sVPAuthToken);
                        response = client.PostAsync(iurl, byteContent1).Result;
                        return response;
                    }
                    else
                    {
                        client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/xml"));
                        client.DefaultRequestHeaders.Add("Authorization", sVPAuthToken);
                        response = client.GetAsync(URL).Result;
                        response.EnsureSuccessStatusCode();
                        if (!response.StatusCode.Equals(HttpStatusCode.Created) && Call == 1)
                        {
                            Thread.Sleep(1000);
                            response = CallVPServiceNew(URL, "G", xmlElem, iurl, 1);
                        }
                        else
                        {
                            return response;
                        }
                    }
                }
            }
            catch (Exception e)
            {
                FatalError = InfoMessage = "Error encountered while Posting data to Viewpost:" + e.Message; ;
                Console.WriteLine(FatalError);
                ExitCode = JobStatus.JOB_FAILED;
                //iCatchErr++;
                //Console.WriteLine("0 ^*^*^ " + "Error encountered while Posting data to Viewpost:" + e.Message);
                //InfoMessage = "Error encountered while Posting data to Viewpost:" + e.Message;
                ////sResponseError = response.ReasonPhrase;
                //iErrorResp++;
                throw;
            }

            return response;
        }
        public static void UpdatePaymentResp(Dictionary<string, string> Vendorpayment, int Count)
        {
            //int status = 0;
            //int voidflag = 0;
            int iTransID = 0;
            int icodeId = 0;
            sSql = new StringBuilder();
            int iCheckPointID = 0;
            LocalCache objCache = null;


            sSql.Remove(0, sSql.Length);
            sSql.Append("SELECT MAX(CHECKPOINT_ROW_ID) FROM VP_CHECKPOINT");
            iCheckPointID = Conversion.ConvertObjToInt(DbFactory.ExecuteScalar(ConnectionString, sSql.ToString()), ClientId);
            iCheckPointID += 1;
            if (Count == 0)
            {
                sSql.Remove(0, sSql.Length);
                sSql.Append("INSERT INTO VP_CHECKPOINT (CHECK_POINT,CHECKPOINT_ROW_ID,DTTM_RCD_SENT) VALUES( '" + Vendorpayment["checkpointToken"] + "' ," + iCheckPointID + ", '" + DateTime.Now.ToString("yyyyMMddhhmmss") + "' )");
                DbFactory.ExecuteScalar(ConnectionString, sSql.ToString());
            }

            objCache = new LocalCache(ConnectionString, ClientId);
            icodeId = objCache.GetCodeId("USD", "CURRENCY_TYPE");
            //   icodeId = GetCodeId();

            //if (Vendorpayment[""].ToString().ToUpper() == "TRUE")
            //    status = 1;
            //if (Vendorpayment["markedAsVoid"].ToString().ToUpper() == "TRUE")
            //    voidflag = 1;

            /// int t= Vendorpayment["isVirtualCreditCardPayment"].ToString().ToUpper() ? 1 : 0;
            sSql.Remove(0, sSql.Length);
            sSql.Append("SELECT TRANS_ID FROM VP_PAYMENT_RESP WHERE TRANS_ID = " + Vendorpayment["refId"]);
            iTransID = Conversion.ConvertObjToInt(DbFactory.ExecuteScalar(ConnectionString, sSql.ToString()), ClientId);

            //if (iTransID == 0)
            //{
            //    sSql.Remove(0, sSql.Length);
            //    //sSql.Append("INSERT THIS " + string.IsNullOrEmpty(Vendorpayment["bankAccountRefId"].ToString()) ??  null , Vendorpayment["bankAccountRefId"]) + ",");
            //    sSql.Append("INSERT INTO VP_PAYMENT_RESP (TRANS_ID,VIEWPOST_ID,VENDOR_ID ,VENDOR_COMPANY_NAME ,BANK_ACCOUNT_ID ,PAY_TO_THE_ORDER_OF,BANK_ACCOUNT_NAME");
            //    sSql.Append(" ,ACCOUNT_NUM_LAST_FOUR, PAYMENT_DATE, CHECK_NUMBER, REFERENCE_NUMBER, CURRENCY_CODE,PAYMENT_AMOUNT, MARKED_AS_VOID"); //CHECK_MEMO_LINE_1, CHECK_MEMO_LINE_2,
            //    sSql.Append(" ,ORIGINATOR, PAYMENT_TYPE, PAYMENT_METHOD_TYPE, PAYMENT_METHOD_NAME, PAYMENT_STATUS, IS_VIRTUAL_CCARD_PAY)  VALUES (" + (Vendorpayment["refId"] == string.Empty ? null : Vendorpayment["refId"]) + ", '" + (Vendorpayment["viewpostId"] == string.Empty ? null : Vendorpayment["viewpostId"]) + "' ," + (Vendorpayment["vendorRefId"] == string.Empty ? null : Vendorpayment["vendorRefId"]));
            //    sSql.Append(", '" + (Vendorpayment["vendorCompanyName"] == string.Empty ? null : Vendorpayment["vendorCompanyName"]) + "' ," + (Vendorpayment["bankAccountRefId"] == string.Empty ? null : Vendorpayment["bankAccountRefId"]) + ", '" + (Vendorpayment["payToTheOrderOf"] == string.Empty ? null : Vendorpayment["payToTheOrderOf"]) + "','" + (Vendorpayment["bankAccountName"] == string.Empty ? null : Vendorpayment["bankAccountName"]) + "' , '" + (Vendorpayment["bankAccountNumberLastFour"] == string.Empty ? null : Vendorpayment["bankAccountNumberLastFour"]) + "',");
            //    sSql.Append("'" + (Vendorpayment["paymentDate"] == string.Empty ? null : Vendorpayment["paymentDate"]) + "','" + (Vendorpayment["checkNumber"] == string.Empty ? null : Vendorpayment["checkNumber"]) + "' ,'" + (Vendorpayment["referenceNumber"] == string.Empty ? null : Vendorpayment["referenceNumber"]) + "', " + icodeId + "," + (Vendorpayment["amount"] == string.Empty ? null : Vendorpayment["amount"]) + "," + (Vendorpayment["markedAsVoid"].ToString().ToUpper() == "TRUE" ? 1 : 0) + ","); // Vendorpayment["line1"]  Vendorpayment["line2"] + "'
            //    sSql.Append("'" + (Vendorpayment["originator"] == string.Empty ? null : Vendorpayment["originator"]) + "','" + (Vendorpayment["paymentType"] == string.Empty ? null : Vendorpayment["paymentType"]) + "','" + (Vendorpayment["paymentMethodType"] == string.Empty ? null : Vendorpayment["paymentMethodType"]) + "','" + (Vendorpayment["paymentMethodName"] == string.Empty ? null : Vendorpayment["paymentMethodName"]) + "','" + (Vendorpayment["status"] == string.Empty ? null : Vendorpayment["status"]) + "'," + (Vendorpayment["isVirtualCreditCardPayment"].ToString().ToUpper() == "TRUE" ? 1 : 0));
            //    DbFactory.ExecuteScalar(ConnectionString, sSql.ToString());

            //}

            sSql.Remove(0, sSql.Length);
            sSql.Append("UPDATE VP_HIST SET PAYMENT_STATUS = '" + Vendorpayment["status"] + "' WHERE TRANS_ID = " + Vendorpayment["refId"] + " AND CHECK_NUMBER = '" + Vendorpayment["checkNumber"] + "' ");
            DbFactory.ExecuteScalar(ConnectionString, sSql.ToString());

            StatusMsg = "Status of the Transaction sent to Viewpost.Check Number: " + Vendorpayment["checkNumber"] + ", Transaction ID: " + Vendorpayment["refId"] + ", Status: " + Vendorpayment["status"] + ", Payment Type: " + Vendorpayment["paymentType"];

            sSql.Remove(0, sSql.Length);
            string CHECK_MEMO = string.Empty;
            sSql.Append("SELECT CHECK_MEMO FROM FUNDS WHERE TRANS_ID = " + Vendorpayment["refId"] + " AND  TRANS_NUMBER = '" + Vendorpayment["checkNumber"] + "' ");
            CHECK_MEMO = Conversion.ConvertObjToStr(DbFactory.ExecuteScalar(ConnectionString, sSql.ToString()));

            if (Vendorpayment["status"].ToString().ToUpper() == "PROCESSED")
            {
                sSql.Remove(0, sSql.Length);

                sSql.Append("UPDATE FUNDS SET CLEARED_FLAG = -1 , CHECK_MEMO = '" + CHECK_MEMO + "Status:" + (Vendorpayment["status"].ToString().ToUpper()) + ".Payment Type:" + Vendorpayment["paymentType"].ToString() + "'");
                sSql.Append(" WHERE   TRANS_NUMBER = '" + Vendorpayment["checkNumber"] + "' ");
                DbFactory.ExecuteScalar(ConnectionString, sSql.ToString());
            }
            else
            {
                sSql.Remove(0, sSql.Length);

                sSql.Append("UPDATE FUNDS SET CHECK_MEMO = '" + CHECK_MEMO + "Status:" + (Vendorpayment["status"].ToString().ToUpper()) + ".Payment Type:" + Vendorpayment["paymentType"].ToString() + "'");
                sSql.Append(" WHERE TRANS_NUMBER = '" + Vendorpayment["checkNumber"] + "' ");
                DbFactory.ExecuteScalar(ConnectionString, sSql.ToString());
            }

            //if (Vendorpayment["checkNumber"] == "509")
            //{
            //    Console.Write("mkaur24");
            //}

        }

        //public static int GetCodeId()
        //{
        //    int icodeId = 0;
        //    sSql = new StringBuilder();
        //    sSql.Append("SELECT  CODE_ID FROM CODES WHERE  SHORT_CODE = 'USD'  AND TABLE_ID IN (SELECT TABLE_ID FROM GLOSSARY WHERE SYSTEM_TABLE_NAME = 'CURRENCY_TYPE')");
        //    icodeId = Convert.ToInt32(DbFactory.ExecuteScalar(ConnectionString, sSql.ToString()));
        //    return icodeId;
        //}
        public static string Getcheckpoint()
        {
            DbReader objReader = null;
            sSql = new StringBuilder();
            sSql.Append("SELECT MAX(CHECK_POINT)  FROM VP_CHECKPOINT");
            objReader = DbFactory.GetDbReader(ConnectionString, sSql.ToString());

            if (objReader != null)
            {
                while (objReader.Read())
                {
                    CHECK_POINT = Conversion.ConvertObjToStr(objReader.GetValue(0));
                }
            }
            return CHECK_POINT;
        }
        public static void GetMessage()
        {
            StringBuilder sqlQuery = new StringBuilder();
            string xml = string.Empty;
            string serr_msg = string.Empty;
            int JOB_LOG_ID = 0;
            MessageList objmsg = new MessageList();
            try
            {
                if (ExitCode == JobStatus.JOB_FAILED)
                {
                    serr_msg = InfoMessage;
                    serr_msg += "The execution of Viewpost Import batch process completed with error.";
                    serr_msg += Environment.NewLine + Environment.NewLine + "Note:In case of further details please refer the utility logs at Path:\\Riskmaster\\WCFService\\bin\\(LOGGINGPATH)\\logs.";
                }
                else
                {
                    serr_msg = InfoMessage;
                    serr_msg += "The execution of Viewpost Import data batch process completed.Please check the ViewpostImport logs for the Transaction's Status.";
                }

                string[] sOut = serr_msg.Split('\n');
                foreach (string s in sOut)
                {
                    string xml2 = string.Empty;
                    if (!string.IsNullOrEmpty(s))
                    {
                        objmsg.Message = "date=\"" + DateTime.Today.ToString("yyyMMdd") + "\"" + " time =\"" + DateTime.Now.ToString("HHmmss") + "\"" + ">" + s.Trim();
                        xml2 = GetXMLFromObject(objmsg).Replace("<?xml version=\"1.0\" encoding=\"utf-16\"?>", string.Empty).Replace("'", "''").Replace("&gt;", ">").Replace("<Message>", "<Message ");
                        xml += xml2;
                    }
                }

                xml = "<MessageList>" + xml.Replace("<MessageList>", string.Empty).Replace("</MessageList>", string.Empty) + "</MessageList>";
                if (m_TaskManDBIsGood)
                {
                    JOB_LOG_ID = GetNextUID("TM_JOB_LOG");
                    sqlQuery.Remove(0, sqlQuery.Length);
                    using (DbConnection dbConnection = DbFactory.GetDbConnection(TaskDatabase))
                    {
                        dbConnection.Open();
                        DbCommand cmdInsert = dbConnection.CreateCommand();
                        DbParameter paramFileId = cmdInsert.CreateParameter();
                        DbParameter paramJobId = cmdInsert.CreateParameter();
                        DbParameter paramFileName = cmdInsert.CreateParameter();
                        DbParameter paramFileData = cmdInsert.CreateParameter();
                        DbParameter paramContentType = cmdInsert.CreateParameter();
                        DbParameter paramLength = cmdInsert.CreateParameter();

                        cmdInsert.CommandText = "INSERT INTO TM_JOB_LOG (JOB_LOG_ID, JOB_ID, LOG_TIME,MESSAGE) VALUES " +
                                                "(~JOB_LOG_ID~, ~JobId~, ~LOGTIME~, ~MESSAGE~)";

                        paramFileId.Direction = ParameterDirection.Input;
                        paramFileId.Value = (JOB_LOG_ID);
                        paramFileId.ParameterName = "JOB_LOG_ID";
                        paramFileId.SourceColumn = "JOB_LOG_ID";
                        cmdInsert.Parameters.Add(paramFileId);

                        paramJobId.Direction = ParameterDirection.Input;
                        paramJobId.Value = int.Parse(JobId);
                        paramJobId.ParameterName = "JobId";
                        paramJobId.SourceColumn = "JOB_ID";
                        cmdInsert.Parameters.Add(paramJobId);

                        paramFileName.Direction = ParameterDirection.Input;
                        paramFileName.Value = DateTime.Now.ToString("yyyyMMddHHmmss");
                        paramFileName.ParameterName = "LOGTIME";
                        paramFileName.SourceColumn = "LOG_TIME";
                        cmdInsert.Parameters.Add(paramFileName);

                        paramFileData.Direction = ParameterDirection.Input;
                        paramFileData.Value = xml;
                        paramFileData.ParameterName = "MESSAGE";
                        paramFileData.SourceColumn = "MESSAGE";
                        cmdInsert.Parameters.Add(paramFileData);

                        cmdInsert.ExecuteNonQuery();
                    }
                }
                else
                {
                    FatalError = "No Taskmanager Connection found for Error logging.";
                }
            }
            catch (Exception e)
            {
                ExitCode = JobStatus.JOB_FAILED;
                FatalError = ("Failed to write to database due the error: " + e.Message);
            }

        }
        static public void FileToDatabase(string filePath)
        {
            FileStream stream;
            byte[] fileData;

            if (m_TaskManDBIsGood)
            {
                try
                {
                    stream = new FileStream(filePath, FileMode.Open);
                    fileData = new byte[stream.Length];
                    stream.Read(fileData, 0, (int)stream.Length);
                    stream.Close();
                }
                catch (Exception e)
                {
                    ExitCode = JobStatus.JOB_FAILED;
                    FatalError = "Failed to open " + filePath + " for inserting into task database (" + e.Message + ")";
                    return;
                }
                try
                {
                    using (DbConnection dbConnection = DbFactory.GetDbConnection(TaskDatabase))
                    {
                        dbConnection.Open();
                        DbCommand cmdInsert = dbConnection.CreateCommand();
                        DbParameter paramFileId = cmdInsert.CreateParameter();
                        DbParameter paramJobId = cmdInsert.CreateParameter();
                        DbParameter paramFileName = cmdInsert.CreateParameter();
                        DbParameter paramFileData = cmdInsert.CreateParameter();
                        DbParameter paramContentType = cmdInsert.CreateParameter();
                        DbParameter paramLength = cmdInsert.CreateParameter();

                        cmdInsert.CommandText = "INSERT INTO TM_JOBS_DOCUMENT " +
                            "(TM_FILE_ID, JOB_ID, FILE_NAME, FILE_DATA, CONTENT_TYPE, CONTENT_LENGTH) VALUES " +
                            "(~FileId~, ~JobId~, ~FileName~, ~FileData~, ~ContentType~, ~ContentLength~)";

                        paramFileId.Direction = ParameterDirection.Input;
                        paramFileId.Value = int.Parse(JobId);
                        paramFileId.ParameterName = "FileId";
                        paramFileId.SourceColumn = "TM_FILE_ID";
                        cmdInsert.Parameters.Add(paramFileId);

                        paramJobId.Direction = ParameterDirection.Input;
                        paramJobId.Value = int.Parse(JobId);
                        paramJobId.ParameterName = "JobId";
                        paramJobId.SourceColumn = "JOB_ID";
                        cmdInsert.Parameters.Add(paramJobId);

                        paramFileName.Direction = ParameterDirection.Input;
                        paramFileName.Value = GetZipName();
                        paramFileName.ParameterName = "FileName";
                        paramFileName.SourceColumn = "FILE_NAME";
                        cmdInsert.Parameters.Add(paramFileName);

                        paramFileData.Direction = ParameterDirection.Input;
                        paramFileData.Value = fileData;
                        paramFileData.ParameterName = "FileData";
                        paramFileData.SourceColumn = "FILE_DATA";
                        cmdInsert.Parameters.Add(paramFileData);

                        paramContentType.Direction = ParameterDirection.Input;
                        paramContentType.Value = "";
                        paramContentType.ParameterName = "ContentType";
                        paramContentType.SourceColumn = "CONTENT_TYPE";
                        cmdInsert.Parameters.Add(paramContentType);

                        paramLength.Direction = ParameterDirection.Input;
                        paramLength.Value = fileData.Length;
                        paramLength.ParameterName = "ContentLength";
                        paramLength.SourceColumn = "CONTENT_LENGTH";
                        cmdInsert.Parameters.Add(paramLength);

                        cmdInsert.ExecuteNonQuery();
                        /////InfoMessage = "File successfully written to Task Manager database";
                    }
                }
                catch (System.Exception e)
                {
                    ExitCode = JobStatus.JOB_FAILED;
                    FatalError = "Failed to write " + filePath + " to database due to DB error (" + e.Message + ")";
                }
                finally
                {
                    if (fileData != null)
                    {
                        fileData = null;
                    }
                }
            }
        }


        public static string GetXMLFromObject(object o)
        {
            StringWriter sw = new StringWriter();
            XmlTextWriter tw = null;
            try
            {
                XmlSerializer serializer = new XmlSerializer(o.GetType());
                tw = new XmlTextWriter(sw);
                XmlSerializerNamespaces ns = new XmlSerializerNamespaces();
                ns.Add(string.Empty, string.Empty);
                serializer.Serialize(tw, o, ns);
            }
            finally
            {
                sw.Close();
                if (tw != null)
                {
                    tw.Close();
                }
            }

            return sw.ToString();
        }
        public static int GetNextUID(string tablename)
        {
            StringBuilder sqlQuery = new StringBuilder();
            int rowID = 0;
            int nextUD = 0;
            try
            {
                sqlQuery.Append("SELECT NEXT_ID FROM TM_IDS WHERE TABLE_NAME = '" + tablename + "'");
                using (DbReader reader = DbFactory.ExecuteReader(TaskDatabase, sqlQuery.ToString()))
                {
                    if (reader.Read())
                    {
                        rowID = Conversion.ConvertObjToInt(reader.GetValue("NEXT_ID"), ClientId);
                        if (rowID == 0)
                        {
                            rowID += 1;
                            nextUD = rowID + 1;
                        }
                        else
                            nextUD = rowID + 1;
                    }
                }

                sqlQuery.Remove(0, sqlQuery.Length);
                sqlQuery.Append("UPDATE TM_IDS SET NEXT_ID = " + nextUD + " WHERE TABLE_NAME = '" + tablename + "'");
               
                DbFactory.ExecuteNonQuery(TaskDatabase, sqlQuery.ToString());
            }
            catch (Exception e)
            {
                ExitCode = JobStatus.JOB_FAILED;
                FatalError = ("Failed access Task manager DB: " + e.Message);
            }

            return rowID;
        }
        static public void LogToDatabase()
        {
            FileToDatabase(GetCompletePath() + GetZipName());
        }

        static public void CreateZip()
        {
            CreateZip(GetZipName());
        }

        static public string GetZipName()
        {
            return "ViewpostImport" + JobId.ToString().PadLeft(8, '0') + ".zip";
        }

        static public void CreateOutputDirectory()
        {
            string completedPath = string.Empty;
            try
            {
                Directory.CreateDirectory(GetCompletePath());
            }
            catch (Exception e)
            {
                ExitCode = JobStatus.JOB_FAILED;
                FatalError = "The temporary directory could not be created. ( " + e.Message + " )";
                InfoMessage = FatalError;
            }
        }

        static public void CreateZip(string filename)
        {
            int fileCount = 0;
            C1ZipFile ZipFile = null;
            try
            {
                ZipFile = new C1ZipFile(GetCompletePath() + filename);
                foreach (string file in Directory.GetFiles(GetCompletePath()))
                {
                    if (!file.EndsWith(".zip"))
                    {
                        fileCount++;
                        ZipFile.Entries.Add(file);
                    }
                }
                ZipFile.Close();

            }
            catch (System.Exception e)
            {
                ExitCode = JobStatus.JOB_FAILED;
                FatalError = "Failed to create zipped file archive. (" + e.Message + ")";
            }
            finally
            {
                if (ZipFile != null)
                {
                    ZipFile.Close();
                    ZipFile = null;
                }
            }


        }

        static public string GetCompletePath()
        {
            return FilePath + "\\" + JobId + "\\";
        }

        static public void WriteLogFile()
        {
            StreamWriter outFile;
            string srrmsg = string.Empty;
            // int count = 1;
            string message = string.Empty;
            try
            {
                if (errCount > 0)
                {
                    message = InfoMessage;
                    message += StatusMsg;
                    message += "The execution of Viewpost Import Financial data batch process completed with Error.";
                    outFile = File.CreateText(GetCompletePath() + "ViewpostImport" + "log_Completed_With_Error.csv");
                }
                else
                {
                    message = InfoMessage;
                    message += StatusMsg;
                    message += "The execution of Viewpost Import Financial data batch process completed at- " + string.Format("{0:t}", DateTime.Now) + ".";
                    outFile = File.CreateText(GetCompletePath() + "ViewpostImport" + "log_Completed.csv");
                }

                string[] sOut = message.Split('\n');
                foreach (string s in sOut)
                {
                    if (!string.IsNullOrEmpty(s))
                    {
                        // outFile.Write(count + ". " + s + Environment.NewLine);
                        outFile.Write(s + Environment.NewLine);
                    }
                }
                outFile.Close();
            }
            catch (System.Exception e)
            {
                ExitCode = JobStatus.JOB_FAILED;
                FatalError = "Error encountered while writing error file (" + e.Message + ")";
            }
        }

        static public void DeleteDirectory()
        {
            try
            {
                var dir = new DirectoryInfo(GetCompletePath());

                dir.Attributes = dir.Attributes & ~FileAttributes.ReadOnly;

                foreach (FileInfo file in dir.GetFiles())
                {
                    file.Delete();
                }

                dir.Delete(true);
            }
            catch (IOException ex)
            {
                FatalError = "Error encountered while deleting directory (" + ex.Message + ")";
            }
        }

        static public void WrtieFatalError()
        {
            StreamWriter outFile;
            string srrmsg = string.Empty;
            if (FatalError.Length > 0)
            {
                try
                {
                    ExitCode = JobStatus.JOB_FAILED;
                    Log.Write(FatalError, "ViewpostImportLog", ClientId);
                    FatalError = "The execution of ViewpostImport.exe failed.";
                    string[] sOut = FatalError.Split('\n');
                    outFile = File.CreateText(FilePath + "\\" + "ViewpostImport" + "_exe_Error" + "_" + JobId + ".txt");
                    foreach (string s in sOut)
                    {
                        if (!string.IsNullOrEmpty(s))
                        {
                            outFile.Write(s + Environment.NewLine);

                        }
                    }
                    outFile.Close();
                }
                catch (System.Exception e)
                {
                    ExitCode = JobStatus.JOB_FAILED;
                    srrmsg = "Error encountered while writing error file ( " + e.Message + " )";
                    Log.Write(srrmsg, "ViewpostImportLog", m_iClientId);
                }
            }
        }
    }
}

using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Data.SqlClient;
using System.Data.Odbc;
using System.Data.OleDb;


namespace J_POSITVE_PAY
{
    public class DataFatch
    {

        public static bool bcheckOptoinSetName(int iUser_ID, string sOptionName, string sConnectionString)
        {
            List<string> OptionNamelist =  new List<string>();
            int iNumberofOptonNames = 0;



            DI_Settings.PositivePay sh = new DI_Settings.PositivePay(sConnectionString);

            OptionNamelist = sh.PositivePay_GetOptionSetNames(_Default.iUser_Id);

            
            iNumberofOptonNames = OptionNamelist.Count;
            for (int i = 0; i < iNumberofOptonNames; i++)
            {
                if (sOptionName == OptionNamelist[i])
                {
                    return false;
                }
            }

            return true;

        }


        public static string sGetAccountName(string sTmp, string sConnectionString)
        {
            string sSql = string.Empty;
            string sAccountName = string.Empty;
            sSql = "SELECT ACCOUNT_NAME FROM ACCOUNT WHERE ACCOUNT_NUMBER = '";
            sSql = sSql + sTmp + "'";

            OleDbConnection con = new OleDbConnection(sConnectionString);
            OleDbCommand cmd = new OleDbCommand(sSql, con);
            OleDbDataReader reader;

            try
            {
                con.Open();
                reader = cmd.ExecuteReader();

                reader.Read();
                sAccountName = reader["ACCOUNT_NAME"].ToString();
                if (sAccountName != "") 
                {
                sTmp = sAccountName + " ---- " + sTmp;
                }
                else 
                {
                    sTmp = ""; 
                }
                reader.Close();

            }
            
                    catch (Exception)
            {
                sTmp = string.Empty;
                //lblResults.Text = "Error getting author. ";
                //lblResults.Text += err.Message;
            }
            finally
            {
                con.Close();
            }
            return sTmp;
        }


 
        
    
    
    }

}

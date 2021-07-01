using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Collections.Specialized;
using System.Configuration;
using System.Data;
using System.Data.Odbc;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;

namespace J_POSITVE_PAY
{
    public partial class _Default : System.Web.UI.Page
    {
        public static int iUser_Id = 50;
        public static int iOptionSetId;
        public static bool bExportfPositivePay;
        public static string sOptionName = "test6";
        public static string sConnectionString = "User Id=sa;Password=riskmaster;"
                + "Data Source=LJDANOV-2;Provider=SQLOLEDB.1;"
                + "Initial Catalog=RMXProduction";
        //"User Id=sa;Password=riskmaster;"
        //  + "Data Source=MCAPPS3-2;Provider=SQLOLEDB.1;"
        //     + "Initial Catalog=riskmaster_mec";
        //"User Id=sa;Password=riskmaster;"
        //   + "Data Source=ljdanov-2;Provider=SQLOLEDB.1;"
        //      + "Initial Catalog=rmxproduction";



        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Code here not executed when page is loaded due to an event on the page
                this.sGetAccountInfo();
                if (_Default.iOptionSetId == 0)
                {
                    this.setSetting();
                }
            }
        }




        void SetddlBankAccount(string sTmp, string sAccountID)
        {
            this.ddlBankAccount.Items.Add(new ListItem(sTmp, sAccountID));
            //this.ddlBankAccount.Items.Add(sTmp);
        }

        protected void cmdAddAccount_Click(object sender, EventArgs e)
        {
            bool bDoubleBankeAccount = false;
            string test = string.Empty;
            string test2 = string.Empty;
            Dictionary<string, string> PP_parms = new Dictionary<string, string>();

           
                //.(new ListItem(test, test2));
            //bDoubleBankeAccount = 
            //used so that the bank account will only show up 1 time in the list box
            if (ddlBankAccount.SelectedValue.Length > 0 & bDoubleBankeAccount == false)
            {
                lstBankAccount.Items.Add(ddlBankAccount.SelectedItem);//ListItem.FromString(ddlBankAccount.SelectedValue));
            }
            else
            {
                //do nothing
            }


        }

        protected void Save_Click(object sender, EventArgs e)
        {//sets the ready falg to try to extract
            bool bReady = true;
            bResetError();

            if (this.txtUserOptiont.Text.Trim() == "")
            {
                bReady = false;
                lblUserOptionName.Text = "*The User Option Name need to be filled in";
                tabOptoin.Rows[1].Visible = true;
            }

            if (bExportfPositivePay == true)
            {

                if (this.ddlBankFormat.SelectedItem.Value.Trim() == "")
                {
                    bReady = false;
                    lblBankFormattMissing.Visible = true;
                }
                if (txtTargetFileName.Text.Trim() == "")
                {
                    bReady = false;
                    lblExtractFile.Visible = true;
                }
                if (ddlBankAccount.SelectedItem.Value.Trim() == "" && lstBankAccount.Items.Count == 0)
                {
                    bReady = false;
                    lblBankAccont.Visible = true;
                }


            }
            else
            {
                if (ddlImportFileFormat.SelectedItem.Value.Trim() == "")
                {
                    bReady = false;
                    lblFileFormat.Visible = true;

                }
                if (txtFileToProcess.Text.Trim() == "")
                {
                    bReady = false;
                    lblFileToProcess.Visible = true;
                }
            }

            if (bReady == true)
            {
                this.Positivepaysave();
            }

        }


        private string sgetAccountNumber()
        {
            int iNumberofAccounts = 0;
            string sAccountNumbers= string.Empty;

            // get the number of acconts that need to be extracted and puts it in a string 
            iNumberofAccounts = lstBankAccount.Items.Count;
            if (iNumberofAccounts > 0)
            {
                
                for (int i = 0; i < iNumberofAccounts; i++)
                {
                    // check to see if you are on the last item on in the list box. 
                    if (i + 1 == iNumberofAccounts)
                    {// if on the last item them dose this 
                         
                        sAccountNumbers = sAccountNumbers + "''" + lstBankAccount.Items[i].ToString() + "''";
                    }
                    else
                    {// if not on the last item
                        sAccountNumbers = sAccountNumbers + "''" + lstBankAccount.Items[i].ToString() + "''" + ",";
                    }
                }
            }
            else
            {
                sAccountNumbers = "''" + this.ddlBankAccount.Text + "''";
            }

            return sAccountNumbers;

        }



        private void setSetting()
        {
            int iIndexTmp = 0;
            int iIndextsofAccountNumber = 0;
            string sPositivePayType = string.Empty;
            string sAccount_Number = string.Empty;
            string sTmp = string.Empty;
            Dictionary<string, string> PP_parms = new Dictionary<string, string>();
            PP_parms.Clear();

            //uses a function from the DI_SettingsHandler.dll 
            DI_Settings.PositivePay sh = new DI_Settings.PositivePay(_Default.sConnectionString);
            // if the option is a old user option then it the setting will are populated 
            txtUserOptiont.Text = _Default.sOptionName;
            //get the setting for the user option name that is going to be changed
            PP_parms = sh.PositivePay_RetrieveSettings(_Default.iUser_Id, _Default.sOptionName);
            PP_parms.TryGetValue("Positive_Pay_Type", out sPositivePayType);
            if (sPositivePayType == "EXPORT")
            {// set the fields used for the Export Positive pay 
                _Default.bExportfPositivePay = true;
                this.panImport.Visible = false;
                this.panExport.Visible = true;

                PP_parms.TryGetValue("BankFormat", out sTmp);
                // this will get the indexs form the drop down list so the user setting will be selected
                for (int i = 0; i < ddlBankFormat.Items.Count; i++)
                {
                    ddlBankFormat.SelectedIndex = i;
                    if (ddlBankFormat.SelectedItem.Value == sTmp)
                    {
                        iIndexTmp = i;
                    }
                }
                ddlBankFormat.SelectedIndex = iIndexTmp;
                PP_parms.TryGetValue("Target_File", out sTmp);
                this.txtTargetFileName.Text = sTmp;
                PP_parms.TryGetValue("Account_Number", out sAccount_Number);
                sAccount_Number = sAccount_Number.Replace("'", "");

                // used to get all the account number out of the string 
                while (sAccount_Number.Length > 0)
                {
                    iIndextsofAccountNumber = sAccount_Number.IndexOf(",", iIndextsofAccountNumber);
                    if (iIndextsofAccountNumber <= 0)
                    {// dose if the indext of , is not less then 0 
                        iIndextsofAccountNumber = 0;
                        sTmp = sAccount_Number;
                        sAccount_Number = (sAccount_Number.Remove(iIndextsofAccountNumber));

                    }
                    else
                    {
                        sTmp = sAccount_Number.Substring(iIndextsofAccountNumber);
                        sTmp = sTmp.Replace(",", "");
                        sAccount_Number = (sAccount_Number.Remove(iIndextsofAccountNumber));
                    }
                    sTmp = DataFatch.sGetAccountName(sTmp, _Default.sConnectionString);
                    lstBankAccount.Items.Add(sTmp);
                }
            }
            else
            {
                _Default.bExportfPositivePay = false;
                this.panExport.Visible = false;
                this.panImport.Visible = true;
                PP_parms.TryGetValue("AccountLen", out sTmp);

                if (sTmp == "0")
                {
                    sTmp = "10-digit Account Number";
                }
                else
                {
                    sTmp = "12-digit Account Number";
                }
                // this will get the indexs fromm the drop down list so the user setting will be selected
                for (int i = 0; i < ddlImportFileFormat.Items.Count; i++)
                {
                    ddlImportFileFormat.SelectedIndex = i;
                    if (ddlImportFileFormat.SelectedItem.Value == sTmp)
                    {
                        iIndexTmp = i;
                    }
                }
                ddlImportFileFormat.SelectedIndex = iIndexTmp;

                PP_parms.TryGetValue("Target_File", out sTmp);
                this.txtFileToProcess.Text = sTmp;

            }






        }


        public void sGetAccountInfo()
        {//used to get the account name and account number from the account table so that the drop down box will can be filled with the bank accounts

            string line = string.Empty;
            string sTmp = string.Empty;
            string sAccountName = string.Empty;
            string sAccountNumber = string.Empty;
            string sAccountID = string.Empty;
            string sSql = "SELECT * FROM ACCOUNT";


            OleDbConnection con = new OleDbConnection(_Default.sConnectionString);
            OleDbCommand cmd = new OleDbCommand(sSql, con);
            OleDbDataReader reader;

            try
            {
                con.Open();
                reader = cmd.ExecuteReader();

                while (reader.Read() == true)
                {
                    sAccountID = reader["ACCOUNT_ID"].ToString();
                    sAccountName = reader["ACCOUNT_NAME"].ToString();
                    sAccountNumber = reader["ACCOUNT_NUMBER"].ToString();
                    sTmp = sAccountName + " ---- " + sAccountNumber;
                    this.SetddlBankAccount(sTmp, sAccountID);

                }
                reader.Close();
            }
            catch (Exception)
            {

            }
            finally
            {
                con.Close();
            }
            con.Close();


        }

        protected void cmdExport_Click(object sender, EventArgs e)
        {
            this.panImport.Visible = false;
            this.panExport.Visible = true;
            _Default.bExportfPositivePay = true;
        }

        protected void cmdImport_Click(object sender, EventArgs e)
        {
            this.panExport.Visible = false;
            this.panImport.Visible = true;
            _Default.bExportfPositivePay = false;

        }

        private void Positivepaysave()
        {


            string sBankFormat = string.Empty;
            string sAccount_Number = string.Empty;
            string sAccountLen = string.Empty;
            string sFileName = string.Empty;
            string sPositivePayType = string.Empty;




            Dictionary<string, string> PP_parms = new Dictionary<string, string>();
            DI_Settings.PositivePay sh = new DI_Settings.PositivePay(_Default.sConnectionString);
            PP_parms.Clear();
            _Default.sOptionName = this.txtUserOptiont.Text;

            if (_Default.bExportfPositivePay == true)
            {//export
                sPositivePayType = "EXPORT";
                sBankFormat = this.ddlBankFormat.SelectedItem.Value;
                sAccount_Number = this.sgetAccountNumber(); // need to add the function to get the account nunmbers and out them in a string
                sFileName = this.txtTargetFileName.Text;

            }
            else
            {//Import
                sPositivePayType = "IMPORT";
                if (ddlImportFileFormat.SelectedItem.Value == "10-digit Account Number")
                {
                    sAccountLen = "0";
                }
                else
                {
                    sAccountLen = "1";
                }
                sFileName = this.txtFileToProcess.Text;
            }
            PP_parms.Add("Positive_Pay_Type", sPositivePayType);
            PP_parms.Add("AccountLen", sAccountLen);
            PP_parms.Add("BankFormat", sBankFormat);
            PP_parms.Add("Account_Number", sAccount_Number);
            // the to and from date are here for use later on
            PP_parms.Add("From_Date", "");
            PP_parms.Add("To_Date", "");
            PP_parms.Add("Target_File", sFileName);



            if (DataFatch.bcheckOptoinSetName(_Default.iUser_Id, _Default.sOptionName, _Default.sConnectionString) == true)
            {
                if (_Default.iOptionSetId == 0)
                {

                    _Default.iOptionSetId = sh.PositivePay_InsertSettings(_Default.iUser_Id, _Default.sOptionName, PP_parms);

                }

                else
                {
                    //show a message on the aspx page saying that the opton name is all ready used 
                    lblUserOptionName.Text = "*The user name is all ready used select a diffent one";
                    tabOptoin.Rows[1].Visible = true;

                }

            }
            else
            {
                _Default.iOptionSetId = sh.PositivePay_SaveSettings(_Default.iUser_Id, _Default.sOptionName, PP_parms);
            }
        }

        private bool bResetError()
        {
            tabOptoin.Rows[1].Visible = false;
            lblBankFormattMissing.Visible = false;
            lblExtractFile.Visible = false;
            lblBankAccont.Visible = false;
            lblFileFormat.Visible = false;
            lblFileToProcess.Visible = false;
            return true;
        }

    }

    }

using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using Riskmaster.BusinessAdaptor;
using Riskmaster.Models;
using Riskmaster.BusinessAdaptor.Common;
using Riskmaster.BusinessHelpers;
using System.Text.RegularExpressions;

namespace Riskmaster.UI.UI.Utilities.ToolsDesigners.TaskManager
{
    
    public partial class DIParameters : System.Web.UI.Page
    {
        private int OptionSetID; // this will be pased in from task manager.

        private const string ModuleName = "POSITIVE_PAY";

       
        // is used to see if the option set name is all ready used in the data base 

        
 



        protected void Page_Load(object sender, EventArgs e)
        {
  
           

            if (!IsPostBack)
            {
            //OptionSetID = 4;// this come from task manager just used to test right now 
            DataIntegratorModel Model = new DataIntegratorModel();
            PPAccountList AccountList = new PPAccountList();
            DataIntegratorService.DataIntegratorServiceClient GetSetting = new Riskmaster.UI.DataIntegratorService.DataIntegratorServiceClient();
                
                AccountList.Token = HttpContext.Current.Session["SessionId"].ToString();// gets the token to access to the data base 
                //gets the account information from the database and puts it in to the acount drop down box
                AccountList = GetSetting.GetAccountList(AccountList);
                PopulateAccountDropDown(AccountList);
                Model.Token = HttpContext.Current.Session["SessionId"].ToString();
                Model.ModuleName = ModuleName; //sets the moduleName 
                Model.OptionSetID = OptionSetID; //sets optsion set id
                Model =  GetSetting.RetrieveSettings(Model);// get the seeting for the UI from the data base 
                SettingUIfeilds(Model);// sets the fields in the UI
                if (Model.OptionSetID != 0)
                {
                    txtOptionSetName.Enabled = true;
                }
            }
            // makes sure that the tab selected is the one being displyaed on the screen.
             ClientScript.RegisterClientScriptBlock(this.GetType(), "anything", "document.body.onload = function(){tabChange('"+hTabName.Value+"')};", true); 
        }


        private void PopulateAccountDropDown(PPAccountList AccountList)
        { // add the a listItem for each item in accountlist to the bank account drop down box.
            for (int i=0; i < AccountList.AccountID.Count; i++)
            {          
                ddlBankAccount.Items.Add(new ListItem(AccountList.AccountNameNumber[i], AccountList.AccountID[i]));
            }
        
        }

        protected void ddlBankFormat_OnSelectedIndexChanged(object sender, EventArgs e)
        {// this make the lsbAccountName list box, the cmdAdd button and cmdDelete button visable or on visable depending on what bank format you selected.
            if (ddlBankFormat.Text =="" || ddlBankFormat.Text == "Corporate Claim" || ddlBankFormat.Text == "Wachovia" || ddlBankFormat.Text == "Northern Trust")
            {
                cmdAdd.Visible = false;
                lsbAccountName.Visible = false;
                cmdDelete.Visible = false;
            }
            else
            {
                cmdAdd.Visible = true;
                lsbAccountName.Visible = true;
                cmdDelete.Visible = true;
  
            }
        }

        private void SettingUIfeilds(DataIntegratorModel Model)
        {//set the fields in the UI based on what was in the data base.
            txtOptionSetName.Text = Model.OptionSetName;
            string sTmp = string.Empty;
            string ListItemValue = string.Empty;
            string sToDate = string.Empty;
            string sFromDate = string.Empty;
            txtOptionSetName.Text = Model.OptionSetName;

            if (Model.Parms["Positive_Pay_Type"] == "EXPORT")
            {//if the type of positive pay is expot
                List<string> AccountList = new List<string>();
                ddlBankFormat.SelectedItem.Value = Model.Parms["BankFormat"];
                txtTargetFileName.Text = Model.Parms["Target_File"];
                sTmp = Model.Parms["Account_ID"];
                //convertes the account string to a list
               sTmp = sTmp.Replace("'", "");
                AccountList = GetAccountString(sTmp);
                sFromDate = Model.Parms["From_Date"];
                if (sFromDate != "")
                {
                    fromcheckdate.Text = sFromDate.Substring(4, 2) + "/" + sFromDate.Substring(6, 2) + "/" + sFromDate.Substring(0, 4);
                }
                sToDate = Model.Parms["To_Date"];
                if (sToDate != "")
                {
                    tocheckdate.Text = sToDate.Substring(4, 2) + "/" + sToDate.Substring(6, 2) + "/" + sToDate.Substring(0, 4);
                }


                if (ddlBankFormat.Text=="" || ddlBankFormat.Text == "Corporate Claim" || ddlBankFormat.Text == "Wachovia" || ddlBankFormat.Text == "Northern Trust")
                {// the bank format only allows one account then cmdAdd, lsbaccountname and cmddelete are set tot false visible so you dont see them 
                    // and in the account list there will only be one vules so you get the accountlist indes 0 
                    ddlBankAccount.SelectedValue = AccountList[0];
                    cmdAdd.Visible = false;
                    lsbAccountName.Visible = false;
                    cmdDelete.Visible = false;

                }
                else
                {// when bank format allows more then one account
                    cmdAdd.Visible = true;
                    lsbAccountName.Visible = true;
                    cmdDelete.Visible = false;
                    foreach (string AccountID in AccountList)
                    {// takes all the items in account list and finds that vaule in ddlBankAccount then add a listItem to lsbAccountName

                        ListItemValue = ddlBankAccount.Items.FindByValue(AccountID).Text;
                        lsbAccountName.Items.Add(new ListItem(ListItemValue, AccountID));
                    }
                }
                // makes sure the right tabe is displayed screen
                 ClientScript.RegisterClientScriptBlock(this.GetType(), "anything", "document.body.onload = function(){tabChange('Export')};", true);
            }
            else
            {//if the type of positive pay is impotes 
                //if the 
                ddlFileFormat.SelectedValue = Model.Parms["AccountLen"];
                // makes sure the right tabe is diplayed on the screen 
                ClientScript.RegisterClientScriptBlock(this.GetType(), "anything", "document.body.onload = function(){tabChange('Import')};", true); 
            }



            // the to and from date are here for use later on

        }


        private List<string> GetAccountString(string AccountString)
        {//makes a list of all the number in the string ther is a , between each number
            List<string> AccountList = new List<string>();
  
            foreach (string sTmp in AccountString.Split(','))
            {
                AccountList.Add(sTmp);
            }
            return AccountList;
        }

        protected void btnSave_onClick(object sender, EventArgs e)
        {
            string sPositivePayType = string.Empty;
            string sBankFormat = string.Empty;
            string sFileName = string.Empty;
            string sAccountIds = string.Empty;
            string sAccountLen = string.Empty;
            string sToDate = string.Empty;
            string sFromDate = string.Empty;
            bool bdateFlag = true;
            bool bsaveflag = true;
            string sDateErrormessage = string.Empty;
            Models.DataIntegratorModel Model = new DataIntegratorModel();
            DataIntegratorService.DataIntegratorServiceClient SaveSetting = new Riskmaster.UI.DataIntegratorService.DataIntegratorServiceClient();

            Model.Token = HttpContext.Current.Session["SessionId"].ToString();
            Model.ModuleName = ModuleName;
            
            //OptionSetID = 4;
            Model.OptionSetID = OptionSetID;
            Model.OptionSetName = txtOptionSetName.Text;

            // sets all the lables to false
            lblOptionsSetName.Visible =false;
            lblFileFormat.Visible = false;
            lblBankAccount.Visible= false;
            lblBankFormat.Visible = false;
            lblFileToProcess.Visible = false;
            lblTargetFileName.Visible = false;
            lblDates.Visible = false;
            if (hTabName.Value == "Export")
            {//for exports 
                sPositivePayType = "EXPORT";
                sBankFormat = ddlBankFormat.SelectedItem.Text;
                if (sBankFormat == "")
                {// makes sure that a bank format is selected and if one not selected the lable is made visable and the setting will not be saved to the database 
                    lblBankFormat.Visible = true;
                    bsaveflag = false;
                }

                sFileName = txtTargetFileName.Text;
                if (sFileName == "")
                {// makes sure that a target file is selected and if one not selected the lable is made visable and the setting will not be saved to the database 
                    lblTargetFileName.Visible = true;
                    bsaveflag = false;
                }
                //format date string to yyyymmdd

                sFromDate = DateFormate(fromcheckdate.Text);


                    sToDate = DateFormate(tocheckdate.Text);
               //checks the dates
                bdateFlag = CheckDates(ref sDateErrormessage, sFromDate, sToDate);
                if (bdateFlag == false)
                {
                    lblDates.Text = sDateErrormessage;
                    lblDates.Visible = true;
                    bsaveflag = false;
                }

                // makes sure that a Account Name is selected and if one not selected the lable is made visable and the setting will not be saved to the database 
                if (lsbAccountName.Items.Count == 0 || ddlBankFormat.Text == "Corporate Claim" || ddlBankFormat.Text == "Wachovia" || ddlBankFormat.Text == "Northern Trust")
                {// if the bankformat only allows one account then the ddlbanaccount is cheacked for the account

                    if (ddlBankAccount.SelectedItem.Text != "" )
                    {
                        sAccountIds = ddlBankAccount.SelectedItem.Value;
                    }
                }
                else
                {
                    if (!checkforDoubleAccountID() && ddlBankAccount.SelectedItem.Text != "")
                    {
                        sAccountIds = ddlBankAccount.SelectedItem.Value;
                    }
                    foreach (ListItem sTmp in lsbAccountName.Items)
                    {// put the value of the itmes in lsbAccountname in to a string. the value are the account ID
                        if (sAccountIds == "")
                        {// for the 1st number in the string 
                            sAccountIds = sTmp.Value;
                            
                        }
                        else
                            {// in between each value there is a '','' the resone for this is cause in the job a a "IN" command is used 
                            // and we want the vluse to have singel qualtes arount it like this 'value' and then spirated by a , 
                            // but in SQL you have to have the extra ' or it wont work.
                                sAccountIds = sAccountIds + "'',''" + sTmp.Value;
                            }

                    }
                    
                }

                if (sAccountIds == "")
                {
                    lblBankAccount.Visible = true;
                    bsaveflag = false;
                }
                sAccountIds = "''" + sAccountIds + "''";
              }  
            
            else
            {//for import
                sPositivePayType = "IMPORT";

                sAccountLen = ddlFileFormat.SelectedItem.Value;

                if (!fulFileToProcess.HasFile)
                {// make sure a file ass been select to upload
                    lblFileToProcess.Visible = true;
                    bsaveflag = false;
                    lblFileToProcess.Text = " Please enter a file to process";
                }
                if (ddlFileFormat.SelectedItem.Text == "")
                {// makes sure a fileformat was selected
                    lblFileFormat.Visible = true;
                    lblFileToProcess.Text = "Please reupload a File to process";
                    lblFileToProcess.Visible = true;
                    bsaveflag = false;
                }
            }
            // set the vulse that will be saved database
            Model.Parms = new Dictionary<string, string>();
            Model.Parms.Add("Positive_Pay_Type", sPositivePayType);
            Model.Parms.Add("AccountLen", sAccountLen);
            Model.Parms.Add("BankFormat", sBankFormat);
            Model.Parms.Add("Account_ID", sAccountIds);
            // the to and from date are here for use later on
            Model.Parms.Add("From_Date", sFromDate);
            Model.Parms.Add("To_Date", sToDate);
            Model.Parms.Add("Target_File", sFileName);


            if (Model.OptionSetName == "")
            {// make sure the option set name is filled in. 
                lblOptionsSetName.Text = "Please enter a Options Set Name";
                lblOptionsSetName.Visible = true;
              
            }
            else
            {
                 if (Model.Parms["Positive_Pay_Type"] == "IMPORT")
                 {
                     if (Model.OptionSetID == 0)
                     {
                         Model.OptionSetID = SaveSetting.SaveSettings(Model);
                     }
                        if (Model.OptionSetID != -1 && bsaveflag == true)
                        {
                            sFileName = Filetoupload(Model.OptionSetID);
                            if (sFileName == "")
                            {
                                lblFileToProcess.Visible = true;
                                lblFileToProcess.Text = "File need to be have txt extension";
                                bsaveflag = false;
                            }
                            Model.Parms["Target_File"] = sFileName;
                        }
                     

                 }
                 if (Model.OptionSetID != -1 && bsaveflag == true)
                {// if optionsetId is not -1 then we have save it
                    Model.OptionSetID = SaveSetting.SaveSettings(Model);
                }
                if (Model.OptionSetID == -1)
                {//makse sure the optionset name is not all ready used
                    lblOptionsSetName.Text = "Sorry Option Set Name is all ready used";
                    lblOptionsSetName.Visible = true;
                }
                if( bsaveflag == true)
                    // make that all the field that need to be filed in are.
                {//set the opstion set ID that is passed to task Manager
                    OptionSetID = Model.OptionSetID;
                }
            }
        }

        protected void cmdAdd_onClick(object sender, EventArgs e)
        {// at the selected item in the drop down box to the list box and make sure there not doubles
            
                if (!checkforDoubleAccountID() && ddlBankAccount.Text != "")
            {
                lsbAccountName.Items.Add(new ListItem(ddlBankAccount.SelectedItem.Text, ddlBankAccount.SelectedItem.Value));
            }
        }

        private bool checkforDoubleAccountID()
        {  
            foreach(ListItem List in lsbAccountName.Items)

                if (List.Value == ddlBankAccount.SelectedValue)
                {
                    return true;
                }

            return false;
        }

        private string Filetoupload(int OptionSetID)
        {//uploade the import file to the folder.
            string file = string.Empty;
            if (fulFileToProcess.HasFile)
            {

                string filepath = fulFileToProcess.PostedFile.FileName;;
                string pat = @"\\(?:.+)\\(.+)\.(.+)";
                Regex r = new Regex(pat);
                //run
                Match m = r.Match(filepath);

                string file_ext = m.Groups[2].Captures[0].ToString();
                 file = "PP" + OptionSetID + "." + file_ext;

                 if (file_ext.ToLower() == "txt")
                 {
                     //save the file to the server 
                     fulFileToProcess.SaveAs("C:\\Documents and Settings\\Administrator\\Desktop\\test\\" + file);
                     return file;
                 }
                 else
                 {
                     file = "";
                 }
            }
            return file;
           
        }

        protected void cmdDelete_onClick(object sender, EventArgs e)
        {//deletes item from the list box.
            if (lsbAccountName.SelectedIndex != -1)
            {
                lsbAccountName.Items.Remove(new ListItem(lsbAccountName.SelectedItem.Text, lsbAccountName.SelectedItem.Value));
            }
        }

        private bool CheckDates(ref string sDateErrormessage, string sFromDate, string sToDate)
        {

                if (sFromDate == "" && sToDate == "")
                {
                    sDateErrormessage = "Please Add From Date and To Date ";
                    return false;
                }
                else if (sFromDate != "" && sToDate != "")
                {
                    if (sToDate.CompareTo(sFromDate) < 0)
                    {
                        sDateErrormessage = "The To Date Need to be grater then the From Date";
                        return false;
                    }

                }
                else
                {
                    if (sFromDate == "")
                    {
                        sDateErrormessage = "Please add a From Date";
                        return false;
                    }
                    if (sToDate == "")
                    {
                        sDateErrormessage = "Please add a To Date";
                        return false;
                    }
                }
            return true;
        }

        private string DateFormate(string sDate)
        {
            int sDateLen;
            string formatedDate = string.Empty;
            sDateLen = sDate.Length;
            // the foreach looks at each part of and make sure it has the right nnumber og digites 
            if (sDate != "")
            {
                foreach (string sTmp in sDate.Split('/'))
                {
                    if (sTmp.Length == 4)// used for the date
                    {
                        formatedDate = sTmp + formatedDate;
                    }
                    else if (sTmp.Length < 2)
                    {
                        formatedDate = formatedDate + 0 + sTmp;
                    }
                    else
                    {
                        formatedDate = formatedDate + sTmp;
                    }
                }
            }
            return formatedDate;
        }
    }


    
}

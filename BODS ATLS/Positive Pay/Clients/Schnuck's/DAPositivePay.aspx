<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DAPositivePay.aspx.cs" Inherits="Riskmaster.UI.UI.Utilities.ToolsDesigners.TaskManager.DIPositivePay" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>
<%@ Register Src="~/UI/Shared/Controls/PleaseWaitDialog.ascx" TagName="PleaseWaitDialog"
    TagPrefix="uc" %>
<%@ Register TagPrefix="uc1" TagName="ErrorControl" Src="~/UI/Shared/Controls/ErrorControl.ascx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">


<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Positive Pay</title>
    <link rel="stylesheet" href="../../../../Content/rmnet.css" type="text/css" />
    <link rel="stylesheet" href="../../../../Content/zpcal/themes/system.css" type="text/css" />
    <script type="text/javascript" language="JavaScript" src="../../../../Scripts/form.js"></script>
    <script src="../../../../Scripts/zapatec/utils/zapatec.js" type="text/javascript"></script>
    <script type="text/javascript" language="JavaScript" src="../../../../Scripts/utilities.js"></script>
    <script type="text/javascript" src="../../../../Scripts/zapatec/zpcal/src/calendar.js">        { var i; }
</script>
    <script type="text/javascript" src="../../../../Scripts/zapatec/zpcal/lang/calendar-en.js">        { var i; }
</script>

    <script type="text/javascript" src="../../../../Scripts/zapatec/zpgrid/src/zpgrid.js">        { var i; }
	</script>
    <script type="text/javascript" src="../../../../Scripts/zapatec/zpgrid/src/zpgrid-xml.js">        { var i; }
	</script>
    <script type="text/javascript" src="../../../../Scripts/zapatec/zpgrid/src/zpgrid-editable.js">        { var i; }
	</script>
    <script type="text/javascript" src="../../../../Scripts/zapatec/zpgrid/src/zpgrid-query.js">        { var i; }
	</script>
 <script type="text/javascript" language="JavaScript" src="../../../../Scripts/DataIntegrator.js"></script>
 <script type="text/javascript" language="JavaScript" src="../../../../Scripts/form.js"></script>
<script type="text/javascript" language="JavaScript" src="../../../../Scripts/TMSettings.js"></script>
    <style type="text/css">
        .style1
        {
            text-align: right;
            width: 165px;
            height: 25px;
        }
        .style2
        {
            text-align: left;
            width: 150px;
            height: 25px;
        }
        .style4
        {
            width: 29px;
        }
        .style5
        {
            text-decoration: underline;
        }
        .style6
        {
            width: 677px;
            height: 225px;
        }
        .style7
        {
            text-align: left;
            width: 271px;
            height: 25px;
        }
        .style8
        {
            width: 271px;
            height: 87px;
        }
        .style10
        {
            text-align: left;
            width: 271px;
        }
        .style12
        {
            text-align: left;
            width: 271px;
            height: 27px;
        }
        .style13
        {
            height: 27px;
        }
        .style14
        {
            height: 87px;
        }
        .style15
        {
            text-align: right;
            width: 165px;
            height: 3px;
        }
        .style16
        {
            height: 3px;
        }
        .style17
        {
            height: 225px;
        }
        #FORMTABExport
        {
            height: 239px;
            width: 488px;
        }
        .style18
        {
            text-align: right;
            width: 165px;
            height: 27px;
        }
    </style>
</head>
<body class="10pt" id="pageBody" runat="server">
    <form id="frmData" runat="server" method="post">
   <table width="100%" border="0" cellspacing="0" cellpadding="4">
        <tr>
            <td colspan="2">
              <uc1:ErrorControl ID="ErrorControl1" runat="server" />
            </td>
        <tr height="10">
            <td>
            </td>
        </tr>
    </table>
    <div>
        <asp:HiddenField ID="hTabName" runat="server" />
        <br />
        <div class="msgheader" id="formtitle">
            Positive Pay Optionset</div>
        <div class="errtextheader">
        </div>
        <table>
           
        </table>
        <table border="0">
            <tr>
                <td>
                    <table border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td class="Selected" nowrap="true" name="TABSExport" id="TABSExport" >
                                <a class="Selected" href="#" onclick="tabChange(this.name);return false;" name="Export" id="LINKTABSExport">
                                    <span style="text-decoration: none">Export</span></a>&nbsp;
                            </td>
                            <td nowrap="true" style="border-bottom: none; border-left: none; border-right: none;
                                border-top: none;">
                                &nbsp;&nbsp;
                            </td>
                            <td class="NotSelected" nowrap="true" name="TABSImport" id="TABSImport">
                                <a class="NotSelected1" href="#" onclick="tabChange(this.name);return false;" name="Import" id="LINKTABSImport">
                                    <span style="text-decoration: none">Import</span></a>
                            </td>
                            <td nowrap="true" style="border-bottom: none; border-left: none; border-right: none;
                                border-top: none;">
                                &nbsp;&nbsp;
                            </td>
                            <td valign="top" nowrap="true">
                            </td>
                        </tr>
                    </table>
                    <div class="singletopborder" style="position: relative; left: 0px; top: -2px; width: 693px;
                        height: 294px; overflow: auto">
                        <table border="0" cellspacing="0" cellpadding="0" 
                            style="height: 255px; width: 686px">
                            <tr>
                                <td class="style6" style=" vertical-align: top; padding-top:25px;">
                                    <table border="0" cellspacing="0" cellpadding="0" name="FORMTABExport" id="FORMTABExport">
                                       <tr id="Tr2">
                <td class="style1">
                    <span class="style5"><u>Optionset Name:</u></span>&nbsp;&nbsp;
                </td>
                <td class="style2">
                    <asp:TextBox size="30" TabIndex="2" ID="txtExportOptionSetName" MaxLength="50" runat="server"
                        Width="263px" />
                </td>
                <td>
                </td>
            </tr>
                                        <tr id="">
                                            <asp:TextBox Style="display: none" ID="RowId" type="id" runat="server" />
                                            <td class="style1">
                                                <span class="style5"><u>Bank Format:</u></span>&nbsp;&nbsp;
                                            </td>
                                            <td class="style10">
                                                <div title="" style="padding: 0px; margin: 0px">
                                                    <asp:DropDownList ID="ddlBankFormat" runat="server" Height="21px"  Width="270px" TabIndex="3" Enabled="True"
                                                        AutoPostBack="true" OnSelectedIndexChanged="ddlBankFormat_OnSelectedIndexChanged">
                                                        <asp:ListItem Value=""></asp:ListItem>
                                                        <asp:ListItem>Bank of America East Cost</asp:ListItem>
                                                        <asp:ListItem>Bank of America East Cost 12 Digit Account Number</asp:ListItem>
                                                        <asp:ListItem>Corporate Claim</asp:ListItem>
                                                        <asp:ListItem>Comerica</asp:ListItem>
                                                        <asp:ListItem>Key Bank</asp:ListItem>
                                                        <asp:ListItem>M and T Bank</asp:ListItem>
                                                        <asp:ListItem>Wachovia</asp:ListItem>
                                                        <asp:ListItem>WachoviaALT</asp:ListItem>
                                                        <asp:ListItem>Northern Trust</asp:ListItem>
                                                        <asp:ListItem>Sun Trust</asp:ListItem>
                                                        <asp:ListItem>US bank</asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>
                                            </td>
                                            <td>
                                                &nbsp;&nbsp;
                                                                                            
                                            </td>

                                        
                                        </tr>
  
                                        
                                          <tr>
                                           <td class="style1">
                                                                                              &nbsp;&nbsp; </td>
                                            <td>
                                                <asp:CheckBox ID="ckbManually" runat="server" Text="Manually Change Date Range"  />
                                            
                                            &nbsp; </td>
                                        </tr>
  
                                        
                                          <tr>
                                        <td class="style15">
                                            <span>Check Range From Date</span>&nbsp;&nbsp;
                                        </td>
                                              <td class="style16">
                    <span class="formw"> 
                  <asp:TextBox runat="server" FormatAs="date" id="fromcheckdate"
                                                RMXType="date" tabindex="4" onchange="setDataChanged(true);" 
                                                 Width="66px"/>
                  <asp:button class="DateLookupControl" runat="server" id="fromcheckdatebtn" 
                      tabindex="5" Height="16px"/>
                  <script type="text/javascript">
                      Zapatec.Calendar.setup(
					{
					    inputField: "fromcheckdate",
					    ifFormat: "%m/%d/%Y",
					    button: "fromcheckdatebtn"
					}
					);
				</script>
                	 </span>&nbsp;&nbsp;
                	 <span>To Date:</span>&nbsp;&nbsp;
                	                <span class="formw"> 
                  <asp:TextBox runat="server" FormatAs="date" id="tocheckdate"
                                                RMXType="date" tabindex="6" onchange="setDataChanged(true);" 
                                                Width="66px" />
                  <asp:button class="DateLookupControl" runat="server" id="tocheckdatebtn" 
                      tabindex="7" Height="16px"   />
                  <script type="text/javascript">
                      Zapatec.Calendar.setup(
					{
					    inputField: "tocheckdate",
					    ifFormat: "%m/%d/%Y",
					    button: "tocheckdatebtn"
					}
					);
				</script>
                </span>       
                   </td>
                   <td class="style16"> &nbsp;&nbsp;
     
                   </td>
                                                                                                 
                                        </tr>
                                        <tr id="">
                                            <td class="style1">
                                                <span class="style5"><u>Target File Name:</u></span>&nbsp;&nbsp;
                                            </td>
                                            <td class="style7">
                                                <asp:TextBox size="30" TabIndex="8" ID="txtTargetFileName" MaxLength="50" runat="server"
                                                    Width="263px" />
                                            </td>
                                            <td>
                                                &nbsp;&nbsp;
                                                </td>
                                        </tr>
                                        <tr id="">
                                            <td class="style18">
                                                <span class="style5"><u>Bank Account:</u></span>&nbsp;&nbsp;
                                            </td>
                                            <td class="style12">
                                                <div title="" style="padding: 0px; margin: 0px">
                                                    <asp:DropDownList ID="ddlBankAccount" type="combobox" runat="server" AutoPostBack="false"
                                                        Height="22px" maxlength="50" Width="270px" TabIndex = "8">
                                                        <asp:ListItem Text="" Value = "0"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>
                                            </td>
                                            <td class="style13">
                                                <asp:Button ID="cmdAdd" Text="Add" class="button" Visible="false" runat="server"
                                                    OnClick="cmdAdd_onClick" Height="19px" Width="38px" TabIndex = "9" />
                                            </td>
                                        </tr>
                                        <tr id="">
                                            <td class="style14">
                                            </td>
                                            <td class="style8">
                                                <asp:ListBox ID="lsbAccountName" runat="server" Width="270px" Visible="false" 
                                                    Style="margin-right: 0px" Height="105px" TabIndex = "10">
                                                </asp:ListBox>
                                            </td>
                                            <td style ="vertical-align:bottom;" class="style14">
                                         <asp:ImageButton ID="btnDelete" runat="server" ImageUrl="~/Images/240.GIF"                                                                  
                                          onclick="btnDelete_Click" Height="16px" style="margin-top: 0px" Width="19px" />        
                                            </td>
                                        </tr>
                                    </table>
            
                                    <table border="0" cellspacing="0" cellpadding="0" name="FORMTABImport" id="FORMTABImport"
                                        style="display: none;" >
                                         <tr id="Tr3">
                <td class="style1">

                    <span class="style5"><u>Optionset Name:</u></span>&nbsp;&nbsp;
                </td>
                <td class="style2">
                    <asp:TextBox size="30" TabIndex="2" ID="txtImportOptionsetName" MaxLength="50" runat="server"
                        Width="263px"/>
                </td>
                <td>
                </td>
            </tr>
                                        <tr id="Tr1">
                                            <td class="style1">
                                                <u>File Format</u>:&nbsp;&nbsp;
                                            </td>
                                            <td>
                                                <div title="" style="padding: 0px; margin: 0px">
                                                    <asp:DropDownList ID="ddlFileFormat" type="combobox" runat="server" Width="270px" TabIndex = "3">
                                                        <asp:ListItem  Text ="" Value=""></asp:ListItem>
                                                        <asp:ListItem Value="0">10-digit Account Number</asp:ListItem>
                                                        <asp:ListItem Value="1">12-digit Account Number</asp:ListItem>
                                                    </asp:DropDownList>
                                                </div>
                                            </td>
                                            <td>
                                              </td>
                                        </tr>
                                        <tr id="">
                                            <td class="style1">
                                                <u>File To Process:</u>&nbsp;&nbsp;
                                            </td>
                                            <td class="style2">
                                                <div title="" style="padding: 0px; margin: 0px">
                                                    <asp:FileUpload ID="fulFileToProcess"  runat="server"  Width ="270" TabIndex = "4"/>
 
                                                </div>
                                            </td>
                                            <td>
                                           </td>
                                        </tr>
                                    </table>
                                </td>
                                <td valign="top" class="style17">
                                </td>
                            </tr>
                        </table>
                    </div>
                    <table style="width: 202px; height: 30px">
                        <div>
                            <tr>
                                <td class="style4">
                                 <asp:Button ID="btnSave" Text="Save" class="button" runat="server"  OnClientClick = "Validatefields(); return false;"
                                        Height="20px" Width="36px" TabIndex = "12" />
    
                                </td>
                                <td>
                                    &nbsp;
                                    <asp:Button ID="btnCancel" Text="Cancel" class="button" OnClientClick="OnCancel();return false;"
                                        runat="server" Height="20px" Width="62px"  TabIndex = "13"/>
                                </td>
                            </tr>
                        </div>
                    </table>
                </td>
            </tr>
        </table>
    </div>
    <asp:HiddenField ID="hdTaskManagerXml" runat="server" />
    <asp:HiddenField ID="hdOptionsetId" runat="server" />
    <asp:HiddenField ID="hdnaction" runat="server" />
   </form>
</body>
</html>

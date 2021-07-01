<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="J_POSITVE_PAY._Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <link href="dhtml-div.css" rel="stylesheet" type="text/css" />
    <link href="Site.css" rel="stylesheet" type="text/css" />
    <link href="system.css" rel="stylesheet" type="text/css" />
    <title>Untitled Page</title>
    <style type="text/css">
        #frmimport
        {
            margin-bottom: 19px;
        }
        .button
        {}
    </style>
    </head>

<body>
   
     <form id  = "frmimport" runat ="server" > 
   
        <asp:Label ID="lblPageName" runat="server" Text="Positve Pay" 
            Font-Bold="True" Font-Size="X-Large" ForeColor="Black" ></asp:Label>
                      <asp:Table ID="tabOptoin" runat="server" Width="40%" 
            HorizontalAlign="Left" Height="33px">
                            <asp:TableRow>
                             <asp:TableCell ColumnSpan="4" HorizontalAlign = "Right">
                             <asp:Label ID="lblOptionSetName" runat="server" TabIndex="1" Text="User Option Name:" 
                    Font-Size="Large"  ForeColor = "Black"></asp:Label>
                </asp:TableCell>
                <asp:TableCell ColumnSpan = "2" HorizontalAlign ="Left">
                    <asp:TextBox ID="txtUserOptiont" runat="server" Height="20px" Width="320px" ForeColor ="Black" ></asp:TextBox>
                </asp:TableCell>
 
               </asp:TableRow>
          <asp:TableRow Visible ="False"  >
          <asp:TableCell ColumnSpan="4" > 
          </asp:TableCell>
               <asp:TableCell> 
                    <asp:Label ID="lblUserOptionName" runat="server" Text="*The user name is all ready used select a diffent one" Visible="True" Font-Bold="True" ForeColor="Red"></asp:Label>
                </asp:TableCell>
          </asp:TableRow>

           </asp:Table>
 
 
 
        <br />
        <br />
        <br />
        <br />
        <br />
 
 
 
     <asp:Table ID="Table1" runat="server" Height="27px" style="margin-top: 0px; margin-left: 0px;" 
            Width="128px">
     <asp:TableRow>
     <asp:TableCell  BorderColor ="Black" BorderStyle = "Solid" BorderWidth= "1">
         <asp:Button ID="cmdExport" runat="server" Text="Export"  Width="120" 
            onclick="cmdExport_Click" />
     </asp:TableCell>
     <asp:TableCell  BorderColor ="Black" BorderStyle = "Solid" BorderWidth= "1">
     <asp:Button ID="cmdImport" runat="server" Text="Import" Width="120" onclick="cmdImport_Click" />
     </asp:TableCell>
     </asp:TableRow>
         
     </asp:Table>
  
 
    <asp:Panel ID="panExport" runat="server" visible="true">
        <asp:Table ID="tabExport" runat="server" Width="839px" HorizontalAlign="Left" 
            style="margin-right: 0px; margin-top: 0px;">
  
        <asp:TableRow>
            <asp:TableCell HorizontalAlign = "Right">
            <asp:Label 
                ID="lblBankFormat" runat="server" TabIndex="2" Text="Bank Format:" 
                Font-Size="Large" Width="175px" ForeColor = "Black"></asp:Label>
            </asp:TableCell>
            <asp:TableCell ColumnSpan="4">
                <asp:DropDownList ID="ddlBankFormat" runat="server" Height="20px" 
                Width="325px"  Enabled="True">
                    <asp:ListItem Value=""></asp:ListItem>
                    <asp:ListItem>Bank of America - East Coast/Texas</asp:ListItem>
                    <asp:ListItem>Bank of America - 12 Digit Account Number</asp:ListItem>
                    <asp:ListItem>Corporate Claim</asp:ListItem>
                    <asp:ListItem>Comerica</asp:ListItem>
                    <asp:ListItem>Key Bank</asp:ListItem>
                    <asp:ListItem>M and T Bank</asp:ListItem>
                    <asp:ListItem>Wachovia</asp:ListItem>
                    <asp:ListItem>WachoviaALT</asp:ListItem>
                    <asp:ListItem>Northern Trust</asp:ListItem>
                    <asp:ListItem>Sun Trust</asp:ListItem>
            </asp:DropDownList>
            </asp:TableCell>
            <asp:TableCell  Width="300px" HorizontalAlign ="Left" >
            <asp:Label ID="lblBankFormattMissing" runat="server" Text="*A Bank Format needs to be selected" Visible="False" ForeColor = "Red" Font-Bold ="true"></asp:Label>
            </asp:TableCell>
        </asp:TableRow>
        <asp:TableRow>
             <asp:TableCell HorizontalAlign = "Right"><asp:Label 
                ID="lblFileTargetName" runat="server"   Font-Size="Large" ForeColor="Black" 
                TabIndex="1" Text="Target File Name:"></asp:Label>
            </asp:TableCell>
             <asp:TableCell ColumnSpan="4" ><asp:TextBox 
                ID="txtTargetFileName" runat="server" Width = "320px" ></asp:TextBox>
            </asp:TableCell>
            <asp:TableCell>
                <asp:Label ID="lblExtractFile" runat="server" Text="*Enter a file name for the extract" Visible="False" ForeColor ="Red" Font-Bold ="true"></asp:Label>
            </asp:TableCell>
            <asp:TableCell></asp:TableCell>
        </asp:TableRow>
      
        <asp:TableRow>
            <asp:TableCell HorizontalAlign = "Right"><asp:Label 
                ID="lblBankAccountExtract" runat="server" Text="Bank Account:" 
                Font-Size="Large" ForeColor = "Black"></asp:Label>
            </asp:TableCell>
            <asp:TableCell ColumnSpan="4">
                <asp:DropDownList ID="ddlBankAccount" runat="server" Height="20px" 
                Width="320px">
                <asp:ListItem Value=""></asp:ListItem>
                </asp:DropDownList>
        <asp:Button ID="cmdAddAccount" runat="server" Height="19px" Text="Add" Width="37px" 
                Visible="True" onclick="cmdAddAccount_Click" />
            </asp:TableCell>
            <asp:TableCell>
            <asp:Label ID="lblBankAccont" runat="server" Text="*A bank account need to be selected." Visible="False" ForeColor ="Red" Font-Bold ="true"></asp:Label>
            </asp:TableCell>
        </asp:TableRow>
        <asp:TableRow>
            <asp:TableCell></asp:TableCell>
            <asp:TableCell ColumnSpan = "4">
                <asp:ListBox 
                    ID="lstBankAccount" runat="server" Height="124px"  Width="325px" 
                    Visible="True">
                </asp:ListBox>
            </asp:TableCell>
            <asp:TableCell></asp:TableCell>
        </asp:TableRow>
        <asp:TableRow>
            <asp:TableCell></asp:TableCell>
            <asp:TableCell ColumnSpan = "4">
 <asp:Button ID="cmbSave" runat="server" onclick="Save_Click" 
                    Text="Save" Height="24px" Width="90px"  CssClass ="button"/>
            </asp:TableCell>
        </asp:TableRow>
    </asp:Table>
    
    
   </asp:Panel>
   
    
    
    <asp:Panel ID="panImport" runat ="server" Visible="False">
        <asp:Table ID="tabImport" runat ="server" Width="555px" HorizontalAlign="Left" 
            Height="71px" style="margin-top: 0px; margin-bottom: 0px;">
 
           <asp:TableRow>
                <asp:TableCell VerticalAlign ="Bottom" HorizontalAlign = "Right" ><asp:Label ID="lblFileImport" runat="server" TabIndex="1" 
                    Text="File Format:" Font-Size="Large"  ForeColor = "Black" Height="20px" Width="150px" Enabled="True"></asp:Label>
                </asp:TableCell>
                <asp:TableCell   HorizontalAlign = "Left" ><asp:DropDownList ID="ddlImportFileFormat" runat="server"  Height="20px" Width="150px">
                        <asp:ListItem Value=""></asp:ListItem>
                        <asp:ListItem>10-digit Account Number</asp:ListItem>
                        <asp:ListItem>12-digit Account Number</asp:ListItem>
                     </asp:DropDownList>
                </asp:TableCell>
                <asp:TableCell><asp:Label ID="lblFileFormat" runat="server" Text="*A File Format need to be selected" Visible ="false" ForeColor ="Red" Font-Bold ="true"></asp:Label>
                </asp:TableCell>
           </asp:TableRow>
           <asp:TableRow>
                <asp:TableCell VerticalAlign ="Bottom" HorizontalAlign = "Right"><asp:Label ID="lblFilToProcess" runat="server" Text="File To Process:" Font-Size="Large"  ForeColor = "Black" ></asp:Label>
                </asp:TableCell>
                <asp:TableCell VerticalAlign ="Bottom" HorizontalAlign = "Left" Font-Size="Large"  ForeColor = "Black"><asp:TextBox ID="txtFileToProcess" runat="server" Height="20px" Width="150px"></asp:TextBox>
                </asp:TableCell>
                <asp:TableCell><asp:Label ID="lblFileToProcess" runat="server" Text="*Enter a file name to be processed" Visible ="false" ForeColor ="Red" Font-Bold ="true"></asp:Label>
                </asp:TableCell>
           </asp:TableRow>
           <asp:TableRow>
           <asp:TableCell></asp:TableCell>
            <asp:TableCell ColumnSpan ="4" HorizontalAlign ="Left" ><asp:Button ID="SaveImport" runat="server" onclick="Save_Click"  Text="Save" Height="24px" Width="90px"  CssClass ="button"/>
            </asp:TableCell> 
           </asp:TableRow>
        </asp:Table>
    </asp:Panel>
 
 
    

 
    </form>
</body>


</html>

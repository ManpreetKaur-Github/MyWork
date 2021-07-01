using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using rmx.DA2.At;
using System.IO;

namespace AT_Tester
{
    /// <summary>
    /// Interaction logic for mainWindow.xaml
    /// </summary>
    public partial class mainWindow : Window
    {
        public mainWindow()
        {
            InitializeComponent();
             
        }

        private void checkBox1_Checked(object sender, RoutedEventArgs e)
        {

        }

        private void button1_Click(object sender, RoutedEventArgs e)
        {

            startTesting();

        }

        private void startTesting()
        {

            txtDebug.Text = "";
            txtDebug.AppendText("Starting..." + Environment.NewLine + Environment.NewLine);
            
            TextWriter _writer = null;

            _writer = new TextBoxStreamWriter(txtDebug);
            

            Console.SetOut(_writer);


            ATCore objATCore = new ATCore();

            objATCore.setRmxTableInfo(txtTablename.Text, txtFriendlyName.Text, txtPKField.Text, txtMatchField.Text, txtDBOwner.Text);            
            objATCore.setLogInfo(chkDisplayLogOnScreen.IsChecked.Value, chkCreateLogFile.IsChecked.Value, "c:\\at\\logs");
            
            objATCore.setJobInfo("c:\\at\\jobs","J_DIS");
            objATCore.setTemplateInfo("c:\\at\\templates", "J_DIS_AT_TEMPLATE.xml");
            objATCore.setRmxDbConfig(txtConnectionString.Text);

            bool result = objATCore.generateJob();   
         
            if (result)
            { Console.Write("The job file was generated sucessfully.");  }
            else
            { Console.Write("The job file can not be generated due an error."); }

            
 

        }

        private void button2_Click(object sender, RoutedEventArgs e)
        {
            txtDebug.Text = "";
        }

        private void close_Click(object sender, RoutedEventArgs e)
        {
            Application.Current.Shutdown();
        }

    }

    public class TextBoxStreamWriter : TextWriter
    {

        TextBox _output = null;


        public TextBoxStreamWriter(TextBox output)
        {

            _output = output;

        }



        public override void Write(char value)
        {

            base.Write(value);

            _output.AppendText(value.ToString()); // When character data is written, append it to the text box.

        }

        public override Encoding Encoding
        {

            get { return System.Text.Encoding.UTF8; }

        }

    }



}

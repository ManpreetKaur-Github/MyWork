using System;
using System.Xml;
using System.Xml.Schema;
using System.Xml.XPath;
using System.Reflection;
using System.IO;
using System.Windows.Forms;



namespace DA_DIS_Conversion_Tool
{
    public class XPathValidation
    {
        public static bool Validate(string XmlPath)
        {

            bool isValid = true;
            try
            {
                XmlReaderSettings settings = new XmlReaderSettings();
                String strAppDir = Application.StartupPath;
                String strFullPathToMyFile = Path.Combine(strAppDir, "FrmtDef.xsd");
                settings.Schemas.Add(null, strFullPathToMyFile);
                settings.ValidationType = ValidationType.Schema;
                XmlDocument document = new XmlDocument();
                document.Load(XmlPath);
                XmlReader rdr = XmlReader.Create(new System.IO.StringReader(document.InnerXml), settings);
                while (rdr.Read()) { }
            }
            catch(Exception EX)
            {
               // MessageBox.Show(EX.Message+ "        " + EX.StackTrace);
                //Log.WriteLog("XML Validation error: " + EX.Message);
                isValid = false;
            }

            return isValid;
        }

       



    }
}

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

namespace J_POSITVE_PAY
{

    public class DataFormat
    {
        public static string FormatDate(string sDate)
        {// this is used to format the date to YYYYMMDD
            string stmp = null;

            if (sDate.Length == 8)
            {//if the date had 8 charters in it M/D/YYYY
                stmp = sDate.Substring(4, 4) + "0" + sDate.Substring(0, 1) + "0" + sDate.Substring(2, 1);
            }
            else if (sDate.Length == 9)
            {//if the date has 9 charters in it 
                if (sDate.LastIndexOf('/') == 4 & sDate.LastIndexOf('/', sDate.LastIndexOf('/') - 1) == 2)
                {// MM/D/YYYY
                    stmp = sDate.Substring(5, 4) + sDate.Substring(0, 2) + "0" + sDate.Substring(3, 1);
                }
                else if (sDate.LastIndexOf('/') == 4 & sDate.LastIndexOf('/', sDate.LastIndexOf('/') - 1) == 1)
                {//M/DD/YYYY
                    stmp = sDate.Substring(5, 4) + "0" + sDate.Substring(0, 1) + sDate.Substring(2, 2);
                }
            }
            else
            {//if the date has 10 charters in it MM/DD/YYYY
                stmp = sDate.Substring(6, 4) + sDate.Substring(0, 2) + sDate.Substring(3, 2);
            }
            return stmp;


    }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ViewpostImport
{
    public partial class  MessageList
    {
     
        private string sMessage = string.Empty;

        public string Message
        {
            get
            {
                return this.sMessage;
            }

            set
            {
                this.sMessage = value;
            }
        }      
        
    }
}

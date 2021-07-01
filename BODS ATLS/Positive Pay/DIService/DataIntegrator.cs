using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Xml;
using System.Xml.Serialization;

namespace Riskmaster.Models
{

    [DataContract]
    public class DataIntegrator : RMServiceType
    {
       
        [DataMember]
        

        public string parms
        {
            get;

            set;

        }
    }

    [DataContract]
    public class PPAccountList : RMServiceType
    {
        private List<string> objAccountlist = new List<string>();
        [DataMember]
        public List<string> AccountNameNumber
        {
            get
            {
                return objAccountlist;
            }
            set
            {
                objAccountlist = value;
            }
        }
    }
}
    


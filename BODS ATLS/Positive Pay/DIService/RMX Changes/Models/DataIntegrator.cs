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
    public class DataIntegratorModel : RMServiceType
    {   
        [DataMember]
        public Dictionary<string, string> Parms
        {
            get;

            set;
        }
        [DataMember]
        public int OptionSetID
        {
            get;

            set;
        }
        [DataMember]
        public string ModuleName
        {
            get;

            set;
        }
        [DataMember]
        public string OptionSetName
        {
            get;

            set;
        }
    }

    [DataContract]
    public class PPAccountList : RMServiceType
    {
        private List<string> objAccountlist = new List<string>();
        private List<string> objAccountID = new List<string>();
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
        [DataMember]
        public List<string> AccountID
        {
            get
            {
                return objAccountID;
            }
            set
            {
                objAccountID = value;
            }
        }
    }
}
    


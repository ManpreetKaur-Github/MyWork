using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using System.IO;
using System.Net;
using System.Xml;
using System.Xml.Serialization;
using System.Reflection;
using Riskmaster.BusinessAdaptor.Common;
using Riskmaster.Common;
using Riskmaster.Security;
using Riskmaster.Models;
using RiskmasterService;
using System.ServiceModel.Activation;


namespace DIService
{
    // NOTE: If you change the interface name "IDataIntegrator" here, you must also update the reference to "IDataIntegrator" in Web.config.
    [ServiceContract]
    public interface IDataIntegrator
    {
        
            [OperationContract]
            //[FaultContract(typeof(RMException))] 
        Riskmaster.Models.DataIntegrator GetPositivePaySetting();
            //    [OperationContract]
            //void SaveNewPositivePaySetting(out PositivePay objReturn);
            //    [OperationContract]
            //   void ReSavePositivePaySetting(out PositivePay objReturn);

        

    }
}

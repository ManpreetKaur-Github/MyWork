using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using System.Xml;
using Riskmaster.Models;

namespace RiskmasterService
{
    [ServiceContract]
    public interface IDataIntegratorService
    {
        [OperationContract]
        [FaultContract(typeof(RMException))]
        int SaveSettings(DataIntegratorModel objDIModel);
        [OperationContract]
        [FaultContract(typeof(RMException))]
        DataIntegratorModel RetrieveSettings(DataIntegratorModel objDIModel);

        [OperationContract]
        [FaultContract(typeof(RMException))]
        void GetAccountList(PPAccountList request, out PPAccountList objReturn);
    }
}
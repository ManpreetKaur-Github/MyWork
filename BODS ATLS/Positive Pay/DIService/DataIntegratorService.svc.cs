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
using Riskmaster.BusinessAdaptor;
using Riskmaster.Models;
using System.ServiceModel.Activation;
using System.Xml;


namespace RiskmasterService
{
    [AspNetCompatibilityRequirements(
   RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]

    // NOTE: If you change the class name "DataIntegratorService" here, you must also update the reference to "DataIntegratorService" in Web.config.
    public class DataIntegratorService : RMService, IDataIntegratorService
    {

        public void GetRetrieveDefault(DataIntegrator request, out DataIntegrator objReturn)
        {
            XmlDocument xmlRequest = null;
            string functionName = "GetSettings";
            UserLogin oUserLogin = null;
            DataIntegratoBusinessAdaptor objDataIntegrator = null;
            BusinessAdaptorErrors systemErrors = null;
            BusinessAdaptorErrors errOut = null;
            bool bResult = false;
           
            //Initialize the Error Collection for handling the error on Service Layer
            try
            {
                systemErrors = new BusinessAdaptorErrors();
                objReturn = new DataIntegrator();
                objDataIntegrator = new DataIntegratoBusinessAdaptor();
                //This is a common function which intialises/perform the common tasks on each service call
                InitiateServiceProcess(request, out xmlRequest, functionName, objDataIntegrator, out oUserLogin, ref systemErrors);
            }
            catch (Exception e)
            {
                // Throw back error if there is ne error in intialization process.
                systemErrors.Add(e, BusinessAdaptorErrorType.SystemError);
                logErrors(functionName, xmlRequest, false, systemErrors);
                RMException theFault = new RMException();
                theFault.Errors = formatOutputXML(null, false, systemErrors);
                throw new FaultException<RMException>(theFault, new FaultReason(e.Message), new FaultCode("Sender"));
            }
            try
            {
                //Initialize the Error Collection to be passed to the respective BA Layer for error handling
                errOut = new BusinessAdaptorErrors(oUserLogin);
                bResult = objDataIntegrator.GetRetrieveDefault(request);
                objReturn = request;
              //  bResult = objDocument.GetDocumentDetailsIntegrated(request, out  objReturn, ref errOut);
            }
            catch (Exception e)
            {
                // Throw back error if business adaptor isn't trapping its own exceptions.
                systemErrors.Add(e, BusinessAdaptorErrorType.SystemError);
                logErrors(functionName, xmlRequest, false, systemErrors);
                RMException theFault = new RMException();
                theFault.Errors = formatOutputXML(null, false, systemErrors);
                throw new FaultException<RMException>(theFault, new FaultReason(e.Message), new FaultCode("Sender"));
            }

            // Final log if all went well
            logErrors(functionName, xmlRequest, bResult, errOut);
            //Explicitly throw out the error in case we have the Business/System/Warnings errors from BA Layer
            if (errOut.Count > 0)
            {
                RMException theFault = new RMException();
                theFault.Errors = formatOutputXML(null, bResult, errOut);
                throw new FaultException<RMException>(theFault, new FaultReason(theFault.Errors), new FaultCode("Sender"));
            }

        }

        public void GetAccountList(PPAccountList request, out PPAccountList objReturn)
        {
            XmlDocument xmlRequest = null;
            string functionName = "GetAccountList";
            UserLogin oUserLogin = null;
            DataIntegratoBusinessAdaptor objDataIntegrator = null;
            BusinessAdaptorErrors systemErrors = null;
            BusinessAdaptorErrors errOut = null;
            bool bResult = false;

            //Initialize the Error Collection for handling the error on Service Layer
            try
            {
                systemErrors = new BusinessAdaptorErrors();
                objReturn = new PPAccountList();
                objDataIntegrator = new DataIntegratoBusinessAdaptor();
                //This is a common function which intialises/perform the common tasks on each service call
                InitiateServiceProcess(request, out xmlRequest, functionName, objDataIntegrator, out oUserLogin, ref systemErrors);
            }
            catch (Exception e)
            {
                // Throw back error if there is ne error in intialization process.
                systemErrors.Add(e, BusinessAdaptorErrorType.SystemError);
                logErrors(functionName, xmlRequest, false, systemErrors);
                RMException theFault = new RMException();
                theFault.Errors = formatOutputXML(null, false, systemErrors);
                throw new FaultException<RMException>(theFault, new FaultReason(e.Message), new FaultCode("Sender"));
            }
            try
            {
                //Initialize the Error Collection to be passed to the respective BA Layer for error handling
                errOut = new BusinessAdaptorErrors(oUserLogin);
      //          bResult = objDataIntegrator.test(request);
                bResult = objDataIntegrator.GetPositivePayAccountList(request);
                objReturn = request;
             }
            catch (Exception e)
            {
                // Throw back error if business adaptor isn't trapping its own exceptions.
                systemErrors.Add(e, BusinessAdaptorErrorType.SystemError);
                logErrors(functionName, xmlRequest, false, systemErrors);
                RMException theFault = new RMException();
                theFault.Errors = formatOutputXML(null, false, systemErrors);
                throw new FaultException<RMException>(theFault, new FaultReason(e.Message), new FaultCode("Sender"));
            }

            // Final log if all went well
            logErrors(functionName, xmlRequest, bResult, errOut);
            //Explicitly throw out the error in case we have the Business/System/Warnings errors from BA Layer
            if (errOut.Count > 0)
            {
                RMException theFault = new RMException();
                theFault.Errors = formatOutputXML(null, bResult, errOut);
                throw new FaultException<RMException>(theFault, new FaultReason(theFault.Errors), new FaultCode("Sender"));
            }

        }

    }
}

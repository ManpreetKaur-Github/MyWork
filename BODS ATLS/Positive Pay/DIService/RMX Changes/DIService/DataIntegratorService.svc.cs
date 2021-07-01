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




namespace RiskmasterService
{
    // NOTE: If you change the class name "RMService" here, you must also update the reference to "RMService" in Web.config and in the associated .svc file.
    [AspNetCompatibilityRequirements(
    RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    // NOTE: If you change the class name "RMService" here, you must also update the reference to "RMService" in Web.config and in the associated .svc file.
    public class DataIntegratorService : RMService, IDataIntegratorService
    {
        public int SaveSettings(DataIntegratorModel objDIModel)
        {
            //XmlDocument xmlRequest = null;
            UserLogin oUserLogin = null;
            DataIntegratorAdaptor objSettings = null;
            BusinessAdaptorErrors systemErrors = null;
            BusinessAdaptorErrors errOut = null;
            int iResult = 0;
            
            //Initialize the Error Collection for handling the error on Service Layer
            try
            {
                systemErrors = new BusinessAdaptorErrors();
                objSettings = new DataIntegratorAdaptor();
                //This is a common function which intialises/perform the common tasks on each service call
                InitiateServiceProcess(objDIModel, objSettings, out oUserLogin, ref systemErrors);
                iResult = objSettings.SaveSettings(objDIModel);
            }
            catch (Exception e)
            {
                // Throw back error if there is ne error in intialization process.
                systemErrors.Add(e, BusinessAdaptorErrorType.SystemError);
                //logErrors(functionName, xmlRequest, false, systemErrors);
                RMException theFault = new RMException();
                theFault.Errors = formatOutputXML(null, false, systemErrors);
                throw new FaultException<RMException>(theFault, new FaultReason(e.Message), new FaultCode("Sender"));
            }
            
            //// Final log if all went well
            //logErrors(functionName, xmlRequest, bResult, errOut);
            ////Explicitly throw out the error in case we have the Business/System/Warnings errors from BA Layer
            //if (errOut.Count > 0)
            //{
            //    RMException theFault = new RMException();
            //    theFault.Errors = formatOutputXML(null, bResult, errOut);
            //    throw new FaultException<RMException>(theFault, new FaultReason(theFault.Errors), new FaultCode("Sender"));
            //}

            return iResult;

        }

        public DataIntegratorModel RetrieveSettings(DataIntegratorModel objDIModel)
        {
            //XmlDocument xmlRequest = null;
            //string functionName = "RetrieveSettings";
            UserLogin oUserLogin = null;
            DataIntegratorAdaptor objSettings = null;
            BusinessAdaptorErrors systemErrors = null;
            BusinessAdaptorErrors errOut = null;
            DataIntegratorModel objDISettings = null;

            //Initialize the Error Collection for handling the error on Service Layer
            try
            {
                systemErrors = new BusinessAdaptorErrors();
                objSettings = new DataIntegratorAdaptor();
                systemErrors = new BusinessAdaptorErrors();
                //This is a common function which intialises/perform the common tasks on each service call
                //InitiateServiceProcess(objDIModel, out xmlRequest, functionName, objSettings, out oUserLogin, ref systemErrors);
                //objDIModel = objSettings.RetrieveSettings();
                InitiateServiceProcess(objDIModel, objSettings, out oUserLogin, ref systemErrors);
                objDISettings = objSettings.RetrieveSettings(objDIModel);

            }
            catch (Exception e)
            {
                // Throw back error if there is ne error in intialization process.
                systemErrors.Add(e, BusinessAdaptorErrorType.SystemError);
                //logErrors(functionName, xmlRequest, false, systemErrors);
                RMException theFault = new RMException();
                theFault.Errors = formatOutputXML(null, false, systemErrors);
                throw new FaultException<RMException>(theFault, new FaultReason(e.Message), new FaultCode("Sender"));
            }

            //// Final log if all went well
            //logErrors(functionName, xmlRequest, bResult, errOut);
            ////Explicitly throw out the error in case we have the Business/System/Warnings errors from BA Layer
            //if (errOut.Count > 0)
            //{
            //    RMException theFault = new RMException();
            //    theFault.Errors = formatOutputXML(null, bResult, errOut);
            //    throw new FaultException<RMException>(theFault, new FaultReason(theFault.Errors), new FaultCode("Sender"));
            //}

            return objDISettings;
        }


        public void GetAccountList(PPAccountList request, out PPAccountList objReturn)
        {
            XmlDocument xmlRequest = null;
            string functionName = "GetAccountList";
            UserLogin oUserLogin = null;
            DataIntegratorAdaptor objDataIntegrator = null;
            BusinessAdaptorErrors systemErrors = null;
            BusinessAdaptorErrors errOut = null;
            bool bResult = false;

            //Initialize the Error Collection for handling the error on Service Layer
            try
            {
                systemErrors = new BusinessAdaptorErrors();
                objReturn = new PPAccountList();
                objDataIntegrator = new DataIntegratorAdaptor();
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
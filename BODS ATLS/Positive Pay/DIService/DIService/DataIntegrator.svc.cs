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
    // NOTE: If you change the class name "DataIntegrator" here, you must also update the reference to "DataIntegrator" in Web.config.
    public class DataIntegrator : IDataIntegrator
    {

        public Riskmaster.Models.DataIntegrator GetPositivePaySetting()
        {
            Riskmaster.Models.DataIntegrator objReturn = new Riskmaster.Models.DataIntegrator();

            XmlDocument xmlRequest = null;
            string functionName = "GetPositivePaySetting";
            UserLogin oUserLogin = null;
            BusinessAdaptorErrors systemErrors = null;
            BusinessAdaptorErrors errOut = null;

            bool bResult = false;

            //Initialize the Error Collection for handling the error on Service Layer
            Dictionary<string, string> PP_parms = new Dictionary<string, string>();

            PP_parms.Add("test1", "Testa1");
            PP_parms.Add("test2", "test3");


            try
            {

              // systemErrors = new BusinessAdaptorErrors();

                //This is a common function which intialises/perform the common tasks on each service call
                //thing this calls the next function
            }
            catch (Exception e)
            {
                // Throw back error if there is ne error in intialization process.
              //  systemErrors.Add(e, BusinessAdaptorErrorType.SystemError);
                RiskmasterService.ServiceLogger.LogErrors(functionName, xmlRequest, false, systemErrors);
                RMException theFault = new RMException();
                //              theFault.Errors = formatOutputXML(null, false, systemErrors);
                throw new FaultException<RMException>(theFault, new FaultReason(e.Message), new FaultCode("Sender"));
            }
            try
            {
                //Initialize the Error Collection to be passed to the respective BA Layer for error handling
               errOut = new BusinessAdaptorErrors(oUserLogin);
                //not sure what to do 
                //    bResult = objDocument.GetDocumentDetailsIntegrated(request, out  objReturn, ref errOut);
            }
            catch (Exception e)
            {
                // Throw back error if business adaptor isn't trapping its own exceptions.
              //  systemErrors.Add(e, BusinessAdaptorErrorType.SystemError);
             //   RiskmasterService.ServiceLogger.LogErrors(functionName, xmlRequest, false, systemErrors);
             ///   RMException theFault = new RMException();
                //             theFault.Errors = formatOutputXML(null, false, systemErrors);
             //   throw new FaultException<RMException>(theFault, new FaultReason(e.Message), new FaultCode("Sender"));
            }

            // Final log if all went well
            RiskmasterService.ServiceLogger.LogErrors(functionName, xmlRequest, bResult, errOut);
            //Explicitly throw out the error in case we have the Business/System/Warnings errors from BA Layer
            if (errOut.Count > 0)
            {
                RMException theFault = new RMException();
                //    theFault.Errors =  formatOutputXML(null, bResult, errOut);
                throw new FaultException<RMException>(theFault, new FaultReason(theFault.Errors), new FaultCode("Sender"));
            }
            return objReturn;
        }

        
        //{
        //    XmlDocument xmlRequest = null;
        //    string functionName = "GetPositivePaySetting";
        //    UserLogin oUserLogin = null;
        //    DocumentManagementAdaptor objDocument = null;
        //    BusinessAdaptorErrors systemErrors = null;
        //    BusinessAdaptorErrors errOut = null;
        //    bool bResult = false;

        //    //Initialize the Error Collection for handling the error on Service Layer



        //    try
        //    {
        //        systemErrors = new BusinessAdaptorErrors();
        //        objReturn = new PositivePay();
        //        objDocument = new DocumentManagementAdaptor();
        //        //This is a common function which intialises/perform the common tasks on each service call
        //        //thing this calls the next function
        //      // InitiateServiceProcess(request, out xmlRequest, functionName, objDocument, out oUserLogin, ref systemErrors);
        //    }
        //    catch (Exception e)
        //    {
        //        // Throw back error if there is ne error in intialization process.
        //        systemErrors.Add(e, BusinessAdaptorErrorType.SystemError);
        //        logErrors(functionName, xmlRequest, false, systemErrors);
        //        RMException theFault = new RMException();
        //        theFault.Errors = formatOutputXML(null, false, systemErrors);
        //        throw new FaultException<RMException>(theFault, new FaultReason(e.Message), new FaultCode("Sender"));
        //    }
        //    try
        //    {
        //        //Initialize the Error Collection to be passed to the respective BA Layer for error handling
        //        errOut = new BusinessAdaptorErrors(oUserLogin);
        //        //not sure what to do 
        //        //    bResult = objDocument.GetDocumentDetailsIntegrated(request, out  objReturn, ref errOut);
        //    }
        //    catch (Exception e)
        //    {
        //        // Throw back error if business adaptor isn't trapping its own exceptions.
        //        systemErrors.Add(e, BusinessAdaptorErrorType.SystemError);
        //        logErrors(functionName, xmlRequest, false, systemErrors);
        //        RMException theFault = new RMException();
        //        theFault.Errors = formatOutputXML(null, false, systemErrors);
        //        throw new FaultException<RMException>(theFault, new FaultReason(e.Message), new FaultCode("Sender"));
        //    }

        //    // Final log if all went well
        //    logErrors(functionName, xmlRequest, bResult, errOut);
        //    //Explicitly throw out the error in case we have the Business/System/Warnings errors from BA Layer
        //    if (errOut.Count > 0)
        //    {
        //        RMException theFault = new RMException();
        //        theFault.Errors = formatOutputXML(null, bResult, errOut);
        //        throw new FaultException<RMException>(theFault, new FaultReason(theFault.Errors), new FaultCode("Sender"));
        //    }
        //}

        //public void ReSavePositivePaySetting(out PositivePay objReturn)
        //{
        //    XmlDocument xmlRequest = null;
        //    string functionName = "GetPositivePaySetting";
        //    UserLogin oUserLogin = null;
        //    DocumentManagementAdaptor objDocument = null;
        //    BusinessAdaptorErrors systemErrors = null;
        //    BusinessAdaptorErrors errOut = null;
        //    bool bResult = false;

        //    //Initialize the Error Collection for handling the error on Service Layer



        //    try
        //    {
        //        systemErrors = new BusinessAdaptorErrors();
        //        objReturn = new PositivePay();
        //        objDocument = new DocumentManagementAdaptor();
        //        //This is a common function which intialises/perform the common tasks on each service call
        //        //thing this calls the next function
        //        //InitiateServiceProcess(request, out xmlRequest, functionName, objDocument, out oUserLogin, ref systemErrors);
        //    }
        //    catch (Exception e)
        //    {
        //        // Throw back error if there is ne error in intialization process.
        //        systemErrors.Add(e, BusinessAdaptorErrorType.SystemError);
        //        logErrors(functionName, xmlRequest, false, systemErrors);
        //        RMException theFault = new RMException();
        //        theFault.Errors = formatOutputXML(null, false, systemErrors);
        //        throw new FaultException<RMException>(theFault, new FaultReason(e.Message), new FaultCode("Sender"));
        //    }
        //    try
        //    {
        //        //Initialize the Error Collection to be passed to the respective BA Layer for error handling
        //        errOut = new BusinessAdaptorErrors(oUserLogin);
        //        //not sure what to do 
        //        //    bResult = objDocument.GetDocumentDetailsIntegrated(request, out  objReturn, ref errOut);
        //    }
        //    catch (Exception e)
        //    {
        //        // Throw back error if business adaptor isn't trapping its own exceptions.
        //        systemErrors.Add(e, BusinessAdaptorErrorType.SystemError);
        //        logErrors(functionName, xmlRequest, false, systemErrors);
        //        RMException theFault = new RMException();
        //        theFault.Errors = formatOutputXML(null, false, systemErrors);
        //        throw new FaultException<RMException>(theFault, new FaultReason(e.Message), new FaultCode("Sender"));
        //    }

        //    // Final log if all went well
        //    logErrors(functionName, xmlRequest, bResult, errOut);
        //    //Explicitly throw out the error in case we have the Business/System/Warnings errors from BA Layer
        //    if (errOut.Count > 0)
        //    {
        //        RMException theFault = new RMException();
        //        theFault.Errors = formatOutputXML(null, bResult, errOut);
        //        throw new FaultException<RMException>(theFault, new FaultReason(theFault.Errors), new FaultCode("Sender"));
        //    }
        //}

    }
}

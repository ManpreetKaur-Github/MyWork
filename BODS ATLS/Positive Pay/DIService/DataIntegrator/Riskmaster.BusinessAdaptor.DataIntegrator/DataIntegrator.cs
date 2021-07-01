using System;
using System.Xml;
using Riskmaster.BusinessAdaptor.Common;
using Riskmaster.ExceptionTypes;
using Riskmaster.Common;
using System.IO;
using Riskmaster.Security;
using System.Collections;
//using Riskmaster.Application.AcrosoftWebserviceWrapper;
using Riskmaster.Models;
using System.Collections.Generic;
using Riskmaster.Application.DataIntegrator;


namespace Riskmaster.BusinessAdaptor 
{

    public class DataIntegratoBusinessAdaptor : BusinessAdaptorBase
    {

        




        DataIntegrator model2 = new DataIntegrator();
        #region Public Methods

        public bool GetRetrieveDefault(DataIntegrator request)
        {


           
            try
            {
                DataIntegrator model = new DataIntegrator();
               DI_Settings.Settings sh = new DI_Settings.Settings();
                sh.connectionString = m_connectionString;
                
                sh.moduleName = "ISO";
                request.parms = sh.RetrieveDefaultSettings_XML();

            }
            catch (Exception e)
            {

                
            }




            
        
           // pp = sh.RetrieveDefaultSettings();

            return true;
       }


        public bool GetPositivePayAccountList(PPAccountList p_objIn)
        {
            bool bReturnValue = false;
            DataIntegratorApplication dtest = new DataIntegratorApplication();
            dtest.ConnectionString = m_connectionString;
           
            try
            {
                bReturnValue = dtest.GetAccountNames(ref p_objIn);
                bReturnValue = true;
            }




            catch (Exception e)
            {
                bReturnValue = false;
            }


            return bReturnValue;
        }


        #endregion

    }
 }


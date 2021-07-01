using System;
using System.Xml;
using Riskmaster.BusinessAdaptor.Common;
//using Riskmaster.Application.DocumentManagement;
using Riskmaster.ExceptionTypes;
//using Riskmaster.Application.FileStorage;
using Riskmaster.Common;
using System.IO;
//using Riskmaster.Application.SecurityManagement;
using Riskmaster.Security;
using System.Collections;
//using Riskmaster.Application.AcrosoftWebserviceWrapper;
//using Riskmaster.Settings;
//using Riskmaster.DataModel;
using Riskmaster.Models;
using System.Collections.Generic;
//using DI_Settings;
using Riskmaster.Application.DataIntegrator;

namespace Riskmaster.BusinessAdaptor
{
    public class DataIntegratorAdaptor : BusinessAdaptorBase
    {
        #region Constructor
        //bool m_bSoapAttachmentCachedToDisk = false;

        public DataIntegratorAdaptor()
        {
            //m_bSoapAttachmentCachedToDisk = (null != Riskmaster.Common.RMConfigurator.Value("CommonWebServiceHandler/UseAttachmentServiceExtension"));
        }

        #endregion

        #region Public Methods



        public DataIntegratorModel RetrieveSettings(DataIntegratorModel objDIModel)
        {

            DI_Settings.Settings objDISettings = new DI_Settings.Settings();
            Dictionary<string, string> objDIDict = null;
            DataIntegratorModel objReturnDIModel = new DataIntegratorModel();
            if (objDIModel.OptionSetID == 0)
            {
                objDISettings.connectionString = m_connectionString;
                objDISettings.moduleName = objDIModel.ModuleName;

              objDIDict = objDISettings.RetrieveDefaultSettings();


            }
            else
            {
              
                objDISettings.connectionString = m_connectionString;
                objDISettings.moduleName = objDIModel.ModuleName;
                objReturnDIModel.OptionSetName = objDISettings.GetOptionSetName(objDIModel.OptionSetID);
                objDIDict = objDISettings.RetrieveOptionSetSettings(userID, objDISettings.GetOptionSetName(objDIModel.OptionSetID));
            }

             objReturnDIModel.Parms = objDIDict;
            return objReturnDIModel;
        }


        public bool GetPositivePayAccountList(PPAccountList p_objIn)
        {
            bool bReturnValue = false;
            DataIntegratorApplication Accountlist = new DataIntegratorApplication();
            Accountlist.ConnectionString = m_connectionString;

            try
            {
                bReturnValue = Accountlist.GetAccountNames(ref p_objIn);
                bReturnValue = true;
            }




            catch (Exception e)
            {
                bReturnValue = false;
            }


            return bReturnValue;
        }
        public int SaveSettings(DataIntegratorModel objDIModel)
        {
            DI_Settings.Settings objDISettings = new DI_Settings.Settings();
            int iReturn = 0;

            if (objDIModel.OptionSetID == 0)
            {
                objDISettings.connectionString = m_connectionString;
                objDISettings.moduleName = objDIModel.ModuleName;
                if (CheckOptionSetName(objDIModel.OptionSetName, objDISettings) == true)
                    iReturn = -1;
                else
                    iReturn = objDISettings.InsertSettings(userID, objDIModel.OptionSetName, objDIModel.Parms);
            }
            else
            {
                objDISettings.connectionString = m_connectionString;
                objDISettings.moduleName = objDIModel.ModuleName;
                iReturn = objDISettings.SaveSettings(userID, objDIModel.OptionSetName, objDIModel.Parms);
            }

            return iReturn;
        }

        public bool CheckOptionSetName(string sOptionSetName, DI_Settings.Settings objDISettings)
        {

            List<string> OptionSetName;
            //DI_Settings.Settings objDISettings = new DI_Settings.Settings();
            OptionSetName = objDISettings.GetOptionSetNames(userID);
            foreach (string sFind in OptionSetName)
            {
                if (sFind == sOptionSetName)
                    return true;
            }
            return false;
        }

        #endregion

    }
}


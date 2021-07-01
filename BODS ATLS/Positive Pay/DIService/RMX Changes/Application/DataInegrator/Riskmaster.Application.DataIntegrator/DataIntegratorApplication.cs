using System;
using System.Data;
using System.IO;
using System.Xml;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Collections.Specialized;
using System.Text;
using Riskmaster.Db;
//using Riskmaster.ExceptionTypes;
using Riskmaster.Common;
using Riskmaster.Application.SecurityManagement;
using Riskmaster.Security;
using Riskmaster.Models;



namespace Riskmaster.Application.DataIntegrator
{
    public class DataIntegratorApplication
    {

        #region Member Variables

            private string m_sConnectionString;
        #endregion

       #region Properties

            public string ConnectionString
        {
            get
            {
                return m_sConnectionString;
            }
            set
            {
                if (value != null)
                {
                    m_sConnectionString = value;
                }
                else
                {
                    m_sConnectionString = string.Empty;
                }
            }
        }

        #endregion

        #region Public Functions



        public bool GetAccountNames(ref PPAccountList objAccount)
        {
          bool bReturnValue = false;
          string sSql = string.Empty;
          string sTmp = string.Empty;
          string sAccountID = string.Empty;
            
          sSql = "SELECT ACCOUNT_ID, ACCOUNT_NAME, ACCOUNT_NUMBER FROM ACCOUNT WHERE ACCOUNT_NAME IS NOT NULL AND ACCOUNT_NUMBER IS NOT NULL";

          DbReader objReader = DbFactory.GetDbReader(m_sConnectionString, sSql);
        try
        {
            while (objReader.Read())
            {
                sAccountID = objReader.GetInt("ACCOUNT_ID").ToString();
                sTmp = objReader.GetString("ACCOUNT_NAME");
                sTmp = sTmp + " --- " + objReader.GetString("ACCOUNT_NUMBER");
                objAccount.AccountNameNumber.Add(sTmp);
                objAccount.AccountID.Add(sAccountID);
            }

            objReader.Close();
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

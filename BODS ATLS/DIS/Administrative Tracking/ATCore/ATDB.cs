using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Collections;
using System.Data.Common;
using System.Data.OleDb;



namespace rmx.DA2.At
{
    [CLSCompliant(true)]
    public class ATDB {

        private string rmxConnectionString;
        private int count;
        private string sql;

        private ATLog objATLog;         
        private OleDbCommand command;
        private OleDbConnection connection;
        private OleDbDataReader reader;     
        private ArrayList[] _masterArrayList;

        
        public ATDB() { }

        public void setLog(ATLog obj)
        {
            objATLog = obj;
        }

        public void setRmxDBConfig(string rmxConnection)
        {
            this.rmxConnectionString = rmxConnection;
        }

        public ArrayList[] getRMXDataDefinition(string tableName)
        {

            _masterArrayList = new ArrayList[7];

            for (int i = 0; i < _masterArrayList.Length; i++)
            {
                _masterArrayList[i] = new ArrayList();
            }


            sql = "SELECT su.sys_field_name,su.user_prompt,su.field_type,su.field_size,su.pattern,gl.system_table_name,su.CODE_FILE_ID FROM SUPP_DICTIONARY su LEFT OUTER JOIN GLOSSARY gl ON (su.code_file_id = gl.table_id) WHERE su.supp_table_name =  \'" + tableName + "\' AND DELETE_FLAG = 0 AND FIELD_TYPE <= 13 ORDER BY seq_num ";
            objATLog.writeDebug("SQL Command sent to the DB: " + sql);


            openRmxDb();

            reader = getReader(sql);

            
            count = 0;

            while (reader.Read())
            {

                _masterArrayList[0].Add(reader["SYS_FIELD_NAME"].ToString());
                _masterArrayList[1].Add(reader["USER_PROMPT"].ToString());
                _masterArrayList[2].Add(Convert.ToInt32(reader["FIELD_TYPE"].ToString()));
                _masterArrayList[3].Add(Convert.ToInt32(reader["FIELD_SIZE"].ToString()));
                _masterArrayList[4].Add(reader["PATTERN"].ToString());
                _masterArrayList[5].Add(reader["SYSTEM_TABLE_NAME"].ToString());
                _masterArrayList[6].Add(Convert.ToInt32(reader["CODE_FILE_ID"].ToString()));

                count += 1;

            }

            closeRmxDb();

            objATLog.writeDebug("Record(s) found: " + count);

            return _masterArrayList;
                        
        }

        private OleDbDataReader getReader(string sql)
        {

            try
            {
                
                command = new OleDbCommand(sql);
                command.Connection = connection;

                objATLog.writeDebug("ATDB - getReader: Querying RMX database...");
                return command.ExecuteReader();

            }

            finally
            {
                command = null;
                
            }

        }

        private void closeRmxDb()
        {

            objATLog.writeDebug("ATDB - closeRmxDb: closing RMX database...");

            if (connection.State == ConnectionState.Open) { connection.Close(); }
            connection = null;         

        }

        private void openRmxDb()
        {

            objATLog.writeDebug("ATDB - openRmxDb: opening RMX database...");

            connection = new OleDbConnection(rmxConnectionString);
            connection.Open();
        
        }

     

    }
}

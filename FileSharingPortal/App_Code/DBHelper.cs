using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace FileSharingPortal.App_Code
{

    /// <summary>
    /// Reusable database helper methods for FileSharingPortal.
    /// </summary>

    public class DBHelper
    {
        public static string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["FileSharingDB"].ConnectionString; }
        }

        /// <summary>
        /// Executes a stored procedure and returns a DataTable.
        /// </summary>
        public static DataTable ExecuteQuery(string spName, SqlParameter[] parameters = null)
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(spName, conn);
                cmd.CommandType = CommandType.StoredProcedure;
                if (parameters != null)
                    cmd.Parameters.AddRange(parameters);

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                adapter.Fill(dt);
            }
            return dt;
        }

        /// <summary>
        /// Executes a stored procedure with no result set.
        /// </summary>
        public static int ExecuteNonQuery(string spName, SqlParameter[] parameters = null)
        {
            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(spName, conn);
                cmd.CommandType = CommandType.StoredProcedure;
                if (parameters != null)
                    cmd.Parameters.AddRange(parameters);
                return cmd.ExecuteNonQuery();
            }
        }

        /// <summary>
        /// Executes a stored procedure and returns the first value (scalar).
        /// </summary>
        public static object ExecuteScalar(string spName, SqlParameter[] parameters = null)
        {
            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(spName, conn);
                cmd.CommandType = CommandType.StoredProcedure;
                if (parameters != null)
                    cmd.Parameters.AddRange(parameters);
                return cmd.ExecuteScalar();
            }
        }

        /// <summary>
        /// Format file size into human-readable string.
        /// </summary>
        public static string FormatFileSize(long bytes)
        {
            if (bytes < 1024) return bytes + " B";
            if (bytes < 1048576) return Math.Round(bytes / 1024.0, 1) + " KB";
            if (bytes < 1073741824) return Math.Round(bytes / 1048576.0, 1) + " MB";
            return Math.Round(bytes / 1073741824.0, 2) + " GB";
        }
    }

}
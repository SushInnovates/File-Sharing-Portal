using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace FileSharingPortal
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                litName.Text = Session["FullName"]?.ToString() ?? Session["Username"].ToString();
                LoadStats();
                LoadRecentFiles();
            }
        }

        private void LoadStats()
        {
            int userID = Convert.ToInt32(Session["UserID"]);
            string conn = ConfigurationManager.ConnectionStrings["FileSharingPortalDB"].ConnectionString;

            using (SqlConnection sqlConn = new SqlConnection(conn))
            {
                sqlConn.Open();
                SqlCommand cmd = new SqlCommand("sp_GetDashboardStats", sqlConn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserID", userID);

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    litTotalFiles.Text = reader["TotalFiles"].ToString();
                    litShared.Text = reader["FilesShared"].ToString();
                    litReceived.Text = reader["FilesReceivedCount"].ToString();

                    long totalBytes = Convert.ToInt64(reader["TotalSize"]);
                    litTotalSize.Text = FormatSize(totalBytes);
                }
            }
        }

        private void LoadRecentFiles()
        {
            int userID = Convert.ToInt32(Session["UserID"]);
            string conn = ConfigurationManager.ConnectionStrings["FileSharingPortalDB"].ConnectionString;

            using (SqlConnection sqlConn = new SqlConnection(conn))
            {
                sqlConn.Open();
                SqlCommand cmd = new SqlCommand(
                    "SELECT TOP 5 FileID, FileName, FileType, FileSize, UploadedAt FROM Files WHERE UserID=@UserID AND IsDeleted=0 ORDER BY UploadedAt DESC",
                    sqlConn);
                cmd.Parameters.AddWithValue("@UserID", userID);

                DataTable dt = new DataTable();
                dt.Load(cmd.ExecuteReader());

                if (dt.Rows.Count > 0)
                {
                    rptRecentFiles.DataSource = dt;
                    rptRecentFiles.DataBind();
                }
                else
                {
                    rptRecentFiles.Visible = false;
                    lblNoFiles.Visible = true;
                }
            }
        }

        protected string FormatSize(long bytes)
        {
            if (bytes < 1024) return bytes + " B";
            if (bytes < 1048576) return Math.Round(bytes / 1024.0, 1) + " KB";
            if (bytes < 1073741824) return Math.Round(bytes / 1048576.0, 1) + " MB";
            return Math.Round(bytes / 1073741824.0, 2) + " GB";
        }

        protected void lbLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }
    }
}
    
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
namespace FileSharingPortal
{
    public partial class ManageFiles : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null) { Response.Redirect("Login.aspx"); return; }
            if (Session["Role"]?.ToString() != "Admin") { Response.Redirect("Dashboard.aspx"); return; }

            if (!IsPostBack) LoadFiles();
        }

        private void LoadFiles()
        {
            string connStr = ConfigurationManager.ConnectionStrings["FileSharingDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("sp_AdminGetAllFiles", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                DataTable dt = new DataTable();
                dt.Load(cmd.ExecuteReader());
                rptFiles.DataSource = dt;
                rptFiles.DataBind();
            }
        }

        protected void rptFiles_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Delete")
            {
                int fileID = Convert.ToInt32(e.CommandArgument);
                string connStr = ConfigurationManager.ConnectionStrings["FileSharingDB"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    // Get stored filename before marking deleted
                    SqlCommand getCmd = new SqlCommand(
                        "SELECT StoredFileName FROM Files WHERE FileID=@id", conn);
                    getCmd.Parameters.AddWithValue("@id", fileID);
                    string stored = getCmd.ExecuteScalar()?.ToString();

                    // Soft-delete in database
                    SqlCommand delCmd = new SqlCommand(
                        "UPDATE Files SET IsDeleted=1 WHERE FileID=@id", conn);
                    delCmd.Parameters.AddWithValue("@id", fileID);
                    delCmd.ExecuteNonQuery();

                    // Optionally remove from disk
                    if (!string.IsNullOrEmpty(stored))
                    {
                        string path = Server.MapPath("~/Uploads/" + stored);
                        if (File.Exists(path)) File.Delete(path);
                    }
                }

                ShowMessage("✅ File deleted.", "success");
                LoadFiles();
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
            Session.Clear(); Session.Abandon();
            Response.Redirect("Login.aspx");
        }

        private void ShowMessage(string msg, string type)
        {
            lblMessage.Text = $"<div class='alert alert-{type}'>{msg}</div>";
            lblMessage.Visible = true;
        }
    }
    
}
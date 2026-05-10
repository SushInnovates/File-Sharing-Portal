using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;

namespace FileSharingPortal
{
    public partial class MyFiles : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }
            if (!IsPostBack)
                LoadFiles();
        }

        private void LoadFiles()
        {
            int userID = Convert.ToInt32(Session["UserID"]);
            string connStr = ConfigurationManager.ConnectionStrings["FileSharingPortalDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("sp_GetMyFiles", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserID", userID);

                DataTable dt = new DataTable();
                dt.Load(cmd.ExecuteReader());

                if (dt.Rows.Count > 0)
                {
                    rptFiles.DataSource = dt;
                    rptFiles.DataBind();
                }
                else
                {
                    rptFiles.Visible = false;
                    lblEmpty.Visible = true;
                }
            }
        }

        protected void rptFiles_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Delete")
            {
                int fileID = Convert.ToInt32(e.CommandArgument);
                DeleteFile(fileID);
            }
            else if (e.CommandName == "Download")
            {
                string[] parts = e.CommandArgument.ToString().Split(',');
                string storedName = parts[1];
                string originalName = parts[2];
                DownloadFile(storedName, originalName);
            }
        }

        private void DeleteFile(int fileID)
        {
            int userID = Convert.ToInt32(Session["UserID"]);
            string connStr = ConfigurationManager.ConnectionStrings["FileSharingPortalDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("sp_DeleteFile", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@FileID", fileID);
                cmd.Parameters.AddWithValue("@UserID", userID);
                cmd.ExecuteNonQuery();
            }

            ShowMessage("✅ File deleted successfully.", "success");
            LoadFiles();
        }

        private void DownloadFile(string storedName, string originalName)
        {
            string filePath = Server.MapPath("~/Uploads/" + storedName);

            if (!File.Exists(filePath))
            {
                ShowMessage("❌ File not found on server.", "error");
                return;
            }

            Response.Clear();
            Response.ContentType = "application/octet-stream";
            Response.AddHeader("Content-Disposition", "attachment; filename=\"" + originalName + "\"");
            Response.AddHeader("Content-Length", new FileInfo(filePath).Length.ToString());
            Response.TransmitFile(filePath);
            Response.End();
        }

        protected string FormatSize(long bytes)
        {
            if (bytes < 1024) return bytes + " B";
            if (bytes < 1048576) return Math.Round(bytes / 1024.0, 1) + " KB";
            if (bytes < 1073741824) return Math.Round(bytes / 1048576.0, 1) + " MB";
            return Math.Round(bytes / 1073741824.0, 2) + " GB";
        }

        protected string GetBadgeClass(string ext)
        {
            switch (ext.ToLower())
            {
                case "pdf": return "badge-pdf";
                case "doc": case "docx": return "badge-docx";
                case "zip": case "rar": return "badge-zip";
                case "jpg": case "jpeg": case "png": case "gif": return "badge-image";
                default: return "badge-other";
            }
        }

        protected void lbLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }

        private void ShowMessage(string msg, string type)
        {
            lblMessage.Text = $"<div class='alert alert-{type}'>{msg}</div>";
            lblMessage.Visible = true;
        }
    }
    
}
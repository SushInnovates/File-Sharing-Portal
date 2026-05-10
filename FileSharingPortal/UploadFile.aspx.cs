using System;
using System.IO;
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
    public partial class UploadFile : System.Web.UI.Page
    {

        // Allowed extensions
        private static readonly string[] AllowedExtensions =
        {
            ".pdf", ".doc", ".docx", ".xls", ".xlsx", ".ppt", ".pptx",
            ".zip", ".rar", ".7z", ".txt",".exe",".dll",".csv",
            ".py",".json",".sketch",
            ".jpg", ".jpeg", ".png", ".gif", ".bmp", ".svg",
            ".mp4", ".mkv", ".avi", ".mp3"
        };

        private const long MaxFileSize = 50 * 1024 * 1024; // 50 MB



        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("Login.aspx");
        }

        protected void btnUpload_Click(object sender, EventArgs e)
        {
            if (!fileUpload.HasFile)
            {
                ShowMessage("⚠️ Please select a file to upload.", "error");
                return;
            }

            string originalName = fileUpload.FileName;
            string ext = Path.GetExtension(originalName).ToLower();
            long fileSize = fileUpload.PostedFile.ContentLength;
            string fileType = ext.TrimStart('.');

            // Validate extension
            bool allowed = false;
            foreach (string ae in AllowedExtensions)
                if (ae == ext) { allowed = true; break; }

            if (!allowed)
            {
                ShowMessage("❌ File type not allowed: " + ext, "error");
                return;
            }

            // Validate size
            if (fileSize > MaxFileSize)
            {
                ShowMessage("❌ File too large. Maximum size is 50 MB.", "error");
                return;
            }

            // Create a unique stored file name to avoid collisions
            string storedName = Guid.NewGuid().ToString("N") + ext;
            string uploadPath = Server.MapPath("~/Uploads/");

            // Ensure Uploads folder exists
            if (!Directory.Exists(uploadPath))
                Directory.CreateDirectory(uploadPath);

            string fullPath = Path.Combine(uploadPath, storedName);

            try
            {
                fileUpload.SaveAs(fullPath);

                int userID = Convert.ToInt32(Session["UserID"]);
                string description = txtDescription.Text.Trim();
                string connStr = ConfigurationManager.ConnectionStrings["FileSharingPortalDB"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand("sp_InsertFile", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserID", userID);
                    cmd.Parameters.AddWithValue("@FileName", originalName);
                    cmd.Parameters.AddWithValue("@StoredFileName", storedName);
                    cmd.Parameters.AddWithValue("@FileSize", fileSize);
                    cmd.Parameters.AddWithValue("@FileType", fileType);
                    cmd.Parameters.AddWithValue("@Description", description);
                    cmd.ExecuteScalar();
                }

                ShowMessage("✅ File uploaded successfully! <a href='MyFiles.aspx' style='color:var(--accent2)'>View My Files →</a>", "success");
                txtDescription.Text = "";
            }
            catch (Exception ex)
            {
                ShowMessage("Error saving file: " + ex.Message, "error");
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
    

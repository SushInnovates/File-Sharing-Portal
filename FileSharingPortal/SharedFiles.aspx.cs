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
    public partial class SharedFiles : System.Web.UI.Page
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
                LoadMyFilesDropdown();
                LoadSharedWithMe();
            }
        }

        private void LoadMyFilesDropdown()
        {
            int userID = Convert.ToInt32(Session["UserID"]);
            string connStr = ConfigurationManager.ConnectionStrings["FileSharingPortalDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(
                    "SELECT FileID, FileName FROM Files WHERE UserID=@UserID AND IsDeleted=0 ORDER BY UploadedAt DESC",
                    conn);
                cmd.Parameters.AddWithValue("@UserID", userID);

                DataTable dt = new DataTable();
                dt.Load(cmd.ExecuteReader());

                ddlFiles.DataSource = dt;
                ddlFiles.DataTextField = "FileName";
                ddlFiles.DataValueField = "FileID";
                ddlFiles.DataBind();

                ddlFiles.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select a file --", "0"));
            }
        }

        private void LoadSharedWithMe()
        {
            int userID = Convert.ToInt32(Session["UserID"]);
            string connStr = ConfigurationManager.ConnectionStrings["FileSharingPortalDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("sp_GetSharedWithMe", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserID", userID);

                DataTable dt = new DataTable();
                dt.Load(cmd.ExecuteReader());

                if (dt.Rows.Count > 0)
                {
                    rptShared.DataSource = dt;
                    rptShared.DataBind();
                }
                else
                {
                    rptShared.Visible = false;
                    lblEmpty.Visible = true;
                }
            }
        }

        protected void btnShare_Click(object sender, EventArgs e)
        {
            if (ddlFiles.SelectedValue == "0")
            {
                ShowMessage("⚠️ Please select a file to share.", "error");
                return;
            }

            string shareWith = txtShareWith.Text.Trim();
            if (string.IsNullOrEmpty(shareWith))
            {
                ShowMessage("⚠️ Please enter the username to share with.", "error");
                return;
            }

            int fileID = Convert.ToInt32(ddlFiles.SelectedValue);
            int sharedByUser = Convert.ToInt32(Session["UserID"]);
            string connStr = ConfigurationManager.ConnectionStrings["FileSharingPortalDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("sp_ShareFile", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@FileID", fileID);
                cmd.Parameters.AddWithValue("@SharedByUserID", sharedByUser);
                cmd.Parameters.AddWithValue("@SharedWithUsername", shareWith);

                int result = Convert.ToInt32(cmd.ExecuteScalar());

                switch (result)
                {
                    case 1:
                        ShowMessage($"✅ File shared successfully with @{shareWith}!", "success");
                        txtShareWith.Text = "";
                        break;
                    case -1:
                        ShowMessage($"❌ User @{shareWith} was not found.", "error");
                        break;
                    case -2:
                        ShowMessage($"⚠️ File is already shared with @{shareWith}.", "info");
                        break;
                }
            }
        }

        protected void rptShared_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Download")
            {
                string[] parts = e.CommandArgument.ToString().Split(',');
                string storedName = parts[0];
                string originalName = parts[1];
                DownloadFile(storedName, originalName);
            }
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
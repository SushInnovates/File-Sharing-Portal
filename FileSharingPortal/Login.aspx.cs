using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Security.Cryptography;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace FileSharingPortal
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (Session["UserID"] != null)
                Response.Redirect("Dashboard.aspx");
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = HashPassword(txtPassword.Text);
            string connStr = ConfigurationManager.ConnectionStrings["FileSharingPortalDB"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand("sp_LoginUser", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Username", username);
                    cmd.Parameters.AddWithValue("@Password", password);

                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        Session["UserID"] = reader["UserID"].ToString();
                        Session["Username"] = reader["Username"].ToString();
                        Session["FullName"] = reader["FullName"].ToString();
                        Response.Redirect("Dashboard.aspx");
                    }
                    else
                    {
                        ShowMessage("❌ Invalid username or password. Please try again.", "error");
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, "error");
            }
        }

        private string HashPassword(string password)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                StringBuilder sb = new StringBuilder();
                foreach (byte b in bytes)
                    sb.Append(b.ToString("x2"));
                return sb.ToString();
            }
        }

        private void ShowMessage(string message, string type)
        {
            lblMessage.Text = $"<div class='alert alert-{type}'>{message}</div>";
            lblMessage.Visible = true;
        }
    }
}
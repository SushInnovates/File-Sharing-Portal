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
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] != null)
                Response.Redirect("Dashboard.aspx");
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string fullName = txtFullName.Text.Trim();
            string username = txtUsername.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;

            // ── SERVER-SIDE PASSWORD COMPLEXITY CHECK ─────────────────────────
            string pwError = CheckPasswordComplexity(password);
            if (pwError != null)
            {
                ShowMessage(pwError, "error");
                return;
            }
            // ──────────────────────────────────────────────────────────────────

            string hashedPassword = HashPassword(password);
            string connStr = ConfigurationManager.ConnectionStrings["FileSharingPortalDB"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand("sp_RegisterUser", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Username", username);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Password", hashedPassword);
                    cmd.Parameters.AddWithValue("@FullName", fullName);

                    int result = Convert.ToInt32(cmd.ExecuteScalar());

                    if (result == -1)
                    {
                        ShowMessage("Username or email already exists. Please choose another.", "error");
                    }
                    else
                    {
                        ShowMessage("✅ Account created successfully! Redirecting to login...", "success");
                        Response.AddHeader("REFRESH", "2;URL=Login.aspx");
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

        /// <summary>
        /// Validates password complexity.
        /// Returns null if password passes all rules, or an error string if it fails.
        /// Rules: min 8 chars, 1 upper, 1 lower, 1 digit, 1 special character.
        /// </summary>
        private string CheckPasswordComplexity(string password)
        {
            if (string.IsNullOrEmpty(password) || password.Length < 8)
                return "❌ Password must be at least 8 characters long.";

            bool hasUpper = false;
            bool hasLower = false;
            bool hasDigit = false;
            bool hasSymbol = false;

            foreach (char c in password)
            {
                if (char.IsUpper(c)) hasUpper = true;
                if (char.IsLower(c)) hasLower = true;
                if (char.IsDigit(c)) hasDigit = true;
                if (!char.IsLetterOrDigit(c) && !char.IsWhiteSpace(c)) hasSymbol = true;
            }

            if (!hasUpper) return "❌ Password must contain at least one uppercase letter (A–Z).";
            if (!hasLower) return "❌ Password must contain at least one lowercase letter (a–z).";
            if (!hasDigit) return "❌ Password must contain at least one number (0–9).";
            if (!hasSymbol) return "❌ Password must contain at least one special character (!@#$%^&*...).";

            return null; // All checks passed
        }

    }

}
    
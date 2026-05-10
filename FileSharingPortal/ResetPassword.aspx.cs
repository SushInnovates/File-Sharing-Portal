using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Cryptography;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FileSharingPortal
{
    public partial class ResetPassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Reset_Email"] == null)
            {
                Response.Redirect("ForgotPassword.aspx");
                return;
            }

            // If already logged in, no need to reset
            if (Session["UserID"] != null)
                Response.Redirect("Dashboard.aspx");
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            // ── Get values ────────────────────────────────────────────────
            string email = Session["Reset_Email"]?.ToString();
            string enteredOTP = (hfOTP.Value ?? "").Trim();
            string newPw = txtNewPassword.Text;
            string confirmPw = txtConfirmPassword.Text;

            // ── 1. OTP format check ───────────────────────────────────────
            if (string.IsNullOrEmpty(enteredOTP) || enteredOTP.Length != 6)
            {
                ShowMessage("⚠️ Please enter all 6 digits of the reset code.", "error");
                return;
            }

            // ── 2. Password match check ───────────────────────────────────
            if (newPw != confirmPw)
            {
                ShowMessage("❌ Passwords do not match. Please try again.", "error");
                return;
            }

            // ── 3. Password complexity check ──────────────────────────────
            string pwError = CheckPasswordComplexity(newPw);
            if (pwError != null)
            {
                ShowMessage(pwError, "error");
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["FileSharingDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // ── 4. Verify the OTP against the database ────────────────
                SqlCommand verifyCmd = new SqlCommand("sp_VerifyOTP", conn);
                verifyCmd.CommandType = CommandType.StoredProcedure;
                verifyCmd.Parameters.AddWithValue("@Email", email);
                verifyCmd.Parameters.AddWithValue("@OTPCode", enteredOTP);

                int verifyResult = Convert.ToInt32(verifyCmd.ExecuteScalar());

                switch (verifyResult)
                {
                    case 1:
                        // ── 5. OTP valid — update the password ───────────
                        string hashedPw = HashPassword(newPw);

                        SqlCommand resetCmd = new SqlCommand("sp_ResetPassword", conn);
                        resetCmd.CommandType = CommandType.StoredProcedure;
                        resetCmd.Parameters.AddWithValue("@Email", email);
                        resetCmd.Parameters.AddWithValue("@NewPassword", hashedPw);
                        resetCmd.ExecuteNonQuery();

                        // Clear the reset session
                        Session.Remove("Reset_Email");

                        ShowMessage("✅ Password reset successfully! You can now log in with your new password. Redirecting...", "success");
                        Response.AddHeader("REFRESH", "3;URL=Login.aspx");
                        break;

                    case -1:
                        ShowMessage("❌ The reset code has expired. Please <a href='ForgotPassword.aspx' style='color:#ffa726;'>request a new code</a>.", "error");
                        break;

                    default:
                        ShowMessage("❌ Incorrect reset code. Please check your email and try again.", "error");
                        break;
                }
            }
        }

        // ── Password complexity — same rules as Register page ─────────────
        private string CheckPasswordComplexity(string password)
        {
            if (string.IsNullOrEmpty(password) || password.Length < 8)
                return "❌ Password must be at least 8 characters long.";

            bool hasUpper = false, hasLower = false,
                 hasDigit = false, hasSymbol = false;

            foreach (char c in password)
            {
                if (char.IsUpper(c)) hasUpper = true;
                if (char.IsLower(c)) hasLower = true;
                if (char.IsDigit(c)) hasDigit = true;
                if (!char.IsLetterOrDigit(c) && !char.IsWhiteSpace(c)) hasSymbol = true;
            }

            if (!hasUpper) return "❌ Password needs at least one uppercase letter (A–Z).";
            if (!hasLower) return "❌ Password needs at least one lowercase letter (a–z).";
            if (!hasDigit) return "❌ Password needs at least one number (0–9).";
            if (!hasSymbol) return "❌ Password needs at least one special character (!@#$...).";

            return null;
        }

        // ── PBKDF2 password hashing — same algorithm as Register ─────────
        private string HashPassword(string password)
        {
            byte[] salt = System.Text.Encoding.UTF8.GetBytes("FileVault_Salt_2024!");
            using (var pbkdf2 = new Rfc2898DeriveBytes(
                password, salt, 10000, HashAlgorithmName.SHA256))
            {
                byte[] hash = pbkdf2.GetBytes(32);
                return Convert.ToBase64String(hash);
            }
        }

        private void ShowMessage(string msg, string type)
        {
            lblMessage.Text = $"<div class='alert alert-{type}'>{msg}</div>";
            lblMessage.Visible = true;
        }
    }
}
    

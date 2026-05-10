//using System;
//using System.Collections.Generic;
//using System.Configuration;
//using System.Data;
//using System.Data.SqlClient;
//using System.Linq;
//using System.Net.Mail;
//using System.Web;
//using System.Web.UI;
//using System.Web.UI.WebControls;

//namespace FileSharingPortal
//{
//    public partial class ForgetPassword : System.Web.UI.Page
//    {
//        protected void Page_Load(object sender, EventArgs e)
//        {
//            if (Session["UserID"] != null)
//                Response.Redirect("Dashboard.aspx");
//        }

//        protected void btnSendOTP_Click(object sender, EventArgs e)
//        {
//            string email = txtEmail.Text.Trim().ToLower();
//            string connStr = ConfigurationManager.ConnectionStrings["FileSharingDB"].ConnectionString;

//            // Generate a 6-digit OTP
//            string otp = new Random().Next(100000, 999999).ToString();

//            try
//            {
//                // ── Step 1: Save OTP to database ────────────────────────────
//                using (SqlConnection conn = new SqlConnection(connStr))
//                {
//                    conn.Open();
//                    SqlCommand cmd = new SqlCommand("sp_ForgotPassword", conn);
//                    cmd.CommandType = CommandType.StoredProcedure;
//                    cmd.Parameters.AddWithValue("@Email", email);
//                    cmd.Parameters.AddWithValue("@OTPCode", otp);

//                    int result = Convert.ToInt32(cmd.ExecuteScalar());

//                    if (result == -1)
//                    {
//                        // We still show a generic success message to prevent
//                        // email enumeration (someone testing if emails exist)
//                        ShowMessage("✅ If that email exists in our system, a reset code has been sent.", "success");
//                        return;
//                    }
//                }

//                // ── Step 2: Send the OTP email ───────────────────────────────
//                SendResetEmail(email, otp);

//                // ── Step 3: Save email to Session so ResetPassword page knows who ─
//                Session["Reset_Email"] = email;

//                // ── Step 4: Redirect to OTP entry + new password page ────────
//                ShowMessage("✅ Reset code sent! Check your inbox. Redirecting...", "success");
//                Response.AddHeader("REFRESH", "2;URL=ResetPassword.aspx");
//            }
//            catch (Exception ex)
//            {
//                ShowMessage("Error: " + ex.Message +
//                    "<br/>Check your SMTP settings in Web.config.", "error");
//            }
//        }

//        private void SendResetEmail(string toEmail, string otp)
//        {
//            MailMessage mail = new MailMessage();
//            mail.To.Add(toEmail);
//            mail.Subject = "FileVault — Password Reset Code";
//            mail.IsBodyHtml = true;
//            mail.Body = $@"
//<!DOCTYPE html>
//<html>
//<body style='margin:0;padding:0;background:#0d0d1f;font-family:Arial,sans-serif;'>
//<div style='max-width:520px;margin:40px auto;background:rgba(255,255,255,0.06);
//            border:1px solid rgba(255,255,255,0.12);border-radius:18px;padding:2.5rem;'>

//    <h2 style='color:#ffa726;margin:0 0 0.5rem;font-size:1.5rem;'>🔑 FileVault</h2>
//    <p style='color:#bbb;margin:0 0 1.5rem;font-size:0.9rem;'>Password Reset Request</p>

//    <p style='color:#f0f0f0;margin-bottom:0.5rem;'>
//        We received a request to reset the password for this account.
//    </p>
//    <p style='color:#ccc;font-size:0.9rem;margin-bottom:1.5rem;'>
//        Your 6-digit password reset code is:
//    </p>

//    <div style='background:rgba(255,167,38,0.12);border:1px solid rgba(255,167,38,0.4);
//                border-radius:14px;padding:1.5rem;text-align:center;margin-bottom:1.5rem;'>
//        <span style='font-size:2.8rem;font-weight:900;letter-spacing:0.6rem;color:#ffa726;'>
//            {otp}
//        </span>
//    </div>

//    <p style='color:#888;font-size:0.85rem;'>
//        ⏱ This code expires in <strong style='color:#ef5350;'>10 minutes</strong>.<br/><br/>
//        If you did NOT request a password reset, you can safely ignore this email.
//        Your password will not be changed.
//    </p>

//    <hr style='border:none;border-top:1px solid rgba(255,255,255,0.08);margin:1.5rem 0;'/>
//    <p style='color:#555;font-size:0.78rem;'>FileVault — Secure File Sharing Portal</p>
//</div>
//</body>
//</html>";

//            SmtpClient smtp = new SmtpClient();
//            smtp.Send(mail);
//        }

//        private void ShowMessage(string msg, string type)
//        {
//            lblMessage.Text = $"<div class='alert alert-{type}'>{msg}</div>";
//            lblMessage.Visible = true;
//        }
//    }
//}
    

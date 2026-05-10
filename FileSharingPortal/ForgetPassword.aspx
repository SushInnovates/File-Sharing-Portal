<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="FileSharingPortal.ForgotPassword" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Forgot Password — ShareSphere</title>
    <link rel="stylesheet" href="Styles/glass.css" />
</head>
<body>
    <form id="form1" runat="server">

        <!-- Navbar -->
        <nav class="navbar">
            <a href="Home.aspx" class="navbar-brand">⬡ FileVault</a>
            <ul class="navbar-nav">
                <li><a href="Login.aspx">Login</a></li>
                <li><a href="Register.aspx" class="btn btn-primary btn-sm">Register</a></li>
            </ul>
        </nav>

        <div class="auth-container">
            <div class="auth-card glass-card" style="max-width:440px;">

                <!-- Header -->
                <div class="auth-logo">
                    <div style="font-size:3rem; margin-bottom:0.5rem;">🔑</div>
                    <h2>Forgot Password?</h2>
                    <p style="color:var(--text-secondary); margin-top:0.4rem; font-size:0.9rem;">
                        No problem. Enter your registered email address and
                        we'll send you a 6-digit reset code.
                    </p>
                </div>

                <!-- Message display -->
                <asp:Label ID="lblMessage" runat="server" Visible="false" />

                <!-- Email field -->
                <div class="form-group">
                    <label>Registered Email Address</label>
                    <asp:TextBox ID="txtEmail" runat="server"
                        CssClass="form-control"
                        TextMode="Email"
                        placeholder="you@example.com"
                        MaxLength="200" />
                    <asp:RequiredFieldValidator
                        ID="rfvEmail" runat="server"
                        ControlToValidate="txtEmail"
                        ErrorMessage="Please enter your email address."
                        CssClass="alert alert-error mt-1 d-block"
                        Display="Dynamic" />
                </div>

                <!-- Submit button -->
                <asp:Button ID="btnSendOTP" runat="server"
                    Text="📧 Send Reset Code"
                    CssClass="btn btn-primary w-100"
                    OnClick="btnSendOTP_Click" />

                <!-- Back to login -->
                <p class="text-center mt-3" style="color:var(--text-secondary); font-size:0.88rem;">
                    Remembered it? <a href="Login.aspx" style="color:var(--accent2);">Back to Login</a>
                </p>

            </div>
        </div>

    </form>
</body>
</html>

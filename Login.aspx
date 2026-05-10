<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="FileSharingPortal.Login" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Login — ShareSphere</title>
    <link rel="stylesheet" href="Styles/glass.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="auth-container">
            <div class="auth-card glass-card">
                <div class="auth-logo">
                    <a href="Home.aspx" style="text-decoration:none;">
                        <h2>⬡ ShareSphere</h2>
                    </a>
                    <p>Welcome back! Sign in to continue.</p>
                </div>

                <asp:Label ID="lblMessage" runat="server" Visible="false" />

                <div class="form-group">
                    <label>Username or Email</label>
                    <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="your username or email" />
                    <asp:RequiredFieldValidator ID="rfvUsername" runat="server"
                        ControlToValidate="txtUsername"
                        ErrorMessage="Please enter your username."
                        CssClass="alert alert-error mt-1 d-block"
                        Display="Dynamic" />
                </div>

                <div class="form-group">
                    <label>Password</label>
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="your password" />
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                        ControlToValidate="txtPassword"
                        ErrorMessage="Please enter your password."
                        CssClass="alert alert-error mt-1 d-block"
                        Display="Dynamic" />
                </div>

                <asp:Button ID="btnLogin" runat="server" Text="Sign In →"
                    CssClass="btn btn-primary w-100"
                    OnClick="btnLogin_Click" />

                 <p class="text-center mt-3" style="font-size:0.88rem;">
                    <a href="ForgotPassword.aspx" style="color:#ffa726;">🔑 Forgot your password?</a>
                </p>

                <p class="text-center mt-2" style="color:var(--text-secondary); font-size:0.88rem;">
                    Don't have an account? <a href="Register.aspx" style="color:var(--accent2);">Register free</a>
                </p>
            </div>
        </div>
    </form>
</body>
</html>
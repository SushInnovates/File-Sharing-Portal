<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="FileSharingPortal.Register" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Register — ShareSphere</title>
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
                    <p>Create your free account</p>
                </div>

                <!-- Alert Messages -->
                <asp:Label ID="lblMessage" runat="server" Visible="false" />

                <div class="form-group">
                    <label>Full Name</label>
                    <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" placeholder="Gojo" MaxLength="200" />
                    <asp:RequiredFieldValidator ID="rfvFullName" runat="server"
                        ControlToValidate="txtFullName"
                        ErrorMessage="Full name is required."
                        CssClass="alert alert-error mt-1 d-block"
                        Display="Dynamic" />
                </div>

                <div class="form-group">
                    <label>Username</label>
                    <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="HonouredOne" MaxLength="100" />
                    <asp:RequiredFieldValidator ID="rfvUsername" runat="server"
                        ControlToValidate="txtUsername"
                        ErrorMessage="Username is required."
                        CssClass="alert alert-error mt-1 d-block"
                        Display="Dynamic" />
                </div>

                <div class="form-group">
                    <label>Email Address</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="Gojo@example.com" MaxLength="200" />
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                        ControlToValidate="txtEmail"
                        ErrorMessage="Email is required."
                        CssClass="alert alert-error mt-1 d-block"
                        Display="Dynamic" />
                </div>

             <div class="form-group">
                    <label>Password</label>
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control"
                        TextMode="Password"
                        placeholder="Min 8 chars — must include A-Z, a-z, 0-9, symbol"
                        MaxLength="100"
                        onkeyup="checkPasswordStrength(this.value)" />
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                        ControlToValidate="txtPassword"
                        ErrorMessage="Password is required."
                        CssClass="alert alert-error mt-1 d-block"
                        Display="Dynamic" />

                    <!-- Strength Bar -->
                    <div style="margin-top:0.6rem;">
                        <div style="height:6px; background:rgba(255,255,255,0.08); border-radius:4px; overflow:hidden;">
                            <div id="strengthBar" style="height:100%; width:0%; border-radius:4px; transition:all 0.35s ease;"></div>
                        </div>
                        <div id="strengthLabel" style="font-size:0.75rem; margin-top:0.3rem; font-weight:600;"></div>
                    </div>

                    <!-- Live Rules Checklist -->
                    <div style="margin-top:0.75rem; display:grid; grid-template-columns:1fr 1fr; gap:0.3rem 1.5rem; font-size:0.8rem;">
                        <span id="r-len">  <span id="i-len"  style="color:#555;">✗</span> At least 8 characters</span>
                        <span id="r-up">   <span id="i-up"   style="color:#555;">✗</span> One uppercase (A–Z)</span>
                        <span id="r-low">  <span id="i-low"  style="color:#555;">✗</span> One lowercase (a–z)</span>
                        <span id="r-num">  <span id="i-num"  style="color:#555;">✗</span> One number (0–9)</span>
                        <span id="r-sym">  <span id="i-sym"  style="color:#555;">✗</span> One symbol (!@#$…)</span>
                    </div>
                </div>

                <div class="form-group">
                    <label>Confirm Password</label>
                    <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Repeat password" MaxLength="100" />
                    <asp:CompareValidator ID="cvPassword" runat="server"
                        ControlToValidate="txtConfirmPassword"
                        ControlToCompare="txtPassword"
                        ErrorMessage="Passwords do not match."
                        CssClass="alert alert-error mt-1 d-block"
                        Display="Dynamic" />
                </div>

                <asp:Button ID="btnRegister" runat="server" Text="Create Account →"
                    CssClass="btn btn-primary w-100"
                    OnClick="btnRegister_Click" />

                <p class="text-center mt-3" style="color:var(--text-secondary); font-size:0.88rem;">
                    Already have an account? <a href="Login.aspx" style="color:var(--accent2);">Sign in</a>
                </p>
            </div>
        </div>

        <script type="text/javascript">
            function checkPasswordStrength(pw) {
                var checks = {
                    len: pw.length >= 8,
                    up:  /[A-Z]/.test(pw),
                    low: /[a-z]/.test(pw),
                    num: /[0-9]/.test(pw),
                    sym: /[!@#$%^&*()\-_=+\[\]{};:'",.<>?\/\\|`~]/.test(pw)
                };

                // Update each rule indicator
                for (var key in checks) {
                    var icon = document.getElementById('i-' + key);
                    if (icon) {
                        icon.textContent = checks[key] ? '✓' : '✗';
                        icon.style.color  = checks[key] ? '#66bb6a' : '#555';
                    }
                }

                // Score = number of rules passed
                var score = Object.values(checks).filter(Boolean).length;

                var bar   = document.getElementById('strengthBar');
                var label = document.getElementById('strengthLabel');

                var levels = [
                    { w:'0%',   c:'transparent', t:'' },
                    { w:'20%',  c:'#ef5350',     t:'Very Weak' },
                    { w:'40%',  c:'#ff7043',     t:'Weak' },
                    { w:'60%',  c:'#ffa726',     t:'Fair' },
                    { w:'80%',  c:'#66bb6a',     t:'Strong' },
                    { w:'100%', c:'#4fc3f7',     t:'Very Strong ✓' }
                ];

                bar.style.width      = levels[score].w;
                bar.style.background = levels[score].c;
                label.textContent    = levels[score].t;
                label.style.color    = levels[score].c;
            }
        </script>

    </form>
</body>
</html>
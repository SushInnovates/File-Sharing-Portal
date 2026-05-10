<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ResetPassword.aspx.cs" Inherits="FileSharingPortal.ResetPassword" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Reset Password — ShareSphere</title>
    <link rel="stylesheet" href="Styles/glass.css" />
    <style>
        /* OTP digit boxes */
        .otp-wrap { display:flex; gap:0.6rem; justify-content:center; margin:1.2rem 0 1.5rem; }
        .otp-box  {
            width:50px; height:56px; text-align:center;
            font-size:1.6rem; font-weight:800;
            background:rgba(255,255,255,0.06);
            border:2px solid rgba(255,255,255,0.15);
            border-radius:12px; color:#f0f0f0; outline:none;
            transition:border-color 0.2s, box-shadow 0.2s;
        }
        .otp-box:focus {
            border-color:#ffa726;
            box-shadow:0 0 0 3px rgba(255,167,38,0.2);
        }
        /* Divider line between sections */
        .section-divider {
            border:none; border-top:1px solid rgba(255,255,255,0.1);
            margin:1.5rem 0;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <nav class="navbar">
            <a href="Home.aspx" class="navbar-brand">⬡ FileVault</a>
            <ul class="navbar-nav">
                <li><a href="Login.aspx">Login</a></li>
            </ul>
        </nav>

        <div class="auth-container">
            <div class="auth-card glass-card" style="max-width:460px;">

                <div class="auth-logo">
                    <div style="font-size:3rem; margin-bottom:0.5rem;">🛡️</div>
                    <h2>Reset Your Password</h2>
                    <p style="color:var(--text-secondary); font-size:0.88rem; margin-top:0.4rem;">
                        Enter the 6-digit code sent to your email,
                        then choose a new password.
                    </p>
                    <p style="color:#ffa726; font-size:0.82rem; margin-top:0.3rem;">
                        Code expires in
                        <span id="countdownTimer" style="font-weight:700;">10:00</span>
                    </p>
                </div>

                <!-- Alert messages -->
                <asp:Label ID="lblMessage" runat="server" Visible="false" />

                <!-- ══ SECTION 1: OTP Entry ══════════════════════════════ -->
                <p style="font-size:0.82rem; color:var(--text-secondary); margin-bottom:0.4rem;">
                    Step 1 — Enter the 6-digit reset code
                </p>

                <div class="otp-wrap">
                    <input class="otp-box" type="text" id="d1" maxlength="1" inputmode="numeric"
                        oninput="moveNext(this,'d2')" onkeydown="moveBack(event,'',this)" />
                    <input class="otp-box" type="text" id="d2" maxlength="1" inputmode="numeric"
                        oninput="moveNext(this,'d3')" onkeydown="moveBack(event,'d1',this)" />
                    <input class="otp-box" type="text" id="d3" maxlength="1" inputmode="numeric"
                        oninput="moveNext(this,'d4')" onkeydown="moveBack(event,'d2',this)" />
                    <input class="otp-box" type="text" id="d4" maxlength="1" inputmode="numeric"
                        oninput="moveNext(this,'d5')" onkeydown="moveBack(event,'d3',this)" />
                    <input class="otp-box" type="text" id="d5" maxlength="1" inputmode="numeric"
                        oninput="moveNext(this,'d6')" onkeydown="moveBack(event,'d4',this)" />
                    <input class="otp-box" type="text" id="d6" maxlength="1" inputmode="numeric"
                        oninput="combineOTP()"        onkeydown="moveBack(event,'d5',this)" />
                </div>

                <!-- Hidden field: combined OTP sent to server -->
                <asp:HiddenField ID="hfOTP" runat="server" />

                <hr class="section-divider" />

                <!-- ══ SECTION 2: New Password ════════════════════════════ -->
                <p style="font-size:0.82rem; color:var(--text-secondary); margin-bottom:0.75rem;">
                    Step 2 — Choose your new password
                </p>

                <div class="form-group">
                    <label>New Password</label>
                    <asp:TextBox ID="txtNewPassword" runat="server"
                        CssClass="form-control"
                        TextMode="Password"
                        placeholder="Min 8 chars — A-Z, a-z, 0-9, symbol"
                        MaxLength="100"
                        onkeyup="checkStrength(this.value)" />

                    <!-- Strength bar -->
                    <div style="margin-top:0.5rem;">
                        <div style="height:5px;background:rgba(255,255,255,0.08);border-radius:3px;overflow:hidden;">
                            <div id="pwBar" style="height:100%;width:0%;border-radius:3px;transition:all 0.3s;"></div>
                        </div>
                        <div id="pwLabel" style="font-size:0.75rem;margin-top:0.25rem;font-weight:600;"></div>
                    </div>

                    <asp:RequiredFieldValidator ID="rfvNewPw" runat="server"
                        ControlToValidate="txtNewPassword"
                        ErrorMessage="New password is required."
                        CssClass="alert alert-error mt-1 d-block"
                        Display="Dynamic" />
                </div>

                <div class="form-group">
                    <label>Confirm New Password</label>
                    <asp:TextBox ID="txtConfirmPassword" runat="server"
                        CssClass="form-control"
                        TextMode="Password"
                        placeholder="Type your new password again"
                        MaxLength="100" />
                    <asp:CompareValidator ID="cvPw" runat="server"
                        ControlToValidate="txtConfirmPassword"
                        ControlToCompare="txtNewPassword"
                        ErrorMessage="Passwords do not match."
                        CssClass="alert alert-error mt-1 d-block"
                        Display="Dynamic" />
                </div>

                <!-- Submit button -->
                <asp:Button ID="btnReset" runat="server"
                    Text="🔒 Reset My Password"
                    CssClass="btn btn-primary w-100"
                    OnClick="btnReset_Click"
                    OnClientClick="combineOTP();" />

                <!-- Resend + back links -->
                <div class="text-center mt-3" style="font-size:0.85rem; color:var(--text-secondary);">
                    Code not received?
                    <a href="ForgotPassword.aspx" style="color:#ffa726;">Send a new code</a>
                </div>
                <div class="text-center mt-2">
                    <a href="Login.aspx" style="color:var(--text-secondary); font-size:0.82rem;">← Back to Login</a>
                </div>

            </div>
        </div>

        <script type="text/javascript">
            // ── OTP Box Navigation ────────────────────────────────────────
            function moveNext(cur, nextId) {
                cur.value = cur.value.replace(/[^0-9]/g, '');
                if (cur.value.length === 1 && nextId)
                    document.getElementById(nextId).focus();
                combineOTP();
            }
            function moveBack(e, prevId, cur) {
                if (e.key === 'Backspace' && cur.value === '' && prevId)
                    document.getElementById(prevId).focus();
            }
            function combineOTP() {
                var code = '';
                for (var i = 1; i <= 6; i++)
                    code += document.getElementById('d' + i).value;
                document.getElementById('<%= hfOTP.ClientID %>').value = code;
            }

            // ── Password Strength Meter ───────────────────────────────────
            function checkStrength(pw) {
                var score = 0;
                if (pw.length >= 8)                                        score++;
                if (/[A-Z]/.test(pw))                                      score++;
                if (/[a-z]/.test(pw))                                      score++;
                if (/[0-9]/.test(pw))                                      score++;
                if (/[^A-Za-z0-9]/.test(pw))                              score++;

                var levels = [
                    {w:'0%',   c:'transparent', t:''},
                    {w:'20%',  c:'#ef5350',     t:'Very Weak'},
                    {w:'40%',  c:'#ff7043',     t:'Weak'},
                    {w:'60%',  c:'#ffa726',     t:'Fair'},
                    {w:'80%',  c:'#66bb6a',     t:'Strong'},
                    {w:'100%', c:'#4fc3f7',     t:'Very Strong ✓'}
                ];
                document.getElementById('pwBar').style.width      = levels[score].w;
                document.getElementById('pwBar').style.background = levels[score].c;
                document.getElementById('pwLabel').textContent    = levels[score].t;
                document.getElementById('pwLabel').style.color    = levels[score].c;
            }

            // ── 10-minute Countdown ───────────────────────────────────────
            var secs = 600;
            var el   = document.getElementById('countdownTimer');
            var tick = setInterval(function() {
                secs--;
                if (secs <= 0) {
                    clearInterval(tick);
                    el.textContent = 'EXPIRED';
                    el.style.color = '#ef5350';
                } else {
                    var m = Math.floor(secs / 60);
                    var s = secs % 60;
                    el.textContent = m + ':' + (s < 10 ? '0' : '') + s;
                }
            }, 1000);
        </script>

    </form>
</body>
</html>
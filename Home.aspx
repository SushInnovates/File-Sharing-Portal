<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="FileSharingPortal.Home" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>FileSharingPortal — Secure File Sharing Portal</title>
    <link rel="stylesheet" href="Styles/glass.css" />
</head>
<body>
    <form id="form1" runat="server">
        <!-- Navigation -->
        <nav class="navbar">
            <a href="Home.aspx" class="navbar-brand">⬡ ShareSphere</a>
            <ul class="navbar-nav">
                <li><a href="Login.aspx">Login</a></li>
                <li><a href="Register.aspx" class="btn btn-primary btn-sm">Get Started</a></li>
            </ul>
        </nav>

        <!-- Hero Section -->
        <section class="hero">
            <h1>Share Files.<br/>Stay Secure.</h1>
            <p>Upload, manage, and share your files with anyone — wrapped in a beautiful, secure interface built for modern teams.</p>
            <div class="hero-buttons">
                <a href="Register.aspx" class="btn btn-primary">🚀 Register</a>
                <a href="Login.aspx" class="btn btn-secondary">→ Sign In</a>
            </div>
        </section>

        <!-- Feature Cards -->
        <div class="features-grid" >
            <div class="feature-card">
                <div class="feat-icon">📤</div>
                <h3>Easy Uploads</h3>
                <p>Upload PDFs, Word docs, ZIPs, images and more. Large file support included.</p>
            </div>
            <div class="feature-card">
                <div class="feat-icon">🔗</div>
                <h3>Instant Sharing</h3>
                <p>Share any file with registered users in one click. Full access control.</p>
            </div>
            <div class="feature-card">
                <div class="feat-icon">📊</div>
                <h3>Smart Dashboard</h3>
                <p>Track all your uploads, shares, and received files from one clean view.</p>
            </div>
            <div class="feature-card emptyCard" style="opacity:0">

            </div>
            <div class="feature-card" style ="align-content:center">
                <div class="feat-icon">🛡️</div>
                <h3>Secure Storage</h3>
                <p>Files stored with unique names. Passwords hashed. Sessions protected.</p>
            </div>


        </div>

        <div style="text-align:center; padding: 3rem; color: rgba(240,240,240,0.3); font-size:0.85rem;">
            Share Without Limits...
        </div>
    </form>
</body>
</html>
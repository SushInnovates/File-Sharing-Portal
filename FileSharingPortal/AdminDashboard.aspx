<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="FileSharingPortal.AdminDashboard" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Dashboard — ShareSphere</title>
    <link rel="stylesheet" href="Styles/glass.css" />
</head>
<body>
    <form id="form1" runat="server">
        <nav class="navbar">
            <a href="AdminDashboard.aspx" class="navbar-brand">⬡ FileVault Admin</a>
            <ul class="navbar-nav">
                <li><a href="AdminDashboard.aspx" style="color:#ffa726;">⚙ Dashboard</a></li>
                <li><a href="ManageUsers.aspx">👥 Users</a></li>
                <li><a href="ManageFiles.aspx">📁 Files</a></li>
                <li><a href="Dashboard.aspx">User View</a></li>
                <li>
                    <asp:LinkButton ID="lbLogout" runat="server" OnClick="lbLogout_Click"
                        CssClass="btn btn-danger btn-sm">Sign Out</asp:LinkButton>
                </li>
            </ul>
        </nav>

        <div class="page-wrapper">
            <div class="page-header">
                <h1>⚙ Admin Dashboard</h1>
                <p>System overview — FileVault portal statistics</p>
            </div>

            <!-- Stats Grid -->
            <div class="stats-grid" style="grid-template-columns:repeat(auto-fit,minmax(180px,1fr));">
                <div class="stat-card">
                    <div class="stat-icon">👥</div>
                    <div class="stat-number"><asp:Literal ID="litTotalUsers" runat="server" Text="0"/></div>
                    <div class="stat-label">Total Users</div>
                </div>
                <div class="stat-card" style="border-color:rgba(255,167,38,0.4);">
                    <div class="stat-icon">⏳</div>
                    <div class="stat-number" style="color:#ffa726;"><asp:Literal ID="litPending" runat="server" Text="0"/></div>
                    <div class="stat-label">Pending Approval</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">🛡️</div>
                    <div class="stat-number"><asp:Literal ID="litAdmins" runat="server" Text="0"/></div>
                    <div class="stat-label">Admins</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">📁</div>
                    <div class="stat-number"><asp:Literal ID="litTotalFiles" runat="server" Text="0"/></div>
                    <div class="stat-label">Total Files</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">💾</div>
                    <div class="stat-number"><asp:Literal ID="litStorage" runat="server" Text="0"/></div>
                    <div class="stat-label">Storage Used</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">🔗</div>
                    <div class="stat-number"><asp:Literal ID="litShares" runat="server" Text="0"/></div>
                    <div class="stat-label">Total Shares</div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="glass-card">
                <h3 style="font-family:Syne,sans-serif; margin-bottom:1.2rem;">Quick Actions</h3>
                <div class="d-flex gap-2" style="flex-wrap:wrap;">
                    <a href="ManageUsers.aspx" class="btn btn-primary">👥 Manage Users</a>
                    <a href="ManageFiles.aspx" class="btn btn-secondary">📁 Manage Files</a>
                </div>
                <asp:Label ID="lblPendingAlert" runat="server" Visible="false" />
            </div>
        </div>
    </form>
</body>
</html>

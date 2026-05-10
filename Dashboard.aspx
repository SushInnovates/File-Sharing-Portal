<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="FileSharingPortal.Dashboard" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Dashboard — ShareSphere</title>
    <link rel="stylesheet" href="Styles/glass.css" />
</head>
<body>
    <form id="form1" runat="server">
        <!-- Nav -->
        <nav class="navbar">
            <a href="Dashboard.aspx" class="navbar-brand">⬡ ShareSphere</a>
            <ul class="navbar-nav">
                <li><a href="Dashboard.aspx">Dashboard</a></li>
                <li><a href="UploadFile.aspx">Upload</a></li>
                <li><a href="MyFiles.aspx">My Files</a></li>
                <li><a href="SharedFiles.aspx">Shared</a></li>
                <li>
                    <asp:LinkButton ID="lbLogout" runat="server" OnClick="lbLogout_Click"
                        CssClass="btn btn-danger btn-sm">Sign Out</asp:LinkButton>
                </li>
            </ul>
        </nav>

        <div class="page-wrapper">
            <div class="page-header">
                <h1>Good to see you, <asp:Literal ID="litName" runat="server" /> 👋</h1>
                <p>Here's what's happening with your files today.</p>
            </div>

            <!-- Stats -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon">📁</div>
                    <div class="stat-number"><asp:Literal ID="litTotalFiles" runat="server" Text="0" /></div>
                    <div class="stat-label">Total Files</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">💾</div>
                    <div class="stat-number"><asp:Literal ID="litTotalSize" runat="server" Text="0 KB" /></div>
                    <div class="stat-label">Total Storage</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">🔗</div>
                    <div class="stat-number"><asp:Literal ID="litShared" runat="server" Text="0" /></div>
                    <div class="stat-label">Files Shared</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">📥</div>
                    <div class="stat-number"><asp:Literal ID="litReceived" runat="server" Text="0" /></div>
                    <div class="stat-label">Received Files</div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="glass-card mb-3">
                <h3 style="font-family:Syne,sans-serif; margin-bottom:1.2rem;">Quick Actions</h3>
                <div class="d-flex gap-2" style="flex-wrap:wrap;">
                    <a href="UploadFile.aspx" class="btn btn-primary">📤 Upload File</a>
                    <a href="MyFiles.aspx" class="btn btn-secondary">📁 My Files</a>
                    <a href="SharedFiles.aspx" class="btn btn-secondary">🔗 Shared Files</a>
                </div>
            </div>

            <!-- Recent Files -->
            <div class="glass-card">
                <div class="d-flex justify-between align-center mb-2">
                    <h3 style="font-family:Syne,sans-serif;">Recent Files</h3>
                    <a href="MyFiles.aspx" style="color:var(--accent2); font-size:0.85rem;">View all →</a>
                </div>
                <asp:Repeater ID="rptRecentFiles" runat="server">
                    <HeaderTemplate>
                        <table class="files-table">
                            <thead>
                                <tr>
                                    <th>File Name</th>
                                    <th>Type</th>
                                    <th>Size</th>
                                    <th>Uploaded</th>
                                </tr>
                            </thead>
                            <tbody>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td><%# Eval("FileName") %></td>
                            <td><span class="file-badge badge-other"><%# Eval("FileType") %></span></td>
                            <td><%# FormatSize(Convert.ToInt64(Eval("FileSize"))) %></td>
                            <td><%# Convert.ToDateTime(Eval("UploadedAt")).ToString("dd MMM yyyy") %></td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                            </tbody>
                        </table>
                    </FooterTemplate>
                </asp:Repeater>
                <asp:Label ID="lblNoFiles" runat="server" Visible="false"
                    Text="<div class='alert alert-info'>No files yet. <a href='UploadFile.aspx' style='color:var(--accent2)'>Upload your first file →</a></div>" />
            </div>
        </div>
    </form>
</body>
</html>
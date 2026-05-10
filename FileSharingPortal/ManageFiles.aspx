<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageFiles.aspx.cs" Inherits="FileSharingPortal.ManageFiles" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Manage Files — ShareSphere Admin</title>
    <link rel="stylesheet" href="Styles/glass.css" />
</head>
<body>
    <form id="form1" runat="server">
        <nav class="navbar">
            <a href="AdminDashboard.aspx" class="navbar-brand">⬡ FileVault Admin</a>
            <ul class="navbar-nav">
                <li><a href="AdminDashboard.aspx">⚙ Dashboard</a></li>
                <li><a href="ManageUsers.aspx">👥 Users</a></li>
                <li><a href="ManageFiles.aspx" style="color:#ffa726;">📁 Files</a></li>
                <li>
                    <asp:LinkButton ID="lbLogout" runat="server" OnClick="lbLogout_Click"
                        CssClass="btn btn-danger btn-sm">Sign Out</asp:LinkButton>
                </li>
            </ul>
        </nav>

        <div class="page-wrapper">
            <div class="page-header">
                <h1>📁 Manage Files</h1>
                <p>View and delete all files uploaded to the portal.</p>
            </div>

            <asp:Label ID="lblMessage" runat="server" Visible="false" />

            <div class="glass-card">
                <asp:Repeater ID="rptFiles" runat="server" OnItemCommand="rptFiles_ItemCommand">
                    <HeaderTemplate>
                        <table class="files-table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>File Name</th>
                                    <th>Uploaded By</th>
                                    <th>Type</th>
                                    <th>Size</th>
                                    <th>Date</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td style="color:var(--text-secondary);"><%# Container.ItemIndex+1 %></td>
                            <td><strong><%# System.Web.HttpUtility.HtmlEncode(Eval("FileName").ToString()) %></strong></td>
                            <td style="color:var(--accent2);">@<%# Eval("Username") %></td>
                            <td><span class="file-badge badge-other"><%# Eval("FileType") %></span></td>
                            <td><%# FormatSize(Convert.ToInt64(Eval("FileSize"))) %></td>
                            <td style="font-size:0.82rem;"><%# Convert.ToDateTime(Eval("UploadedAt")).ToString("dd MMM yy") %></td>
                            <td>
                                <span class="file-badge <%# Convert.ToBoolean(Eval("IsDeleted"))?"badge-zip":"badge-image" %>">
                                    <%# Convert.ToBoolean(Eval("IsDeleted"))?"Deleted":"Active" %>
                                </span>
                            </td>
                            <td>
                                <asp:LinkButton runat="server" CommandName="Delete"
                                    CommandArgument='<%# Eval("FileID") %>'
                                    Visible='<%# !Convert.ToBoolean(Eval("IsDeleted")) %>'
                                    CssClass="btn btn-danger btn-sm"
                                    OnClientClick="return confirm('Delete this file?');">🗑 Delete</asp:LinkButton>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate></tbody></table></FooterTemplate>
                </asp:Repeater>
            </div>
        </div>
    </form>
</body>
</html>
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageUsers.aspx.cs" Inherits="FileSharingPortal.ManageUsers" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Manage Users — ShareSphere Admin</title>
    <link rel="stylesheet" href="Styles/glass.css" />
</head>
<body>
    <form id="form1" runat="server">
        <nav class="navbar">
            <a href="AdminDashboard.aspx" class="navbar-brand">⬡ FileVault Admin</a>
            <ul class="navbar-nav">
                <li><a href="AdminDashboard.aspx">⚙ Dashboard</a></li>
                <li><a href="ManageUsers.aspx" style="color:#ffa726;">👥 Users</a></li>
                <li><a href="ManageFiles.aspx">📁 Files</a></li>
                <li>
                    <asp:LinkButton ID="lbLogout" runat="server" OnClick="lbLogout_Click"
                        CssClass="btn btn-danger btn-sm">Sign Out</asp:LinkButton>
                </li>
            </ul>
        </nav>

        <div class="page-wrapper">
            <div class="page-header">
                <h1>👥 Manage Users</h1>
                <p>Approve, reject, or delete registered users. Pending users appear first.</p>
            </div>

            <asp:Label ID="lblMessage" runat="server" Visible="false" />

            <div class="glass-card">
                <asp:Repeater ID="rptUsers" runat="server" OnItemCommand="rptUsers_ItemCommand">
                    <HeaderTemplate>
                        <table class="files-table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Name</th>
                                    <th>Username</th>
                                    <th>Email</th>
                                    <th>Role</th>
                                    <th>Verified</th>
                                    <th>Status</th>
                                    <th>Joined</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr style='<%# !Convert.ToBoolean(Eval("IsApproved")) ? "border-left:3px solid #ffa726;" : "" %>'>
                            <td style="color:var(--text-secondary);"><%# Container.ItemIndex+1 %></td>
                            <td><strong><%# System.Web.HttpUtility.HtmlEncode(Eval("FullName").ToString()) %></strong></td>
                            <td style="color:var(--accent2);">@<%# Eval("Username") %></td>
                            <td style="color:var(--text-secondary);font-size:0.82rem;"><%# Eval("Email") %></td>
                            <td>
                                <span class="file-badge <%# Eval("Role").ToString()=="Admin"?"badge-pdf":"badge-other" %>">
                                    <%# Eval("Role") %>
                                </span>
                            </td>
                            <td>
                                <span class="file-badge <%# Convert.ToBoolean(Eval("EmailVerified"))?"badge-image":"badge-zip" %>">
                                    <%# Convert.ToBoolean(Eval("EmailVerified"))?"✓ Yes":"✗ No" %>
                                </span>
                            </td>
                            <td>
                                <span class="file-badge <%# Convert.ToBoolean(Eval("IsApproved"))?"badge-docx":"badge-zip" %>">
                                    <%# Convert.ToBoolean(Eval("IsApproved"))?"✓ Approved":"⏳ Pending" %>
                                </span>
                            </td>
                            <td style="font-size:0.82rem;"><%# Convert.ToDateTime(Eval("CreatedAt")).ToString("dd MMM yy") %></td>
                            <td>
                                <div class="d-flex gap-1" style="flex-wrap:wrap;">
                                    <asp:LinkButton runat="server" CommandName="Approve"
                                        CommandArgument='<%# Eval("UserID") %>'
                                        Visible='<%# !Convert.ToBoolean(Eval("IsApproved")) %>'
                                        CssClass="btn btn-success btn-sm"
                                        OnClientClick="return confirm('Approve this user?');">✅ Approve</asp:LinkButton>

                                    <asp:LinkButton runat="server" CommandName="Reject"
                                        CommandArgument='<%# Eval("UserID") %>'
                                        Visible='<%# Convert.ToBoolean(Eval("IsApproved")) %>'
                                        CssClass="btn btn-danger btn-sm"
                                        OnClientClick="return confirm('Reject/deactivate this user?');">🚫 Reject</asp:LinkButton>

                                    <asp:LinkButton runat="server" CommandName="Delete"
                                        CommandArgument='<%# Eval("UserID") %>'
                                        CssClass="btn btn-danger btn-sm"
                                        OnClientClick="return confirm('PERMANENTLY DELETE this user and all their data? Cannot be undone!');">🗑 Delete</asp:LinkButton>
                                </div>
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
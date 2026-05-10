<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MyFiles.aspx.cs" Inherits="FileSharingPortal.MyFiles" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>My Files — ShareSphere</title>
    <link rel="stylesheet" href="Styles/glass.css" />
</head>
<body>
    <form id="form1" runat="server">
        <nav class="navbar">
            <a href="Dashboard.aspx" class="navbar-brand">⬡ FileVault</a>
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
            <div class="page-header d-flex justify-between align-center">
                <div>
                    <h1>My Files</h1>
                    <p>All your uploaded files. Download, share, or delete.</p>
                </div>
                <a href="UploadFile.aspx" class="btn btn-primary">📤 Upload New</a>
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
                                    <th>Type</th>
                                    <th>Size</th>
                                    <th>Uploaded</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td style="color:var(--text-secondary);"><%# Container.ItemIndex + 1 %></td>
                            <td>
                                <strong><%# System.Web.HttpUtility.HtmlEncode(Eval("FileName").ToString()) %></strong>
                                <div style="font-size:0.78rem;color:var(--text-secondary);"><%# Eval("Description") %></div>
                            </td>
                            <td>
                                <span class="file-badge <%# GetBadgeClass(Eval("FileType").ToString()) %>">
                                    <%# Eval("FileType") %>
                                </span>
                            </td>
                            <td><%# FormatSize(Convert.ToInt64(Eval("FileSize"))) %></td>
                            <td><%# Convert.ToDateTime(Eval("UploadedAt")).ToString("dd MMM yyyy") %></td>
                            <td>
                                <div class="d-flex gap-1">
                                    <asp:LinkButton runat="server" CommandName="Download"
                                        CommandArgument='<%# Eval("FileID") + "," + Eval("StoredFileName") + "," + Eval("FileName") %>'
                                        CssClass="btn btn-success btn-sm">⬇ Download</asp:LinkButton>
                                    <asp:LinkButton runat="server" CommandName="Delete"
                                        CommandArgument='<%# Eval("FileID") %>'
                                        CssClass="btn btn-danger btn-sm"
                                        OnClientClick="return confirm('Delete this file?');">🗑 Delete</asp:LinkButton>
                                </div>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                            </tbody>
                        </table>
                    </FooterTemplate>
                </asp:Repeater>
                <asp:Label ID="lblEmpty" runat="server" Visible="false"
                    Text="<div class='alert alert-info'>📭 You haven't uploaded any files yet. <a href='UploadFile.aspx' style='color:var(--accent2)'>Upload now →</a></div>" />
            </div>
        </div>
    </form>
</body>
</html>
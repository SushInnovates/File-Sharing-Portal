<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SharedFiles.aspx.cs" Inherits="FileSharingPortal.SharedFiles" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Shared Files — ShareSphere</title>
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
            <div class="page-header">
                <h1>Shared Files</h1>
                <p>Share your files with others, and view files shared with you.</p>
            </div>

            <asp:Label ID="lblMessage" runat="server" Visible="false" />

            <!-- ===== SHARE A FILE ===== -->
            <div class="glass-card mb-3">
                <h3 style="font-family:Syne,sans-serif; margin-bottom:1.2rem;">🔗 Share a File</h3>
                <div style="display:grid; grid-template-columns:1fr 1fr auto; gap:1rem; align-items:end;">
                    <div class="form-group" style="margin:0;">
                        <label>Select your file</label>
                        <asp:DropDownList ID="ddlFiles" runat="server" CssClass="form-control" />
                    </div>
                    <div class="form-group" style="margin:0;">
                        <label>Share with (username)</label>
                        <asp:TextBox ID="txtShareWith" runat="server" CssClass="form-control" placeholder="Enter exact username" />
                    </div>
                    <asp:Button ID="btnShare" runat="server" Text="Share →"
                        CssClass="btn btn-primary"
                        OnClick="btnShare_Click" />
                </div>
            </div>

            <!-- ===== FILES SHARED WITH ME ===== -->
            <div class="glass-card">
                <h3 style="font-family:Syne,sans-serif; margin-bottom:1.2rem;">📥 Files Shared With Me</h3>
                <asp:Repeater ID="rptShared" runat="server" OnItemCommand="rptShared_ItemCommand">
                    <HeaderTemplate>
                        <table class="files-table">
                            <thead>
                                <tr>
                                    <th>File Name</th>
                                    <th>Type</th>
                                    <th>Size</th>
                                    <th>Shared By</th>
                                    <th>Date</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td><strong><%# System.Web.HttpUtility.HtmlEncode(Eval("FileName").ToString()) %></strong></td>
                            <td><span class="file-badge badge-other"><%# Eval("FileType") %></span></td>
                            <td><%# FormatSize(Convert.ToInt64(Eval("FileSize"))) %></td>
                            <td><%# Eval("SharedByName") %> <span style="color:var(--text-secondary);font-size:0.8rem;">(@<%# Eval("SharedByUsername") %>)</span></td>
                            <td><%# Convert.ToDateTime(Eval("SharedAt")).ToString("dd MMM yyyy") %></td>
                            <td>
                                <asp:LinkButton runat="server" CommandName="Download"
                                    CommandArgument='<%# Eval("StoredFileName") + "," + Eval("FileName") %>'
                                    CssClass="btn btn-success btn-sm">⬇ Download</asp:LinkButton>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                            </tbody>
                        </table>
                    </FooterTemplate>
                </asp:Repeater>
                <asp:Label ID="lblEmpty" runat="server" Visible="false"
                    Text="<div class='alert alert-info'>📭 No files have been shared with you yet.</div>" />
            </div>
        </div>
    </form>
</body>
</html>
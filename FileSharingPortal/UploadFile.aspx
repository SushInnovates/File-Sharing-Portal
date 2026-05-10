<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UploadFile.aspx.cs" Inherits="FileSharingPortal.UploadFile" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Upload File — ShareSphere</title>
    <link rel="stylesheet" href="Styles/glass.css" />
    <style>
        #fileLabel { display:block; cursor:pointer; }
        #filePreview { margin-top:1rem; color:var(--accent2); font-size:0.9rem; }
    </style>
</head>
<body>
    <form id="form1" runat="server" enctype="multipart/form-data">
        <!-- Nav -->
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
                <h1>Upload a File</h1>
                <p>Supported: PDF, DOCX, XLSX, ZIP, Images and more (max 50MB)</p>
            </div>

            <div class="glass-card" style="max-width:640px; margin:0 auto;">
                <asp:Label ID="lblMessage" runat="server" Visible="false" />

                <!-- Drop Zone -->
                <label id="fileLabel" for="fileUpload" class="upload-zone">
                    <div class="upload-icon">☁️</div>
                    <p><strong>Click to browse</strong> or drag & drop your file here</p>
                    <p style="font-size:0.8rem; margin-top:0.5rem;">PDF, DOCX, XLSX, ZIP, JPG, PNG, MP4...</p>
                </label>
                <div id="filePreview"></div>

                <!-- ASP.NET File Upload -->
                <asp:FileUpload ID="fileUpload" runat="server"
                    Style="display:none;"
                    onchange="showFileName(this)" />

                <div class="form-group mt-3">
                    <label>Description (Optional)</label>
                    <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control"
                        placeholder="Brief description of the file..."
                        TextMode="MultiLine" Rows="3" MaxLength="500" />
                </div>

                <asp:Button ID="btnUpload" runat="server" Text="📤 Upload File"
                    CssClass="btn btn-primary w-100"
                    OnClick="btnUpload_Click" />
            </div>
        </div>

        <script>
            function showFileName(input) {
                if (input.files && input.files[0]) {
                    var name = input.files[0].name;
                    var size = (input.files[0].size / 1024).toFixed(1) + " KB";
                    document.getElementById('filePreview').innerHTML =
                        '📄 <strong>' + name + '</strong> (' + size + ')';
                }
            }
        </script>
    </form>
</body>
</html>
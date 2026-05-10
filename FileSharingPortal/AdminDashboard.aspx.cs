using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FileSharingPortal
{
    public partial class AdminDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // ── ADMIN ROLE GATE ──────────────────────────────────────────────
            if (Session["UserID"] == null) { Response.Redirect("Login.aspx"); return; }
            if (Session["Role"]?.ToString() != "Admin") { Response.Redirect("Dashboard.aspx"); return; }
            // ────────────────────────────────────────────────────────────────

            if (!IsPostBack) LoadStats();
        }

        private void LoadStats()
        {
            string connStr = ConfigurationManager.ConnectionStrings["FileSharingDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("sp_AdminGetStats", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlDataReader r = cmd.ExecuteReader();
                if (r.Read())
                {
                    litTotalUsers.Text = r["TotalUsers"].ToString();
                    litPending.Text = r["PendingUsers"].ToString();
                    litAdmins.Text = r["AdminCount"].ToString();
                    litTotalFiles.Text = r["TotalFiles"].ToString();
                    litShares.Text = r["TotalShares"].ToString();
                    litStorage.Text = FormatSize(Convert.ToInt64(r["TotalStorage"]));

                    int pending = Convert.ToInt32(r["PendingUsers"]);
                    if (pending > 0)
                    {
                        lblPendingAlert.Text = $"<div class='alert alert-info' style='margin-top:1rem;'>⚠ {pending} user(s) are waiting for approval. <a href='ManageUsers.aspx' style='color:var(--accent2)'>Review now →</a></div>";
                        lblPendingAlert.Visible = true;
                    }
                }
            }
        }

        private string FormatSize(long bytes)
        {
            if (bytes < 1024) return bytes + " B";
            if (bytes < 1048576) return Math.Round(bytes / 1024.0, 1) + " KB";
            if (bytes < 1073741824) return Math.Round(bytes / 1048576.0, 1) + " MB";
            return Math.Round(bytes / 1073741824.0, 2) + " GB";
        }

        protected void lbLogout_Click(object sender, EventArgs e)
        {
            Session.Clear(); Session.Abandon();
            Response.Redirect("Login.aspx");
        }
    }
}
  
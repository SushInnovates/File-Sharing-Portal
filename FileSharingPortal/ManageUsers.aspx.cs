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
    public partial class ManageUsers : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null) { Response.Redirect("Login.aspx"); return; }
            if (Session["Role"]?.ToString() != "Admin") { Response.Redirect("Dashboard.aspx"); return; }

            if (!IsPostBack) LoadUsers();
        }

        private void LoadUsers()
        {
            string connStr = ConfigurationManager.ConnectionStrings["FileSharingDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("sp_AdminGetAllUsers", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                DataTable dt = new DataTable();
                dt.Load(cmd.ExecuteReader());
                rptUsers.DataSource = dt;
                rptUsers.DataBind();
            }
        }

        protected void rptUsers_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            int targetID = Convert.ToInt32(e.CommandArgument);
            int currentAdminID = Convert.ToInt32(Session["UserID"]);

            // Prevent admin from acting on themselves
            if (targetID == currentAdminID)
            {
                ShowMessage("⚠️ You cannot perform this action on your own account.", "error");
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["FileSharingDB"].ConnectionString;
            string spName = "";

            switch (e.CommandName)
            {
                case "Approve": spName = "sp_AdminApproveUser"; break;
                case "Reject": spName = "sp_AdminRejectUser"; break;
                case "Delete": spName = "sp_AdminDeleteUser"; break;
            }

            if (!string.IsNullOrEmpty(spName))
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(spName, conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserID", targetID);
                    cmd.ExecuteNonQuery();
                }

                string msg = e.CommandName == "Approve" ? "✅ User approved." :
                             e.CommandName == "Reject" ? "✅ User rejected/deactivated." :
                                                          "✅ User permanently deleted.";
                ShowMessage(msg, "success");
                LoadUsers();
            }
        }

        protected void lbLogout_Click(object sender, EventArgs e)
        {
            Session.Clear(); Session.Abandon();
            Response.Redirect("Login.aspx");
        }

        private void ShowMessage(string msg, string type)
        {
            lblMessage.Text = $"<div class='alert alert-{type}'>{msg}</div>";
            lblMessage.Visible = true;
        }
    }
    
}
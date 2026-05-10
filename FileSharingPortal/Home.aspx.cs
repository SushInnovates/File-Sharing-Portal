using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FileSharingPortal
{
    public partial class Home : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // If already logged in, redirect to Dashboard
            if (Session["UserID"] != null)
            {
                Response.Redirect("Dashboard.aspx");
            }

        }
    }
}
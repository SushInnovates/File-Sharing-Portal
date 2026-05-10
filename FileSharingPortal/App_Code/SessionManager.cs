using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FileSharingPortal.App_Code
{

    /// <summary>
    /// Manages session values for the logged-in user.
    /// </summary>
    public class SessionManager
    {
        public static bool IsLoggedIn
        {
            get { return HttpContext.Current.Session["UserID"] != null; }
        }

        public static int UserID
        {
            get
            {
                if (HttpContext.Current.Session["UserID"] == null) return 0;
                return int.Parse(HttpContext.Current.Session["UserID"].ToString());
            }
        }

        public static string Username
        {
            get { return HttpContext.Current.Session["Username"]?.ToString() ?? ""; }
        }

        public static string FullName
        {
            get { return HttpContext.Current.Session["FullName"]?.ToString() ?? ""; }
        }

        public static void SetUser(int userID, string username, string fullName)
        {
            HttpContext.Current.Session["UserID"] = userID.ToString();
            HttpContext.Current.Session["Username"] = username;
            HttpContext.Current.Session["FullName"] = fullName;
        }

        public static void Logout()
        {
            HttpContext.Current.Session.Clear();
            HttpContext.Current.Session.Abandon();
        }
    }
}
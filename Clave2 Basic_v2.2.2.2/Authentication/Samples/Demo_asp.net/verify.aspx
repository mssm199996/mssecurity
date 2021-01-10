<%@ Page Language="C#" Description="iToken LC Demo ---ASP.NET" %>

<%@ Import Namespace="System" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Security" %>
<%@ Import Namespace="System.Security.Cryptography" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="System.Reflection" %>

<script language = "C#" runat="Server">
  
    string ServerDigest = "";  
    string ReadDB(string LCSN)
    {
        string Key = "";   
        string SN = "";    
        string filename = this.MapPath("UserDB.txt");
        
        StreamReader srReadLine = new StreamReader((System.IO.Stream)File.OpenRead(filename),
                System.Text.Encoding.ASCII);

        srReadLine.BaseStream.Seek(0, SeekOrigin.Begin);
        bool b_break = true;
        while (srReadLine.Peek() > -1 && b_break)
        {
            SN = srReadLine.ReadLine();
            if (Object.Equals(SN, LCSN))
            {
                Key = srReadLine.ReadLine();
                b_break = false;
            }
        }
        srReadLine.Close();
        if (b_break == true)
        {
            Key = "";
        }
        return Key;
    }
    bool validate (string RanData, string Key, string ClientDigest)  
    {
        
        Type tp = Type.GetTypeFromProgID("LC_SEC.LCSEC.1");
        Object obj;
        obj = Activator.CreateInstance(tp);
        Object[] args = new object[] { RanData, 20, Key };
        Object Result;
        Result = tp.InvokeMember("Hmac_software", BindingFlags.InvokeMethod, null, obj, args);
        ServerDigest = Result.ToString();
        if (!Object.Equals(Result, ClientDigest))
            return false;
        return true;
    }
    
</script>

<% 
    string RanData = Session["Message"].ToString();
    string LCSN = Request.Form["Serial_ID"];
    string ClientDigest = Request.Form["Digest"];  
    int ErrCode = 0;
    string Key = "";    
   
    Key = ReadDB(LCSN);
    if (Key == "")
    {
        ErrCode = 1;
    }
    else
    {
        if (!validate(RanData, Key, ClientDigest))
        {
             ErrCode = 2;
        }  
    }
%>
  
<% 
    if (ErrCode != 0)
    {
        Msg1.Text += "<p>Error Code : " + ErrCode + "</p>";
        Msg1.Text += "<p>Client Serial number : " + LCSN + "</p>";
        Msg1.Text += "<p>Server key : " + Key + "</p>";
        Msg1.Text += "<p>Random data : " + RanData + "</p>";
        Msg1.Text += "<p>Client digest : " + ClientDigest + "</p>";
        Msg1.Text += "<p>Server digest : " + ServerDigest + "</p>";
    }
%>
<%
    if (ErrCode == 0)
    {
        Msg2.Text += "<h1 align='center'><font color='blue'>Congradulations! You passed the authentication!</font></h1> ";
    }
    if (ErrCode == 1)
    {
        Msg2.Text += "<h2 align='center'><font color='red'>Error : Unable to find this client.</font></h2> ";
    }
    if (ErrCode == 2)
    {
        Msg2.Text += "<h2 align='center'><font color='red'>Error : Indetification unmatched.</font></h2> ";
    }
%>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<style type="text/css">
<!--
@import "test.css";
-->
</style>
</head>
<body>
    <asp:Label ID="Msg1" runat="server" /><br>
    <table width="600" border="0" align="center">
        <tr>
            <td>
                <p>&nbsp;
                    </p>
                <p>&nbsp;
                    </p>
                <p>&nbsp;
                    </p>
                <p>&nbsp;
                    </p>
                    <p>&nbsp;</p>
                    <p>&nbsp;</p>
                <asp:Label ID="Msg2" ForeColor="red" Font-Bold="true" runat="server" /><br>
                <p>&nbsp;
                    </p>
            </td>
        </tr>
    </table>
    <font color='#000000'>
        <p>&nbsp;
            </p>
        <p>&nbsp;
            </p>
        <p align="center" style="color: black; font-family: Verdana; font-size: 9pt; font-style: normal;">
            </p>
        <p align="center" style="color: black; font-family: Verdana; font-size: 9pt; font-style: normal;">
           </p>
    </font>
</body>
</html>

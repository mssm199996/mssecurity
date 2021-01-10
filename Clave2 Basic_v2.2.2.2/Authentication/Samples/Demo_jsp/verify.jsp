<%@ page language="java" contentType="text/html;charset=gb2312"%>
<%@ page import="java.util.*"%>
<%@ page import="java.lang.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.security.*"%>
<%@ page session="true"%>
<%@ page import="com.LC.util.*"%>

<%!
    public String HexArrayToString(byte [] HexArray)
    {
            // If not already calculated, return null.

            StringBuffer r = new StringBuffer();
            final String hex = "0123456789abcdef";

            for (int i = 0; i < 20; i++)
            {
                    int c = ((HexArray[i]) >>> 4) & 0xf;
                    r.append(hex.charAt(c));
                    c = ((int)HexArray[i] & 0xf);
                    r.append(hex.charAt(c));
            }
            return r.toString();
     }
     public byte ToByte(char c)
     {
      return (byte)("0123456789abcdef".indexOf(c));
     }

     public byte [] HexStringToByteArray(String HexStr)
     {
       int length = HexStr.length();
       byte result[] = new byte[length/2];
       int pos = 0;
       char charA[] = HexStr.toLowerCase().toCharArray();

       for(int i = 0; i < length/2; i++)
       {
         pos = 2*i;
         result[i] = (byte)(ToByte(charA[pos])<<4 | ToByte(charA[pos+1]));
       }
       return result;
     }
%>
<%
    String Randata = (String)session.getAttribute("RandomData");
    String LCSN = request.getParameter("LCSN");
    String ClientDigest = request.getParameter("LCDigest");
    String ServerDigest = "";
    byte Digest[];
    int bError;
    bError = 0;
    String PrintErr = "";

	byte Key[] = {};
try{
  String str = request.getRealPath("UserDB.txt");
  FileReader fr = new FileReader(str);
  BufferedReader rd = new BufferedReader(fr);
  String sSn = "";
  String sKey = "";
  String line = rd.readLine();
  boolean bContinue = true;
  while (line != null && bContinue)
  {
    if (line.compareTo(LCSN) == 0)
    {
       bContinue = false;
    }
    line = rd.readLine();
  }

  if(bContinue)
     {
       bError = 1;              
     }
  else{
      Key = HexStringToByteArray(line);
      Hmac hm = new Hmac();
      Digest = hm.GetHmacSHA1(Randata.getBytes(), Randata.getBytes().length, Key);
      ServerDigest = hm.toString();
  }
}
catch (NoSuchAlgorithmException nsae) {
                        nsae.printStackTrace();
                }

        if(ServerDigest.equals(ClientDigest))
        {
          bError = 0;
        }
        else
        {
          bError = 1;
        }
%>

<html>
<head>
<title>Logon - JSP demo program for LC COM ActiveX Control</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<style type="text/css">
<!--
@import "test.css";
-->
</style>
</head>
<body>
<table width="600" border="0" align="center">
  <tr>
    <td>
  <script language="JavaScript" type="text/JavaScript">
  if(<%=bError%> == 0)
  {
        document.write("<p>&nbsp;&nbsp;&nbsp;</p>");
	document.write("<p>&nbsp;&nbsp;&nbsp;</p>");
	document.write("<p>&nbsp;&nbsp;&nbsp;</p>");
	document.write("<p>&nbsp;&nbsp;&nbsp;</p>");
	document.write("<p>&nbsp;&nbsp;&nbsp;</p>");
	document.write("<p>&nbsp;&nbsp;&nbsp;</p>");
	document.write("<p>&nbsp;&nbsp;&nbsp;</p>");
        document.write("<h1 align='center'><font color='#0000FF'> Congradulations! You passed the authentication</FONT></h1>");
  }
  else
  {
        document.write("<h2><font color=\"#FF0000\">LCSN: <%=LCSN%><BR></FONT></h3>" );
        document.write("<h2><font color=\"#FF0000\">Randata: <%=Randata%><BR></FONT></h3>" );
        document.write("<h2><font color=\"#FF0000\">Key: <%=HexArrayToString(Key)%><BR></FONT></h3>" );
        document.write("<h2><font color=\"#FF0000\">ClientDigest: <%=ClientDigest%><BR></FONT></h3>" );
        document.write("<h2><font color=\"#FF0000\">ServerDigest: <%=ServerDigest%></FONT></h3>");
	document.write("<p>&nbsp;&nbsp;&nbsp;</p>");
	document.write("<h2 align='center'><font color=\"#FF0000\">Unable to find this client<BR></FONT></h2>");
  }
  </script>
	  <P>&nbsp;</P>
	  <P>&nbsp;</P>
    </td>
  </tr>
</table>
<p>&nbsp;</p>
<P ALIGN="center"></P>
<P ALIGN="center"></P>
</body>
</html>

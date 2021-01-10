<%@ page language="java" contentType="text/html;charset=gb2312"%>
<%@ page import="java.util.*" %>
<%@ page session="true"%>

<%
String RndData ="";
char Upper = 'z';
char Lower = 'a';
   Random r = new Random();
for(int i=0;i<20;i++)
{
   int tempval = (int)((int)Lower + (r.nextFloat() * ((int)(Upper - Lower))));
   RndData += new Character((char)tempval).toString();
}
session.setAttribute("RandomData",RndData);
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<TITLE>Logon - Delphi demo program for Middeware ActiveX Control</TITLE>
<style type="text/css">
		INPUT{BORDER-TOP-WIDTH: 1px; PADDING-RIGHT: 1px; PADDING-LEFT: 1px; BORDER-LEFT-WIDTH: 1px; FONT-SIZE: 9pt; BORDER-LEFT-COLOR: #666666; BORDER-BOTTOM-WIDTH: 1px; BORDER-BOTTOM-COLOR: #666666; PADDING-BOTTOM: 1px; BORDER-TOP-COLOR: #666666; PADDING-TOP: 1px; HEIGHT: 18px; BORDER-RIGHT-WIDTH: 1px; BORDER-RIGHT-COLOR: #666666}
</style>

<script language="JavaScript" type="text/JavaScript">
function Init()
{

	if(InitInfoForm.INDEX.value == "")
	{
		alert("Index of input device is null!");
		document.InitInfoForm.INDEX.focus();
		return false;
	}

	if(InitInfoForm.PIN.value == "" || InitInfoForm.PIN.value.length != 8)
	{
		alert("Password must not be null or the multiple of 8!");
		document.InitInfoForm.PIN.focus();
		return false;
	}

	var LCPIN;
	var LCIndex;
	var LCDN;
	var LCSN;
	var LCSD;
	var LCDigest;
	var SoftDigest;

	LCIndex = InitInfoForm.INDEX.value;
	LCPIN = InitInfoForm.PIN.value;
	
		try{
		var LC = new ActiveXObject("LC_SEC.LCSEC.1");
	}
	catch(error)
	{
		alert("LCsafety control is unregistered.");
		return false;
	}
	
	try
	{
		LC.Open(LCIndex);
	}
	catch(error)
	{
		alert("Cann't open LC")
		return false;
	}

try
	{
		LC.Passwd(2, LCPIN);
	}
	catch(error)
	{
		alert("Incorrect password")
		return false;
	}

try
	{
		LCSN = LC.Get_hardware_info(0);
		LCSD = LC.Get_hardware_info(1);
	}
	catch(error)
	{
		alert("Failed to get LC device information")
		return false;
	}
		
	try
	{
		LCDigest = LC.Hmac ("<%=(String)session.getAttribute("RandomData")%>", 20);
	}
	catch(error)
	{
		alert("Failed to Hmac")
		return false;
	}
	
	try
	{
		LC.Close();
	}
	catch(error)
	{
		alert("Failed to close LC")
		return false;
	}

	document.getElementById("LCDigest").innerHTML = "<input type='hidden' name='LCDigest' value='" + LCDigest + "'>"
	document.getElementById("LCSN").innerHTML = "<input type='hidden' name='LCSN' value='" + LCSN + "'>"
	return true;
}
</script>
</head>

<body>
<p>
&nbsp;
</p>
<H1 ALIGN="center">JSP demo program for LC safety ActiveX Control</H1>
<table width="75%" border="0" align="center">
  <tr>
    <td width="50" height="50">&nbsp;</td>
    <td height="50">&nbsp;</td>
    <td width="50" height="50">&nbsp;</td>
  </tr>
  <tr>
    <td width="50" height="220">&nbsp;</td>
    <td height="220" align="center" valign="middle">
      <form name="InitInfoForm" method="post" action="verify.jsp" onSubmit="return Init()">

      	<span id="LCDigest"></span>
		<span id="LCSN"></span>

        <table width="350" style = "height:200"  border="0" cellpadding="0" cellspacing="0" bgcolor="#666666">
          <tr>
            <td align="center" valign="middle"><table width="350" style = "height:165" border="0" cellpadding="0" cellspacing="1">
				<tr bgcolor="#FFFFFF">
                  <td width="120" height="40" align="right" valign="middle"><font size="2">Index of device:</font></td>
                  <td height="40" align="center" valign="middle"> <font size="2">
                    <input name="INDEX" type="text" id="INDEX" size="25" value = "0">
                    </font></td>
                </tr>
				<tr bgcolor="#FFFFFF">
                  <td width="120" height="40" align="right" valign="middle"><font size="2">authentication password:</font></td>
                  <td height="40" align="center" valign="middle"> <font size="2">
                    <input name="PIN" type="password" id="PIN" size="28">
                    </font></td>
                </tr>
                <tr align="center" bgcolor="efefef">
                  <td height="40" colspan="2" valign="middle">
					<input name="submit" type="submit" id="submit" value="logon">
					&nbsp
					<input name="Reset" type="Reset" id="Reset" value="Reset">
                  </td>
                </tr>
              </table></td>
          </tr>
        </table>
      </form></td>
    <td width="50" height="220">&nbsp;</td>
  </tr>
  <tr>
    <td width="50" height="25">&nbsp;</td>
    <td height="25" align="center" valign="middle">&nbsp;</td>
    <td width="50" height="25">&nbsp;</td>
  </tr>
</table>
<H2>&nbsp;</H2>
<P>&nbsp;</P>
<P ALIGN="center"></P>
<P ALIGN="center"></P>
</body>
</html>

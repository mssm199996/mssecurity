<%@ Page Language="C#" EnableSessionState="true" %>

<%
    Random randomGenerator = new Random(DateTime.Now.Millisecond);

    String RandData = "";
    for (int i = 0; i < 20; i++)
        RandData += Convert.ToChar(randomGenerator.Next(97, 122));

    Session["Message"] = RandData;
%>
<html>
<head>
    <title>Logon - ASP.NET(c#) demo program for iToken LC ActiveX Control</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312"/>
    <style type="text/css">
<!--
@import "test.css";
-->
</style>

    <script language="VBScript">
Dim FirstDigest, Digest, bErr

sub ShowErr(Msg)
	Dim errorno
	errorno = Err.number And &HFF
	bErr = true
	Document.Writeln "<FONT COLOR='#FF0000'>"
	Document.Writeln "<P>&nbsp;</P><P>&nbsp;</P><P>&nbsp;</P><P ALIGN='CENTER'><B>ERROR:</B>"
	Document.Writeln "<P>&nbsp;</P><P ALIGN='CENTER'>"
	Document.Writeln Msg
	Document.Writeln " failed, and returns 0x" & hex(errorno) & ".<br>"
	Document.Writeln "<P>&nbsp;</P><P>&nbsp;</P><P>&nbsp;</P>"
	Document.Writeln "</FONT>"
End Sub

function Validate()
	On Error Resume Next

	Digest = "01234567890123456789"
	Dim chIndex
	chPid = 0
	chIndex = 0
	Dim TheForm
	Set TheForm = Document.forms("ValidForm")

	If len(TheForm.TokenIndex.Value) = 0  Then
		MsgBox "Index is null"		 
		Validate = false
		Exit function
	Else
		chIndex = CInt(TheForm.TokenIndex.Value)
	End If

	If Len(TheForm.UserPIN.Value) <> 8  Then
		MsgBox "Password must not be null or the multiple of 8"	 
		Validate = false
		Exit function
	End If

	bErr = false
	
	'Open iToken LC device
	LC.Open chIndex
	If Err Then
	    If Err.number = &H1B6 Then
	        ShowErr "LC safety control is registered"
	        Validate = false
			Exit function
	    else
			ShowErr "Failed to open LC device"
			Validate = false
			Exit function
		End If
	End If
	
	'Verify authentication password
	LC.Passwd 2, TheForm.UserPIN.Value
	If Err Then
		LC.Close
		ShowErr "Incorrect authentication password"
		Validate = false
		Exit function
	End If
		
	'Get device information	
	dim serialNumber, setDate
	serialNumber = LC.Get_hardware_info(0)
	setDate = LC.Get_hardware_info(1)
	If Err Then
		LC.Close
		ShowErr "Failed to get device information"
		Exit function
	End If

	If Not bErr Then
	'Calculate on client side
		Digest = LC.Hmac ("<%=Session["Message"].ToString()%>", 20)
		If Err Then 
			LC.Close
			ShowErr "Failed to calculate on client side"
			Validate = false
			
			Exit function
		End If
		
	'	Dim strPin, softHmac
	'	softHmac = "01234567890123456789"
	'	strPin = "0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b"
	'	softHmac = LC.Hmac_software("<%=Session["Message"].ToString()%>", 20, strPin)
	'	If Err Then
	'		ShowErr "Hmac_software excute error!"
	'		Validate = false
	'		Exit function
	'	End If
	'	softHmac = CStr(softHmac)
	'	Digest = CStr(Digest)
	'	Dim len1, len2
	'	len1 = len(softHmac)
	'	len2 = len(Digest)
	'	If softHmac <> Digest Then
	'		ShowErr "error"
	'		Validate = false
	'		LC.Close
	'		Exit function
	'	End If
			
		DigestID.innerHTML = "<input type='hidden' name='Digest' Value='" & Digest & "'>"
		SerialID.innerHTML = "<input type='hidden' name='Serial_ID' Value='" & serialNumber & "'>"
	End If
	LC.Close
End function
    </script>

</head>
<body>
    <object classid="clsid:D9AD0FA7-7515-48B0-87F5-0A9546F9D5E8" id="LC" name="LC"
        style="left: 0px; top: 0px" width="0" height="0">
    </object>
	<h1>&nbsp;</h1>
    <h1 align="center">iToken LC ASP.NET(c#) demo program</h1>
    <table width="600" border="0" align="center">
        <tr>
            <td>

                <script id="clientEventHandlersVBS" language="vbscript">
<!--
		Document.Writeln "<P>&nbsp;</P><P>&nbsp;</P></TD></TR><TR><TD>"
		Document.Writeln "<FORM id=ValidForm METHOD='post' ACTION='verify.aspx' onsubmit='return Validate();' language='jscript'>"

		Document.Writeln "<span id=DigestID></span>"
		Document.Writeln "<span id=SerialID></span>"

		Document.Writeln "<TABLE WIDTH='250' BORDER='1' ALIGN='center' CELLSPACING='0' BORDERCOLORDARK='#E7EBFF' BORDERCOLORLIGHT='#000000'>"

		Document.Writeln "<TR><TD ALIGN='right'>Index of device:</TD><TD><INPUT NAME='TokenIndex' CLASS='inputtext' VALUE=''></TD></TR>"

		Document.Writeln "<TR><TD ALIGN='right'>authentication password:</TD><TD><INPUT TYPE='password' NAME='UserPIN' CLASS='inputtext' value=''></TD></TR>"

		Document.Writeln "</TABLE><P>&nbsp;</P><P ALIGN='center'>"
		Document.Writeln "<INPUT TYPE='submit' NAME='Submit' VALUE='Logon' CLASS='inputbtn'>"
		Document.Writeln "&nbsp;&nbsp;&nbsp;"
		Document.Writeln "<INPUT TYPE='reset' NAME='Reset' VALUE='Reset' CLASS='inputbtn'></P></FORM>"
-->
                </script>

            </td>
        </tr>
    </table>
    <h2>
        &nbsp;</h2>
    <p>
        &nbsp;</p>
    <p align="center">
        </p>
    <p align="center">
        </p>
</body>
</html>

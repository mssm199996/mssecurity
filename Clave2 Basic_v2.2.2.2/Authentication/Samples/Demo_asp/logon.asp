<%@ Language=VBScript %>
<%  OPTION EXPLICIT %>
<%
Session("RandomData") = ""

Dim RndData
Dim I, Upper, Lower

'Create some random data for HASH compute.
Randomize
RndData = ""
Upper = Asc("z")
Lower = Asc("a")
For I = 0 to 19
	RndData = RndData + Chr(Int((Upper - Lower)*Rnd + Lower))
NEXT

Session("RandomData") = RndData

%>

<HTML>
<HEAD>
<TITLE>Logon - ASP demo program for LC2 control</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=gb2312">
<STYLE TYPE="text/css">
<!--
@import "test.css";
-->
</STYLE>
							
<script language=VBScript>
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
			ShowErr "Failed to open device"
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
		'calculate on client side
		Digest = LC.Hmac (<%
						Response.Write Chr(34)
						Response.Write RndData
						Response.Write Chr(34)
						%>, 20)
		If Err Then 
			LC.Close
			ShowErr "Failed to calculate on client side"
			Validate = false
			
			Exit function
		End If
		
	'	Dim strPin, softHmac
	'	softHmac = "01234567890123456789"
	'	strPin = "0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b"
	'	softHmac = LC.Hmac_software(<%
	'					Response.Write Chr(34)
	'					Response.Write RndData
	'					Response.Write Chr(34)
	'					%>, 20, strPin)
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

</HEAD>
<BODY>
      
<OBJECT classid=clsid:D9AD0FA7-7515-48B0-87F5-0A9546F9D5E8 id = LC name = LC STYLE="LEFT: 0px; TOP: 0px" width=0 height=0></OBJECT>
<h1>&nbsp;</h1>
<H1 ALIGN="center">ASP demo program for LC2 control</H1>
<TABLE WIDTH="600" BORDER="0" ALIGN="center">
  <TR>
    <TD>

<SCRIPT id=clientEventHandlersVBS language=vbscript>
<!--
		Document.Writeln "<P>&nbsp;</P><P>&nbsp;</P></TD></TR><TR><TD>"
		Document.Writeln "<FORM id=ValidForm METHOD='post' ACTION='verify.asp' onsubmit='return Validate();' language='jscript'>"

		Document.Writeln "<span id=DigestID></span>"
		Document.Writeln "<span id=SerialID></span>"

		Document.Writeln "<TABLE WIDTH='250' BORDER='1' ALIGN='center' CELLSPACING='0' BORDERCOLORDARK='#E7EBFF' BORDERCOLORLIGHT='#000000'>"
		Document.Writeln "<TR><TD ALIGN='right'>Device index:</TD><TD><INPUT NAME='TokenIndex' CLASS='inputtext'></TD></TR>"	
		Document.Writeln "<TR><TD ALIGN='right'>Auth password:</TD><TD><INPUT TYPE='password' NAME='UserPIN' CLASS='inputtext'></TD></TR>"

		Document.Writeln "</TABLE><P>&nbsp;</P><P ALIGN='center'>"
		Document.Writeln "<INPUT TYPE='submit' NAME='Submit' VALUE='Logon' CLASS='inputbtn'>"
		Document.Writeln "&nbsp;&nbsp;&nbsp;"
		Document.Writeln "<INPUT TYPE='reset' NAME='Reset' VALUE='Reset' CLASS='inputbtn'></P></FORM>"
-->
</SCRIPT>

	</TD>
  </TR>
</TABLE>
<H2>&nbsp;</H2>
<P>&nbsp;</P>
<P ALIGN="center"></P>
<P ALIGN="center"></P>
</BODY>
</HTML>
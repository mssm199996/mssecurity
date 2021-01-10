<?PHP
/*session_start();*/
if(!session_is_registered("RandomData"))
	if(!session_register("RandomData"))
		die("Can't register a session name");
$RandomData = substr(md5(time()).md5(time()), 0, 32);
$_SESSION["RandomData"] = $RandomData;

?>

<HTML>
<HEAD>
<TITLE>Logon - ASP demo program of LC LC2 control</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=gb2312">
<STYLE TYPE="text/css">
<!--
@import "test.css";
-->
</STYLE>
<script language = VBScript>

Dim LCDigest, bErr

sub ShowErr(Msg)
	Dim errorno
	errorno = Err.number And &HFF
	bErr = true
	Document.Writeln "<FONT COLOR='#FF0000'>"
	Document.Writeln "<P>&nbsp;</P><P>&nbsp;</P><P>&nbsp;</P><P ALIGN='CENTER'><B>ERROR:</B>"
	Document.Writeln "<P>&nbsp;</P><P ALIGN='CENTER'>"
	Document.Writeln Msg
	Document.Writeln " <br> return: " & Hex(errorno) & ".<br>"
	Document.Writeln "<P>&nbsp;</P><P>&nbsp;</P><P>&nbsp;</P>"
	Document.Writeln "</FONT>"
End Sub

function Validate()
	On Error Resume Next

	LCDigest = "01234567890123456789"
	Dim LCIndex

	LCIndex = 0
	Dim TheForm
	
	Set TheForm = Document.forms("ValidForm")

	If len(TheForm.INDEX.Value) = 0  Then
		MsgBox "Device index is null!"	 
		Validate = false
		Exit function
	Else
		LCIndex = CInt(TheForm.INDEX.Value)
	End If

	If Len(TheForm.PIN.Value) <> 8  Then
		MsgBox "Incorrect length of authentication password!"	 
		Validate = false
		Exit function
	End If

	bErr = false
	
	'Open LC device
	LC.Open LCIndex
	If Err Then
	    If Err.number = &H1B6 Then
	        ShowErr "LC safety control is unregistered"
	        Validate = false
			Exit function
	    else
			ShowErr "Cann't open LC device"
			Validate = false
			Exit function
		End If
	End If
	
	'Verify authentication password 
	LC.Passwd 2, TheForm.PIN.Value
	If Err Then
		LC.Close
		ShowErr "Incorrect authentication password "
		Validate = false
		Exit function
	End If
	
	'Get device information
	dim serialNumber, setDate	
	serialNumber = LC.Get_hardware_info(0)
	setDate = LC.Get_hardware_info(1)
	If Err Then
		ShowErr "Failed to get device information"
		LC.Close
		Exit function
	End If
	
	If Not bErr Then
	'Calculate on client side
		LCDigest = LC.Hmac ("<?PHP print $RandomData ?>", 32)
		If Err Then 
			LC.Close
			ShowErr "Failed to calculate on client side"
			Validate = false
			Exit function
		End If
			
		LCDigestID.innerHTML = "<input type='hidden' name='LCDigest' Value='" & LCDigest & "'>"
		SerialID.innerHTML = "<input type='hidden' name='LCSN' Value='" & serialNumber & "'>"
	End If
	LC.Close
End function
</script>

</HEAD>
<BODY>
           
<OBJECT classid=clsid:D9AD0FA7-7515-48B0-87F5-0A9546F9D5E8 id = LC name = LC STYLE="LEFT: 0px; TOP: 0px" width=0 height=0></OBJECT>
<h1>&nbsp;</h1>
<H1 ALIGN="center">PHP demo program for LC safely ActiveX Control</H1>
<TABLE WIDTH="600" BORDER="0" ALIGN="center">
  <TR>
    <TD>


<SCRIPT id=clientEventHandlersVBS language=vbscript>
<!--

		Document.Writeln "<P>&nbsp;</P><P>&nbsp;</P></TD></TR><TR><TD>"
		Document.Writeln "<FORM id=ValidForm METHOD='post' ACTION='verify.php' onsubmit='return Validate();' language='jscript'>"

		Document.Writeln "<span id=LCDigestID></span>"
		Document.Writeln "<span id=SerialID></span>"

		Document.Writeln "<TABLE WIDTH='250' BORDER='1' ALIGN='center' CELLSPACING='0' BORDERCOLORDARK='#E7EBFF' BORDERCOLORLIGHT='#000000'>"
	
		Document.Writeln "<TR><TD ALIGN='right'>Index of device:</TD><TD><INPUT NAME='INDEX' CLASS='inputtext' value=''></TD></TR>"
		Document.Writeln "<TR><TD ALIGN='right'>authentication password:</TD><TD><INPUT TYPE='password' NAME='PIN' CLASS='inputtext' value=''></TD></TR>"
		
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
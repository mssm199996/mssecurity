<%@ Language=VBScript %>
<%  OPTION EXPLICIT %>
<!--
[]=================================================================[]
	Logon.asp

	Comment : Demonstration how to use iToken LC Active Control
			  in ASP
[]=================================================================[]
-->
<%
Dim RandomData, ClientDigest, ServerDigest
Dim LCSN, SetDate
Dim bErr, bContinue
Dim LC
Dim fs, DBFile, DBFileName
Dim SN   'Index on server
Dim Key  'Authentication key on server

ServerDigest = "01234567890123456789"  'Digest on server
LCSN = Request.Form("Serial_ID") 'Device index on client
RandomData = Session("RandomData")  'Random data on client
ClientDigest = Request.Form("Digest") 'Digest on client

bErr = 0
bContinue = true

If LCSN = "" Or RandomData = "" Or ClientDigest = "" Then
	bErr = 1 'Unknown error.
End If

'Query key with LCSY in UserDB.txt
'You can save LCSY and Key in database
If bErr = 0 Then
	DBFileName = Server.MapPath(".") & "\UserDB.txt"
	Set fs = Server.CreateObject("Scripting.FileSystemObject")

	If fs.FileExists(DBFileName) Then
		Set DBFile = fs.OpenTextFile(DBFileName, 1, false)
		Key = "0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b"
		While (NOT DBFile.AtEndOfStream) AND bContinue
			SN = DBFile.readline
			Key = DBFile.readline
			If UCase(SN) = UCase(LCSN) Then 
				bContinue = false
			End If
		Wend

		If bContinue = true Then bErr = 3 'Cann't find this user
		DBFile.Close
		set DBFile = Nothing
	Else
		bErr = 2 'UserDB.txt is not exist
	End If
	Set fs = Nothing
End If

If bErr = 0 Then
	'Hmac on server
	Set LC = Server.CreateObject("LC_SEC.LCSEC.1")
	ServerDigest = LC.Hmac_software( RandomData, 20, Key ) 
	If ServerDigest <> ClientDigest Then
		bErr = 4 '
	End If
	Set LC = Nothing
End If

%>

<html>
<head>
<title>ASP demo program for Middeware ActiveX Control</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<style type="text/css">
<!--
@import "test.css";
-->
</style>
</head>

<body>
<%
If bErr <> 0 Then
	Response.Write "<P>Error Code : " & bErr
	Response.Write "<P>Client serial number : " & LCSN
	Response.Write "<P>Server serial number : " & SN
	Response.Write "<P>Server key : " & Key
	Response.Write "<P>Random data : " & RandomData
	Response.Write "<P>Client digest : '"&ClientDigest&"'"
	Response.Write "<P>Server digest : '"&ServerDigest&"'"
End If
%>

<table width="600" border="0" align="center">
  <tr>
    <td>
	  <P>&nbsp;</P>
	  <P>&nbsp;</P>
	  
<%
If bErr = 0 Then
	Response.Write "<h1>&nbsp;</h1>"
	Response.Write "<h1>&nbsp;</h1>"
	Response.Write "<h1 align='center'><font color='#0000FF'> Congradulations! You passed the authentication!</FONT></h1>"
End If
'If bErr = 1 Then
'	Response.Write "<h2 align='center'><font color='#FF0000'>Error : Unknown error.</FONT></h2>"
'End If
'If bErr = 2 Then
'	Response.Write "<h2 align='center'><font color='#FF0000'>Error : UserDB.txt is not exist.</FONT></h2>"
'End If
If bErr = 3 Then
	Response.Write "<h2 align='center'><font color='#FF0000'>Error : Unable to find this client.</FONT></h2>"
End If
If bErr = 4 Then
	Response.Write "<h2 align='center'><font color='#FF0000'>Error : Indetification unmatched.</FONT></h2>"
End If
%>
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

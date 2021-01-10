<?PHP
/*session_start();*/

$errCode = 0;
if(!session_register("RandomData"))
	$errCode = 1;

$RandomData=$_SESSION["RandomData"]; 
$LCSN = $_POST["LCSN"];         
$ClientDigest = $_POST["LCDigest"]; 

$database =  "UserDB.txt"; 
$fp = fopen($database,"r");
while (!feof($fp))
{
	$SN = fgets($fp,1000); 
	$len = strpos($SN,chr(13));
	if(!$len)
		$len=strpos($SN,chr(10));
	if(!$len)
		$len=strlen($SN);
	$SN=substr($SN,0,$len);	
	
	$Key = fgets($fp,1000);
	$len = strpos($Key,chr(13));
	if(!$len)
		$len = strpos($Key,chr(10));
	if(!$len)
		$len=strlen($Key);
	$Key=substr($Key,0,$len);
	
	if ($SN==$LCSN)  
		break;
}
if ($SN!=$LCSN)     
{
	$errCode=2;
	print "<P>errCode : $errCode";
	print "<P>Client serial number : $LCSN";
	print "<P>Random data : $RandomData";
	print "<P>Client digest : $ClientDigest";
}
	

if(0 == $errCode)
{
	$LC = new COM("LC_SEC.LCSEC.1") or die("errro");         
	$ServerDigest = $LC->Hmac_software($RandomData, 32, $Key) or die("error: $ServerDigest");  
	
	if($ClientDigest != $ServerDigest)
	{
		$errCode = 3;
		print "<P>errCode : $errCode";
		print "<P>Client serial number : $LCSN"; 
		print "<P>Server serial number : $SN";
		print "<P>Server key : $Key";
		print "<P>Random data : $RandomData";
		print "<P>Client digest : $ClientDigest";
		print "<P>Server digest : $ServerDigest";
	}
}
?>

<html>
<head>
<title>Logon - PHP demo program for LC safely ActiveX Control</title>
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
	  <P>&nbsp;</P>
	  <P>&nbsp;</P>
<?PHP
if(0 == $errCode)
{
	print "<h1>&nbsp;</h1>";
	print "<h1 align=\"center\"><font color=\"#0000FF\">Congradulations! You passed the authentication.</FONT></h1>";
}
	

if(2 == $errCode)
{
	print "<h2 align=\"center\"><font color=\"#FF0000\">Error : Unable to find this client.</FONT></h2>";
}

if(3 == $errCode)
{
	print "<h2 align=\"center\"><font color=\"#FF0000\">Error : Indetification unmatched.</FONT></h2>";
}
?>
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

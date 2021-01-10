VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   6600
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   7755
   LinkTopic       =   "Form1"
   ScaleHeight     =   6600
   ScaleWidth      =   7755
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton test 
      Caption         =   "TEST"
      Height          =   375
      Left            =   3120
      TabIndex        =   1
      Top             =   6000
      Width           =   1455
   End
   Begin VB.ListBox List1 
      Height          =   5715
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   7455
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub test_Click()

Dim handle, res, i As Long
Dim dis As String



' Open device
res = LC_open(0, 0, handle) 'DEMOËø

If res = LC_SUCCESS Then
    dis = "open device success!"
Else
    dis = "open device failed! ERROR CODE : " + Str(res)
    List1.AddItem (dis)
    Exit Sub
End If
List1.AddItem (dis)

' Verify user password
res = LC_passwd(handle, 1, "12345678")
If res = LC_SUCCESS Then
    dis = "Verify user password success!"
Else
    dis = "Verify user password failed! ERROR CODE : " + Str(res)
End If
List1.AddItem (dis)

' encrypt Data
Dim endata(0 To 15) As Byte
Dim dedata(0 To 15) As Byte
Dim tmp(0 To 15) As Byte

' init the data
For i = 0 To UBound(endata)
    endata(i) = Val(Mid("&H00&H11&H22&H33&H44&H55&H66&H77&H88&H99&Haa&Hbb&Hcc&Hdd&Hee&Hff", i * 4 + 1, 4))
Next

For i = 0 To UBound(dedata)
    dedata(i) = Val(Mid("&H69&Hc4&He0&Hd8&H6a&H7b&H04&H30&Hd8&Hcd&Hb7&H80&H70&Hb4&Hc5&H5a", i * 4 + 1, 4))
Next

res = LC_encrypt(handle, endata(0), tmp(0))
If res = LC_SUCCESS Then
    dis = "encrypt data success!"
Else
    dis = "encrypt failed! ERROR CODE : " + Str(res)
End If
List1.AddItem (dis)


' decrypt data
res = LC_decrypt(handle, dedata(0), tmp(0))
If res = LC_SUCCESS Then
    dis = "decrypt data success!"
Else
    dis = "decrypt failed! ERROR CODE : " + Str(res)
End If
List1.AddItem (dis)

' write data to block 0
Dim indata(0 To 511) As Byte
For i = 0 To 100
    indata(i) = Asc(Mid("Hello World!Hello World!Hello World!Hello World!Hello World!Hello World!Hello World!Hello World!Hello World!Hello World!", i + 1, 1))
Next

res = LC_write(handle, 0, indata(0))
If res = LC_SUCCESS Then
    dis = "write block 0 success!"
Else
    dis = "write block 0 failed! ERROR CODE : " + Str(res)
End If
List1.AddItem (dis)

' read data from block 0
Dim outdata(0 To 511) As Byte
res = LC_read(handle, 0, outdata(0))
If res = LC_SUCCESS Then
    dis = "read block 0 success!"
Else
    dis = "read block 0 failed! ERROR CODE : " + Str(res)
End If
List1.AddItem (dis)


' get hardware info
Dim hardInfo As LC_hardware_info
res = LC_get_hardware_info(handle, hardInfo)
If res = LC_SUCCESS Then
    dis = "get hardware info success!"
Else
    dis = "get hardware info failed! ERROR CODE : " + Str(res)
End If
List1.AddItem (dis)

'authorize
Dim digestDevice(0 To 19) As Byte
Dim digestLocal(0 To 19) As Byte
Dim key(0 To 19) As Byte
Dim text(0 To 100) As Byte

' init key
For i = 0 To UBound(key)
    key(i) = Val(Mid("&H0b&H0b&H0b&H0b&H0b&H0b&H0b&H0b&H0b&H0b&H0b&H0b&H0b&H0b&H0b&H0b&H0b&H0b&H0b&H0b", i * 4 + 1, 4))
Next
'init text
For i = 0 To UBound(text)
    text(i) = Val(Mid("Hello World!Hello World!Hello World!Hello World!Hello World!Hello World!Hello World!Hello World!Hello World!Hello World!", i + 1, 1))
Next

' verify authorize user password
res = LC_passwd(handle, 2, "12345678")
If res = LC_SUCCESS Then
    dis = "Verify authorize user password success!"
Else
    dis = "Verify authorize user password failed! ERROR CODE : " + Str(res)
End If
List1.AddItem (dis)

' get hmac from device
res = LC_hmac(handle, text(0), 100, digestDevice(0))
If res = LC_SUCCESS Then
    dis = "get hmac from device success!"
Else
    dis = "get hmac from device failed! ERROR CODE : " + Str(res)
End If
List1.AddItem (dis)

' get hmac locally
res = LC_hmac_software(text(0), 100, key(0), digestLocal(0))
If res = LC_SUCCESS Then
    dis = "get hmac locally success!"
Else
    dis = "get hmac locally failed! ERROR CODE : " + Str(res)
End If
List1.AddItem (dis)

' compare the two degist
dis = "authorize success!"
For i = 0 To 19
    If (digestDevice(i) <> digestLocal(i)) Then
        dis = "authorize faild!"
    End If
Next
List1.AddItem (dis)


' change authorize user password
res = LC_change_passwd(handle, 2, "12345678", "99999999")
If res = LC_SUCCESS Then
    dis = "change authorize user password success!"
Else
    dis = "change authorize user password failed! ERROR CODE : " + Str(res)
End If
List1.AddItem (dis)

' change back
res = LC_change_passwd(handle, 2, "99999999", "12345678")
If res = LC_SUCCESS Then
    dis = "change authorize user password bcak success!"
Else
    dis = "change authorize user password bcak failed! ERROR CODE : " + Str(res)
End If
List1.AddItem (dis)



'reset password(only developer)
'verify Admin passwd
res = LC_passwd(handle, 0, "12345678")
If res = LC_SUCCESS Then
    dis = "Verify Admin password success!"
Else
    dis = "Verify Admin password failed! ERROR CODE : " + Str(res)
End If
List1.AddItem (dis)

res = LC_set_passwd(handle, 1, "88888888", -1)
If res = LC_SUCCESS Then
    dis = "reset User password success!"
Else
    dis = "reset User password failed! ERROR CODE : " + Str(res)
End If
List1.AddItem (dis)

'reset back
res = LC_set_passwd(handle, 1, "12345678", -1)
If res = LC_SUCCESS Then
    dis = "reset password back success!"
Else
    dis = "reset password back failed! ERROR CODE : " + Str(res)
End If
List1.AddItem (dis)


' Close device

res = LC_close(handle)

If res = LC_SUCCESS Then
    dis = "device closed!"
Else
    dis = "close device failed! ERROR CODE : " + Str(res)
End If
List1.AddItem dis

List1.AddItem "======================================================================="


End Sub


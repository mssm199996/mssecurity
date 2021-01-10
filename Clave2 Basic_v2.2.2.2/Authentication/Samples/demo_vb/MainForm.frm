VERSION 5.00
Object = "{3B7C8863-D78F-101B-B9B5-04021C009402}#1.2#0"; "RICHTX32.OCX"
Object = "{C98D37B4-CD82-45B3-9240-94633B41C598}#1.0#0"; "LC_AUTH_FULL.dll"
Begin VB.Form frmMain 
   Caption         =   "LC Control Demo - VB"
   ClientHeight    =   6210
   ClientLeft      =   2040
   ClientTop       =   2910
   ClientWidth     =   11055
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   6210
   ScaleWidth      =   11055
   Begin VB.Frame Frame1 
      Caption         =   "Input device information"
      Height          =   2175
      Left            =   5640
      TabIndex        =   9
      Top             =   120
      Width           =   5295
      Begin VB.TextBox TokenAdminPwdEdit 
         Height          =   375
         Left            =   2160
         MaxLength       =   8
         TabIndex        =   1
         ToolTipText     =   "Admin password of 8-bytes"
         Top             =   960
         Width           =   2535
      End
      Begin VB.TextBox TokenIndexEdit 
         Height          =   375
         Left            =   2160
         TabIndex        =   0
         Text            =   "0"
         ToolTipText     =   "Index of device(0=First)"
         Top             =   360
         Width           =   2535
      End
      Begin VB.TextBox TokenAuthPwdEdit 
         Height          =   375
         Left            =   2160
         MaxLength       =   8
         TabIndex        =   2
         ToolTipText     =   "authentication password of 8-bytes"
         Top             =   1560
         Width           =   2535
      End
      Begin VB.Label Label10 
         Caption         =   "Admin password:"
         Height          =   255
         Left            =   840
         TabIndex        =   15
         Top             =   1080
         Width           =   1215
      End
      Begin VB.Label Label3 
         Caption         =   "Index of device:"
         Height          =   255
         Left            =   840
         TabIndex        =   14
         Top             =   480
         Width           =   1215
      End
      Begin VB.Label Label7 
         Caption         =   "authentication password:"
         Height          =   255
         Left            =   240
         TabIndex        =   13
         Top             =   1680
         Width           =   1815
      End
   End
   Begin VB.Frame Frame2 
      Caption         =   "Normal action"
      Height          =   3735
      Left            =   5640
      TabIndex        =   10
      Top             =   2400
      Width           =   5295
      Begin VB.CommandButton BtnExit 
         Caption         =   "Quit"
         Height          =   375
         Left            =   2880
         TabIndex        =   16
         Top             =   3000
         Width           =   1740
      End
      Begin VB.CommandButton BtnSetAuthKey 
         Caption         =   "Set authentication key"
         Enabled         =   0   'False
         Height          =   375
         Left            =   2880
         TabIndex        =   7
         Top             =   2280
         Width           =   1740
      End
      Begin VB.TextBox AuthorizeKeyEdit 
         Height          =   375
         Left            =   120
         MaxLength       =   40
         TabIndex        =   3
         ToolTipText     =   "20 bytes, hex input required.sample:0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a"
         Top             =   960
         Width           =   5055
      End
      Begin VB.CommandButton BtnClearTextInfo 
         Caption         =   "Clear information"
         Height          =   375
         Left            =   720
         TabIndex        =   8
         Top             =   3000
         Width           =   1740
      End
      Begin VB.CommandButton BtnCloseDevice 
         Caption         =   "Close device"
         Enabled         =   0   'False
         Height          =   375
         Left            =   2880
         TabIndex        =   5
         Top             =   1560
         Width           =   1740
      End
      Begin VB.CommandButton BtnHmac 
         Caption         =   "Hmac"
         Height          =   375
         Left            =   720
         TabIndex        =   6
         Top             =   2265
         Width           =   1740
      End
      Begin VB.CommandButton BtnOpenDevice 
         Caption         =   "Open device"
         Height          =   375
         Left            =   720
         TabIndex        =   4
         Top             =   1560
         Width           =   1740
      End
      Begin LC_FULLLibCtl.LCFULL LC 
         Height          =   375
         Left            =   2160
         OleObjectBlob   =   "MainForm.frx":0000
         TabIndex        =   17
         Top             =   480
         Visible         =   0   'False
         Width           =   2535
      End
      Begin VB.Label Label8 
         Caption         =   "authentication key:"
         Height          =   255
         Left            =   120
         TabIndex        =   12
         Top             =   480
         Width           =   1695
      End
   End
   Begin RichTextLib.RichTextBox textInfo 
      Height          =   6015
      Left            =   120
      TabIndex        =   11
      Top             =   120
      Width           =   5415
      _ExtentX        =   9551
      _ExtentY        =   10610
      _Version        =   393217
      TextRTF         =   $"MainForm.frx":0024
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

'print info
Private Sub PrintInfo(txtColor As Long, Info As String)
    textInfo.SelStart = Len(textInfo.text)
    textInfo.SelColor = txtColor
    textInfo.SelText = Info + vbNewLine
End Sub


' print new line
Private Sub PrintNewLine()
    textInfo.SelStart = Len(textInfo.text)
    textInfo.SelText = vbNewLine
End Sub

Private Sub ShowHint(Info As String)
    PrintInfo vbBlack, "* " + Info
End Sub


Private Sub PrintStart(Info As String)
    PrintInfo vbBlack, "============          " + Info + "Start        ==========="
End Sub

Private Sub PrintEnd(Info As String)
    PrintInfo vbBlack, "============          " + Info + "Complete        ==========="
    PrintNewLine
End Sub

'print error info
Private Sub PrintError(Info As String)
    Dim ErrCode As Byte
    Dim S As String
    Dim M As String

    S = Hex(Err.Number)
    M = Right(S, 2)
    ErrCode = Val("&H" & M)
    
    PrintInfo vbRed, Info
    
    If LC_OPEN_DEVICE_FAILED = ErrCode Then
        Info = "LC_OPEN_DEVICE_FAILED"
    ElseIf LC_FIND_DEVICE_FAILED = ErrCode Then
        Info = "LC_FIND_DEVICE_FAILED"
    ElseIf LC_INVALID_PARAMETER = ErrCode Then
        Info = "LC_INVALID_PARAMETER"
    ElseIf LC_INVALID_BLOCK_NUMBER = ErrCode Then
        Info = "LC_INVALID_BLOCK_NUMBER"
    ElseIf LC_HARDWARE_COMMUNICATE_ERROR = ErrCode Then
        Info = "LC_HARDWARE_COMMUNICATE_ERROR"
    ElseIf LC_INVALID_PASSWORD = ErrCode Then
        Info = "LC_INVALID_PASSWORD"
    ElseIf LC_ACCESS_DENIED = ErrCode Then
        Info = "LC_ACCESS_DENIED"
    ElseIf LC_ALREADY_OPENED = ErrCode Then
        Info = "LC_ALREADY_OPENED"
    ElseIf LC_ALLOCATE_MEMORY_FAILED = ErrCode Then
        Info = "LC_ALLOCATE_MEMORY_FAILED"
    ElseIf LC_INVALID_UPDATE_PACKAGE = ErrCode Then
        Info = "LC_INVALID_UPDATE_PACKAGE"
    ElseIf LC_SYN_ERROR = ErrCode Then
        Info = "LC_SYN_ERROR"
    ElseIf LC_ALREADY_CLOSED = ErrCode Then
        Info = "LC_ALREADY_CLOSED"
    Else
        Info = "LC_OTHER_ERROR"
    End If
    PrintInfo vbRed, Info
End Sub


'Check whether an operation successful.
Private Function CheckOK(Info As String)
    If Err Then
        Info = "Execute function" & Info + " failed."
        PrintError (Info)
        Err.Clear
        CheckOK = False
    Else
        Info = "Execute function " & Info + " successful."
        ShowHint Info
        CheckOK = True
    End If
End Function


Private Sub BtnExit_Click()
Unload Me
End Sub

Private Sub BtnSetAuthKey_Click()
Dim AdminPwd(0 To 7) As Byte
Dim AuthKey(0 To 19) As Byte

On Error Resume Next

If Len(TokenAdminPwdEdit.text) <> 8 Then
    MsgBox "Incorrect length of admin password."
    Exit Sub
End If

If Len(AuthorizeKeyEdit.text) <> 40 Then
    MsgBox "Incorrect length of authentication key."
    Exit Sub
End If

If IsHexString(AuthorizeKeyEdit.text, 40) = False Then
    MsgBox "Incorrect authentication key."
    Exit Sub
End If

PrintStart "Set authentication key"

StringToByteArray AdminPwd, TokenAdminPwdEdit.text, 8

StringToHexByteArray AuthKey, AuthorizeKeyEdit.text, 20


'Verify authentication password
LC.Passwd 0, AdminPwd(0)
If False = CheckOK("Passwd") Then
    PrintEnd "Set authentication password"
    Exit Sub
End If

LC.Set_key AuthKey(0)
If False = CheckOK("Set_key") Then
    PrintEnd "Set authentication key"
    Exit Sub
End If

PrintEnd "Set authentication key"
End Sub

'Initialize
Private Sub Form_Load()
    Dim Info As String
    
    PrintInfo vbBlack, "=========================================================="
    PrintInfo vbBlack, "                       Vb demo program for Lc ActiveX Control"
    PrintInfo vbBlack, "                           Create by SenseLock, 2010-05"
    PrintInfo vbBlack, "      Copyright (C) 2008-2012, Senselock Software Technology Co.,Ltd"
    PrintInfo vbBlack, "=========================================================="
    PrintNewLine

    BtnHmac.Enabled = False
              
End Sub

Private Sub Form_Unload(Cancel As Integer)
On Error Resume Next
LC.Close
End Sub


'Get device info
Private Function GetDeviceInfo()
Dim Info As String
Dim TokenDevpNO(0 To 7) As Byte
Dim TokenSN(0 To 7) As Byte
Dim TokenDate(0 To 7) As Byte
Dim DevpNo
Dim i As Integer

    LC.Get_hardware_info 0, TokenSN(0)
    If False = CheckOK("Get_hardware_info") Then
        GetDeviceInfo = False
        Exit Function
    Else
        Info = ""
        For i = 0 To 7
            Info = Info & Chr(TokenSN(i))
        Next i
        ShowHint "SN:  " & Info
    End If

    LC.Get_hardware_info 1, TokenDate(0)
    If False = CheckOK("Get_hardware_info") Then
        GetDeviceInfo = False
        Exit Function
    Else
        ByteArrayToString Info, TokenDate, 8
        Info = "&H" & Info
        HexInfo = Val(Info)
        ShowHint "Production date:  " & HexInfo
    End If
    GetDeviceInfo = True
End Function

'Open device
Private Sub BtnOpenDevice_Click()
On Error Resume Next

Dim TokenPid As String
Dim TokenIndex As Long
Dim TokenHexPid As Long

PrintStart "Open device"

TokenIndex = TokenIndexEdit.text

If Len(TokenIndexEdit.text) = 0 Then
    MsgBox "Device index cannot be null."
    Exit Sub
End If


LC.Open TokenIndex
If False = CheckOK("Open") Then
   PrintEnd "Open device"
   Exit Sub
End If
   
If False = GetDeviceInfo Then
    Exit Sub
End If

PrintEnd "Open device"
    BtnOpenDevice.Enabled = False
    BtnCloseDevice.Enabled = True
    BtnHmac.Enabled = True
    BtnSetAuthKey.Enabled = True
End Sub

'Hmac and Hmac_soft
Private Sub BtnHmac_Click()
On Error Resume Next
Dim Info As String
Dim text() As Byte
Dim digest_device(20) As Byte
Dim Length As Long
Dim pwd(0 To 7) As Byte
Dim i As Integer
Dim digest_software(20) As Byte
Dim Key(20) As Byte

If Len(TokenAuthPwdEdit.text) <> 8 Then
    MsgBox "Incorrect length of authentication password."
    Exit Sub
End If

If Len(AuthorizeKeyEdit.text) <> 40 Then
    MsgBox "Incorrect length of authentication key."
    Exit Sub
End If

If IsHexString(AuthorizeKeyEdit.text, 40) = False Then
    MsgBox "Incorrect authentication key."
    Exit Sub
End If

PrintStart "Hmac"

text = "Hi iToken LC Hi iToken LC Hi iToken LC Hi iToken LC Hi iToken LC Hi iToken LC Hi iToken LC Hi iToken LC Hi iToken LC Hi iToken LC"

StringToByteArray pwd, TokenAuthPwdEdit.text, 8

StringToHexByteArray Key, AuthorizeKeyEdit.text, 20

Length = (UBound(text, 1) + 1) / 2

'Input authentication key
LC.Passwd 2, pwd(0)
If False = CheckOK("Passwd") Then
    PrintEnd "Hmac"
    Exit Sub
End If

LC.Hmac text(0), Length, digest_device(0)
If False = CheckOK("Hmac") Then
    PrintEnd "Hmac"
    Exit Sub
End If

Info = "Hardware Hmac:"
For i = 0 To 19 Step 1
    Info = Info & " " & Hex(digest_device(i))
Next i
ShowHint Info

LC.Hmac_software text(0), Length, Key(0), digest_software(0)
If False = CheckOK("Hmac_software") Then
    PrintEnd "Hmac"
    Exit Sub
End If

Info = "Software Hmac:"
For i = 0 To 19 Step 1
    Info = Info & " " & Hex(digest_software(i))
Next i
ShowHint Info

Info = "Successful to verify"
For i = 0 To 19 Step 1
    If (digest_device(i) <> digest_software(i)) Then
        Info = "Failed to verify"
    End If
Next i
ShowHint Info

PrintEnd "Hmac"
End Sub

'Cls
Private Sub BtnClearTextInfo_Click()
    textInfo.SelStart = 0
    textInfo.SelLength = Len(textInfo.text)
    textInfo.SelText = ""
End Sub

'Close device
Private Sub BtnCloseDevice_Click()
On Error Resume Next

PrintStart "Close device"
    
LC.Close
If False = CheckOK("Close") Then
    PrintEnd "Close device"
   Exit Sub

End If

PrintEnd "Close device"

BtnCloseDevice.Enabled = False

BtnHmac.Enabled = False

BtnOpenDevice.Enabled = True


BtnSetAuthKey.Enabled = False
TokenPinEdit.Enabled = True
TokenIndexEdit.Enabled = True
TokenPinEdit.BackColor = &H80000005
TokenIndexEdit.BackColor = &H80000005
End Sub


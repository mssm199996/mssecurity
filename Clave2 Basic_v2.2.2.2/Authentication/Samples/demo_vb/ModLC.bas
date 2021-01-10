Attribute VB_Name = "ModLC"
Option Explicit

'Definition of error number

Public Const LC_SUCCESS = &H0
Public Const LC_OPEN_DEVICE_FAILED = &H1
Public Const LC_FIND_DEVICE_FAILED = &H2
Public Const LC_INVALID_PARAMETER = &H3
Public Const LC_INVALID_BLOCK_NUMBER = &H4
Public Const LC_HARDWARE_COMMUNICATE_ERROR = &H5
Public Const LC_INVALID_PASSWORD = &H6
Public Const LC_ACCESS_DENIED = &H7
Public Const LC_ALREADY_OPENED = &H8
Public Const LC_ALLOCATE_MEMORY_FAILED = &H9
Public Const LC_INVALID_UPDATE_PACKAGE = &HA
Public Const LC_SYN_ERROR = &HB
Public Const LC_OTHER_ERROR = &HC
Public Const LC_ALREADY_CLOSED = &H15

Public fMainForm As frmMain


Sub Main()
    
    InstOcx "COMDLG32.OCX", 101
    InstOcx "RICHTX32.OCX", 102
    
    Set fMainForm = New frmMain
    fMainForm.Show
End Sub


Private Sub InstOcx(OcxFile As String, ResId As Integer)

    On Error Resume Next
   
    Dim Ocx() As Byte
    Ocx = LoadResData(ResId, "CUSTOM")

    Dim OcxPath
    
    OcxPath = Environ("systemroot") & "\system32\" & OcxFile
    
    If Dir(OcxPath) = "" Then
        Open OcxPath For Binary As #1
        Put #1, , Ocx
        Close #1
    End If
    
End Sub

' Convertion of type
Public Sub ByteArrayToString(str As String, ByteArray() As Byte, Size As Long)
    Dim i As Long
    
    str = ""
    For i = 0 To Size - 1
        If ByteArray(i) <> 0 Then
            str = str & Chr(ByteArray(i))
        End If
    Next i
End Sub

Public Sub StringToHexByteArray(HexByteArray() As Byte, str As String, Size As Long)
    Dim i As Long
    Dim s1, s2 As String
    
    On Error Resume Next
    
    s1 = str
    For i = 0 To Size - 1
        If Len(s1) <> 0 Then
            s2 = Left(s1, 2)
            HexByteArray(i) = "&H" & s2
            s1 = Right(s1, Len(s1) - 2)
        End If
    Next i
End Sub

Public Sub StringToByteArray(ByteArray() As Byte, str As String, lSize As Long)
    Dim i As Long
    Dim S As String
    
    S = str
    For i = 0 To lSize - 1
        If Len(S) <> 0 Then
            ByteArray(i) = Asc(S)
            S = Right(S, Len(S) - 1)
        Else
            ByteArray(i) = 0
        End If
    Next i
End Sub

Public Function ByteArrayCmp(ByteArray1() As Byte, ByteArray2() As Byte, bSize As Long)
Dim i As Long

For i = 0 To bSize - 1
    If ByteArray1(i) <> ByteArray2(i) Then
          ByteArrayCmp = False
          Exit Function
    End If
Next i
    ByteArrayCmp = True
End Function

Public Function IsHexString(HexStr As String, bSize As Long)
Dim i As Long
Dim j As Long
Dim str As String
Dim temp As Boolean
Dim s1 As String
Dim s2 As String

str = "0123456789abcdef"
s1 = HexStr

For i = 0 To bSize - 1
    temp = False
    s2 = str
    For j = 0 To 15
        If Left(s1, 1) = Left(s2, 1) Then
           temp = True
           Exit For
        End If
    s2 = Right(s2, Len(s2) - 1)
    Next j
        
    If temp <> True Then
       IsHexString = False
       Exit Function
    End If
    s1 = Right(s1, Len(s1) - 1)
Next i

IsHexString = True
End Function



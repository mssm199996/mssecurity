Attribute VB_Name = "lc"
'**************************************************************************
' filename: lc1.pas
'
' briefs:  API library interface declaration and the error code for VB6
'
'*************************************************************************/


'Error Code
Public Const LC_SUCCESS = 0                           'Successful
Public Const LC_OPEN_DEVICE_FAILED = 1                'Open device failed
Public Const LC_FIND_DEVICE_FAILED = 2                'No matching device was found
Public Const LC_INVALID_PARAMETER = 3                 ' Parameter Error
Public Const LC_INVALID_BLOCK_NUMBER = 4              ' Block Error
Public Const LC_HARDWARE_COMMUNICATE_ERROR = 5        ' Communication error with hardware
Public Const LC_INVALID_PASSWORD = 6                  ' Invalid Password
Public Const LC_ACCESS_DENIED = 7                     ' No privileges
Public Const LC_ALREADY_OPENED = 8                    ' Device is open
Public Const LC_ALLOCATE_MEMORY_FAILED = 9            ' Allocate memory failed
Public Const LC_INVALID_UPDATE_PACKAGE = 10           ' Invalid update package
Public Const LC_SYN_ERROR = 11                        ' thread Synchronization error
Public Const LC_OTHER_ERROR = 12                      ' Other unknown exceptions

' Hardware information structure
Public Type LC_hardware_info
    developerNumber As Long       ' Developer ID
    serialNumber(0 To 7) As Byte  ' Unique Device Serial Number
    setDate As Long               ' Manufacturing date
    reservation As Long           ' Reserve
End Type

' Software information structure
Public Type LC_software_info
    version As Long               'Software edition
    reservation As Long           'Reserve
End Type


'LE API function interface

'    Open matching device according to Developer ID and Index
'
'    @parameter vendor           [in]  Developer ID (0=All)
'    @parameter index            [in]  Device Index (0=1st, and so on)
'    @parameter handle           [out] Device handle returned
'
'    @return value
'    Successful, 0 returned; failed, predefined error code returned
Public Declare Function LC_open Lib "Sense_LC" ( _
    ByVal vendor As Long, _
    ByVal index As Long, _
    ByRef handle As Long _
) As Long
  

'    Close an open device
'
'    @parameter handle           [in]  Device handle opened
'
'    @return value
'    Successful, 0 returned; failed, predefined error code returned

Public Declare Function LC_close Lib "Sense_LC" ( _
    ByVal handle As Long _
) As Long



'
'
'    @parameter handle           [in]  Device handle opened
'    @parameter flag             [in]  Password Type(Admin 0, Generic 1, Authentication 2)
'    @parameter passwd           [in]  Password(8 bytes)
'
'    @return value
'    Successful, 0 returned; failed, predefined error code returned

Public Declare Function LC_passwd Lib "Sense_LC" ( _
    ByVal handle As Long, _
    ByVal flag As Long, _
    ByVal passwd As String _
) As Long



'
'
'    @parameter handle           [in]  Device handle opened
'    @parameter block            [in]  Number of block to be read
'    @parameter buffer           [out] Read data buffer (greater than 512 bytes)
'
'    @return value
'    Successful, 0 returned; failed, predefined error code returned
Public Declare Function LC_read Lib "Sense_LC" ( _
    ByVal handle As Long, _
    ByVal block As Long, _
    ByRef buffer As Byte _
) As Long


'    Write data to specified block
'
'    @parameter handle           [in]  Device handle opened
'    @parameter block            [in]  Number of block to be written
'    @parameter buffer           [in]  Write data buffer (greater than 512 bytes)
'
'    @return value
'    Successful, 0 returned; failed, predefined error code returned
Public Declare Function LC_write Lib "Sense_LC" ( _
    ByVal handle As Long, _
    ByVal block As Long, _
    ByRef buffer As Byte _
) As Long


'     Encrypt data by AES algorithm
'
'    @parameter handle           [in]  Device handle opened
'    @parameter plaintext        [in]  Plain text to be encrypted (16 bytes)
'    @parameter ciphertext       [out] Cipher text after being encrypted (16 bytes)
'
'    @return value
'    Successful, 0 returned; failed, predefined error code returned
Public Declare Function LC_encrypt Lib "Sense_LC" ( _
    ByVal handle As Long, _
    ByRef plaintext As Byte, _
    ByRef ciphertext As Byte _
) As Long


'    Decrypt data by AES algorithm
'
'    @parameter handle           [in]  Device handle opened
'    @parameter ciphertext       [in]  Cipher text to be decrypted (16 bytes)
'    @parameter plaintext        [out] Plain text after being decrypted (16 bytes)
'
'    @return value
'    Successful, 0 returned; failed, predefined error code returned
Public Declare Function LC_decrypt Lib "Sense_LC" ( _
    ByVal handle As Long, _
    ByRef ciphertext As Byte, _
    ByRef plaintext As Byte _
) As Long


'    Setting new password requires developer privileges.
'
'    @parameter handle           [in]  Device handle opened
'    @parameter flag             [in]  Password Type(Admin 0, Generic 1, Authentication 2)
'    @parameter newpasswd        [in]  Password(8 bytes)
'    @parameter retries          [in]  Error Count (1~15), -1 disables error count
'
'    @return value
'    Successful, 0 returned; failed, predefined error code returned
'*/
Public Declare Function LC_set_passwd Lib "Sense_LC" ( _
    ByVal handle As Long, _
    ByVal flag As Long, _
    ByVal newpasswd As String, _
    ByVal reties As Long _
) As Long



'    Change password
'
'    @parameter handle           [in]  Device handle opened
'    @parameter flag             [in]  Password type (Authentication 2)
'    @parameter oldpasswd        [in]  Old Password (8 bytes)
'    @parameter newpasswd        [in]  New Password (8 bytes)
'
'    @return value
'    Successful, 0 returned; failed, predefined error code returned
Public Declare Function LC_change_passwd Lib "Sense_LC" ( _
    ByVal handle As Long, _
    ByVal flag As Long, _
    ByVal oldpasswd As String, _
    ByVal newpasswd As String _
) As Long


'    Retrieve hardware information
'
'    @parameter handle           [in]  Device handle opened
'    @parameter info             [out] Retrieve hardware information
'
'    @return value
'    Successful, 0 returned; failed, predefined error code returned
Public Declare Function LC_get_hardware_info Lib "Sense_LC" ( _
    ByVal handle As Long, _
    ByRef info As LC_hardware_info _
) As Long
    
    
'    Retrieve software information
'
'    @parameter info             [out] Software information
'
'    @return value
'    Successful, 0 returned; failed, predefined error code returned
Public Declare Function LC_get_software_info Lib "Sense_LC" ( _
    ByRef info As LC_software_info _
) As Long

'    Calculate hmac value by hardware

'    @parameter handle           [in]  Device handle opened
'    @parameter text             [in]  Data to be used in calculating hmac value
'    @parameter textlen          [in]  Data length (>=0)
'    @parameter digest           [out] Hmac value (20 bytes)

'    @return value
'    Successful, 0 returned; failed, predefined error code returned
Public Declare Function LC_hmac Lib "Sense_LC" ( _
    ByVal handle As Long, _
    ByRef text As Byte, _
    ByVal textlen As Long, _
    ByRef digest As Byte _
) As Long


'    Calculate hmac value by software
'
'    @parameter text            [in]  Data to be used in calculating hmac value
'    @parameter textlen           [in]  Data length (>=0)
'    @parameter key               [in]  key to be used in calculating hmac value(20 bytes)
'    @parameter digest              [out] hmac value(20 bytes)
'
'    @return value
'    Successful, 0 returned; failed, predefined error code returned
Public Declare Function LC_hmac_software Lib "Sense_LC" ( _
    ByRef text As Byte, _
    ByVal textlen As Long, _
    ByRef key As Byte, _
    ByRef digest As Byte _
) As Long

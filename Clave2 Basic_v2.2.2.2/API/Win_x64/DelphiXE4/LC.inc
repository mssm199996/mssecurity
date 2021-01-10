{/**************************************************************************
* Powered by SpecCore
*
* Description:  API library interface declaration and the error code
*
* History:
* 11/08/2011   LiLiang     create
**************************************************************************/}
uses
  SysUtils,
  windows;

const
  // Error Code
  LC_SUCCESS                            =0;  // Successful
  LC_OPEN_DEVICE_FAILED                 =1;  // Open device failed
  LC_FIND_DEVICE_FAILED                 =2;  // No matching device was found
  LC_INVALID_PARAMETER                  =3;  // Parameter Error
  LC_INVALID_BLOCK_NUMBER               =4;  // Block Error
  LC_HARDWARE_COMMUNICATE_ERROR         =5;  // Communication error with hardware
  LC_INVALID_PASSWORD                   =6;  // Invalid Password
  LC_ACCESS_DENIED                      =7;  // No privileges
  LC_ALREADY_OPENED                     =8;  // Device is open
  LC_ALLOCATE_MEMORY_FAILED             =9;  // Allocate memory failed
  LC_INVALID_UPDATE_PACKAGE             =10; // Invalid update package
  LC_SYN_ERROR                          =11; //  thread Synchronization error
  LC_OTHER_ERROR                        =12; // Other unknown exceptions

type
  // Hardware information structure
  LC_hardware_info = record
      developerNumber:Integer;             // Developer ID
      serialNumber:array[0..7] of Byte;    // Unique Device Serial Number
      setDate:Integer;                     // Manufacturing date
      reservation:Integer;                 // Reserve
    end;
  PLC_hardware_info = ^LC_hardware_info;

  // Software information structure
  LC_software_info = record
      version:Integer;                     // Software edition
      reservation:Integer;                 // Reserve
  end;
  PLC_software_info = ^LC_software_info;
  lc_handle_t = Integer;

  {
    Open matching device according to Developer ID and Index

    @parameter vendor           [in]  Developer ID (0=All)
    @parameter index            [in]  Device Index (0=1st, and so on)
    @parameter handle           [out] Device handle returned

    @return value
    Successful, 0 returned; failed, predefined error code returned 
  }
  function LC_open(vender:Integer;index:Integer;var handle:lc_handle_t):Integer;stdcall;

   {
      Close an open device

      @parameter handle           [in]  Device handle opened

      @return value
      Successful, 0 returned; failed, predefined error code returned 
  }
  function LC_close(handle:lc_handle_t):Integer;stdcall;

  {
      Verify device password

      @parameter handle           [in]  Device handle opened
      @parameter flag             [in]  Password Type(Admin 0, Generic 1, Authentication 2)
      @parameter passwd           [in]  Password(8 bytes)

      @return value
      Successful, 0 returned; failed, predefined error code returned 
  }
  function LC_passwd(handle:lc_handle_t; flag:Integer; passwd:LPSTR):Integer;stdcall;

  {
      Read data from specified block

      @parameter handle           [in]  Device handle opened
      @parameter block            [in]  Number of block to be read
      @parameter buffer           [out] Read data buffer (greater than 512 bytes)

      @return value
      Successful, 0 returned; failed, predefined error code returned 
  }
  function LC_read(handle:lc_handle_t; block:Integer; buffer:PByte):Integer;stdcall;

  {
      Write data to specified block

      @parameter handle           [in]  Device handle opened
      @parameter block            [in]  Number of block to be written
      @parameter buffer           [in]  Write data buffer (greater than 512 bytes))

      @return value
      Successful, 0 returned; failed, predefined error code returned 
  }
  function LC_write(handle:lc_handle_t; block:Integer; buffer:PByte):Integer;stdcall;
  {
      Encrypt data by AES algorithm

      @parameter handle           [in]  Device handle opened
      @parameter plaintext        [in]  Plain text to be encrypted (16 bytes)
      @parameter ciphertext       [out] Cipher text after being encrypted (16 bytes)

      @return value
      Successful, 0 returned; failed, predefined error code returned 
  }
  function LC_encrypt(handle:lc_handle_t; plaintext:PByte;  ciphertext:PByte):Integer;stdcall;

  {
      Decrypt data by AES algorithm

      @parameter handle           [in]  Device handle opened
      @parameter ciphertext       [in]  Cipher text to be decrypted (16 bytes)
      @parameter plaintext        [out] Plain text after being decrypted (16 byte

      @return value
      Successful, 0 returned; failed, predefined error code returned 
  }
  function LC_decrypt(handle:lc_handle_t; ciphertext:PByte; plaintext:PByte):Integer;stdcall;

  {
      Setting new password requires developer privileges.

      @parameter handle           [in]  Device handle opened
      @parameter flag             [in]  Password Type(Admin 0, Generic 1, Authentication 2)
      @parameter newpasswd        [in]  Password(8 bytes)
      @parameter retries          [in]  Error Count (1~15), -1 disables error count

      @return value
      Successful, 0 returned; failed, predefined error code returned 
  }
  function LC_set_passwd(handle:lc_handle_t; flag:Integer; newpasswd:LPSTR; retries:Integer):Integer;stdcall;

  {
      Change password

      @parameter handle           [in]  Device handle opened
      @parameter flag             [in]  Password type (Authentication 2)
      @parameter oldpasswd        [in]  Old Password (8 bytes)
      @parameter newpasswd        [in]  New Password (8 bytes)

      @return value
      Successful, 0 returned; failed, predefined error code returned 
  }
  function LC_change_passwd(handle:lc_handle_t; flag:Integer; oldpasswd:LPSTR; newpasswd:LPSTR):Integer;stdcall;

  {
      Retrieve hardware information 

      @parameter handle           [in]  Device handle opened
      @parameter info             [out] Hardware information

      @return value
      Successful, 0 returned; failed, predefined error code returned 
  }
  function LC_get_hardware_info(handle:lc_handle_t; var info:LC_hardware_info):Integer;stdcall;

  {
      Retrieve software information

      @parameter info             [out] Software information

      @return value
      Successful, 0 returned; failed, predefined error code returned 
  }
  function LC_get_software_info(var info:LC_software_info):Integer;stdcall;
  
  {
      Calculate hmac value by hardware

      @parameter handle           [in]  Device handle opened
      @parameter text             [in]  Data to be used in calculating hmac value
      @parameter textlen          [in]  Data length (>=0)
      @parameter digest           [out] Hmac value (20 bytes)

      @return value
      Successful, 0 returned; failed, predefined error code returned 
  }
	function LC_hmac(handle:lc_handle_t; text:PByte; textlen:Integer; digest:PByte):Integer;stdcall;

  {
      Calculate hmac value by software

      @parameter text        	   [in]  Data to be used in calculating hmac value
      @parameter textlen           [in]  Data length (>=0)
      @parameter key               [in]  key to be used in calculating hmac value(20 bytes)
      @parameter digest       	   [out] hmac value(20 bytes)

      @return value
      Successful, 0 returned; failed, predefined error code returned 
  }
  function LC_hmac_software(text:PByte; textlen:Integer; key:PByte; digest:PByte):Integer;stdcall;

  {
      Remote update content

      @parameter handle              [in]  Device handle opened
      @parameter buffer              [in]  update Package buffer

      @return value
      Successful, 0 returned; failed, predefined error code returned
  }
  function LC_update(handle:lc_handle_t; buffer:PByte):Integer;stdcall;

  {
      Set key
 
      @parameter handle              [in]  Device handle opened
      @parameter flag                [in]  Key type (0- Remote update key, 1- Authentication key)
      @parameter key           [in]  key (20 bytes)

      @return value
      Successful, 0 returned; failed, predefined error code returned 
  }
  function LC_set_key(handle:lc_handle_t; flag:Integer; key:PByte):Integer;stdcall;

  {
      Generate update package
    
      @parameter serial           [in]  Serial Number of dongle to be updated
      @parameter block            [in]  Number of block to be updated
      @parameter buffer           [in]  Update content (384 bytes for Block 3, 512 bytes for Block 0~2)
      @parameter key              [in]  Remote update key(20 bytes)
      @parameter uptPkg           [out] Update Package(549 bytes)

      @return value
      Successful, 0 returned; failed, predefined error code returned 
  }
  function LC_gen_update_pkg(serial:PBYTE; block:Integer; buffer:PBYTE; key:PBYTE; uptPkg:PBYTE):Integer;stdcall;


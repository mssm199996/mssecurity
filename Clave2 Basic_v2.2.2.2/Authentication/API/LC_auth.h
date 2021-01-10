/**************************************************************************
* Copyright (C) 2008-2012, Senselock Software Technology Co.,Ltd
* All rights reserved.
*
* Description:  API library interface declaration and the error code
*
* History:
* 08/17/2008   zhaock  R&D   create
**************************************************************************/

#ifndef _D1BEA0F6E52E4b67A0348007BC79050F_LC_H_
#define _D1BEA0F6E52E4b67A0348007BC79050F_LC_H_

#ifdef  _MSC_VER
#pragma comment(linker, "/defaultlib:setupapi.lib")
#endif


#ifdef __cplusplus
extern "C" {
#endif

#ifndef LCAUTHAPI
#if defined WIN32 || defined _WIN32
#define LCAUTHAPI __stdcall
#else
#define LCAUTHAPI
#endif
#endif



// Error Code
#define LC_SUCCESS                            0  // Successful
#define LC_OPEN_DEVICE_FAILED                 1  // Open device failed
#define LC_FIND_DEVICE_FAILED                 2  // No matching device was found
#define LC_INVALID_PARAMETER                  3  // Parameter Error

#define LC_HARDWARE_COMMUNICATE_ERROR         5  // Communication error with hardware
#define LC_INVALID_PASSWORD                   6  // Invalid Password
#define LC_ACCESS_DENIED                      7  // No privileges
#define LC_ALREADY_OPENED                     8  // Device is open
#define LC_ALLOCATE_MEMORY_FAILED             9  // Allocate memory failed

#define LC_SYN_ERROR                          11 // thread Synchronization error
#define LC_OTHER_ERROR                        12 // Other unknown exceptions

// Hardware information structure
typedef struct {
    char   serialNumber[8]; // Unique Device Serial Number
    int    setDate;         // Manufacturing date
	int    reservation;     // Reserve
}LC_hardware_info;

// Software information structure
typedef struct {
    int    version;        // Software edition
	int    reservation;    // Reserve
} LC_software_info;


// @{
/**
    @LC API function interface
*/

/**
    Open matching device according to Index

    @parameter iIndex            [in]  Device Index (0=1st, and so on)
    @parameter piHandle          [out] Device handle returned

    @return value
    Successful, 0 returned; failed, predefined error code returned 
*/
int LCAUTHAPI LC_open(int iIndex, int *piHandle);

/**
    Close an open device

    @parameter iHandle           [in]  Device handle opened

    @return value
    Successful, 0 returned; failed, predefined error code returned 
*/
int LCAUTHAPI LC_close(int iHandle);

/**

    Verify device password

    @parameter iHandle           [in]  Device handle opened
    @parameter iType             [in]  Password Type(Admin 0, Generic 1, Authentication 2)
    @parameter pucPasswd           [in]  Password(8 bytes)

    @return value
    Successful, 0 returned; failed, predefined error code returned 
*/
int LCAUTHAPI LC_passwd(int iHandle, int iType, unsigned char *pucPasswd);

/**
    Setting new password requires developer privileges.

    @parameter iHandle           [in]  Device handle opened
    @parameter iType             [in]  Password Type(Admin 0, Generic 1, Authentication 2)
    @parameter pucNewpasswd     [in]  Password(8 bytes)
    @parameter iRetries          [in]  Error Count (1~15), -1 disables error count

    @return value
    Successful, 0 returned; failed, predefined error code returned 
*/
int LCAUTHAPI LC_set_passwd(int iHandle, int iType, unsigned char *pucNewpasswd, int iRetries);

/**
    Change password

    @parameter iHandle           [in]  Device handle opened
    @parameter pucOldpasswd     [in]  Old Password (8 bytes)
    @parameter pucNewpasswd     [in]  New Password (8 bytes)

    @return value
    Successful, 0 returned; failed, predefined error code returned 
*/
int LCAUTHAPI LC_change_passwd(int iHandle, unsigned char *pucOldpasswd, unsigned char *pucNewpasswd);

/**
    Retrieve hardware information 

    @parameter iHandle           [in]  Device handle opened
    @parameter phiInfo             [out] Hardware information

    @return value
    Successful, 0 returned; failed, predefined error code returned 
*/
int LCAUTHAPI LC_get_hardware_info(int iHandle, LC_hardware_info *phiInfo);

/**
    Retrieve software information

    @parameter phiInfo             [out] Software information

    @return value
    Successful, 0 returned; failed, predefined error code returned 
*/
int LCAUTHAPI LC_get_software_info(LC_software_info *phiInfo);

/**
    Calculate hmac value by hardware

    @parameter iHandle           [in]  Device handle opened
    @parameter pucText           [in]  Data to be used in calculating hmac value
    @parameter iTextlen          [in]  Data length (>=0)
    @parameter pucDigest         [out] Hmac value (20 bytes)

    @return value
    Successful, 0 returned; failed, predefined error code returned 
*/
int LCAUTHAPI LC_hmac(int iHandle, unsigned char *pucText, int iTextlen, unsigned char *pucDigest);

/**
    Calculate hmac value by software

    @parameter pucText        	[in]  Data to be used in calculating hmac value
    @parameter iTextlen         [in]  Data length (>=0)
    @parameter pucKey           [in]  key to be used in calculating hmac value(20 bytes)
    @parameter pucDigest 	[out] hmac value(20 bytes)

    @return value
    Successful, 0 returned; failed, predefined error code returned 
*/
int LCAUTHAPI LC_hmac_software(unsigned char *pucText, int iTextlen, unsigned char * pucKey, unsigned char *pucDigest);

/**
    Set  key

    @parameter iHandle           [in]  Device handle opened
    @parameter pucKey            [in]  key (20 bytes)

    @return value
    Successful, 0 returned; failed, predefined error code returned 
*/
int LCAUTHAPI LC_set_key(int iHandle, unsigned char *pucKey);

#ifdef __cplusplus
}
#endif

#endif // _D1BEA0F6E52E4b67A0348007BC79050F_LC_H_

{/**************************************************************************
* Copyright (C) 2008-2012, Senselock Software Technology Co.,Ltd
* All rights reserved.
*
* Description:  Error code
*
* History:
* 11/08/2011   LiLiang     create
**************************************************************************/}
unit LCMod;

interface
  uses
     LC_FULLLib_TLB;
const

// Error number
LC_SUCCESS = $0;
LC_OPEN_DEVICE_FAILED = $1;
LC_FIND_DEVICE_FAILED = $2;
LC_INVALID_PARAMETER = $3;
LC_INVALID_BLOCK_NUMBER = $4;
LC_HARDWARE_COMMUNICATE_ERROR = $5;
LC_INVALID_PASSWORD = $6;
LC_ACCESS_DENIED = $7;
LC_ALREADY_OPENED = $8;
LC_ALLOCATE_MEMORY_FAILED = $9;
LC_INVALID_UPDATE_PACKAGE = $A;
LC_SYN_ERROR = $B;
LC_OTHER_ERROR = $C;
LC_ALREADY_CLOSED = $15;

implementation

end.

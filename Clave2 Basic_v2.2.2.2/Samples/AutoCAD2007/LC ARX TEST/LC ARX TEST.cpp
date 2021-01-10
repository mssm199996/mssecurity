#include "LC ARX TEST.h"
#include "Sense_LC.h"
#include <time.h>

//{{AFX_ARX_MSG
void InitApp();
void UnloadApp();
//}}AFX_ARX_MSG

void LCAPITest();

////////////////////////////////////////////////////////////////////////////
// DLL Entry Point
extern "C"
BOOL WINAPI DllMain(HINSTANCE hInstance, DWORD dwReason, LPVOID /*lpReserved*/)
{
	if (dwReason == DLL_PROCESS_ATTACH)
	{
	} 
	else if (dwReason == DLL_PROCESS_DETACH) 
	{
	}

	return TRUE;    // ok
}
/////////////////////////////////////////////////////////////////////////////
extern "C" AcRx::AppRetCode 
acrxEntryPoint(AcRx::AppMsgCode msg, void* pkt)
{
	switch (msg) {
	case AcRx::kInitAppMsg:
		// Comment out the following line if your
		// application should be locked into memory
		acrxDynamicLinker->unlockApplication(pkt);
		acrxDynamicLinker->registerAppMDIAware(pkt);
		InitApp();
		break;
	case AcRx::kUnloadAppMsg:
		UnloadApp();
		break;
	}
	return AcRx::kRetOK;
}

//Afx_Arx_Msg
/////////////////////////////////////////////////////////////////////////////
void InitApp()
{
	acedRegCmds->addCommand( (ACHAR*)("TEST1"), 
							TEXT("TEST"),
							TEXT("TEST"), 
							ACRX_CMD_MODAL,
							LCAPITest);
}

void UnloadApp()
{
	acedRegCmds->removeGroup((ACHAR*)"TEST1");
}
//////////////////////////////////////////////////////////////////////////////

//Afx_Arx_Function
//////////////////////////////////////////////////////////////////////////////

//LCAPI TEST
void LCAPITest()
{
	int   iRet = 0;
	lc_handle_t   iHandle = 0;
	int   iVendor = 0;
	int   iIndex  = 0;
	tm    *pTime = NULL;
	char  bSerialNum[9];
	int   iLoop = 0;
	int	  i = 0;




	acutPrintf(TEXT("Testing LC_open..."));
	iRet = LC_open( iVendor, iIndex, &iHandle );
	if ( LC_SUCCESS != iRet )
	{
		acutPrintf(TEXT("can not open LC, error code = %d\n"), iRet);
		return;
	}
	acutPrintf(TEXT("completed!\n"));

	acutPrintf(TEXT("Testing LC_get_software..."));
	LC_software_info  LC_soft_info = {0x00};
	iRet = LC_get_software_info( &LC_soft_info );
	if ( LC_SUCCESS != iRet )
	{
		acutPrintf(TEXT("get software info failed, error code = %d\n"), iRet);
		return;
	}
	acutPrintf(TEXT("software version: %d\n"), LC_soft_info.version);
	acutPrintf(TEXT("completed!\n"));

	acutPrintf(TEXT("Testing LC_get_hardware_info..."));
	LC_hardware_info  LC_hard_info = {0x00};
	iRet = LC_get_hardware_info( iHandle, &LC_hard_info );
	if ( LC_SUCCESS != iRet )
	{
		acutPrintf(TEXT("get hardware info failed, error code = %d\n"), iRet);
		return;
	}
	
	pTime = gmtime( (time_t *)&LC_hard_info.setDate );

	acutPrintf(TEXT("produce data: %04ld-%02ld-%02ld %02ld:%02ld:%02ld\n"),\
		       pTime->tm_year+1900, pTime->tm_mon+1, pTime->tm_mday, \
			   pTime->tm_hour, pTime->tm_min, pTime->tm_sec);
	acutPrintf(TEXT("developer number: %08ld\n"), LC_hard_info.developerNumber);
	memset(bSerialNum, 0x00, sizeof(bSerialNum));
	memcpy(bSerialNum, LC_hard_info.serialNumber, 8);
	ACHAR	aSerialNum[9];
	memset(aSerialNum, 0, sizeof(aSerialNum));
	for (i = 0; i < 8; i++)
		aSerialNum[i] = bSerialNum[i];

	acutPrintf(TEXT("serial number: %s\n"), aSerialNum);
	acutPrintf(TEXT("completed!\n"));

	acutPrintf(TEXT("Testing LC_passwd..."));
	iRet = LC_passwd( iHandle, 0, (unsigned char *)"12345678" );
	if ( LC_SUCCESS != iRet )
	{
		acutPrintf(TEXT("verify admin password failed, error code = %d\n"), iRet);
		return;
	}

	iRet = LC_passwd( iHandle, 1, (unsigned char *)"12345678" );
	if ( LC_SUCCESS != iRet )
	{
		acutPrintf(TEXT("verify user password failed, error code = %d\n"), iRet);
		return;
	}

	iRet = LC_passwd( iHandle, 2, (unsigned char *)"12345678" );
	if ( LC_SUCCESS != iRet )
	{
		acutPrintf(TEXT("verify authentication password failed, error code = %d\n"), iRet);
		return;
	}
	acutPrintf(TEXT("completed!\n"));

	unsigned char bucWriData[1921];
	unsigned char bucReaData[1921];

	memset( bucWriData, 0x00, sizeof(bucWriData) );
	memset( bucReaData, 0x00, sizeof(bucReaData) );

	for( iLoop = 0; iLoop < sizeof(bucWriData); iLoop++ )
	{
		bucWriData[iLoop] = (unsigned char)iLoop;
	}

	acutPrintf(TEXT("Testing LC_write..."));
	iRet = LC_write( iHandle, 0, bucWriData );
	if ( LC_SUCCESS != iRet )
	{
		acutPrintf(TEXT("write 0 block failed, error code = %d\n"), iRet);
		return;
	}

	iRet = LC_write( iHandle, 1, bucWriData+512 );
	if ( LC_SUCCESS != iRet )
	{
		acutPrintf(TEXT("write 1 block failed, error code = %d\n"), iRet);
		return;
	}

	iRet = LC_write( iHandle, 2, bucWriData+1024 );
	if ( LC_SUCCESS != iRet )
	{
		acutPrintf(TEXT("write 2 block failed, error code = %d\n"), iRet);
		return;
	}

	iRet = LC_write( iHandle, 3, bucWriData+1536 );
	if ( LC_SUCCESS != iRet )
	{
		acutPrintf(TEXT("write 3 block failed, error code = %d\n"), iRet);
		return;
	}
	acutPrintf(TEXT("completed!\n"));

	acutPrintf(TEXT("Testing LC_read..."));
	iRet = LC_read( iHandle, 0, bucReaData );
	if ( LC_SUCCESS != iRet )
	{
		acutPrintf(TEXT("read 0 block failed, error code = %d\n"), iRet);
		return;
	}

	if ( 0 != memcmp( bucWriData, bucReaData, 512 ) )
	{
		acutPrintf(TEXT("read 0 block data error\n"));
		return;
	}

	iRet = LC_read( iHandle, 1, bucReaData+512 );
	if ( LC_SUCCESS != iRet )
	{
		acutPrintf(TEXT("read 1 block failed, error code = %d\n"), iRet);
		return;
	}
	
	if ( 0 != memcmp( bucWriData+512, bucReaData+512, 512 ) )
	{
		acutPrintf(TEXT("read 1 block data error\n"));
		return;
	}

	iRet = LC_read( iHandle, 2, bucReaData+1024 );
	if ( LC_SUCCESS != iRet )
	{
		acutPrintf(TEXT("read 2 block failed, error code = %d\n"), iRet);
		return;
	}
	
	if ( 0 != memcmp( bucWriData+1024, bucReaData+1024, 512 ) )
	{
		acutPrintf(TEXT("read 2 block data error\n"));
		return;
	}

	iRet = LC_read( iHandle, 3, bucReaData+1536 );
	if ( LC_SUCCESS != iRet )
	{
		acutPrintf(TEXT("read 3 block failed, error code = %d\n"), iRet);
		return;
	}
	
	if ( 0 != memcmp( bucWriData+1536, bucReaData+1536, 384 ) )
	{
		acutPrintf(TEXT("read 3 block data error\n"));
		return;
	}
	acutPrintf(TEXT("completed!\n"));

	unsigned char bEncData[16];
	unsigned char bDecData[16];
	unsigned char bSourceData[16];

	memset( bEncData, 0x00, sizeof(bEncData) );
	memset( bDecData, 0x00, sizeof(bDecData) );
	memset( bSourceData, 0x00, sizeof(bSourceData) );

	for( iLoop = 0; iLoop<sizeof(bSourceData); iLoop++ )
	{
		bSourceData[iLoop] = iLoop;
	}

	acutPrintf(TEXT("Testing LC_encrypt..."));
	iRet = LC_encrypt( iHandle, bSourceData, bEncData );
	if ( LC_SUCCESS != iRet )
	{
		acutPrintf(TEXT("encrypt data failed, error code = %d\n"), iRet);
		return;
	}
	acutPrintf(TEXT("completed!\n"));

	acutPrintf(TEXT("Testing LC_decrypt..."));
	iRet = LC_decrypt( iHandle, bEncData, bDecData );
	if ( LC_SUCCESS != iRet )
	{
		acutPrintf(TEXT("decrypt data failed, error code = %d\n"), iRet);
		return;
	}
	acutPrintf(TEXT("completed!\n"));

	unsigned char bKey[20];

	for( iLoop=0; iLoop<20; iLoop++ )
	{
		bKey[iLoop] = iLoop;
	}

	acutPrintf(TEXT("Testing LC_set_key..."));
	iRet = LC_set_key( iHandle, 0, bKey );
	if ( LC_SUCCESS != iRet )
	{
		acutPrintf(TEXT(" set updata key failed, error code = %d\n"), iRet);
		return;
	}

	iRet = LC_set_key( iHandle, 1, bKey );
	if ( LC_SUCCESS != iRet )
	{
		acutPrintf(TEXT(" set verify key failed, error code = %d\n"), iRet);
		return;
	}
	acutPrintf(TEXT("completed!\n"));


	unsigned char bSourcePkg[512];
	unsigned char bPkg1[550];
	unsigned char bPkg2[550];
	unsigned char bPkg3[550];

	memset( bSourcePkg, 0x00, sizeof(bSourcePkg) );
	memset( bPkg1, 0x00, sizeof(bPkg1) );
	memset( bPkg2, 0x00, sizeof(bPkg2) );
	memset( bPkg3, 0x00, sizeof(bPkg3) );

	for( iLoop=0; iLoop<sizeof(bSourcePkg); iLoop++ )
	{
		bSourcePkg[iLoop] = (unsigned char)iLoop;
	}

	acutPrintf(TEXT("Testing LC_gen_update_pkg..."));
	iRet = LC_gen_update_pkg( (unsigned char *)bSerialNum, 1, bSourcePkg, bKey, bPkg1 );
	if ( LC_SUCCESS != iRet )
	{
		acutPrintf(TEXT("gen 1 block pkg failed, error code= %d\n"), iRet);
		return;
	}

	iRet = LC_gen_update_pkg( (unsigned char *)bSerialNum, 2, bSourcePkg, bKey, bPkg2 );
	if ( LC_SUCCESS != iRet )
	{
		acutPrintf(TEXT("gen 2 block pkg failed, error code= %d\n"), iRet);
		return;
	}

	iRet = LC_gen_update_pkg( (unsigned char *)bSerialNum, 3, bSourcePkg, bKey, bPkg3 );
	if ( LC_SUCCESS != iRet )
	{
		acutPrintf(TEXT("gen 3 block pkg failed, error code= %d\n"), iRet);
		return;
	}
	acutPrintf(TEXT("completed!\n"));

	acutPrintf(TEXT("Testing LC_update..."));
	iRet = LC_update( iHandle, bPkg1 );
	if ( LC_SUCCESS != iRet )
	{
		acutPrintf(TEXT("update 1 block failed, error code= %d\n"), iRet);
		return;
	}

	iRet = LC_update( iHandle, bPkg2 );
	if ( LC_SUCCESS != iRet )
	{
		acutPrintf(TEXT("update 2 block failed, error code= %d\n"), iRet);
		return;
	}

	iRet = LC_update( iHandle, bPkg3 );
	if ( LC_SUCCESS != iRet )
	{
		acutPrintf(TEXT("update 3 block failed, error code= %d\n"), iRet);
		return;
	}
	acutPrintf(TEXT("completed!\n"));

	acutPrintf(TEXT("Testing LC_set_passwd..."));
	iRet = LC_set_passwd( iHandle, 0, (unsigned char *)"11111111", -1 );
	if ( LC_SUCCESS !=iRet )
	{
		acutPrintf(TEXT("set admin password failed, error code= %d\n"), iRet);
		return;
	}

	iRet = LC_set_passwd( iHandle, 1, (unsigned char *)"11111111", -1 );
	if ( LC_SUCCESS !=iRet )
	{
		acutPrintf(TEXT("set user password failed, error code= %d\n"), iRet);
		return;
	}

	iRet = LC_set_passwd( iHandle, 0, (unsigned char *)"11111111", -1 );
	if ( LC_SUCCESS !=iRet )
	{
		acutPrintf(TEXT("set authentication password failed, error code= %d\n"), iRet);
		return;
	}
	acutPrintf(TEXT("completed!\n"));

	acutPrintf(TEXT("Testing LC_change_passwd..."));
	iRet = LC_change_passwd( iHandle, 2, (unsigned char *)"12345678", 
		                      (unsigned char *)"11111111" );
	if ( LC_SUCCESS != iRet )
	{
		acutPrintf(TEXT("change authentication password failed, error code= %d\n"), iRet);
		return;
	}
	acutPrintf(TEXT("completed!\n"));

	iRet = LC_set_passwd( iHandle, 0, (unsigned char *)"12345678", -1 );
	iRet = LC_set_passwd( iHandle, 1, (unsigned char *)"12345678", -1 );
	iRet = LC_set_passwd( iHandle, 2, (unsigned char *)"12345678", -1 );

	//Close
	acutPrintf(TEXT("Testing LC_close..."));
	iRet = LC_close( iHandle );
	if ( LC_SUCCESS != iRet )
	{
		acutPrintf(TEXT("close failed, error code= %d\n"), iRet);
		return;
	}
	acutPrintf(TEXT("completed!\n"));

	acutPrintf(TEXT("Test finished!.....\n"));
}
//////////////////////////////////////////////////////////////////////////////

// CTest.cpp : Defines the entry point for the console application.
//

#include "Sense_LC.h"
#include <stdio.h>
#include <windows.h>
#include <time.h>

int main(int argc, char* argv[])
{
	int		iDevNumber = 0;
	int		iDeviceNum = 0;
	lc_handle_t		iHandle    = 0;
	int		iRetValue  = 0;
	int		iX = 0;
	
	char	lpErrMessage[MAX_PATH];

	BYTE	bVerifyKey[21];
	BYTE	bUpdateKey[21];

	BYTE	bUpdateData[512];
	BYTE	bPkg1[550];
	BYTE	bPkg2[550];
	BYTE	bPkg3[550];
	
	LC_hardware_info	info = {0};
	BYTE	*bSerialNum = (BYTE*)"00005021"; // Device Serial Number

	//Set Authentication Password
	memset( bVerifyKey, 0x00, sizeof(bVerifyKey) );
	for(iX = 0; iX < sizeof(bVerifyKey) - 1; iX++ )
	{
		bVerifyKey[iX] = iX;
	}

	//Set Update Key
	memset( bUpdateKey, 0x00, sizeof(bUpdateKey) );
	for( iX = 0; iX < sizeof(bUpdateKey) - 1; iX++ )
	{
		bUpdateKey[iX] = iX;
	}

	//Initiate data
	memset( bUpdateData, 0x00, sizeof(bUpdateData) );
	*(int *)bUpdateData = time(NULL);
	for( iX = 4; iX < sizeof(bUpdateData); iX++ )
	{
		bUpdateData[iX] = iX;
	}

	memset( bPkg1, 0x00, sizeof(bPkg1) );
	memset( bPkg2, 0x00, sizeof(bPkg2) );
	memset( bPkg3, 0x00, sizeof(bPkg3) );

	//Open dongle
	iRetValue = LC_open( iDevNumber, iDeviceNum, &iHandle );
	if( LC_SUCCESS != iRetValue )
	{
		sprintf( lpErrMessage, "Open failed, error code = 0x%08lx\n", iRetValue );
		printf( lpErrMessage );
		getchar();
		return 0;
	}

	//Verify Admin Password
	iRetValue = LC_passwd( iHandle, 0, (BYTE *)"12345678" );
	if( LC_SUCCESS != iRetValue )
	{
		sprintf( lpErrMessage, "Passwd failed, error code = 0x%08lx\n", iRetValue );
		printf( lpErrMessage );
		getchar();
		return 0;
	}	
	
	iRetValue = LC_set_key( iHandle, 1, bVerifyKey );
	if( LC_SUCCESS != iRetValue )
	{
		sprintf( lpErrMessage, "set verify key failed, error code = 0x%08lx\n", iRetValue );
		printf( lpErrMessage );
		getchar();
		return 0;
	}

	iRetValue = LC_set_key( iHandle, 0, bUpdateKey );
	if( LC_SUCCESS != iRetValue )
	{
		sprintf( lpErrMessage, "set update key failed, error code = 0x%08lx\n", iRetValue );
		printf( lpErrMessage );
		getchar();
		return 0;
	}

	iRetValue = LC_get_hardware_info(iHandle, &info);
	bSerialNum = info.serialNumber;

	iRetValue = LC_close( iHandle );
	if( LC_SUCCESS != iRetValue )
	{
		sprintf( lpErrMessage, "close failed, error code = 0x%08lx\n", iRetValue );
		printf( lpErrMessage );
		getchar();
		return 0;
	}

	//Make update package
	iRetValue = LC_gen_update_pkg( bSerialNum,
									  1, 
									  bUpdateData,
									  bUpdateKey,
									  bPkg1 );
	if( LC_SUCCESS != iRetValue )
	{
		sprintf( lpErrMessage, "makepkg1 failed, error code = 0x%08lx\n", iRetValue );
		printf( lpErrMessage );
		getchar();
		return 0;
	}

	iRetValue = LC_gen_update_pkg( bSerialNum,
									  2, 
									  bUpdateData,
									  bUpdateKey,
									  bPkg2 );
	if( LC_SUCCESS != iRetValue )
	{
		sprintf( lpErrMessage, "makepkg2 failed, error code = 0x%08lx\n", iRetValue );
		printf( lpErrMessage );
		getchar();
		return 0;
	}

	iRetValue =  LC_gen_update_pkg( bSerialNum,
									  3, 
									  bUpdateData,
									  bUpdateKey,
									  bPkg3 );
	if( LC_SUCCESS != iRetValue )
	{
		sprintf( lpErrMessage, "makepkg3 failed, error code = 0x%08lx\n", iRetValue );
		printf( lpErrMessage );
		getchar();
		return 0;
	}
	
	//Open dongle
	iRetValue = LC_open( iDevNumber, iDeviceNum, &iHandle );
	if( LC_SUCCESS != iRetValue )
	{
		sprintf( lpErrMessage, "Open failed, error code = 0x%08lx\n", iRetValue );
		printf( lpErrMessage );
		getchar();
		return 0;
	}
	
	//Verify Authentication Password
	iRetValue = LC_passwd( iHandle, 1, (BYTE *)"12345678" );
	if( LC_SUCCESS != iRetValue )
	{
		sprintf( lpErrMessage, "verifyasswd failed, error code = 0x%08lx\n", iRetValue );
		printf( lpErrMessage );
		getchar();
		return 0;
	}	
	
	//Update
	iRetValue = LC_update( iHandle, bPkg1 );
	if( LC_SUCCESS != iRetValue )
	{
		sprintf( lpErrMessage, "updatepkg1 failed, error code = 0x%08lx\n", iRetValue );
		printf( lpErrMessage );
		getchar();
		return 0;
	}

	iRetValue = LC_update( iHandle, bPkg2 );
	if( LC_SUCCESS != iRetValue )
	{
		sprintf( lpErrMessage, "updatepkg2 failed, error code = 0x%08lx\n", iRetValue );
		printf( lpErrMessage );
		getchar();
		return 0;
	}

	iRetValue = LC_update( iHandle, bPkg3 );
	if( LC_SUCCESS != iRetValue )
	{
		sprintf( lpErrMessage, "updatepkg3 failed, error code = 0x%08lx\n", iRetValue );
		printf( lpErrMessage );
		getchar();
		return 0;
	}

	iRetValue = LC_close( iHandle );
	if( LC_SUCCESS != iRetValue )
	{
		sprintf( lpErrMessage, "close failed, error code = 0x%08lx\n", iRetValue );
		printf( lpErrMessage );
		getchar();
		return 0;
	}

	printf("Completed!\n");
	getchar();
	return 0;
}

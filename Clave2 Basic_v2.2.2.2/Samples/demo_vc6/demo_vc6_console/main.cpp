/**************************************************************************
*
* filename: main.cpp
*
* briefs:  show how to using static lib in Microsoft VC6
*
**************************************************************************/
#include <windows.h>
#include <stdio.h>
#include <string.h>
#include "Sense_LC.h"
//---------------------------------------------------------------------------

char * error[] = {
	"LC_SUCCESS",
	"LC_OPEN_DEVICE_FAILED",
	"LC_FIND_DEVICE_FAILED",
	"LC_INVALID_PARAMETER",
	"LC_INVALID_BLOCK_NUMBER",
	"LC_HARDWARE_COMMUNICATE_ERROR",
	"LC_INVALID_PASSWORD",
	"LC_ACCESS_DENIED",
	"LC_ALREADY_OPENED",
	"LC_ALLOCATE_MEMORY_FAILED",
	"LC_INVALID_UPDATE_PACKAGE",
	"LC_OTHER_ERROR"
};

int main(int argc, char* argv[])
{
    lc_handle_t handle;
    int res, i;

    // getting get software info
    LC_software_info softInfo;
    res = LC_get_software_info(&softInfo);
    if(res) {
        printf("get_software_info failed\n");
		printf("ERROR CODE: %s\n",error[res]);
        getchar();
        return -1;
    }
    printf("\tsoftwre version: %d\n", softInfo.version);

    // opening LC device
    res = LC_open(0, 0, &handle);
    if(res) {
        printf("open failed\n");
		printf("ERROR CODE: %s\n",error[res]);
        getchar();
        return -1;
    }
    printf("\nopen success!\n");

    // verify normal user password
    res = LC_passwd(handle, 1, (unsigned char *) "12345678");  //"12345678" is user password
    if(res) {
        LC_close(handle);
        printf("verify password failed\n");
		printf("ERROR CODE: %s\n",error[res]);
        getchar();
        return -1;
    }
    printf("\nverify password success!\n");

    // encrypt data
    unsigned char In[] = {0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff};
    unsigned char Out[] = {0x69, 0xc4, 0xe0, 0xd8, 0x6a, 0x7b, 0x04, 0x30, 0xd8, 0xcd, 0xb7, 0x80, 0x70, 0xb4, 0xc5, 0x5a};
    unsigned char tmp[16];
    res = LC_encrypt(handle, In,  tmp);
    if(res){
		LC_close(handle);
		printf("encrypt failed\n");
		printf("ERROR CODE: %s\n",error[res]);
		getchar();
		return -1;
	}
    printf("\nencrypt OK!\n");

    // decrypt data
    res = LC_decrypt(handle, Out,  tmp);
	if(res){
		LC_close(handle);
		printf("decrypt failed\n");
		printf("ERROR CODE: %s\n",error[res]);
		getchar();
		return -1;
	}
    printf("\ndecrypt OK!\n");

    // write block 0 (R/W block)
    unsigned char data[512] = "Hello World!Hello World!Hello World!Hello World!Hello World! \
		Hello World!Hello World!Hello World!Hello World!Hello World!Hello World!Hello World! \
		Hello World!Hello World!Hello World!Hello World!Hello World!Hello World!Hello World!";
    unsigned char outdata[512];

    res = LC_write(handle, 0, data);
    if(res) {
        LC_close(handle);
        printf("write failed\n");
		printf("ERROR CODE: %s\n",error[res]);
        getchar();
        return -1;
    }
    printf("\nwrite success!\n");

    // read back the data just writed into block 0
    res = LC_read(handle, 0, outdata);
    if(res || memcmp(data, outdata, 512)) {
        LC_close(handle);
        printf("read failed\n");
		printf("ERROR CODE: %s\n",error[res]);
        getchar();
        return -1;
    }
    printf("\nread success!\n");

    // get hardware info
    LC_hardware_info info;
    res = LC_get_hardware_info(handle, &info);
    if(res) {
        LC_close(handle);
        printf("get info failed\n");
		printf("ERROR CODE: %s\n",error[res]);
        getchar();
        return -1;
    }
    printf("\nget info success!\n");
    printf("\tdeveloperNumber: %d\n", info.developerNumber);
    printf("\tserial number:");
    for(i = 0;i<8;i++)
        printf("%i ", info.serialNumber[i]);
    printf("\n\tsetDate: %d\n", info.setDate);

    // authorize
    printf("\nverify authorize user password:\t");
    res = LC_passwd(handle, 2, (unsigned char *) "12345678");
    if(res) {
        LC_close(handle);
        printf("verify authorize user password failed\n");
		printf("ERROR CODE: %s\n",error[res]);
        getchar();
        return -1;
    }
    printf("verify authorize user password success!\n");

    unsigned char key[20] = {0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, \
    0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b}; // this should be the hmac key in your LC device

    unsigned char text[] = "Hi LC Hi LC Hi LC Hi LC Hi LC Hi LC Hi LC Hi LC Hi LC Hi LC";
    unsigned char digest_local[20];
    unsigned char digest_device[20];
    printf("get digest from device:\t");
    res = LC_hmac(handle, text, strlen((char *) text) , digest_device);
    if(res) {
        LC_close(handle);
        printf("hmac_sha1 in device failed\n");
		printf("ERROR CODE: %s\n",error[res]);
        getchar();
        return -1;
    }
    printf("success!\n");

    printf("get digest locally:\t");
    res = LC_hmac_software(text,  strlen((char *) text) , key, digest_local);
    if(res) {
        LC_close(handle);
        printf("hmac_sha1 local failed\n");
		printf("ERROR CODE: %s\n",error[res]);
        getchar();
        return -1;
    }
    printf("success!\n");

    printf("compare the two digest:\t");
    for(i = 0; i < 20; i++) {
        if(digest_local[i] != digest_device[i]) {
            LC_close(handle);
            printf("not equal\n");
            getchar();
            return -1;
        }
    }
    printf("OK\n");
    
    printf("authoriz success!\n");

    // change authorize user's password
    res = LC_change_passwd(handle, 2, (unsigned char *) "12345678", (unsigned char *) "55555555");
    if(res) {
        LC_close(handle);
        printf("change authorize user's password failed\n");
		printf("ERROR CODE: %s\n",error[res]);
		getchar();
        return -1;
    }
    printf("\nchange authorize user's password success!\n");

    printf("change password back:\t");    
    res = LC_change_passwd(handle, 2, (unsigned char *) "55555555", (unsigned char *) "12345678");
    if(res) {
        printf("failed\n");
        printf("ERROR CODE: %s\n",error[res]);
    }
	printf("OK\n");

    // reset password
    printf("\nverify Admin password: "); // only developer can reset the passwd
    res = LC_passwd(handle, 0, (unsigned char *) "12345678");
    if(res) {
        LC_close(handle);
        printf("failed\n");
		printf("ERROR CODE: %s\n",error[res]);
        getchar();
        return -1;
    }
    printf("success!\n");

    printf("reset normal user password to \"99999999\":\t");
    res = LC_set_passwd(handle, 1, (unsigned char *) "99999999", -1);
    if(res) {
        LC_close(handle);
        printf("failed\n");
		printf("ERROR CODE: %s\n",error[res]);
        getchar();
        return -1;
    }
    printf("success!\n");

    printf("verify normal user password with new password:\t");
	res = LC_passwd(handle, 1, (unsigned char *) "99999999");
    if(res) {
        printf("failed\n");
        printf("ERROR CODE: %s\n",error[res]);
    }
    printf("OK\n");

    printf("set back:\t");
    res = LC_set_passwd(handle, 1, (unsigned char *) "12345678", -1);
    if(res) {
        LC_close(handle);
        printf("failed\n");
        printf("ERROR CODE: %s\n",error[res]);
        getchar();
        return -1;
    }
    printf("success!\n");

    res = LC_close(handle);
    if(res) {
        LC_close(handle);
        printf("close failed\n");
		printf("ERROR CODE: %s\n",error[res]);
        getchar();
        return -1;
    }
    printf("\nclose success!\n");
    getchar();
    return 0;
}
//---------------------------------------------------------------------------

using System;
using System.Collections.Generic;
using System.Text;

using System.Runtime.InteropServices;
using System.Diagnostics;
using System.IO;
using lc_handle_t=System.UInt32;

namespace demo_csharp
{
    class lcDemo
    {
        // Error Code
        static public uint LC_SUCCESS = 0;  // Successful
        static public uint LC_OPEN_DEVICE_FAILED = 1;  // Open device failed
        static public uint LC_FIND_DEVICE_FAILED = 2;  // No matching device was found
        static public uint LC_INVALID_PARAMETER = 3;  // Parameter Error
        static public uint LC_INVALID_BLOCK_NUMBER = 4;  // Block Error
        static public uint LC_HARDWARE_COMMUNICATE_ERROR = 5;  // Communication error with hardware
        static public uint LC_INVALID_PASSWORD = 6;  // Invalid Password
        static public uint LC_ACCESS_DENIED = 7;  // No privileges
        static public uint LC_ALREADY_OPENED = 8;  // Device is open
        static public uint LC_ALLOCATE_MEMORY_FAILED = 9;  // Allocate memory failed
        static public uint LC_INVALID_UPDATE_PACKAGE = 10; // Invalid update package
        static public uint LC_SYN_ERROR = 11; // thread Synchronization error
        static public uint LC_OTHER_ERROR = 12;// Other unknown exceptions

        
        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Auto)]
        // Hardware information structure
        public struct LC_hardware_info
        {
            public int developerNumber;             // Developer ID
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 8)]
            public byte[] serialNumber;             // Unique Device Serial Number
            public int setDate;                     // Manufacturing date
            public int reservation;                // Reserve
        }

        // Software information structure
        public struct LC_software_info
        {
            public int version;        // Software edition
            public int reservation;    // Reserve
        }

        // LC API function interface

        [DllImport(@"..\..\Sense_LC.dll")]
        private static extern int LC_open(int vendor, int index, ref lc_handle_t handle);
        [DllImport(@"..\..\Sense_LC.dll")]
        private static extern int LC_close(lc_handle_t handle);
        [DllImport(@"..\..\Sense_LC.dll")]
        private static extern int LC_passwd(lc_handle_t handle, int type, byte[] passwd);
        [DllImport(@"..\..\Sense_LC.dll")]
        private static extern int LC_read(lc_handle_t handle, int block, byte[] buffer);
        [DllImport(@"..\..\Sense_LC.dll")]
        private static extern int LC_write(lc_handle_t handle, int block, byte[] buffer);
        [DllImport(@"..\..\Sense_LC.dll")]
        private static extern int LC_encrypt(lc_handle_t handle, byte[] plaintext, byte[] ciphertext);
        [DllImport(@"..\..\Sense_LC.dll")]
        private static extern int LC_decrypt(lc_handle_t handle, byte[] ciphertext, byte[] plaintext);
        [DllImport(@"..\..\Sense_LC.dll")]
        private static extern int LC_set_passwd(lc_handle_t handle, int type, byte[] newpasswd, int retries);
        [DllImport(@"..\..\Sense_LC.dll")]
        private static extern int LC_change_passwd(lc_handle_t handle, int type, byte[] oldpasswd, byte[] newpasswd);
        [DllImport(@"..\..\Sense_LC.dll")]
        private static extern int LC_get_hardware_info(lc_handle_t handle, ref LC_hardware_info info);
        [DllImport(@"..\..\Sense_LC.dll")]
        private static extern int LC_get_software_info(ref LC_software_info info);
        [DllImport(@"..\..\Sense_LC.dll")]
        private static extern int LC_hmac(lc_handle_t handle, byte[] text, int textlen, byte[] digest);
        [DllImport(@"..\..\Sense_LC.dll")]
        private static extern int LC_hmac_software(byte[] text, int textlen, byte[] key, byte[] digest);
        [DllImport(@"..\..\Sense_LC.dll")]
        private static extern int LC_update(lc_handle_t handle, byte[] buffer);

        static void Main(string[] args)
        {
            lc_handle_t handle = 0;
            int res;

            // open device
            res = LC_open(0, 0, ref handle);
            if (res != LC_SUCCESS)
            {
                Console.WriteLine("open failed!");
                Console.WriteLine("ERROR CODE:{0}", res);
                Console.ReadLine();
                return;
            }
            Console.WriteLine("open succeed!");

            // get hardware info
            LC_hardware_info info = new LC_hardware_info();

            res = LC_get_hardware_info(handle, ref info);
            if (res != LC_SUCCESS)
            {
                Console.WriteLine("get hardware info failed!");
                Console.WriteLine("ERROR CODE:{0}", res);
                Console.ReadLine();
                LC_close(handle);
                return;
            }
            Console.WriteLine("get hardware info succeed!");
            Console.WriteLine("\tdeveloper number:0x{0:x8}", info.developerNumber);
            Console.WriteLine("\tserial number:{0}", System.Text.Encoding.Default.GetString(info.serialNumber));

            // verify user password
            byte[] passwd = { (byte)'1', (byte)'2', (byte)'3', (byte)'4', (byte)'5', (byte)'6', (byte)'7', (byte)'8' };
            res = LC_passwd(handle, 1, passwd);
            if (res != LC_SUCCESS)
            {
                Console.WriteLine("verify user password failed!");
                Console.WriteLine("ERROR CODE:{0}", res);
                Console.ReadLine();
                LC_close(handle);
                return;
            }
            Console.WriteLine("verify user password succeed!");

            // encrypt data
            byte[] In = { 0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff };
            byte[] Out = new byte[16];
            byte[] tmp = new byte[16];

            res = LC_encrypt(handle, In, Out);
            if (res != LC_SUCCESS)
            {
                Console.WriteLine("encrypt data failed!");
                Console.WriteLine("ERROR CODE:{0}", res);
                Console.ReadLine();
                LC_close(handle);
                return;
            }
            Console.WriteLine("encrypt data succeed!");

            // decrypt data
            res = LC_decrypt(handle, Out, tmp);
            if (res != LC_SUCCESS)
            {
                Console.WriteLine("decrypt data failed!");
                Console.WriteLine("ERROR CODE:{0}", res);
                Console.ReadLine();
                LC_close(handle);
                return;
            }
            Console.WriteLine("decrypt data succeed!");

            // Write Block 0
            byte[] data = System.Text.Encoding.Default.GetBytes("Hello World!Hello World!Hello World!Hello World!Hello World!Hello World!Hello World!Hello World!Hello World!Hello World!Hello World!Hello World!Hello World!Hello World!Hello World!Hello World!Hello World!Hello World!Hello World!Hello World!");

            res = LC_write(handle, 0, data);
            if (res != LC_SUCCESS)
            {
                Console.WriteLine("write block 0 failed!");
                Console.WriteLine("ERROR CODE:{0}", res);
                Console.ReadLine();
                LC_close(handle);
                return;
            }
            Console.WriteLine("write block 0 succeed!");

            // Read Block 0
            byte[] outdata = new byte[512]; // at least 512 bytes

            res = LC_read(handle, 0, outdata);
            if (res != LC_SUCCESS)
            {
                Console.WriteLine("read block 0 failed!");
                Console.WriteLine("ERROR CODE:{0}", res);
                Console.ReadLine();
                LC_close(handle);
                return;
            }
            Console.WriteLine("read block 0 succeed!");

            // Authentication
            // Verify Admin Password.
            byte[] authPwd = System.Text.Encoding.Default.GetBytes("12345678");
            res = LC_passwd(handle, 2, authPwd);
            if (res != LC_SUCCESS)
            {
                Console.WriteLine("verify authentication password failed!");
                Console.WriteLine("ERROR CODE:{0}", res);
                Console.ReadLine();
                LC_close(handle);
                return;
            }
            Console.WriteLine("verify authentication password succeed!");

            // auth key in the dongle(This is the default value)
            byte[] key = { 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b };

            byte[] text = System.Text.Encoding.Default.GetBytes("Hi LC Hi LC Hi LC Hi LC Hi LC Hi LC Hi LC Hi LC Hi LC Hi LC");
            byte[] digest_local = new byte[20];
            byte[] digest_device = new byte[20];

            // get digest from device
            res = LC_hmac(handle, text, text.Length, digest_device);
            if (res != LC_SUCCESS)
            {
                Console.WriteLine("get digest from device failed!");
                Console.WriteLine("ERROR CODE:{0}", res);
                Console.ReadLine();
                LC_close(handle);
                return;
            }
            Console.WriteLine("get digest from device succeed!");

            // get digest locally
            res = LC_hmac_software(text, text.Length, key, digest_local);
            if (res != LC_SUCCESS)
            {
                Console.WriteLine("get digest locally failed!");
                Console.WriteLine("ERROR CODE:{0}", res);
                Console.ReadLine();
                LC_close(handle);
                return;
            }
            Console.WriteLine("get digest locally succeed!");

            // compare the two digest
            int i;
            for (i = 0; i < 20; i++)
            {
                if (digest_local[i] != digest_device[i])
                {
                    Console.WriteLine("the two digest are not equal!auth failed!");
                    Console.ReadLine();
                    LC_close(handle);
                    return;
                }
            }
            Console.WriteLine("auth succeed!");

            // change authentication password
            res = LC_change_passwd(handle, 2, System.Text.Encoding.Default.GetBytes("12345678"), System.Text.Encoding.Default.GetBytes("55555555"));
            if (res != LC_SUCCESS)
            {
                Console.WriteLine("change authentication password failed!");
                Console.WriteLine("ERROR CODE:{0}", res);
                Console.ReadLine();
                LC_close(handle);
                return;
            }
            Console.WriteLine("change authentication password succeed!");

            // reset password

            //verify Admin password
            res = LC_passwd(handle, 0, System.Text.Encoding.Default.GetBytes("12345678"));
            if (res != LC_SUCCESS)
            {
                Console.WriteLine("verify Admin password failed!");
                Console.WriteLine("ERROR CODE:{0}", res);
                Console.ReadLine();
                LC_close(handle);
                return;
            }
            Console.WriteLine("verify Admin password succeed!");

            // reset Admin password
            res = LC_set_passwd(handle, 0, System.Text.Encoding.Default.GetBytes("12345678"), -1);
            if (res != LC_SUCCESS)
            {
                Console.WriteLine("reset Admin password failed!");
                Console.WriteLine("ERROR CODE:{0}", res);
                Console.ReadLine();
                LC_close(handle);
                return;
            }
            Console.WriteLine("reset Admin password succeed!");

            // reset user password
            res = LC_set_passwd(handle, 1, System.Text.Encoding.Default.GetBytes("12345678"), -1);
            if (res != LC_SUCCESS)
            {
                Console.WriteLine("reset user password failed!");
                Console.WriteLine("ERROR CODE:{0}", res);
                Console.ReadLine();
                LC_close(handle);
                return;
            }
            Console.WriteLine("reset user password succeed!");

            // reset authentication password
            res = LC_set_passwd(handle, 2, System.Text.Encoding.Default.GetBytes("12345678"), -1);
            if (res != LC_SUCCESS)
            {
                Console.WriteLine("reset authentication password failed!");
                Console.WriteLine("ERROR CODE:{0}", res);
                Console.ReadLine();
                LC_close(handle);
                return;
            }
            Console.WriteLine("reset authentication password succeed!");

            // close device
            res = LC_close(handle);
            if (res != LC_SUCCESS)
            {
                Console.WriteLine("close device failed!");
                Console.WriteLine("ERROR CODE:{0}", res);
                Console.ReadLine();
                LC_close(handle);
                return;
            }
            Console.WriteLine("close device succeed!");

            Console.ReadLine();

        }
    }
}

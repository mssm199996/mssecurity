
class lc_java
{
	public static void main(String args[]) 
	{
		lc_java lc = new lc_java();
		int res;
		int[] handle = new int[1];
		LC_software_info sinfo = lc.new LC_software_info();
		LC_hardware_info hinfo = lc.new LC_hardware_info();

		// Retrieve the software information
		res = lc.LC_get_software_info(sinfo);
		if (res != lc_java.LC_SUCCESS) {
			System.out.print("Retrieve the software information failed. Error Code:" + res);
			return;
		}
		System.out.println("Retrieve the software information succeded. software version : " + sinfo.version);

		// Open device
		res = lc.LC_open(1633837924, 0, handle); // Demo dongle
		if (res != lc_java.LC_SUCCESS) {
			System.out.print("Open deveice failed. Error Code:" + res);
			return;
		}
		System.out.println("Open device succeded");
		
		// Retrieve the hardware information
		res = lc.LC_get_hardware_info(handle[0],hinfo);
		if (res != lc_java.LC_SUCCESS) {
			System.out.print("Retrieve the hardware information failed. Error Code:" + res);
			return;
		}
		System.out.println("Retrieve the hardware information succeded");
		// you can check the information here
		
		// Verify User Password.
		res = lc.LC_passwd(handle[0], 1, ((String)"12345678").getBytes());
		if (res != lc_java.LC_SUCCESS) {
			System.out.print("Verify User Password failed. Error Code:" + res);
			return;
		}
		System.out.println("Verify User Password succeded");
		
		// Encrypte data
		byte[] plaintext = {0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 
				(byte)0x88, (byte)0x99, (byte)0xaa, (byte)0xbb, (byte)0xcc, 
				(byte)0xdd, (byte)0xee, (byte)0xff};
		byte[] ciphertext = new byte[16];
		res = lc.LC_encrypt(handle[0], plaintext, ciphertext);
		if (res != lc_java.LC_SUCCESS) {
			System.out.print("Encrypte data failed. Error Code:" + res);
			return;
		}
		System.out.println("Encrypted data succeded");
		
		// Decrypte data
		res = lc.LC_decrypt(handle[0], ciphertext, plaintext);
		if (res != lc_java.LC_SUCCESS) {
			System.out.print("Decrypte data failed. Error Code:" + res);
			return;
		}
		System.out.println("Decrypte data succeded ");
		
		// Write Block 0
		byte[] indata = new byte[512];
		byte[] tmpbuf = ((String)"Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World!").getBytes();
		int tmplen = tmpbuf.length;
		for (int i = 0; i <tmplen; i++) {
			indata[i] = tmpbuf[i];
		}
		
		res = lc.LC_write(handle[0], 0, indata);
		if (res != lc_java.LC_SUCCESS) {
			System.out.print("Write Block 0 failed. Error Code:" + res);
			return;
		}
		System.out.println("Write Block 0 succeded ");
		
		// Read Block 0
		byte[] outdata = new byte[512];
		
		res = lc.LC_read(handle[0], 0, outdata);
		if (res != lc_java.LC_SUCCESS) {
			System.out.print("Read Block 0 failed. Error Code:" + res);
			return;
		}
		System.out.println("Read Block 0 succeded ");	
		
		// Verify Admin Password.
		res = lc.LC_passwd(handle[0], 0, ((String)"12345678").getBytes());
		if (res != lc_java.LC_SUCCESS) {
			System.out.print("Verify Admin Password failed. Error Code:" + res);
			return;
		}
		System.out.println("Verify Administration Password succed");
		
		 // Reset User Password
		res = lc.LC_set_passwd(handle[0], 1, ((String)"12345678").getBytes(), -1);
		if (res != lc_java.LC_SUCCESS) {
			System.out.print("Reset User Password failed. Error Code:" + res);
			return;
		}
		System.out.println("Reset User Password succeded.");
		
		// Close device 
		res = lc.LC_close(handle[0]);
		if (res != lc_java.LC_SUCCESS) {
			System.out.print("Close device failed. Error Code:" + res);
			return;
		}
		System.out.println("Close deveice succeded");
	}
	
	public static int LC_SUCCESS = 0; // Successful
	public static int LC_OPEN_DEVICE_FAILED = 1; // Open device failed
	public static int LC_FIND_DEVICE_FAILED = 2; // No matching device was found
	public static int LC_INVALID_PARAMETER = 3; // Parameter Error
	public static int LC_INVALID_BLOCK_NUMBER = 4; // Block Error
	public static int LC_HARDWARE_COMMUNICATE_ERROR = 5; // Communication error with hardware
	public static int LC_INVALID_PASSWORD = 6; // Invalid Password
	public static int LC_ACCESS_DENIED = 7; // No privileges
	public static int LC_ALREADY_OPENED = 8; // Device is open
	public static int LC_ALLOCATE_MEMORY_FAILED = 9; // Allocate memory failed
	public static int LC_INVALID_UPDATE_PACKAGE = 10; // Invalid update package
	public static int LC_SYN_ERROR = 11; // thread Synchronization error
	public static int LC_OTHER_ERROR = 12; // Other unknown exceptions
	
   public class LC_software_info
    {
        public int version;
        public int reservation;
    }

    public class LC_hardware_info
    {
			public int developerNumber;
			public byte[] serialNumber;
			public int setDate;
			public int reservation;
			LC_hardware_info()
			{
			    serialNumber = new byte[8];
			}
    }

    public native int LC_open(int vendor, int index, int[] handle);
    public native int LC_close(int handle);
    public native int LC_passwd(int handle, int type, byte[] passwd);
    public native int LC_read(int handle, int block, byte[] buffer);
    public native int LC_write(int handle, int block, byte[] buffer);
    public native int LC_encrypt(int handle, byte[] plaintext,  byte[] ciphertext);
    public native int LC_decrypt(int handle, byte[] ciphertext, byte[] plaintext);
    public native int LC_set_passwd(int handle, int type, byte[] newpasswd, int retries);
    public native int LC_change_passwd(int handle, int type, byte[] oldpasswd, byte[] newpasswd);
    public native int LC_get_hardware_info(int handle, LC_hardware_info info);
    public native int LC_get_software_info(LC_software_info info);
    public native int LC_update(int handle, byte[] buffer);
	public native int LC_set_key(int handle, int type, byte[] key);
	public native int LC_gen_update_pkg(byte[] serial, int block, byte[] buffer, byte[] key, byte[] uptPkg);


    public lc_java() { }

    static
    {
        try
        {
        	System.loadLibrary("lc_java");
        }
        catch (UnsatisfiedLinkError e)
		{
		    System.err.println("Cannot find library lc_java.dll");
		    e.printStackTrace();
	    }
	  }
}
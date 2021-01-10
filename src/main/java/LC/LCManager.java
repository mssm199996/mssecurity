package LC;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;

import com.sun.jna.Library;
import com.sun.jna.Native;
import com.sun.jna.Pointer;
import com.sun.jna.Structure;

public interface LCManager extends Library {

	public static class LC_hardware_info extends Structure {
		public static class ByReference extends LC_hardware_info implements Structure.ByReference {
		}

		public static class ByValue extends LC_hardware_info implements Structure.ByValue {
		}

		public int developerNumber;
		public byte[] serialNumber = new byte[8];
		public int setDate;

		@Override
		protected List<String> getFieldOrder() {
			return Arrays.asList("developerNumber", "serialNumber", "setDate");
		}
	}

	int LC_open(int vendorId, int index, LCHandlerPointer handler);

	int LC_close(Pointer handle);

	int LC_passwd(Pointer handle, int type, byte[] passwd);

	int LC_read(Pointer handler, int block, byte[] buffer);

	int LC_get_hardware_info(Pointer handler, LC_hardware_info.ByReference lC_hardware_info);

	public static LCManager init() {
		String libraryPath = "";

		if (LCManager.isOperatingSystemArchitecture64())
			libraryPath = "lib/LC_64.dll";
		else
			libraryPath = "lib/LC_x86.dll";

		Path path = Paths.get(libraryPath);
		
		System.out.println("Path: " + path.toAbsolutePath().toString());
		
		return (LCManager) Native.load(libraryPath, LCManager.class);
	}

	public static boolean isOperatingSystemArchitecture64() {
		boolean is64bit = false;

		if (System.getProperty("os.name").contains("Windows")) {
			is64bit = (System.getenv("ProgramFiles(x86)") != null);
		} else {
			is64bit = (System.getProperty("os.arch").indexOf("64") != -1);
		}

		return is64bit;
	}
}

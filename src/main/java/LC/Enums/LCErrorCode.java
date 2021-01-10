package LC.Enums;

public enum LCErrorCode {

	LC_SUCCESS(0),
	LC_OPEN_DEVICE_FAILED(1),
	LC_FIND_DEVICE_FAILED(2),
	LC_INVALID_PARAMETER(3),
	LC_INVALID_BLOCK_NUMBER(4),
	LC_HARDWARE_COMMUNICATE_ERROR(5),
	LC_INVALID_PASSWORD(6),
	LC_ACCESS_DENIED(7),
	LC_ALREADY_OPENED(8),
	LC_ALLOCATE_MEMORY_FAILED(9),
	LC_INVALID_UPDATE_PACKAGE(10),
	LC_SYN_ERROR(11),
	LC_OTHER_ERROR(12);
	
	private int value;
	
	LCErrorCode(int value) {
		this.value = value;
	}
	
	public int getValue() {
		return this.value;
	}
	
	public static LCErrorCode fromInt(int code) {
		return LCErrorCode.values()[code];
	}
}

package LC;

import LC.LCManager.LC_hardware_info;
import LC.Enums.LCErrorCode;
import LC.Enums.PasswordType;
import LC.Exceptions.DeviceNotOpenedException;
import LC.Exceptions.DongleOperationFailedException;
import LC.Exceptions.PasswordAuthenticationException;
import LC.Structures.HardwareInfo;

public class LCHandler {

	private LCManager lcManager;
	private LCHandlerPointer lcHandlerPointer;

	private boolean opened;
	private boolean admin;

	private int developerId;
	private int index;

	public LCHandler(LCManager lcManager, int developerId, int index) {
		this.lcManager = lcManager;
		this.developerId = developerId;
		this.lcHandlerPointer = new LCHandlerPointer();
		this.index = index;
		this.opened = false;
		this.admin = false;
	}

	public LCHandler(LCManager lcManager, int developerId) {
		this(lcManager, developerId, 0);
	}

	public LCHandler(LCManager lcManager) {
		this(lcManager, 0, 0);
	}

	public void open() throws DongleOperationFailedException {
		if (!this.opened) {
			int status = this.lcManager.LC_open(this.developerId, this.index, this.lcHandlerPointer);

			LCErrorCode errorCode = LCErrorCode.fromInt(status);

			if (errorCode == LCErrorCode.LC_SUCCESS) {
				this.opened = true;
				this.admin = false;
			} else
				throw new DongleOperationFailedException();
		}
	}

	public void close() throws DongleOperationFailedException, DeviceNotOpenedException {
		if (this.opened) {
			int status = this.lcManager.LC_close(this.lcHandlerPointer.getValue());

			LCErrorCode errorCode = LCErrorCode.fromInt(status);

			if (errorCode == LCErrorCode.LC_SUCCESS)
				this.opened = false;
			else
				throw new DongleOperationFailedException();
		} else
			throw new DeviceNotOpenedException();
	}

	public void authenticate(PasswordType passwordType, String password)
			throws PasswordAuthenticationException, DeviceNotOpenedException {
		if (this.opened) {
			byte[] buffer = password.getBytes();

			int status = this.lcManager.LC_passwd(this.lcHandlerPointer.getValue(), passwordType.getValue(), buffer);

			LCErrorCode errorCode = LCErrorCode.fromInt(status);

			if (errorCode == LCErrorCode.LC_SUCCESS) {
				if (passwordType == PasswordType.ADMIN)
					this.admin = true;
				else
					this.admin = false;
			} else
				throw new PasswordAuthenticationException();
		} else
			throw new DeviceNotOpenedException();
	}

	public byte[] read(int block, int dataSize) throws DongleOperationFailedException, DeviceNotOpenedException {
		if (this.opened) {
			byte[] buffer = new byte[512];

			int status = this.lcManager.LC_read(this.lcHandlerPointer.getValue(), block, buffer);

			LCErrorCode errorCode = LCErrorCode.fromInt(status);

			if (errorCode == LCErrorCode.LC_SUCCESS) {
				byte[] result;

				if (dataSize <= buffer.length) {
					result = new byte[dataSize];

					for (int i = 0; i < dataSize; i++)
						result[i] = buffer[i];
				} else
					result = buffer;

				return result;
			} else
				throw new DongleOperationFailedException();
		} else
			throw new DeviceNotOpenedException();
	}

	public int[] readAsInt(int block, int dataSize) throws DongleOperationFailedException, DeviceNotOpenedException {
		byte[] buffer = this.read(block, dataSize);
		int[] result = new int[buffer.length];

		for (int i = 0; i < buffer.length; i++)
			result[i] = buffer[i] & 0xFF;

		return result;
	}

	public String readAsString(int block, int dataSize)
			throws DongleOperationFailedException, DeviceNotOpenedException {
		int[] buffer = this.readAsInt(block, dataSize);
		StringBuilder stringBuilder = new StringBuilder();

		for (int i : buffer)
			stringBuilder.append(Integer.toHexString(i));

		return stringBuilder.toString().toUpperCase();
	}

	public HardwareInfo getHardwareInfo() throws DongleOperationFailedException {
		LC_hardware_info.ByReference pointer = new LC_hardware_info.ByReference();

		int status = this.lcManager.LC_get_hardware_info(this.lcHandlerPointer.getValue(), pointer);

		LCErrorCode errorCode = LCErrorCode.fromInt(status);

		if (errorCode == LCErrorCode.LC_SUCCESS) {
			HardwareInfo hardwareInfo = new HardwareInfo();
			hardwareInfo.setDeveloperNumber(pointer.developerNumber);
			hardwareInfo.setSerialNumber(this.byteArrayToString(pointer.serialNumber));
			hardwareInfo.setSetDate(pointer.setDate);

			return hardwareInfo;
		} else
			throw new DongleOperationFailedException();
	}

	private String byteArrayToString(byte[] buffer) {
		int[] intBuffer = new int[buffer.length];

		for (int i = 0; i < buffer.length; i++)
			intBuffer[i] = buffer[i] & 0xFF;

		StringBuilder stringBuilder = new StringBuilder();

		for (int i : intBuffer)
			stringBuilder.append(Integer.toHexString(i));

		return stringBuilder.toString();
	}
}

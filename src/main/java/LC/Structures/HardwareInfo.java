package LC.Structures;

public class HardwareInfo {

	private int developerNumber;
	private String serialNumber;
	private int setDate;

	public int getDeveloperNumber() {
		return developerNumber;
	}

	public void setDeveloperNumber(int developerNumber) {
		this.developerNumber = developerNumber;
	}

	public String getSerialNumber() {
		return serialNumber;
	}

	public void setSerialNumber(String serialNumber) {
		this.serialNumber = serialNumber;
	}

	public int getSetDate() {
		return setDate;
	}

	public void setSetDate(int setDate) {
		this.setDate = setDate;
	}

	@Override
	public String toString() {
		return "LC Device (" + this.developerNumber + " ; " + this.serialNumber + " ; " + this.setDate + ")";
	}
}

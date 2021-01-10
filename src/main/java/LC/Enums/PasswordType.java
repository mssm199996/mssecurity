package LC.Enums;

public enum PasswordType {

	ADMIN(0),
	GENERIC(1),
	AUTHENTICATION(2);
	
	private int value;
	
	PasswordType(int value) {
		this.value = value;
	}
	
	public int getValue() {
		return this.value;
	}
}

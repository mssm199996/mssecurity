package MainPackage;

import DomainModel.Poste;
import Exceptions.AlreadySignUpPosteAndModifiedCredentials;
import Exceptions.NoneActiveException;
import LC.Enums.PasswordType;
import LC.Exceptions.DeviceNotOpenedException;
import LC.Exceptions.DongleOperationFailedException;
import LC.Exceptions.PasswordAuthenticationException;
import LC.LCHandler;
import LC.LCManager;
import LC.Structures.HardwareInfo;
import msdatabaseutils.SessionFactoryHandler;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.util.Collection;
import java.util.HashSet;

public abstract class LCDongleCopyrightHandler extends CopyrightHandler {

	public static LCManager INSTANCE = null;

	private final int licenseCodeBlockIndex = 1;
	private final int licenseCodeDataSize = 16;

	private final int featuresBlockIndex = 2;
	private final int featuresDataSize = 512;

	private String cipheredSoftwareKey;
	private String cipheredHardwareKey;

	private int developerId;
	private int index;

	private LCHandler lcHandler;

	private HardwareInfo currentHardwareInfo;

	private String cipheredUserPassword;

	public LCDongleCopyrightHandler(SessionFactoryHandler sessionFactoryHandler, CipheringUtilities cipheringUtilities,
			String cipheredSoftwareKey, int developerId, int index, String cipheredUserPassword) {

		super(sessionFactoryHandler, cipheringUtilities);

		this.cipheredUserPassword = cipheredUserPassword;
		this.cipheredSoftwareKey = cipheredSoftwareKey;
		this.developerId = developerId;
		this.index = index;
	}

	@Override
	public void verifyCopyright() throws AlreadySignUpPosteAndModifiedCredentials, IOException, NoneActiveException,
			NoSuchAlgorithmException, DongleOperationFailedException, PasswordAuthenticationException,
			DeviceNotOpenedException, IllegalBlockSizeException, BadPaddingException {

		if (LCDongleCopyrightHandler.INSTANCE == null)
			LCDongleCopyrightHandler.INSTANCE = LCManager.init();

		String clearUserPassword = this.cipheringUtilities.unCipherText(this.cipheredUserPassword);

		this.lcHandler = new LCHandler(LCDongleCopyrightHandler.INSTANCE, this.developerId, this.index);
		this.lcHandler.open();
		this.lcHandler.authenticate(PasswordType.GENERIC, clearUserPassword);

		super.verifyCopyright();

		this.currentPoste = this.fetchCurrentPoste();

		if (this.currentPoste == null)
			this.currentPoste = this.createNewPoste(Integer.MAX_VALUE + "");
	}

	@Override
	public String getCurrentPosteId() throws NoSuchAlgorithmException, IOException, DongleOperationFailedException {
		this.currentHardwareInfo = this.lcHandler.getHardwareInfo();

		return this.cipheringUtilities.cipherInMD5(this.currentHardwareInfo.getSerialNumber());
	}

	@Override
	public boolean isPosteStillActive() throws DongleOperationFailedException, DeviceNotOpenedException {
		this.cipheredHardwareKey = this.lcHandler.readAsString(this.licenseCodeBlockIndex, this.licenseCodeDataSize);

		String md5SoftwareKey = this.cipheredSoftwareKey;
		String md5HardwareKey = this.cipheredHardwareKey;

		return md5SoftwareKey.equals(md5HardwareKey);
	}

	@Override
	public boolean isValidLicenseKey(Poste poste, String givenCipheredText) {
		return false;
	}

	@Override
	public boolean isUserActivable() {
		return false;
	}

	@Override
	public int getRemainingTime() throws NumberFormatException, IllegalBlockSizeException, BadPaddingException {
		return Integer.MAX_VALUE;
	}

	@Override
	public Collection<String> getEnabledModules() throws DongleOperationFailedException, DeviceNotOpenedException {
		String features = this.lcHandler.readAsString(this.featuresBlockIndex, this.featuresDataSize);

		Collection<String> result = new HashSet<>();

		for (int i = 0; i < features.length(); i += 2) {
			char c1 = features.charAt(i);
			char c2 = features.charAt(i + 1);

			if (c1 == '0' && c2 == '0')
				break;
			else
				result.add(String.valueOf(c1).concat(String.valueOf(c2)));
		}

		return result;
	}

	@Override
	public boolean trackActivityTime() {
		return false;
	}
}

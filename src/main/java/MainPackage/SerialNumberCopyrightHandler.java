package MainPackage;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.LinkOption;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;

import DomainModel.Poste;
import Exceptions.AlreadySignUpPosteAndModifiedCredentials;
import Exceptions.NoneActiveException;
import LC.Exceptions.DeviceNotOpenedException;
import LC.Exceptions.DongleOperationFailedException;
import LC.Exceptions.PasswordAuthenticationException;
import msdatabaseutils.SessionFactoryHandler;

public abstract class SerialNumberCopyrightHandler extends CopyrightHandler {
	private static final Path POSTE_ID_FILE = Paths.get("id_config.system");

	private String securityFile;

	public SerialNumberCopyrightHandler(SessionFactoryHandler sessionFactoryHandler,
			CipheringUtilities cipheringUtilities, String securityFile) {
		super(sessionFactoryHandler, cipheringUtilities);

		this.securityFile = securityFile;
	}

	public void verifyCopyright() throws AlreadySignUpPosteAndModifiedCredentials, IOException, NoneActiveException,
			NoSuchAlgorithmException, DongleOperationFailedException, IllegalBlockSizeException, BadPaddingException,
			PasswordAuthenticationException, DeviceNotOpenedException {

		// 1- Looking for the poste
		this.currentPoste = this.fetchCurrentPoste();

		if (this.currentPoste == null) {
			boolean isPosteHashAlreadyUsedProgram = this.isPosteHashAlreadyUsedProgram();

			if (!isPosteHashAlreadyUsedProgram)
				this.currentPoste = this.createNewPoste(2 * 24 * 60 * 60 + "");
			else
				throw new AlreadySignUpPosteAndModifiedCredentials();
		}

		super.verifyCopyright();
	}

	@Override
	public int getRemainingTime() throws NumberFormatException, IllegalBlockSizeException, BadPaddingException {
		String tempUtilisationAsString = this.currentPoste.getTempsUtilisation();
		String periodeUtilisationAsString = this.currentPoste.getPeriodeUtilisation();

		int tempUtilisation = Integer.parseInt(this.cipheringUtilities.unCipherText(tempUtilisationAsString));
		int periodUtilisation = Integer.parseInt(this.cipheringUtilities.unCipherText(periodeUtilisationAsString));
		int remainingTime = periodUtilisation - tempUtilisation;

		return remainingTime;
	}

	@Override
	public boolean isPosteStillActive() {
		try {
			return this.getRemainingTime() >= 0;
		} catch (NumberFormatException | IllegalBlockSizeException | BadPaddingException e) {
			e.printStackTrace();
		}

		return false;
	}

	@Override
	public String getCurrentPosteFullId() throws NoSuchAlgorithmException, IOException {
		return this.getCurrentPosteId() + this.currentPoste.getNombreActivations();
	}

	@Override
	public String getCurrentPosteId() throws NoSuchAlgorithmException, IOException {
		String osName = System.getProperty("os.name");
		String postePrefix = System.getProperty("application.poste.prefix");
		String posteSuffix = System.getProperty("application.poste.suffix");

		String id = "";

		if (Files.exists(SerialNumberCopyrightHandler.POSTE_ID_FILE)) {
			List<String> idConfigFileContent = Files.readAllLines(SerialNumberCopyrightHandler.POSTE_ID_FILE);

			if (!idConfigFileContent.isEmpty())
				id = idConfigFileContent.get(0);
		} else {
			if (osName.toLowerCase().contains("windows"))
				id = this.getWindowsMotherboard();
			else
				id = this.getLinuxMotherboard();

			List<String> data = new ArrayList<>(1);
			data.add(id);

			Files.createFile(SerialNumberCopyrightHandler.POSTE_ID_FILE);
			Files.write(SerialNumberCopyrightHandler.POSTE_ID_FILE, data, Charset.forName("UTF-8"));
			Files.setAttribute(SerialNumberCopyrightHandler.POSTE_ID_FILE, "dos:hidden", Boolean.TRUE,
					LinkOption.NOFOLLOW_LINKS);
		}

		id = postePrefix + id + posteSuffix;

		return this.cipheringUtilities.cipherInMD5(id);
	}

	@Override
	public boolean isValidLicenseKey(Poste poste, String givenCipherText) {
		try {
			String supposedClearText = poste.getId() + poste.getNombreActivations() + this.signature;
			String supposedCipherText = this.cipheringUtilities.cipherInMD5(supposedClearText);

			return givenCipherText.equals(supposedCipherText);
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}

		return true;
	}

	@Override
	public boolean isUserActivable() {
		return true;
	}

	// ---------------------------------------------------------------------------------------

	private boolean isPosteHashAlreadyUsedProgram() throws IOException {
		Path path = Paths.get(System.getenv("APPDATA") + "\\" + this.securityFile + ".system");

		boolean result = Files.exists(path);

		if (!result) {
			Files.createFile(path);
			Files.setAttribute(path, "dos:hidden", Boolean.TRUE, LinkOption.NOFOLLOW_LINKS);
		}

		return result;
	}

	private String getLinuxMotherboard() {
		String command = "dmidecode -s baseboard-serial-number";
		String result = null;

		try {
			Process SerNumProcess = Runtime.getRuntime().exec(command);
			BufferedReader sNumReader = new BufferedReader(new InputStreamReader(SerNumProcess.getInputStream()));

			result = sNumReader.readLine().trim();

			SerNumProcess.waitFor();
			sNumReader.close();
		}

		catch (Exception ex) {
			result = null;
		}

		return result;
	}

	private String getWindowsMotherboard() throws NoSuchAlgorithmException, IOException {
		String result = "";

		File file = File.createTempFile("realhowto", ".vbs");
		file.deleteOnExit();

		FileWriter fw = new FileWriter(file);

		String vbs = "Set objWMIService = GetObject(\"winmgmts:\\\\.\\root\\cimv2\")\n"
				+ "Set colItems = objWMIService.ExecQuery _ \n	" + "(\"Select * from Win32_BaseBoard\") \n"
				+ "For Each objItem in colItems \n	" + "Wscript.Echo objItem.SerialNumber \n	"
				+ "exit for  ' do the first cpu only! \n" + "Next \n";

		fw.write(vbs);
		fw.close();

		Process p = Runtime.getRuntime().exec("cscript //NoLogo " + file.getPath());
		BufferedReader input = new BufferedReader(new InputStreamReader(p.getInputStream()));

		String line;

		while ((line = input.readLine()) != null) {
			result += line;
		}

		input.close();

		return result.trim();
	}
}

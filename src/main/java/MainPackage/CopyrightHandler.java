package MainPackage;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.math.BigInteger;
import java.nio.file.Files;
import java.nio.file.LinkOption;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.NoSuchAlgorithmException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;

import DomainModel.Poste;
import Exceptions.AlreadySignUpPoste;
import Exceptions.LicenseExpiredException;
import Exceptions.UnrecognizedLicenseKey;
import msdatabaseutils.SessionFactoryHandler;

public abstract class CopyrightHandler {
	public static Poste CURRENT_POSTE = null;

	private CipheringUtilities cipheringUtilities = null;
	private SessionFactoryHandler sessionFactoryHandler = null;

	private Timer timer = new Timer();

	private int frequency = 1000;
	private String signature = "MSSM";
	private String securityFile;

	private boolean isStarted = false;

	public CopyrightHandler(SessionFactoryHandler sessionFactoryHandler, CipheringUtilities cipheringUtilities,
			String securityFile) {
		this.securityFile = securityFile;
		this.sessionFactoryHandler = sessionFactoryHandler;
		this.cipheringUtilities = cipheringUtilities;
	}

	public void verifyCopyright()
			throws AlreadySignUpPoste, IOException, LicenseExpiredException, NoSuchAlgorithmException {
		boolean isPosteHashAlreadyUsedProgram = this.isPosteHashAlreadyUsedProgram();

		Poste currentPoste = this.getCurrentPoste();

		if (currentPoste == null) {
			if (!isPosteHashAlreadyUsedProgram) {
				int nombrePostes = this.getAvailableNumberOfPostes();

				CopyrightHandler.CURRENT_POSTE = new Poste();
				CopyrightHandler.CURRENT_POSTE.setId(getPosteVersion());
				CopyrightHandler.CURRENT_POSTE.setNomPoste("Poste " + nombrePostes);
				CopyrightHandler.CURRENT_POSTE.setPeriodeUtilisation(this.getCipheredPeriodeEssait());
				CopyrightHandler.CURRENT_POSTE.setTempsUtilisation(this.cipheringUtilities.cipherText("0"));
				CopyrightHandler.CURRENT_POSTE.setNombreActivations(0);

				this.sessionFactoryHandler.insertArray(CopyrightHandler.CURRENT_POSTE);
				this.onPosteCreation(CopyrightHandler.CURRENT_POSTE);
			}

			else
				throw new AlreadySignUpPoste();
		} else
			CopyrightHandler.CURRENT_POSTE = currentPoste;

		this.sessionFactoryHandler.constructDatabase();

		if (this.isPosteStillAlive())
			this.startCounter();
		else
			throw new LicenseExpiredException();
	}

	public void validateSoftware(String givenCipherText) throws UnrecognizedLicenseKey {
		Poste poste = CopyrightHandler.CURRENT_POSTE;

		boolean isValidKey = this.cipheringUtilities.isValidLicenseKey(poste, givenCipherText, this.signature);

		if (isValidKey) {
			poste.setNombreActivations(poste.getNombreActivations() + 1);
			poste.setPeriodeUtilisation(this.cipheringUtilities.cipherText(Integer.MAX_VALUE + ""));
			poste.setTempsUtilisation(this.cipheringUtilities.cipherText("0"));

			this.stopCounter();
			this.sessionFactoryHandler.updateArray(poste);
			this.startCounter();
		}

		else
			throw new UnrecognizedLicenseKey();
	}

	public String getIdForValidation() {
		return CopyrightHandler.CURRENT_POSTE.getId() + CopyrightHandler.CURRENT_POSTE.getNombreActivations();
	}

	public LocalDateTime getRemainingTimeAsString() {
		try {
			String tempUtilisationAsString = CopyrightHandler.CURRENT_POSTE.getTempsUtilisation();
			String periodeUtilisationAsString = CopyrightHandler.CURRENT_POSTE.getPeriodeUtilisation();

			int tempUtilisation = Integer.parseInt(this.cipheringUtilities.unCipherText(tempUtilisationAsString));
			int periodUtilisation = Integer.parseInt(this.cipheringUtilities.unCipherText(periodeUtilisationAsString));
			int remainingTime = periodUtilisation - tempUtilisation;

			return LocalDateTime.now().plusSeconds(remainingTime);
		} catch (NumberFormatException | IllegalBlockSizeException | BadPaddingException e) {
			e.printStackTrace();
		}

		return null;
	}

	public boolean isPosteStillAlive() {
		try {
			String tempUtilisationAsString = CopyrightHandler.CURRENT_POSTE.getTempsUtilisation();
			String periodeUtilisationAsString = CopyrightHandler.CURRENT_POSTE.getPeriodeUtilisation();

			int tempUtilisation = Integer.parseInt(this.cipheringUtilities.unCipherText(tempUtilisationAsString));
			int periodUtilisation = Integer.parseInt(this.cipheringUtilities.unCipherText(periodeUtilisationAsString));

			return tempUtilisation <= periodUtilisation;
		} catch (NumberFormatException | IllegalBlockSizeException | BadPaddingException e) {
			e.printStackTrace();
		}

		return false;
	}

	private void startCounter() {
		if (!isStarted) {
			this.timer = new Timer();
			this.timer.scheduleAtFixedRate(new TimerTask() {
				@Override
				public void run() {
					try {
						long tempsUtilisation = Integer
								.parseInt(cipheringUtilities.unCipherText(CURRENT_POSTE.getTempsUtilisation()));
						long periodeUtilisation = Integer
								.parseInt(cipheringUtilities.unCipherText(CURRENT_POSTE.getPeriodeUtilisation()));

						if (tempsUtilisation > periodeUtilisation)
							System.exit(0);

						else {
							long nouveauTempsUtilisation = (tempsUtilisation + (frequency / 1000));

							CopyrightHandler.CURRENT_POSTE
									.setTempsUtilisation(cipheringUtilities.cipherText(nouveauTempsUtilisation + ""));

							sessionFactoryHandler.updateArray(CopyrightHandler.CURRENT_POSTE);
						}
					} catch (NumberFormatException | IllegalBlockSizeException | BadPaddingException e) {
						System.exit(0);
					}
				}
			}, 0, this.frequency);
		}
	}

	private void stopCounter() {
		this.timer.cancel();
		this.isStarted = false;
	}

	private boolean isPosteHashAlreadyUsedProgram() throws IOException {
		Path path = Paths.get(System.getenv("APPDATA") + "\\" + this.securityFile + ".system");

		boolean result = Files.exists(path);

		if (!result) {
			Files.createFile(path);
			Files.setAttribute(path, "dos:hidden", Boolean.TRUE, LinkOption.NOFOLLOW_LINKS);
		}

		return result;
	}

	public String getPosteVersion() throws NoSuchAlgorithmException {
		try {
			Process process = Runtime.getRuntime().exec("wmic baseboard get serialnumber");

			BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));

			String computerVersion = "";
			String line = null;

			while ((line = reader.readLine()) != null) {
				computerVersion += line;
			}

			computerVersion = computerVersion.toLowerCase();
			computerVersion = computerVersion.replaceAll("serialnumber", "");
			computerVersion = computerVersion.replaceAll(" ", "");
			computerVersion = this.cipheringUtilities.cipherInMD5(computerVersion);

			return computerVersion;
		}

		catch (IOException e) {
			e.printStackTrace();
		}

		return null;
	}

	private int getAvailableNumberOfPostes() {
		return ((BigInteger) this.sessionFactoryHandler.selectUsingSQL("SELECT COUNT(*) FROM POSTES").get(0)).intValue()
				+ 1;
	}

	@SuppressWarnings("unchecked")
	private Poste getCurrentPoste() throws NoSuchAlgorithmException {
		List<Poste> result = (List<Poste>) (Object) this.sessionFactoryHandler.select("FROM Poste p WHERE p.id = ?",
				this.getPosteVersion());

		if (result.isEmpty())
			return null;

		return result.get(0);
	}

	private String getCipheredPeriodeEssait() {
		return this.cipheringUtilities.cipherText(2 * 24 * 60 * 60 + "");
	}

	public abstract void onPosteCreation(Poste poste);
}

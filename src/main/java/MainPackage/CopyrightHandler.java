package MainPackage;

import java.io.IOException;
import java.math.BigInteger;
import java.security.NoSuchAlgorithmException;
import java.time.LocalDateTime;
import java.util.Collection;
import java.util.LinkedList;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;

import DomainModel.Poste;
import Exceptions.AlreadySignUpPosteAndModifiedCredentials;
import Exceptions.NoneActiveException;
import Exceptions.UnrecognizedLicenseKey;
import LC.Exceptions.DeviceNotOpenedException;
import LC.Exceptions.DongleOperationFailedException;
import LC.Exceptions.PasswordAuthenticationException;
import msdatabaseutils.SessionFactoryHandler;

public abstract class CopyrightHandler {

	protected String signature = "MSSM";
	protected Poste currentPoste = null;

	protected CipheringUtilities cipheringUtilities = null;
	protected SessionFactoryHandler sessionFactoryHandler = null;

	private Timer timer;
	private int frequency = 1000;
	private boolean isStarted = false;

	public CopyrightHandler(SessionFactoryHandler sessionFactoryHandler, CipheringUtilities cipheringUtilities) {
		this.sessionFactoryHandler = sessionFactoryHandler;
		this.cipheringUtilities = cipheringUtilities;
	}

	// -------->

	public void verifyCopyright() throws AlreadySignUpPosteAndModifiedCredentials, IOException, NoneActiveException,
			NoSuchAlgorithmException, DongleOperationFailedException, PasswordAuthenticationException,
			DeviceNotOpenedException, IllegalBlockSizeException, BadPaddingException {

		if (this.isPosteStillActive())
			this.startBackgroundThread();
		else
			throw new NoneActiveException();
	}

	@SuppressWarnings("unchecked")
	public Poste fetchCurrentPoste() throws NoSuchAlgorithmException, IOException, DongleOperationFailedException {
		List<Poste> result = (List<Poste>) (Object) this.sessionFactoryHandler.select("FROM Poste p WHERE p.id = ?",
				this.getCurrentPosteId());

		if (result.isEmpty())
			return null;

		return result.get(0);
	}

	public int getAvailableNumberOfPostes() {
		return ((BigInteger) this.sessionFactoryHandler.selectUsingSQL("SELECT COUNT(*) FROM POSTES").get(0)).intValue()
				+ 1;
	}

	public void validateSoftware(String givenCipheredText) throws UnrecognizedLicenseKey {
		this.validateSoftware(this.currentPoste, givenCipheredText);
	}

	public void validateSoftware(Poste poste, String givenCipheredText) throws UnrecognizedLicenseKey {
		boolean isValidKey = this.isValidLicenseKey(poste, givenCipheredText);

		if (isValidKey) {
			poste.setNombreActivations(poste.getNombreActivations() + 1);
			poste.setPeriodeUtilisation(this.cipheringUtilities.cipherText(Integer.MAX_VALUE + ""));
			poste.setTempsUtilisation(this.cipheringUtilities.cipherText("0"));

			this.stopBackgroundThread();
			this.sessionFactoryHandler.updateArray(poste);
			this.startBackgroundThread();
		}

		else
			throw new UnrecognizedLicenseKey();
	}

	public Poste createNewPoste(String initialSecondsPeriod)
			throws NoSuchAlgorithmException, IOException, DongleOperationFailedException {
		String cipheredInitialPeriod = this.cipheringUtilities.cipherText(initialSecondsPeriod);
		int nombrePostes = this.getAvailableNumberOfPostes();

		Poste poste = new Poste();
		poste.setId(this.getCurrentPosteId());
		poste.setNomPoste("Poste " + nombrePostes);
		poste.setPeriodeUtilisation(cipheredInitialPeriod);
		poste.setTempsUtilisation(this.cipheringUtilities.cipherText("0"));
		poste.setNombreActivations(0);

		this.sessionFactoryHandler.insertArray(poste);
		this.onPosteCreation(poste);

		return poste;
	}

	public String getCurrentPosteFullId() throws NoSuchAlgorithmException, IOException, DongleOperationFailedException {
		return this.getCurrentPosteId();
	}

	public LocalDateTime getRemainingTimeAsString()
			throws NumberFormatException, IllegalBlockSizeException, BadPaddingException {
		return LocalDateTime.now().plusSeconds(this.getRemainingTime());
	}

	protected void startBackgroundThread() {
		if (!this.isStarted) {
			this.timer = new Timer();
			this.timer.scheduleAtFixedRate(new TimerTask() {

				@Override
				public void run() {
					try {
						try {
							if (!isPosteStillActive())
								System.exit(0);
							else if(trackActivityTime())
								updateTempsUtilisation(currentPoste);
						} catch (DongleOperationFailedException | DeviceNotOpenedException e) {
							e.printStackTrace();

							System.exit(0);
						}
					} catch (NumberFormatException | IllegalBlockSizeException | BadPaddingException e) {
						System.exit(0);
					}
				}
			}, 0, this.frequency);
		}
	}

	protected void stopBackgroundThread() {
		if(this.timer != null)
			this.timer.cancel();

		this.isStarted = false;
	}

	protected void updateTempsUtilisation(Poste poste)
			throws NumberFormatException, IllegalBlockSizeException, BadPaddingException {
		long tempsUtilisation = Integer.parseInt(this.cipheringUtilities.unCipherText(poste.getTempsUtilisation()));
		long nouveauTempsUtilisation = (tempsUtilisation + (this.frequency / 1000));

		this.currentPoste.setTempsUtilisation(this.cipheringUtilities.cipherText(nouveauTempsUtilisation + ""));
		this.sessionFactoryHandler.updateArray(this.currentPoste);
	}

	public Poste getCurrentPoste() {
		return this.currentPoste;
	}

	public abstract String getCurrentPosteId()
			throws NoSuchAlgorithmException, IOException, DongleOperationFailedException;

	public abstract boolean isPosteStillActive() throws DongleOperationFailedException, DeviceNotOpenedException;

	public abstract boolean trackActivityTime();

	public abstract boolean isValidLicenseKey(Poste poste, String givenCipheredText);

	public abstract boolean isUserActivable();

	public abstract int getRemainingTime() throws NumberFormatException, IllegalBlockSizeException, BadPaddingException;

	public abstract void onPosteCreation(Poste poste);

	public Collection<String> getEnabledModules() throws DongleOperationFailedException, DeviceNotOpenedException {
		return new LinkedList<>();
	}
}

package MainPackage;

import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Base64;

import DomainModel.Poste;

public class CipheringUtilities {
	private Cipher cipherer = null;
	private Cipher unCipherer = null;

	public CipheringUtilities() {
		IvParameterSpec iv = new IvParameterSpec(new byte[] { 4, 2, 7, 5, 3, 7, 0, 4, 9, 8, 9, 3, 7, 4, 6, 6 });
		byte[] keyBytes = new byte[] { 5, 8, 11, 2, 4, 9, 3, 4, 7, 1, 9, 5, 7, 2, 4, 8 };
		SecretKeySpec key = new SecretKeySpec(keyBytes, "AES");

		try {
			this.cipherer = Cipher.getInstance("AES/CBC/PKCS5PADDING");
			this.cipherer.init(Cipher.ENCRYPT_MODE, key, iv);

			this.unCipherer = Cipher.getInstance("AES/CBC/PKCS5PADDING");
			this.unCipherer.init(Cipher.DECRYPT_MODE, key, iv);
		} catch (NoSuchPaddingException | InvalidKeyException | NoSuchAlgorithmException
				| InvalidAlgorithmParameterException e) {
			e.printStackTrace();
		}
	}

	public String cipherText(String clearText) {
		try {
			return Base64.encodeBase64String(this.cipherer.doFinal(clearText.getBytes()));
		} catch (IllegalBlockSizeException | BadPaddingException e) {
			e.printStackTrace();
		}

		return "";
	}

	public String unCipherText(String cipheredText) throws IllegalBlockSizeException, BadPaddingException {
		return new String(this.unCipherer.doFinal(Base64.decodeBase64(cipheredText)));
	}

	// --------------------------------------------------------------------------------------

	public boolean isValidLicenseKey(Poste poste, String givenCipherText, String signature) {
		try {
			String supposedClearText = poste.getId() + poste.getNombreActivations() + signature;

			String supposedCipherText = this.cipherInMD5(supposedClearText);

			return givenCipherText.equals(supposedCipherText);
		}

		catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}

		return true;
	}

	public String cipherInMD5(String clearText) throws NoSuchAlgorithmException {
		MessageDigest cipher = MessageDigest.getInstance("MD5");

		byte[] cipherBytes = cipher.digest(clearText.getBytes());

		String cipherText = this.toHexString(cipherBytes);
		cipherText = this.wellFormattedKey(cipherText);
		cipherText = cipherText.toUpperCase();

		return cipherText;
	}

	public String wellFormattedKey(String supposedCipherText) {
		String result = new String("");

		for (int i = 0; i < supposedCipherText.length(); i++) {
			if (i % 4 == 0 && i != 0)
				result += "-";

			result += supposedCipherText.charAt(i);
		}

		return result;
	}

	public String toHexString(byte[] bytes) {
		StringBuilder hexString = new StringBuilder();

		for (int i = 0; i < bytes.length; i++) {
			String hex = Integer.toHexString(0xFF & bytes[i]);

			if (hex.length() == 1) {
				hexString.append('0');
			}

			hexString.append(hex);
		}

		return hexString.toString();
	}

	public byte[] hexStringToByteArray(String s) {
		int len = s.length();

		byte[] data = new byte[len / 2];

		for (int i = 0; i < len; i += 2) {
			data[i / 2] = (byte) ((Character.digit(s.charAt(i), 16) << 4) + Character.digit(s.charAt(i + 1), 16));
		}
		return data;
	}
}

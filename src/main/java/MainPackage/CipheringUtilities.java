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
import javax.xml.bind.DatatypeConverter;

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
			// return
			// Base64.encodeBase64String(this.cipherer.doFinal(clearText.getBytes())); old
			// style

			return DatatypeConverter.printBase64Binary(this.cipherer.doFinal(clearText.getBytes()));
		} catch (IllegalBlockSizeException | BadPaddingException e) {
			e.printStackTrace();
		}

		return "";
	}

	public String unCipherText(String cipheredText) throws IllegalBlockSizeException, BadPaddingException {
		// return new
		// String(this.unCipherer.doFinal(Base64.decodeBase64(cipheredText))); old code

		return new String(this.unCipherer.doFinal(DatatypeConverter.parseBase64Binary(cipheredText)));
	}

	public String cipherInMD5(String clearText) throws NoSuchAlgorithmException {
		MessageDigest cipher = MessageDigest.getInstance("MD5");

		byte[] cipherBytes = cipher.digest(clearText.getBytes());

		String cipherText = this.toHexString(cipherBytes);
		cipherText = this.wellFormattedKey(cipherText);
		cipherText = cipherText.toUpperCase();

		return cipherText;
	}

	// ---------------------------------------------------------------------------

	private String wellFormattedKey(String supposedCipherText) {
		String result = new String("");

		for (int i = 0; i < supposedCipherText.length(); i++) {
			if (i % 4 == 0 && i != 0)
				result += "-";

			result += supposedCipherText.charAt(i);
		}

		return result;
	}

	private String toHexString(byte[] bytes) {
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
}

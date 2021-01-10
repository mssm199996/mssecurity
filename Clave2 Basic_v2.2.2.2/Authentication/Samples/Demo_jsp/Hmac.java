package com.LC.util;
import java.security.*;

public class Hmac {

    public static void main(String arg[])
        {
                Hmac hm;
                byte result[];
                String expectedHash;
                String text;
                String HashStr;

                text = "onyaaeeisikurxpsoycf";
                byte key[] = {
                             (byte)0x0b, (byte)0x0b, (byte)0x0b, (byte)0x0b, (byte)0x0b, (byte)0x0b, (byte)0x0b, (byte)0x0b, (byte)0x0b, (byte)0x0b,
                             (byte)0x0b, (byte)0x0b, (byte)0x0b, (byte)0x0b, (byte)0x0b, (byte)0x0b, (byte)0x0b, (byte)0x0b, (byte)0x0b, (byte)0x0b
                };

                System.out.println(" The test uses Hmac-SHA1.");
                System.out.println();
                System.out.println("Test :");

                try {
                    hm = new Hmac();
                    result = hm.GetHmacSHA1(text.getBytes(), text.getBytes().length, key);
                    HashStr = hm.toString();
                    System.out.println("Calculated hash: " + HashStr);
                    }
                catch (NoSuchAlgorithmException nsae) {
                        nsae.printStackTrace();
                }
        }

        private byte digest[];

       
        public byte [] GetHmacSHA1(byte [] text, int textlen, byte [] key) throws NoSuchAlgorithmException
        {
            MessageDigest SHA;

            MessageDigest innerSHA;

            byte kIpad[];

            byte kOpad[];

            SHA = MessageDigest.getInstance("SHA-1");
            innerSHA = MessageDigest.getInstance("SHA-1");

            

            kIpad = new byte[64];	// inner padding - key XORd with ipad

            kOpad = new byte[64];	// outer padding - key XORd with opad

            // start out by storing key in pads
            System.arraycopy(key, 0, kIpad, 0, 20);
            System.arraycopy(key, 0, kOpad, 0, 20);

            // XOR key with ipad and opad values
            for (int i = 0; i < 64; i++)
            {
                kIpad[i] ^= 0x36;
                kOpad[i] ^= 0x5c;
            }

            innerSHA.reset();
            innerSHA.update(kIpad);   // Intialize the inner pad.
            digest = null;           // mark the digest as incomplete.
            innerSHA.update(text, 0, textlen);
            digest = innerSHA.digest();

            SHA.reset();
            SHA.update(kOpad);
            SHA.update(digest);
            digest = SHA.digest();

         return digest;
    }


    public String toString()
    {
            // If not already calculated, return null.
            if (digest == null)
                    return null;

            StringBuffer r = new StringBuffer();
            final String hex = "0123456789abcdef";
            byte b[] = digest;

            for (int i = 0; i < 20; i++)
            {
                    int c = ((b[i]) >>> 4) & 0xf;
                    r.append(hex.charAt(c));
                    c = ((int)b[i] & 0xf);
                    r.append(hex.charAt(c));
            }

            return r.toString();
      }

    public Hmac()
    {
        try {
            jbInit();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    private void jbInit() throws Exception {
    }
}

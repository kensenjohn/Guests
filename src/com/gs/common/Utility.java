package com.gs.common;

import java.io.StringWriter;
import java.util.Random;
import java.util.UUID;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;

public class Utility {
	public static String getNewGuid() {
		UUID uuid = UUID.randomUUID();

		return uuid.toString();
	}

	public static String convertTelNumToDigits(String sTelNumber) {
		String sFinalString = " ";
		if (sTelNumber != null && !"".equalsIgnoreCase(sTelNumber)) {
			char[] chString = sTelNumber.toCharArray();
			for (char singleChar : chString) {
				if (singleChar == '1' || singleChar == '2' || singleChar == '3'
						|| singleChar == '4' || singleChar == '5'
						|| singleChar == '6' || singleChar == '7'
						|| singleChar == '8' || singleChar == '9'
						|| singleChar == '0') {
					sFinalString = sFinalString + singleChar + " ";
				}
			}
		}
		return sFinalString;
	}

	public static <T> String getXmlFromBean(Class<T> className, T bean)
			throws JAXBException {
		JAXBContext jaxbContext = JAXBContext.newInstance(className);

		Marshaller marshaller = jaxbContext.createMarshaller();
		marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, Boolean.TRUE);
		marshaller.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");
		java.io.StringWriter sw = new StringWriter();

		marshaller.marshal(bean, sw);

		return sw.toString();

	}

	public static Integer getRandomInteger(Integer iLimit) {

		Random randomGenerator = new Random();
		int randomInt = randomGenerator.nextInt(iLimit);
		return randomInt;
	}

	public static String generateSecretKey(Integer iNumOfDigits) {
		long seed = (System.nanoTime()) | (System.nanoTime() << 16)
				| (System.nanoTime() << 32) ^ (System.nanoTime() << 40);

		Random rnd = new Random(seed);
		String pin = "";
		int last_n = -1, n = -1;

		for (int i = 0; i < iNumOfDigits; i++) {

			// Be sure the new digit is different from the last
			for (int j = 0; j < 25 && (last_n == n); j++) {
				n = (int) (rnd.nextFloat() * 9.0f);
			}

			last_n = n;
			pin += n;
		}

		return pin;
	}

}

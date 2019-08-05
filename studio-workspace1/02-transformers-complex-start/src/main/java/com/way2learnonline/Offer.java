
package com.way2learnonline;

import java.util.Date;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlType;
import javax.xml.datatype.XMLGregorianCalendar;



public class Offer {

    protected double offerPrice;
    private Date offerValidUntil;
    
    public Offer() {
		// TODO Auto-generated constructor stub
	}
    
    public Offer(double offerPrice, Date offerValidUntil) {
		super();
		this.offerPrice = offerPrice;
		this.offerValidUntil = offerValidUntil;
	}



    public double getOfferPrice() {
        return offerPrice;
    }

    public void setOfferPrice(double value) {
        this.offerPrice = value;
    }

	public Date getOfferValidUntil() {
		return offerValidUntil;
	}

	public void setOfferValidUntil(Date offerValidUntil) {
		this.offerValidUntil = offerValidUntil;
	}

 

}

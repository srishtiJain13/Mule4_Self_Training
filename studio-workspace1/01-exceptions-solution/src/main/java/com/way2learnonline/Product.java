

package com.way2learnonline;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;



public class Product {

    protected String brandName;
    protected String description;
   
    
    protected List<String> images;
    protected String name;
   
    protected Offer offer;
    protected double originalPrice;
    

    protected Long productId;
    
    public Product() {
		// TODO Auto-generated constructor stub
	}



	public Product( String name, String description, double originalPrice, double offerPrice,
			Date offerValidUntil, String brandName, List<String> images) {
		super();
		
		this.name = name;
		this.description = description;
		this.originalPrice = originalPrice;
		
		this.offer= new Offer(originalPrice, offerValidUntil);
	
		this.brandName = brandName;
		this.images = images;
	}


	/**
     * Gets the value of the brandName property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getBrandName() {
        return brandName;
    }

   
	/**
     * Sets the value of the brandName property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setBrandName(String value) {
        this.brandName = value;
    }

    /**
     * Gets the value of the description property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDescription() {
        return description;
    }

    /**
     * Sets the value of the description property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDescription(String value) {
        this.description = value;
    }

   
    public List<String> getImages() {
        if (images == null) {
            images = new ArrayList<String>();
        }
        return this.images;
    }

   
    public String getName() {
        return name;
    }

    /**
     * Sets the value of the name property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setName(String value) {
        this.name = value;
    }

    /**
     * Gets the value of the offer property.
     * 
     * @return
     *     possible object is
     *     {@link Offer }
     *     
     */
    public Offer getOffer() {
        return offer;
    }

    /**
     * Sets the value of the offer property.
     * 
     * @param value
     *     allowed object is
     *     {@link Offer }
     *     
     */
    public void setOffer(Offer value) {
        this.offer = value;
    }

    /**
     * Gets the value of the originalPrice property.
     * 
     */
    public double getOriginalPrice() {
        return originalPrice;
    }

    /**
     * Sets the value of the originalPrice property.
     * 
     */
    public void setOriginalPrice(double value) {
        this.originalPrice = value;
    }

    /**
     * Gets the value of the productId property.
     * 
     * @return
     *     possible object is
     *     {@link Long }
     *     
     */
    public Long getProductId() {
        return productId;
    }

    /**
     * Sets the value of the productId property.
     * 
     * @param value
     *     allowed object is
     *     {@link Long }
     *     
     */
    public void setProductId(Long value) {
        this.productId = value;
    }

}

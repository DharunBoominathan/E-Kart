package com.model;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name="products")
public class Product {
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private int p_id;
    @Column(nullable = false)
    private String name;
    @Column
    private int price;
    @Column(length = 1000)
    private String description;
    @Column
    private String img_url;

    @Column(nullable = false)
    private String category="others";
    @Column(nullable = false)
    private String brand="others";

    @Column(nullable = false)
    private int stock=1;

    private static final List<String> ALLOWED_CATEGORIES = new ArrayList<>(Arrays.asList("Electronics", "Fashion", "Groceries", "Sports","Furniture","Mobiles","Others"));
    private static final List<String> ALLOWED_BRANDS = new ArrayList<>(Arrays.asList("BrandA", "BrandB", "BrandC", "Others"));

    public Product() {};

    public Product(String name, int price, String description, String img_url, String category, String brand,int stock) {
        this.name = name;
        this.price = price;
        this.description = description;
        this.img_url = img_url;
        setCategory(category);
        setBrand(brand);
        this.stock=stock;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        if (ALLOWED_CATEGORIES.contains(category)) {
            this.category = category;
        } else {
            ALLOWED_CATEGORIES.add(category);
            this.category = category;
        }
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        if (ALLOWED_BRANDS.contains(brand)) {
            this.brand = brand;
        } else {
            ALLOWED_BRANDS.add(brand);
            this.brand = brand;
        }

    }
    public static List<String> getAllowedCategories() {
        return ALLOWED_CATEGORIES;
    }

    public static List<String> getAllowedBrands() {
        return ALLOWED_BRANDS;
    }

    public int getP_id() {
        return p_id;
    }
    public void setP_id(int p_id) {
        this.p_id = p_id;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public int getPrice() {
        return price;
    }
    public void setPrice(int price) {
        this.price = price;
    }
    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }
    public String getImg_url() {
        return img_url;
    }
    public void setImg_url(String img_url) {
        this.img_url = img_url;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }


}

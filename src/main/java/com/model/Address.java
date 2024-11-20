package com.model;

import jakarta.persistence.*;
import jakarta.servlet.annotation.WebServlet;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;

@Entity
@Table(name="address")
public class Address {
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private int addr_id;
    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="u_id",nullable = false)
    private User user;
    @Column(nullable = false)
    private String fullName;
    @Column(nullable = false)
    private String phoneNumber;
    @Column(nullable = false)
    private String addressLine1;
    @Column(nullable = false)
    private String addressLine2=null;
    @Column(nullable = false)
    private String city;
    @Column(nullable = false)
    private String state;
    @Column(nullable = false)
    private String pinCode;

    private String country="India";

    public static final List<String> states=new ArrayList<>(Arrays.asList("Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chhattisgarh",
            "Goa", "Gujarat", "Haryana", "Himachal Pradesh", "Jharkhand", "Karnataka",
            "Kerala", "Madhya Pradesh", "Maharashtra", "Manipur", "Meghalaya",
            "Mizoram", "Nagaland", "Odisha", "Punjab", "Rajasthan", "Sikkim",
            "Tamil Nadu", "Telangana", "Tripura", "Uttar Pradesh", "Uttarakhand",
            "West Bengal", "Andaman and Nicobar Islands", "Chandigarh",
            "Dadra and Nagar Haveli and Daman and Diu", "Delhi", "Lakshadweep",
            "Puducherry"
    ));

    // Constructors
    public Address() {
    }

    public Address(User user, String fullName, String phoneNumber, String addressLine1, String addressLine2, String city, String state, String pinCode) {
        this.user = user;
        this.fullName = fullName;
        this.phoneNumber = phoneNumber;
        this.addressLine1 = addressLine1;
        this.addressLine2 = addressLine2;
        this.city = city;
        this.state = state;
        this.pinCode = pinCode;
    }

    // Getters and Setters
    public int getAddr_id() {
        return addr_id;
    }

    public void setAddr_id(int addr_id) {
        this.addr_id = addr_id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(int u_id) {
        this.user = user;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getAddressLine1() {
        return addressLine1;
    }

    public void setAddressLine1(String addressLine1) {
        this.addressLine1 = addressLine1;
    }

    public String getAddressLine2() {
        return addressLine2;
    }

    public void setAddressLine2(String addressLine2) {
        this.addressLine2 = addressLine2;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getPinCode() {
        return pinCode;
    }

    public void setPinCode(String pinCode) {
        this.pinCode = pinCode;
    }


    public String getFullAddress() {
        return String.format("%s %s %s, %s %s, %s - %s, %s",
                fullName.toUpperCase(),
                phoneNumber,
                addressLine1,
                (addressLine2 != null && !addressLine2.trim().isEmpty() ? addressLine2 + "," : ""),
                city,
                state,
                pinCode,
                country);
    }

    public String getFrmtAddress1(){
            StringBuilder formattedAddress = new StringBuilder();

            formattedAddress.append(fullName.toUpperCase()).append("\t").append(phoneNumber).append("<br>")
                    .append(addressLine1).append(",<br>");

            if (addressLine2 != null && !addressLine2.isEmpty()) {
                formattedAddress.append(addressLine2).append(",<br>");
            }

            formattedAddress.append(city).append(",<br>")
                    .append(state).append(" - ")
                    .append(pinCode);

            return formattedAddress.toString();
        }

    public String getFrmtAddress2(){
        StringBuilder formattedAddress = new StringBuilder();

        formattedAddress.append(fullName.toUpperCase()).append("\t").append(phoneNumber).append("<br>")
                .append(addressLine1).append(",");

        if (addressLine2 != null && !addressLine2.isEmpty()) {
            formattedAddress.append(addressLine2).append(",<br>");
        }

        formattedAddress.append(city).append(", ")
                .append(state).append(" - ")
                .append(pinCode);

        return formattedAddress.toString();
    }
}

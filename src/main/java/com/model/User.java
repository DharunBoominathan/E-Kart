package com.model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int u_id;

    @Column(name = "name")
    private String name;

    @Column(unique = true, nullable = false)
    private String email;

    @Column(name = "dob")
    private LocalDate dob;

    @Column(unique = true, nullable = false)
    private String phone;

    @Column
    private String pass;

    public User() {}


    public User(String name, String email, LocalDate dob, String phone, String pass) {
        this.name = name;
        this.email = email;
        this.dob = dob;
        this.phone = phone;
        this.pass = pass;
    }



    public int getU_id() {
        return u_id;
    }


    public void setU_id(int u_id) {
        this.u_id = u_id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public LocalDate getDob() {
        return dob;
    }

    public void setDob(LocalDate dob) {
        this.dob = dob;
    }
    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPass() {
        return pass;
    }

    public void setPass(String pass) {
        this.pass = pass;
    }

}

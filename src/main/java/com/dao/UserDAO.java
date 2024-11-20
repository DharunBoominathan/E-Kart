package com.dao;

import com.model.User;

import java.util.List;
import java.util.Map;

public interface UserDAO {

    boolean emailExists(String email);
    boolean phoneExists(String phone);
    int verify_user(String u_name,String pass);
    void addUser(User u);
    User getUser(int id);

    void updateUser(User u);
    List<User> getAllUsers();


    int getTotalUsers();
    Map<String, Integer> getUsersByAgeGroup();

}

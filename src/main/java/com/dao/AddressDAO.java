package com.dao;

import com.model.Address;
import com.model.User;

import java.util.List;

public interface AddressDAO {
    void addAddress(Address address);
    List<Address> getUserAddresses(User user);
    Address getAddressById(int addr_id);
    void deleteAddress(int addr_id);
    void updateAddress(Address address);
}

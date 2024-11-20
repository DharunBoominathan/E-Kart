package com.dao;

import com.model.Cart;
import com.model.User;

import java.util.List;

public interface CartDAO {

    int addCart(Cart cart);
    List<Cart> getUserCart(User user);
    int removeUserProduct(int p_id,int u_id);
    boolean setCartQuantity(int cart_id,int q);

    Cart getUserCartProduct(int p_id,int u_id);

    Cart getCartByC_id(int cart_id);
    int getCartItemCount(User user);
}

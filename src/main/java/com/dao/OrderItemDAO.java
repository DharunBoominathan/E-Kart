package com.dao;

import com.model.OrderItem;
import com.model.User;

import java.util.List;

public interface OrderItemDAO {
    void addOrderItem(OrderItem orderItem);
    void removeOrderItem(OrderItem orderItem);
    void removeOrderItem(int orderItem_Id);
    List<OrderItem> getUserOrderItems(User user);
    int getOrderCountOfProduct(int p_id);
}

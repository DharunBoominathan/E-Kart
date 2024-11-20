package com.dao;

import com.model.Order;
import com.model.OrderItem;
import com.model.User;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

public interface OrderDAO {
    void connect();

    void newOrder(Order order);
    boolean updateOrder(Order order, List<OrderItem> orderItemList);
    void removeOrder(Order order);
    void removeOrder(int orderId);
    List<Order> getUserOrders(User user);
    List<Order> getAllOrders();

    Order getOrderById(int orderId);
    void updateOrder(Order order);
    List<Order> searchOrders(String query);

    int getTotalOrders();
    double getTotalOrderPrices();
    Map<String, Integer> getOrdersPerDayOrMonth(boolean perMonth);

    List<Order> getFilteredOrders(LocalDate fromDate, LocalDate toDate, String product, String user, String status);

}

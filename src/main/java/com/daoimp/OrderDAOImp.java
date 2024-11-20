package com.daoimp;

import com.connection.SessionManager;
import com.dao.OrderDAO;
import com.model.Order;
import com.model.OrderItem;
import com.model.User;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class OrderDAOImp implements OrderDAO {

    Session session;
    Transaction transaction=null;
    @Override
    public void connect(){
        try{
            session= new SessionManager().getSession();
        }
        catch (Exception e){
            e.printStackTrace();
        }
    }

    @Override
    public void newOrder(Order order) {

        try{
            transaction=session.beginTransaction();
            session.persist(order);
            transaction.commit();
        }
        catch (Exception e){
            e.printStackTrace();
        }
    }
    public boolean updateOrder(Order order, List<OrderItem> orderItemList){
        try{
            transaction=session.beginTransaction();
            order.setOrderItems(orderItemList);
            session.merge(order);
            transaction.commit();
            return true;
        }
        catch (Exception e) {
            e.printStackTrace();
            return false;

        }
    }

    @Override
    public void removeOrder(Order order) {
        try{
            transaction=session.beginTransaction();
            session.remove(order);
            transaction.commit();
        }
        catch (Exception e){
            e.printStackTrace();
        }

    }

    @Override
    public void removeOrder(int orderId) {
        Order order=getOrderById(orderId);
        removeOrder(order);
    }
    @Override
    public Order getOrderById(int id){
        String hql = "FROM Order o WHERE o.order_id=:id";
        Query<Order> query = session.createQuery(hql, Order.class);
        query.setParameter("id", id);
        Order res = query.list().get(0);
        return res;
    }

    @Override
    public void updateOrder(Order order) {
        try{
            transaction=session.beginTransaction();
            session.merge(order);
            transaction.commit();
        }
        catch (Exception e){
            e.printStackTrace();
        }
    }

    public List<Order> getUserOrders(User user){
        String hql = "FROM Order o WHERE o.user.u_id=:u_id";
        Query<Order> query = session.createQuery(hql, Order.class);
        query.setParameter("u_id", user.getU_id());
        List<Order> res = query.list();
        return res;
    }
    public List<Order> getAllOrders(){
        String hql = "FROM Order";
        Query<Order> query = session.createQuery(hql, Order.class);
        List<Order> res = query.list();
        return res;
    }
    public List<Order> searchOrders(String searchQuery) {
        String hql = "SELECT DISTINCT o FROM Order o " +
                "JOIN o.user u " +
                "JOIN o.orderItems oi " +
                "JOIN oi.product p " +
                "WHERE u.name LIKE :query " +
                "OR p.name LIKE :query " +
                "OR o.paymentType LIKE :query " +
                "OR CAST(o.order_id AS string) LIKE :query";
        Query query = session.createQuery(hql);
        query.setParameter("query", "%" + searchQuery + "%");
        List<Order> results = query.getResultList();
        return results;
    }

    @Override
    public int getTotalOrders() {
        String hql = "SELECT COUNT(o) FROM Order o";
        Query<Long> query = session.createQuery(hql, Long.class);
        return query.uniqueResult().intValue();
    }

    @Override
    public double getTotalOrderPrices() {
        String hql = "SELECT SUM(o.totalPrice) FROM Order o";
        Query<Number> query = session.createQuery(hql, Number.class);
        Number totalPrice = query.uniqueResult();
        return totalPrice != null ? totalPrice.doubleValue() : 0.0;
    }

    @Override
    public Map<String, Integer> getOrdersPerDayOrMonth(boolean perMonth) {
        String hql = perMonth
                ? "SELECT FUNCTION('DATE_FORMAT', o.orderDate, '%Y-%m') AS period, COUNT(o) FROM Order o GROUP BY period"
                : "SELECT FUNCTION('DATE', o.orderDate) AS period, COUNT(o) FROM Order o GROUP BY period";

        Query<Object[]> query = session.createQuery(hql, Object[].class);
        List<Object[]> results = query.getResultList();

        DateTimeFormatter formatter = perMonth ? DateTimeFormatter.ofPattern("yyyy-MM") : DateTimeFormatter.ofPattern("yyyy-MM-dd");

        Map<String, Integer> ordersCount = new HashMap<>();
        for (Object[] result : results) {
            String period;
            if (result[0] instanceof java.sql.Date) {
                LocalDate date = ((java.sql.Date) result[0]).toLocalDate(); // Convert java.sql.Date to LocalDate
                period = date.format(formatter);
            } else {
                period = (String) result[0];
            }
            ordersCount.put(period, ((Long) result[1]).intValue());
        }
        return ordersCount;
    }

    public List<Order> getFilteredOrders(LocalDate fromDate, LocalDate toDate, String product, String user, String status) {

        List<Order> orders = null;

        StringBuilder hql = new StringBuilder("FROM Order o JOIN o.user u JOIN o.orderItems oi JOIN oi.product p WHERE 1=1");

            if (fromDate != null) {
                hql.append(" AND o.orderDate >= :fromDate");
            }
            if (toDate != null) {
                hql.append(" AND o.orderDate <= :toDate");
            }
            if (product != null && !product.isEmpty()) {
                hql.append(" AND p.name LIKE :product");
            }
            if (user != null && !user.isEmpty()) {
                hql.append(" AND u.email LIKE :user");
            }
            if (status != null && !status.isEmpty()) {
                hql.append(" AND o.status = :status");
            }

            Query query = session.createQuery(hql.toString());

            if (fromDate != null) {
                query.setParameter("fromDate", fromDate);
            }
            if (toDate != null) {
                query.setParameter("toDate", toDate);
            }
            if (product != null && !product.isEmpty()) {
                query.setParameter("product", "%" + product + "%");
            }
            if (user != null && !user.isEmpty()) {
                query.setParameter("user", "%" + user + "%");
            }
            if (status != null && !status.isEmpty()) {
                query.setParameter("status", status);
            }

            orders = query.list();


        return orders;
    }



}

package com.daoimp;

import com.connection.SessionManager;
import com.dao.OrderItemDAO;
import com.model.Cart;
import com.model.OrderItem;
import com.model.User;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;

public class OrderItemDAOImp implements OrderItemDAO {

    Session session;
    Transaction transaction=null;
    public OrderItemDAOImp(){
        try{
            session= new SessionManager().getSession();
        }
        catch (Exception e){
            e.printStackTrace();
        }
    }
    @Override
    public void addOrderItem(OrderItem orderItem) {
        try{
            transaction=session.beginTransaction();
            session.persist(orderItem);
            transaction.commit();
        }
        catch (Exception e){
            e.printStackTrace();
        }
    }

    @Override
    public void removeOrderItem(OrderItem orderItem) {
        try{
            transaction=session.beginTransaction();
            session.remove(orderItem);
            transaction.commit();
        }
        catch (Exception e){
            e.printStackTrace();
        }
    }

    @Override
    public void removeOrderItem(int orderItem_Id) {
            OrderItem orderItem=getOrderItemById(orderItem_Id);
            removeOrderItem(orderItem);
    }

    public OrderItem getOrderItemById(int id){
        String hql = "FROM OrderItem o WHERE o.order_item_id=:id";
        Query<OrderItem> query = session.createQuery(hql, OrderItem.class);
        query.setParameter("id", id);
        OrderItem res = query.list().get(0);
        return res;
    }

    public List<OrderItem> getUserOrderItems(User user){
        String hql = "FROM OrderItem o WHERE o.user.u_id=:u_id";
        Query<OrderItem> query = session.createQuery(hql, OrderItem.class);
        query.setParameter("u_id", user.getU_id());
        List<OrderItem> res = query.list();
        return res;
    }
    public int getOrderCountOfProduct(int p_id){
        String hql = "FROM OrderItem o WHERE o.product.p_id=:p_id";
        Query<OrderItem> query = session.createQuery(hql, OrderItem.class);
        query.setParameter("p_id", p_id);
        List<OrderItem> res = query.list();
        return res.size();

    }
}

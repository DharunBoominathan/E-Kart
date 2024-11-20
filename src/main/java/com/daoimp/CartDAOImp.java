package com.daoimp;


import com.connection.SessionManager;
import com.dao.CartDAO;
import com.model.User;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.model.Cart;
import org.hibernate.query.Query;

import java.sql.Array;
import java.util.List;

public class CartDAOImp implements CartDAO {
    Session session;
    Transaction transaction=null;
    public CartDAOImp(){
        try{
            session= new SessionManager().getSession();
        }
        catch (Exception e){
            e.printStackTrace();
        }
    }
    @Override
    public int addCart(Cart cart) {
        Cart existingCart = getExistingCart(cart);

        if (existingCart != null) {
            if (existingCart.getQuantity() == cart.getQuantity()) return 0;//already in cart
            else {
                if (setCartQuantity(existingCart,cart.getQuantity())) return 1;
                else return -1;
            }
        }
        else{
                try {
                    transaction = session.beginTransaction();
                    session.persist(cart);
                    transaction.commit();
                    return 2;//addded
                } catch (Exception e) {
                    e.printStackTrace();
                    if (transaction != null) {
                        transaction.rollback();
                    }
                    return -1;
                } finally {
                    session.close();
                }
            }
    }
    @Override
    public boolean setCartQuantity(int cart_id,int q){
        Cart cart=getCartByC_id(cart_id);
        try{
            transaction=session.beginTransaction();
            cart.setQuantity(q);
            session.merge(cart);
            transaction.commit();
            return true;//updated
        }
        catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            session.close();
        }
    }

    //method overloading
    public boolean setCartQuantity(Cart cart,int q){
        try{
            transaction=session.beginTransaction();
            cart.setQuantity(q);
            session.merge(cart);
            transaction.commit();
            return true;//updated
        }
        catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            session.close();
        }
    }



    public Cart getExistingCart(Cart cart){
        String hql = "FROM Cart c WHERE c.product.p_id = :p_id AND c.user.u_id=:u_id";
        Query<Cart> query = session.createQuery(hql, Cart.class);
        query.setParameter("p_id", cart.getProduct().getP_id());
        query.setParameter("u_id", cart.getUser().getU_id());
        List<Cart> res = query.list();
        return res.isEmpty()? null:res.get(0);
    }

    public List<Cart> getUserCart(User user){
        String hql = "FROM Cart c WHERE c.user.u_id=:u_id";
        Query<Cart> query = session.createQuery(hql, Cart.class);
        query.setParameter("u_id", user.getU_id());
        List<Cart> res = query.list();
        return res;
    }

    @Override
    public int removeUserProduct(int p_id,int u_id) {
        Cart cart = getUserCartProduct(p_id, u_id);
        if (cart != null) {
            try {
                transaction = session.beginTransaction();
                session.remove(cart);
                transaction.commit();
                return 1;
            } catch (Exception e) {
                e.printStackTrace();
                if (transaction != null) {
                    transaction.rollback();
                }
                return 0;
            } finally {
                session.close();
            }
        }
        else{
            return 0;
        }


    }

    public Cart getUserCartProduct(int p_id,int u_id) {
        try {
            String hql = "From Cart c WHERE c.product.p_id= :p_id AND c.user.u_id= :u_id";
            Query<Cart> query = session.createQuery(hql, Cart.class);
            query.setParameter("p_id", p_id);
            query.setParameter("u_id", u_id);
            Cart res = query.list().get(0);
            return res;
        }
        catch (Exception e){
            e.printStackTrace();
            return null;
        }

    }

    @Override
    public Cart getCartByC_id(int c_id){
        try {
            String hql = "From Cart c WHERE c.cart_id=:c_id";
            Query<Cart> query = session.createQuery(hql, Cart.class);
            query.setParameter("c_id", c_id);
            Cart res = query.list().get(0);
            return res;
        }
        catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public int getCartItemCount(User user) {
        List<Cart> cart=getUserCart(user);
        return cart.size();
    }
}



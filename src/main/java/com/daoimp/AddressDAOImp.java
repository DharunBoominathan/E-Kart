package com.daoimp;

import com.connection.SessionManager;
import com.dao.AddressDAO;
import com.model.Address;
import com.model.User;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;
import java.util.Queue;

public class AddressDAOImp implements AddressDAO {
    private Session session;
    Transaction transaction = null;

    public AddressDAOImp() {
        try {
            session=new SessionManager().getSession();
        }
        catch(Exception e) {
            e.printStackTrace();
        }
    }
    @Override
    public void addAddress(Address address) {
        try{
            transaction=session.getTransaction();
            transaction.begin();
            session.persist(address);
            transaction.commit();
        }
        catch (Exception e){
            e.printStackTrace();
        }
        finally {
            session.close();
        }
    }

    @Override
    public List<Address> getUserAddresses(User user) {
        String hql="FROM Address a WHERE a.user.u_id=:u_id";
        Query<Address> query=session.createQuery(hql, Address.class);
        query.setParameter("u_id",user.getU_id());
        List<Address> res=query.list();
        return res;
    }

    @Override
    public Address getAddressById(int addr_id) {
        String hql="FROM Address a WHERE a.addr_id=:addr_id";
        Query<Address> query=session.createQuery(hql, Address.class);
        query.setParameter("addr_id",addr_id);
        Address res=query.list().get(0);
        return res;
    }

    @Override
    public void deleteAddress(int addr_id) {
        Address address=getAddressById(addr_id);
        try{
            transaction=session.beginTransaction();
            session.remove(address);
            transaction.commit();
        }
        catch (Exception e){
            e.printStackTrace();
        }
        finally {
            session.close();
        }

    }

    @Override
    public void updateAddress(Address address) {
        try{
            transaction=session.beginTransaction();
            session.merge(address);
            transaction.commit();
        }
        catch (Exception e){
            e.printStackTrace();
        }
        finally {
            session.close();
        }
    }
}

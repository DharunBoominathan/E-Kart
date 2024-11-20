package com.daoimp;


import java.time.LocalDate;
import java.time.Period;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import com.connection.SessionManager;
import com.dao.UserDAO;
import com.model.User;
import org.mindrot.jbcrypt.BCrypt;

public class UserDAOImp implements UserDAO {
    private Session session;
    Transaction transaction = null;
    public UserDAOImp() {
        try {
            session=new SessionManager().getSession();
        }
        catch(Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public boolean emailExists(String email) {
        String hql = "FROM User u WHERE u.email = :email";
        Query<User> query = session.createQuery(hql, User.class);
        query.setParameter("email", email);
        List<User> res = query.list();
        return !res.isEmpty();
    }

    @Override
    public boolean phoneExists(String phone) {
        String hql = "FROM User u WHERE u.phone = :phone";
        Query<User> query = session.createQuery(hql, User.class);
        query.setParameter("phone", phone);
        List<User> res = query.list();
        return !res.isEmpty();
    }


    @Override
    public void addUser(User u){
        try {
            transaction = session.beginTransaction();
            session.persist(u);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
        finally {
            session.close();
        }
    }

    @Override
    public int verify_user(String u_name, String pass) {
        String hgl="FROM User u WHERE (u.email = :uname OR u.phone = :uname)";
        Query<User> query=session.createQuery(hgl,User.class);
        query.setParameter("uname", u_name);
        List<User> res = query.list();
        System.out.print(u_name+"  "+pass);
        if (!res.isEmpty()) {
            User user = res.get(0);
            String hashedPassword = user.getPass();
            if(BCrypt.checkpw(pass, hashedPassword)) return res.get(0).getU_id();
            else return 0;
        }
        else {
            return 0;
        }

    }
    @Override
    public User getUser(int id){
        User user = null;
        try {
            transaction = session.beginTransaction();
            user = session.get(User.class, id);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
        return user;
    }

    @Override
    public void updateUser(User u) {
        try {
            transaction = session.beginTransaction();
            session.merge(u);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
        finally {
            session.close();
        }
    }

    @Override
    public List<User> getAllUsers() {
        String hql = "FROM User u";
        Query<User> query = session.createQuery(hql, User.class);
        List<User> res = query.list();
        return res;
    }

    @Override
    public int getTotalUsers() {
        String hql = "SELECT COUNT(u) FROM User u";
        Query<Long> query = session.createQuery(hql, Long.class);
        return query.uniqueResult().intValue();
    }
    @Override
    public Map<String, Integer> getUsersByAgeGroup() {

        List<User> users = getAllUsers();

        Map<String, Integer> ageGroupCount = new HashMap<>();
        for (User user : users) {
            int age = Period.between(user.getDob(), LocalDate.now()).getYears();
            String ageGroup;
            if (age >= 18 && age <= 25) {
                ageGroup = "18-25";
            } else if (age >= 26 && age <= 35) {
                ageGroup = "26-35";
            } else if (age >= 36 && age <= 50) {
                ageGroup = "36-50";
            } else {
                ageGroup = "51+";
            }

            ageGroupCount.put(ageGroup, ageGroupCount.getOrDefault(ageGroup, 0) + 1);
        }
        return ageGroupCount;
    }


    }

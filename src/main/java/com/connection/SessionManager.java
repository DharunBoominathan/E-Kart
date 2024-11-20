package com.connection;

import com.model.*;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

public class SessionManager {
    private static final SessionFactory sessionFactory = buildSessionFactory();
        private Session session;

    private static SessionFactory buildSessionFactory() {
        try {
            return new Configuration()
                    .configure()
                    .addAnnotatedClass(User.class)
                    .addAnnotatedClass(Address.class)
                    .addAnnotatedClass(Product.class)
                    .addAnnotatedClass(Cart.class)
                    .addAnnotatedClass(Order.class)
                    .addAnnotatedClass(OrderItem.class)
                    .buildSessionFactory();
        } catch (Exception e) {
            System.err.println("Initial SessionFactory creation failed." + e);
            throw new ExceptionInInitializerError(e);
        }
    }



    public Session getSession() {
        return sessionFactory.openSession();
    }


    public void close(Session session) {
        if (session != null && session.isOpen()) {
            session.close();
        }
    }

    public static void shutdown() {
        if (sessionFactory != null && !sessionFactory.isClosed()) {
            sessionFactory.close();
        }
    }
}


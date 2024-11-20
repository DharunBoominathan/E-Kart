package com.daoimp;

import com.connection.SessionManager;
import com.dao.ProductDAO;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.*;

import com.model.Product;

public class ProductDAOImp implements ProductDAO {
    private Session session;
    Transaction transaction = null;

    public ProductDAOImp() {
        try {
            session=new SessionManager().getSession();
        }
        catch(Exception e) {
            e.printStackTrace();
        }
    }
    @Override
    public List<Product> getAllProducts() {
        List<Product> productList = null;
        try {
            transaction = session.beginTransaction();
            Query<Product> query = session.createQuery("from Product", Product.class);
            productList = query.list();
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        } finally {
            session.close();
        }

        return productList;
    }
    @Override
    public int addProduct(Product product){
        try {
            transaction = session.beginTransaction();
            session.persist(product);
            transaction.commit();
            return 1;
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
            return 0;
        }
        finally {
            session.close();
        }
    }
    @Override
    public Product getProductById(int id) {
        Product product = null;
        try {
            transaction = session.beginTransaction();
            product = session.get(Product.class, id);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
        return product;
    }

    @Override
    public void updateStock(int id, int quantity) {
        Product product=getProductById(id);
        try {
            transaction = session.beginTransaction();
            int newStock=product.getStock()+quantity;
            product.setStock(newStock);
            session.merge(product);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }

    }

    @Override
    public List<String> getSuggestions(String searchQuery) {
        List<String> res=null;
        try {
            String nameHql = "SELECT DISTINCT p.name FROM Product p WHERE p.name LIKE :query";
            String brandHql = "SELECT DISTINCT p.brand FROM Product p WHERE p.brand LIKE :query";
            String categoryHql = "SELECT DISTINCT p.category FROM Product p WHERE p.category LIKE :query";

            String queryParam = "%" + searchQuery + "%";

            List<String> names = session.createQuery(nameHql, String.class)
                    .setParameter("query", queryParam)
                    .getResultList();

            List<String> brands = session.createQuery(brandHql, String.class)
                    .setParameter("query", queryParam)
                    .getResultList();

            List<String> categories = session.createQuery(categoryHql, String.class)
                    .setParameter("query", queryParam)
                    .getResultList();


            Set<String> combinedResults = new HashSet<>();
            combinedResults.addAll(names);
            combinedResults.addAll(brands);
            combinedResults.addAll(categories);

            List<String> suggestions = new ArrayList<>(combinedResults);
            return suggestions;

        } finally {
            session.close();
        }


    }

    @Override
    public List<Product> searchProducts(String query) {
            List<Product> products = new ArrayList<>();
            try {
                String hql = "FROM Product p " +
                        "WHERE p.name LIKE :query " +
                        "   OR p.category LIKE :query " +
                        "   OR p.brand LIKE :query";

                Query<Product> hQuery = session.createQuery(hql, Product.class);
                hQuery.setParameter("query", "%" + query + "%");
                products = hQuery.list();
            } catch (Exception e) {
                e.printStackTrace();
            }
            finally {
                session.close();
            }
            return products;

    }

    @Override
    public int getTotalProducts() {
        String hql = "SELECT COUNT(p) FROM Product p";
        Query<Long> query = session.createQuery(hql, Long.class);
        return query.uniqueResult().intValue();
    }

    @Override
    public Map<String, Integer> getProductsBySales() {
        String hql = """
                SELECT p.name, SUM(oi.quantity)
                FROM OrderItem oi
                JOIN oi.product p
                GROUP BY p.name
                """;
        Query<Object[]> query = session.createQuery(hql, Object[].class);
        List<Object[]> results = query.getResultList();

        Map<String, Integer> productSales = new HashMap<>();
        for (Object[] result : results) {
            productSales.put((String) result[0], ((Long) result[1]).intValue());
        }
        return productSales;
    }
    @Override
    public boolean updateProduct(Product product){
        try {
            transaction = session.beginTransaction();
            session.merge(product);
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteProduct(Product product) {
        try {
            transaction = session.beginTransaction();
            session.remove(product);
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
            return false;
        }
    }

}

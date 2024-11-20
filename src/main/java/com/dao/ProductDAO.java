package com.dao;

import com.model.Product;

import java.util.List;
import java.util.Map;

public interface ProductDAO {
    List<Product> getAllProducts();
    int addProduct(Product product);
    Product getProductById(int id);
    void updateStock(int id,int quantity);
    List<String> getSuggestions(String query);
    List<Product> searchProducts(String query);
    int getTotalProducts();
    Map<String, Integer> getProductsBySales();

    boolean updateProduct(Product product);
    boolean deleteProduct(Product product);
}

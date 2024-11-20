package com.controller;

import com.daoimp.ProductDAOImp;
import com.model.Cart;
import com.model.Product;
import com.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;


@WebServlet("/orderAgainServlet")
public class OrderAgainServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String selectedOrderItems = req.getParameter("selectedOrderItems");
            User user=(User)req.getSession().getAttribute("user");
            List<Cart> selectedItems = new ArrayList<>();

        if (selectedOrderItems == null || selectedOrderItems.isEmpty()) {
            req.getSession().setAttribute("error", "Please select items to proceed.");
            resp.sendRedirect("orderHistory.jsp");
        }
        else if(user==null) {
            resp.sendRedirect("login.jsp");
        }
        else {
            String[] items = selectedOrderItems.split(";");
            int i=-10;
            for (String item : items) {
                String[] parts = item.split(",");
                int productId = Integer.parseInt(parts[0]);
                int quantity = Integer.parseInt(parts[1]);
                Product product=new ProductDAOImp().getProductById(productId);
                selectedItems.add(new Cart(i,user,product,quantity));
                i++;

            }
            req.getSession().setAttribute("selectedItems", selectedItems);
            resp.sendRedirect(req.getContextPath()+"/order.jsp");
        }
    }
}

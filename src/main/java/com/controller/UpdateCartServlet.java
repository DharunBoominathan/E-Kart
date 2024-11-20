package com.controller;

// Import necessary classes
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.dao.CartDAO;
import com.daoimp.CartDAOImp;

@WebServlet("/updateCartServlet")
public class UpdateCartServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int cartId = Integer.parseInt(request.getParameter("cart_id"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));


        CartDAO cartDAO = new CartDAOImp();
        boolean isUpdated = cartDAO.setCartQuantity(cartId, quantity);

        if (isUpdated) {
            response.setStatus(HttpServletResponse.SC_OK);
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}

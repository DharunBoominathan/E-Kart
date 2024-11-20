package com.controller;

import com.dao.CartDAO;
import com.daoimp.CartDAOImp;
import com.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
@WebServlet("/cartServlet")
public class CartServlet extends HttpServlet{

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        User user=(User) req.getSession().getAttribute("user");
        if (user == null) {
            req.getSession().setAttribute("view_cart", "Please login to your account to check your cart");
            resp.sendRedirect("login.jsp");
        } else {
            resp.sendRedirect("cart.jsp");
        }
    }
}
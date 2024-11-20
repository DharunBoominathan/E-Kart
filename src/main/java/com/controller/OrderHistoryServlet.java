package com.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
@WebServlet("/orderHistoryServlet")
public class OrderHistoryServlet extends HttpServlet{
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        HttpSession session=req.getSession();
        if (session.getAttribute("user") == null) {
            session.setAttribute("view_cart", "Please login to your account to check your Orders");
            resp.sendRedirect("login.jsp");
        } else {
            resp.sendRedirect("orderHistory.jsp");
        }
    }
}
package com.controller.AdminServlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/adminLoginServlet")
public class AdminLoginServlet extends HttpServlet {
    // Hardcoded credentials for simplicity; ideally, this should come from a secure database.
    private static final String ADMIN_USERNAME = "admin";
    private static final String ADMIN_PASSWORD = "admin123";
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        if (ADMIN_USERNAME.equals(username) && ADMIN_PASSWORD.equals(password)) {
            HttpSession session = req.getSession();
            session.setAttribute("isAdminLoggedIn", true);
            resp.sendRedirect("admin/main.jsp");
        } else {
            req.setAttribute("error","Invalid credentials");
            req.getRequestDispatcher("admin/adminLogin.jsp").forward(req,resp);
        }
    }
}
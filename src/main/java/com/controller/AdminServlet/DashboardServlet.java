package com.controller.AdminServlet;

import com.dao.OrderDAO;
import com.dao.ProductDAO;
import com.dao.UserDAO;
import com.daoimp.OrderDAOImp;
import com.daoimp.ProductDAOImp;
import com.daoimp.UserDAOImp;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Map;
@WebServlet("/dashboardServlet")
public class DashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        UserDAO userDAO = new UserDAOImp();
        OrderDAO orderDAO = new OrderDAOImp();
        orderDAO.connect();
        ProductDAO productDAO = new ProductDAOImp();

        int totalUsers = userDAO.getTotalUsers();
        int totalOrders = orderDAO.getTotalOrders();
        int totalProducts = productDAO.getTotalProducts();
        double totalOrderPrices = orderDAO.getTotalOrderPrices();

        Map<String, Integer> ordersPerDayOrMonth = orderDAO.getOrdersPerDayOrMonth(false); // Per day
        Map<String, Integer> usersByAgeGroup = userDAO.getUsersByAgeGroup();
        Map<String, Integer> productsBySales = productDAO.getProductsBySales();

        req.setAttribute("totalUsers", totalUsers);
        req.setAttribute("totalOrders", totalOrders);
        req.setAttribute("totalProducts", totalProducts);
        req.setAttribute("totalOrderPrices", totalOrderPrices);
        req.setAttribute("ordersPerDayOrMonth", ordersPerDayOrMonth);
        req.setAttribute("usersByAgeGroup", usersByAgeGroup);
        req.setAttribute("productsBySales", productsBySales);


        req.getRequestDispatcher("admin/dashboard.jsp").forward(req, resp);
    }
}

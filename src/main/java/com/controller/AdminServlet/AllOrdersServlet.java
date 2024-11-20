package com.controller.AdminServlet;

import com.dao.OrderDAO;
import com.daoimp.OrderDAOImp;
import com.model.Order;
import com.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/allOrdersServlet")
public class AllOrdersServlet extends HttpServlet {
    protected void doGet (HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        OrderDAO orderDAO=new OrderDAOImp();
        orderDAO.connect();
        List<Order> results=orderDAO.getAllOrders();
        int currentPage = Integer.parseInt(req.getParameter("page") != null ? req.getParameter("page") : "1");
        int ordersPerPage = 10;

        int totalProducts = results.size();
        int totalPages = (int) Math.ceil((double) totalProducts / ordersPerPage);

        // Paginate results
        int startIndex = (currentPage - 1) * ordersPerPage;
        int endIndex = Math.min(startIndex + ordersPerPage, totalProducts);
        List<Order> paginatedResults = results.subList(startIndex, endIndex);

        req.setAttribute("results", paginatedResults);
        req.setAttribute("currentPage", currentPage);
        req.setAttribute("totalPages", totalPages);

        req.getRequestDispatcher("admin/orders.jsp").forward(req, resp);

    }
}

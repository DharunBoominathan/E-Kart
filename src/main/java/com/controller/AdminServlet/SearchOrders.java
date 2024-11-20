package com.controller.AdminServlet;

import com.dao.OrderDAO;
import com.daoimp.OrderDAOImp;
import com.model.Order;
import com.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpServletRequest;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@WebServlet("/searchOrders")
public class SearchOrders extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String fromDateStr = req.getParameter("fromDate");
        String toDateStr = req.getParameter("toDate");
        String product = req.getParameter("product");
        String user = req.getParameter("user");
        String orderStatus = req.getParameter("status");

        LocalDate fromDate = (fromDateStr != null && !fromDateStr.isEmpty()) ? LocalDate.parse(fromDateStr) : null;
        LocalDate toDate = (toDateStr != null && !toDateStr.isEmpty()) ? LocalDate.parse(toDateStr) : null;

        int currentPage = Integer.parseInt(req.getParameter("page") != null ? req.getParameter("page") : "1");
        int ordersPerPage = 10;


        OrderDAO orderDAO=new OrderDAOImp();
        orderDAO.connect();
        List<Order> filteredOrders = orderDAO.getFilteredOrders(fromDate, toDate, product, user, orderStatus);
        int totalProducts = filteredOrders.size();
        int totalPages = (int) Math.ceil((double) totalProducts / ordersPerPage);

        // Paginate results
        int startIndex = (currentPage - 1) * ordersPerPage;
        int endIndex = Math.min(startIndex + ordersPerPage, totalProducts);
        List<Order> paginatedResults = filteredOrders.subList(startIndex, endIndex);

        req.setAttribute("results", paginatedResults);
        req.setAttribute("currentPage", currentPage);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("filters", Map.of(
                "fromDate", fromDate,
                "toDate", toDate,
                "product", product,
                "user", user,
                "status", orderStatus
        ));
        req.getRequestDispatcher("admin/orders.jsp").forward(req, resp);
    }
}

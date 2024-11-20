package com.controller.AdminServlet;


import com.dao.UserDAO;
import com.daoimp.UserDAOImp;
import com.model.Order;
import com.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
@WebServlet("/allUsersServlet")
public class AllUsersServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserDAO userDAO = new UserDAOImp();
        List<User> results = userDAO.getAllUsers();
        int currentPage = Integer.parseInt(req.getParameter("page") != null ? req.getParameter("page") : "1");
        int ordersPerPage = 15;

        int totalProducts = results.size();
        int totalPages = (int) Math.ceil((double) totalProducts / ordersPerPage);

        // Paginate results
        int startIndex = (currentPage - 1) * ordersPerPage;
        int endIndex = Math.min(startIndex + ordersPerPage, totalProducts);
        List<User> paginatedResults = results.subList(startIndex, endIndex);

        req.setAttribute("results", paginatedResults);
        req.setAttribute("currentPage", currentPage);
        req.setAttribute("totalPages", totalPages);

        req.getRequestDispatcher("admin/users.jsp").forward(req, resp);

    }
}

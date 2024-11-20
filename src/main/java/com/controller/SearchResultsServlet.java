package com.controller;

import com.dao.ProductDAO;
import com.daoimp.ProductDAOImp;
import com.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/searchResultsServlet")
public class SearchResultsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException, IOException {
        String query = req.getParameter("query");
        int currentPage = Integer.parseInt(req.getParameter("page") != null ? req.getParameter("page") : "1");
        int productsPerPage = 8;
        String src= req.getParameter("src");

        // Fetch search results from the database
        ProductDAO productDAO=new ProductDAOImp();
        List<Product> results = productDAO.searchProducts(query);
        int totalProducts = results.size();
        int totalPages = (int) Math.ceil((double) totalProducts / productsPerPage);

        // Paginate results
        int startIndex = (currentPage - 1) * productsPerPage;
        int endIndex = Math.min(startIndex + productsPerPage, totalProducts);
        List<Product> paginatedResults = results.subList(startIndex, endIndex);

        req.setAttribute("results", paginatedResults);
        req.setAttribute("currentPage", currentPage);
        req.setAttribute("totalPages", totalPages);
        if(src!=null)  req.getRequestDispatcher("admin/products.jsp").forward(req, resp);
        else req.getRequestDispatcher("/searchResults.jsp").forward(req, resp);
    }
}

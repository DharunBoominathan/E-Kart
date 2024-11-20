package com.controller;

import com.dao.ProductDAO;
import com.daoimp.ProductDAOImp;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/searchSuggestions")
public class SearchSuggestionsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        String query = req.getParameter("query");
        resp.setContentType("application/json");

        // Simulated database query
        ProductDAO productDAO=new ProductDAOImp();
        List<String> suggestions = productDAO.getSuggestions(query);

        // Convert list to JSON
        String json = new Gson().toJson(suggestions);
        resp.getWriter().write(json);
    }
}

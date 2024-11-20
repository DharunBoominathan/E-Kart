package com.controller;

import com.daoimp.AddressDAOImp;
import com.model.Address;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
@WebServlet("/editAddressServlet")
public class EditAddressServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String editAddressId = request.getParameter("editAddressId");
        if (editAddressId != null) {
            Address address = new AddressDAOImp().getAddressById(Integer.parseInt(editAddressId));
            request.setAttribute("editAddress", address);
        }
        request.getRequestDispatcher("addAddress.jsp").forward(request, response);
    }
}
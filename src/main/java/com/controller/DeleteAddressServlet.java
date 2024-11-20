package com.controller;

import com.dao.AddressDAO;
import com.daoimp.AddressDAOImp;
import com.model.Address;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
@WebServlet("/deleteAddressServlet")
public class DeleteAddressServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
        int deleteAddressId = Integer.parseInt(req.getParameter("addressId"));
        AddressDAO addressDAO=new AddressDAOImp();
        addressDAO.deleteAddress(deleteAddressId);
        req.getSession().setAttribute("success","Address"+deleteAddressId+"is deleted");
        resp.sendRedirect("manageAddress.jsp");
    }
}

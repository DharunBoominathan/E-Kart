package com.controller;

import com.dao.AddressDAO;
import com.daoimp.AddressDAOImp;
import com.model.Address;
import com.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/addAddressServlet")
public class AddAddressServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException{
        User user=(User)req.getSession().getAttribute("user");
        if(user==null){
            req.getSession().setAttribute("error", "Please login to your account to order product");
            resp.sendRedirect(req.getContextPath()+"/login.jsp");
        }
        String fullName=req.getParameter("fullName");
        String phoneNumber=req.getParameter("phoneNumber");
        String addressLine1=req.getParameter("addressLine1");
        String addressLine2=req.getParameter("addressLine2");
        String city=req.getParameter("city");
        String state=req.getParameter("state");
        String pinCode=req.getParameter("pinCode");
        String addressId=req.getParameter("addressId");
        String src=req.getParameter("src");
        AddressDAO addressDAO=new AddressDAOImp();
        System.out.println(addressId);

        if (addressId == null || addressId.equals("")){
            Address address=new Address(user,fullName,phoneNumber,addressLine1,addressLine2,city,state,pinCode);
            addressDAO.addAddress(address);
        }
        else{
            Address address=addressDAO.getAddressById(Integer.parseInt(addressId));
            address.setFullName(fullName);
            address.setPhoneNumber(phoneNumber);
            address.setAddressLine1(addressLine1);
            address.setAddressLine2(addressLine2);
            address.setCity(city);
            address.setState(state);
            address.setPinCode(pinCode);
            addressDAO.updateAddress(address);
        }
        if(req.getSession().getAttribute("src")!=null){
            req.getSession().setAttribute("successMessage", "Account created successfully! Please log in.");
            req.getSession().removeAttribute("src");
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
        }
        else if (!src.equals("")) {
            if (addressId != null || !addressId.equals("")) {
                req.getSession().setAttribute("success", "Changes have been made in Address"+addressId);
                req.getSession().removeAttribute(addressId);
                resp.sendRedirect(req.getContextPath() + "/manageAddress.jsp");
            }
            else{
            req.getSession().setAttribute("success", "New Address is added Successfully...");
            resp.sendRedirect(req.getContextPath() + "/manageAddress.jsp");
        }
        }
        else{
            req.getSession().setAttribute("successMessage", "new Address added successfully!");
            resp.sendRedirect(req.getContextPath() + "/order.jsp");
        }
    }
}

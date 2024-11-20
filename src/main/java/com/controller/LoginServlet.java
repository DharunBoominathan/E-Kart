package com.controller;

import java.io.IOException;

import com.dao.UserDAO;
import com.daoimp.UserDAOImp;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/loginservlet")
public class LoginServlet extends HttpServlet{

    protected void doPost(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException{

        UserDAO userimp=new UserDAOImp();

        String u_name=req.getParameter("username");
        String pass=req.getParameter("password");

        int u_id=userimp.verify_user(u_name,pass);

        if(u_id!=0) {
            req.getSession().setAttribute("successMessage", "Logined successfully!");
            req.getSession().setAttribute("user", userimp.getUser(u_id));
            String productId = req.getParameter("p_id");
            if(productId != null && !productId.equals("null")) {
                resp.sendRedirect(req.getContextPath() + "/productDetails.jsp?id="+productId);
            }
            else{
                resp.sendRedirect(req.getContextPath() + "/home.jsp");
            }
        }
        else {
            req.setAttribute("error", "Email or Password is incorrect");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }


    }


}

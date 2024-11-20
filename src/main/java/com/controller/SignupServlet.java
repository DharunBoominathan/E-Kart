package com.controller;


import java.io.IOException;
import java.time.LocalDate;

import com.dao.UserDAO;
import com.daoimp.UserDAOImp;
import com.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/signupservlet")
public class SignupServlet extends HttpServlet{


    protected void doPost(HttpServletRequest req,HttpServletResponse resp) throws ServletException,IOException{

        UserDAO userimp=new UserDAOImp();

        String name=req.getParameter("name");
        String email=req.getParameter("email");
        LocalDate date=LocalDate.parse(req.getParameter("dob"));
        String phone=req.getParameter("phone");
        String pass=req.getParameter("password");
        String c_pass=req.getParameter("confirm_password");

        if (!pass.equals(c_pass)) {
            req.setAttribute("error", "Passwords do not match.");
            req.getRequestDispatcher("/signup.jsp").forward(req, resp);
            return;
        }

        if (userimp.emailExists(email)) {
            req.setAttribute("emailError", "Email already exists");
            req.getRequestDispatcher("/signup.jsp").forward(req, resp);
            return;

        }
        if (userimp.phoneExists(phone)) {
            req.setAttribute("phoneError", "Phone number already exists");
            req.getRequestDispatcher("/signup.jsp").forward(req, resp);
            return;

        }

        User u=new User(name,email,date,phone,hashPassword(pass));
        new UserDAOImp().addUser(u);
        req.getSession().setAttribute("user",u);
        req.getSession().setAttribute("src","signup");
        resp.sendRedirect(req.getContextPath() + "/addAddress.jsp");

    }

    public static String hashPassword(String plainPassword) {
        int saltRounds = 12;
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(saltRounds));
    }

}
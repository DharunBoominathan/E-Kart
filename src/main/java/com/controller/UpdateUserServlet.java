package com.controller;


import com.dao.UserDAO;
import com.daoimp.UserDAOImp;
import com.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

@WebServlet("/updateUserServlet")
public class UpdateUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        // Assuming a User object and UserDAO are already defined
        User user = (User) request.getSession().getAttribute("user");
        if (user != null) {
            user.setName(name);
            user.setEmail(email);
            user.setPhone(phone);
            user.setPass(hashPassword(password));

            UserDAO userDAO = new UserDAOImp();
            userDAO.updateUser(user);


            request.getSession().setAttribute("user", user);

            request.getSession().setAttribute("success","Changes have been made successfully...");
            response.sendRedirect("profile.jsp");
        } else {
            response.sendRedirect("login.jsp");
        }
    }

    public static String hashPassword(String plainPassword) {
        int saltRounds = 12;
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(saltRounds));
    }
}

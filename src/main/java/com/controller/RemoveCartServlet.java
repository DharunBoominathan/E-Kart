package com.controller;

import com.dao.CartDAO;
import com.dao.ProductDAO;
import com.daoimp.CartDAOImp;
import com.daoimp.ProductDAOImp;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/removeCartServlet")
public class RemoveCartServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException{
            int p_id= Integer.parseInt(req.getParameter("product_id"));
            int u_id=Integer.parseInt(req.getParameter("user_id"));

            CartDAO cartDAO=new CartDAOImp();
            ProductDAO productDAO=new ProductDAOImp();
            int val=cartDAO.removeUserProduct(p_id,u_id);
            if(val==1){
                req.getSession().setAttribute("removeProduct",
                        "The "+productDAO.getProductById(p_id).getName()+" is removed from your cart");

                resp.sendRedirect(req.getContextPath()+"/cart.jsp");
            }
            else{
                req.getSession().setAttribute("removeProduct",
                        "There was an error deleting from the cart. Please try again. ");

                resp.sendRedirect(req.getContextPath()+"/cart.jsp");
            }
    }
}

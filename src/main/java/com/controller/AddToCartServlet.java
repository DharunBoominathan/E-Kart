package com.controller;

import com.dao.CartDAO;
import com.daoimp.CartDAOImp;
import com.daoimp.ProductDAOImp;
import com.model.Cart;
import com.model.Product;
import com.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
@WebServlet("/addToCartServlet")
public class AddToCartServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException{
        int p_id=Integer.parseInt(req.getParameter("productId"));
        int quantity=Integer.parseInt(req.getParameter("quantity"));

        Product product=new ProductDAOImp().getProductById(p_id);

        User user= (User) req.getSession().getAttribute("user");
        if(user==null){
            req.setAttribute("p_id",p_id);
            req.getRequestDispatcher("/login.jsp").forward(req,resp);
        }
        else{
            Cart cart=new Cart(user,product,quantity);
            CartDAO cartDAO= new CartDAOImp();
            int add_cart=cartDAO.addCart(cart);
            System.out.print(add_cart);
            if(add_cart==2){
                req.getSession().setAttribute("cartSuccess","The "+product.getName()+" is added succesfully to the cart.");
                resp.sendRedirect(req.getContextPath()+"/home.jsp");
            }
            else if(add_cart==1){
                req.getSession().setAttribute("cartSuccess","The "+product.getName()+" is updated succesfully in the cart.");
                resp.sendRedirect(req.getContextPath()+"/home.jsp");
            }
            else if(add_cart==0){
                req.getSession().setAttribute("cartInfo","The "+product.getName()+" is already present in the cart.");
                resp.sendRedirect(req.getContextPath()+"/productDetails.jsp?id="+p_id);
            }
            else{
                req.getSession().setAttribute("cartInfo","There was an error updating the cart. Please try again.");
                resp.sendRedirect(req.getContextPath()+"/productDetails.jsp?id="+p_id);
            }

        }
    }
}

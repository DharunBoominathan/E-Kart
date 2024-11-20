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
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
@WebServlet("/orderServlet")
public class OrderServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String[] selectedCartItems = req.getParameterValues("selectedCartItems");
        String p_id=req.getParameter("productId");
        String quantity=req.getParameter("quantity");
        List<Cart> selectedItems = new ArrayList<>();

        User user= (User) req.getSession().getAttribute("user");
        if(user==null){
            req.setAttribute("p_id",p_id);
            req.getRequestDispatcher("/login.jsp").forward(req,resp);
        }

        else if (selectedCartItems != null && selectedCartItems.length > 0) {
            List<Integer> cartItemIds = Arrays.stream(selectedCartItems)
                    .map(Integer::parseInt)
                    .collect(Collectors.toList());

            CartDAO cartDAO = new CartDAOImp();
            for(int i:cartItemIds){
                System.out.println(i);
                selectedItems.add(cartDAO.getCartByC_id(i));
            }
            req.getSession().setAttribute("selectedItems", selectedItems);
            resp.sendRedirect(req.getContextPath()+"/order.jsp");

        } else if (p_id!=null) {
            Product p=new ProductDAOImp().getProductById(Integer.parseInt(p_id));
            User u=(User)req.getSession().getAttribute("user");
            selectedItems.add(new Cart(u,p,Integer.parseInt(quantity)));
            req.getSession().setAttribute("selectedItems", selectedItems);
            resp.sendRedirect(req.getContextPath()+"/order.jsp");

        } else {
            req.getSession().setAttribute("error", "Please select items to proceed.");
            resp.sendRedirect(req.getContextPath()+"/cart.jsp");
        }
    }

}

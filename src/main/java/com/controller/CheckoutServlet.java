package com.controller;

import com.dao.CartDAO;
import com.dao.OrderDAO;
import com.dao.OrderItemDAO;
import com.dao.ProductDAO;
import com.daoimp.*;
import com.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/checkoutServlet")
public class CheckoutServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        User user= (User) req.getSession().getAttribute("user");
        if (user == null) {
            req.getSession().setAttribute("view_cart", "Please login to your account to check your cart");
            resp.sendRedirect("login.jsp");
        } else {
            int addr_id=Integer.parseInt(req.getParameter("selectedAddressId"));
            String[] productIds = req.getParameterValues("productIds");
            String[] quantities = req.getParameterValues("quantities");
            String payment_method=req.getParameter("selectedPaymentMethod");
            int total=Integer.parseInt(req.getParameter("totalPrice"));

            Address address=new AddressDAOImp().getAddressById(addr_id);
            ProductDAO productDAO=new ProductDAOImp();
            OrderDAO orderDAO=new OrderDAOImp();
            OrderItemDAO orderItemDAO=new OrderItemDAOImp();

            //set Order
            Order order=new Order();

            order.setUser(user);
            order.setAddress(address.getFrmtAddress1());
            order.setTotalPrice(total);
            order.setPaymentType(payment_method);
            orderDAO.connect();
            orderDAO.newOrder(order);

            //set orderItem
            List<OrderItem> orderItemList=new ArrayList<>();

            for(int i=0;i<productIds.length;i++) {
                Product product=productDAO.getProductById(Integer.parseInt(productIds[i]));
                OrderItem orderItem = new OrderItem(order, product,Integer.parseInt(quantities[i]));
                orderItemList.add(orderItem);
                orderItemDAO.addOrderItem(orderItem);
            }
            orderDAO.connect();
            boolean is_completed=orderDAO.updateOrder(order,orderItemList);
            if(is_completed) {
                for(int i=0;i<productIds.length;i++) {
                    productDAO.updateStock(Integer.parseInt(productIds[i]),-Integer.parseInt(quantities[i]));
                    int k=new CartDAOImp().removeUserProduct(Integer.parseInt(productIds[i]),user.getU_id());
                }
                resp.sendRedirect("success.jsp");

            }
            else{
                for(OrderItem orderItem:orderItemList){
                    orderItemDAO.removeOrderItem(orderItem);
                }
                orderDAO.connect();
                orderDAO.removeOrder(order);
                req.getSession().setAttribute("orderError","An error occurred while proceeding this order.. ");
                resp.sendRedirect("order.jsp");
            }
        }
    }

    @Override
    public void destroy() {

    }
}
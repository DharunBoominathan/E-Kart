package com.controller;

import com.dao.OrderDAO;
import com.dao.OrderItemDAO;
import com.dao.ProductDAO;
import com.daoimp.OrderDAOImp;
import com.daoimp.OrderItemDAOImp;
import com.daoimp.ProductDAOImp;
import com.model.Cart;
import com.model.OrderItem;
import com.model.Product;
import com.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;


@WebServlet("/orderCancelServlet")
public class OrderCancelServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String canceledItems = req.getParameter("canceledItems");
        int canceledOrder = Integer.parseInt(req.getParameter("canceledOrder"));
        String selectedOrderItems = req.getParameter("selectedOrderItems");
        User user=(User)req.getSession().getAttribute("user");
        OrderItemDAO orderItemDAO=new OrderItemDAOImp();
        OrderDAO orderDAO=new OrderDAOImp();
        ProductDAO productDAO=new ProductDAOImp();

        if(user==null) {
            resp.sendRedirect("login.jsp");
        }
        else {
            String[] o_items = canceledItems.split(",");
            for (String o_item : o_items) {
                int orderItem_Id = Integer.parseInt(o_item);
                orderItemDAO.removeOrderItem(orderItem_Id);

            }
            String[] p_items = selectedOrderItems.split(";");
            for (String item : p_items) {
                String[] parts = item.split(",");
                int productId = Integer.parseInt(parts[0]);
                int quantity = Integer.parseInt(parts[1]);
                productDAO.updateStock(productId,quantity);
            }
            orderDAO.connect();
            orderDAO.removeOrder(canceledOrder);
            req.getSession().setAttribute("error","The order-"+canceledOrder+" is cancelled..." );
            resp.sendRedirect(req.getContextPath()+"/orderHistory.jsp");
        }
    }
}



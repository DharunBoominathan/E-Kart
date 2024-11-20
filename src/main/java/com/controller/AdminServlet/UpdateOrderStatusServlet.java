package com.controller.AdminServlet;

import com.dao.OrderDAO;
import com.daoimp.OrderDAOImp;
import com.model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/updateOrderStatusServlet")
public class UpdateOrderStatusServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        int orderId = Integer.parseInt(request.getParameter("order_id"));
        String newStatus = request.getParameter("status");

        OrderDAO orderDAO = new OrderDAOImp();
        orderDAO.connect();
        Order order = orderDAO.getOrderById(orderId);
        order.setStatus(newStatus);
        orderDAO.updateOrder(order);
        response.setStatus(HttpServletResponse.SC_OK);


    }
}


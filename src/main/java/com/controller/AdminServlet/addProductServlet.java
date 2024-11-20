package com.controller.AdminServlet;

import com.dao.ProductDAO;
import com.daoimp.ProductDAOImp;
import com.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;


@WebServlet("/addProductServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 10,      // 10 MB
        maxRequestSize = 1024 * 1024 * 15)   // 15 MB
public class addProductServlet extends HttpServlet {

    private static final String IMAGE_UPLOAD_DIR = "product_images";
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name");
        int price = Integer.parseInt(req.getParameter("price"));
        String description = req.getParameter("description");
        String category = req.getParameter("category");
        String brand = req.getParameter("brand");
        int stock = Integer.parseInt(req.getParameter("stock"));

        Part filePart = req.getPart("img_file");

        // Define where to save the file
        String uploadPath = getServletContext().getRealPath("") + File.separator + IMAGE_UPLOAD_DIR;
        File uploadDir = new File(uploadPath);

        int nextFileNumber = getNextFileNumber(uploadDir);

        if (!uploadDir.exists()) uploadDir.mkdir();
        // Save the file on the server
        String fileName = nextFileNumber + ".jpg";
        String filePath = uploadPath + File.separator + fileName;

        String newCategory = req.getParameter("newCategory");
        String newBrand = req.getParameter("newBrand");
        if ("new".equals(category) && newCategory != null && !newCategory.trim().isEmpty()) {
            category = newCategory.trim();
        }

        if ("new".equals(brand) && newBrand != null && !newBrand.trim().isEmpty()) {
            brand = newBrand.trim();
        }


        try {
            filePart.write(filePath);
            String img_url = IMAGE_UPLOAD_DIR + "/" + fileName;

            Product product = new Product(name, price, description, img_url, category, brand, stock);
            ProductDAO productDAO = new ProductDAOImp();

            if (productDAO.addProduct(product) == 1) {
                req.setAttribute("img_url",img_url);
                req.getRequestDispatcher("/admin/productSuccess.jsp").forward(req, resp);
            } else {
                new File(filePath).delete();
                req.setAttribute("errorMsg", "Unable to add product");
                req.getRequestDispatcher("/admin/addProduct.jsp").forward(req, resp);
            }
        } catch (IOException | ServletException e) {
            new File(filePath).delete();
            req.setAttribute("errorMsg", "An error occurred while uploading the product. Please try again.");
            req.getRequestDispatcher("/admin/addProduct.jsp").forward(req, resp);

        }
    }
    private int getNextFileNumber(File dir) {
        int maxNumber = 0;
        for (File file : dir.listFiles()) {
            if (file.isFile()) {
                try {
                    int number = Integer.parseInt(file.getName().replace(".jpg", ""));
                    if (number > maxNumber) {
                        maxNumber = number;
                    }
                } catch (NumberFormatException e) {
                    // Skip files that do not match the format
                }
            }
        }
        return maxNumber + 1;
    }
}


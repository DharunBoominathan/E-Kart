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
import java.util.HashMap;
import java.util.Map;

@WebServlet("/updateProductServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 10,      // 10 MB
        maxRequestSize = 1024 * 1024 * 15)   // 15 MB
public class UpdateProductServlet extends HttpServlet {
    private static final String UPLOAD_DIR = "product_images";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String productId = req.getParameter("productId");

        // Set response type to JSON
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        Map<String, String> responseMap = new HashMap<>();
        if (action == null || productId == null) {
            responseMap.put("status", "error");
            responseMap.put("message", "Invalid action or product ID.");
            sendJsonResponse(resp, responseMap);
            return;
        }

        ProductDAO productDAO = new ProductDAOImp();
        Product product = productDAO.getProductById(Integer.parseInt(productId));

        try {
            if ("update".equals(action)) {
                // Update product details
                String productName = req.getParameter("productName");
                String productBrand = req.getParameter("productBrand");
                String productCategory = req.getParameter("productCategory");
                String productDescription = req.getParameter("productDescription");
                String productPrice = req.getParameter("productPrice");
                String productStock = req.getParameter("productStock");
                Part imagePart = req.getPart("productImage");

                product.setName(productName);
                product.setBrand(productBrand);
                product.setCategory(productCategory);
                product.setDescription(productDescription);
                product.setPrice(Integer.parseInt(productPrice));
                product.setStock(Integer.parseInt(productStock));

                if (imagePart != null && imagePart.getSize() > 0) {
                    String uploadPath = req.getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdir();
                    }
                    int nextFileNumber = getNextFileNumber(uploadDir);
                    String fileName = nextFileNumber + ".jpg";
                    String filePath = uploadPath + File.separator + fileName;
                    imagePart.write(filePath);

                    String prev_img=product.getImg_url();
                    String imagePath = req.getServletContext().getRealPath("") + File.separator + prev_img;
                    File imageFile = new File(imagePath);
                    imageFile.delete();
                    product.setImg_url(UPLOAD_DIR + "/" + fileName);
                }

                boolean isUpdated = productDAO.updateProduct(product);
                if (isUpdated) {
                    responseMap.put("status", "success");
                    responseMap.put("message", "Product updated successfully.");
                } else {
                    responseMap.put("status", "error");
                    responseMap.put("message", "Failed to update product.");
                }

            } else if ("delete".equals(action)) {
                boolean isDeleted = productDAO.deleteProduct(product);
                if (isDeleted) {
                    responseMap.put("status", "success");
                    responseMap.put("message", "Product deleted successfully.");
                } else {
                    responseMap.put("status", "error");
                    responseMap.put("message", "Failed to delete product.");
                }
            } else {
                responseMap.put("status", "error");
                responseMap.put("message", "Invalid action.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            responseMap.put("status", "error");
            responseMap.put("message", "An error occurred.");
        }

        sendJsonResponse(resp, responseMap);
    }

    private void sendJsonResponse(HttpServletResponse resp, Map<String, String> responseMap) throws IOException {
        StringBuilder jsonResponse = new StringBuilder();
        jsonResponse.append("{");
        for (Map.Entry<String, String> entry : responseMap.entrySet()) {
            jsonResponse.append("\"").append(entry.getKey()).append("\":\"").append(entry.getValue()).append("\",");
        }
        // Remove trailing comma
        if (jsonResponse.length() > 1) {
            jsonResponse.setLength(jsonResponse.length() - 1);
        }
        jsonResponse.append("}");
        resp.getWriter().write(jsonResponse.toString());
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

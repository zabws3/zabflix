package servlets;

import clases.Video;
import com.google.gson.JsonObject;
import daos.videoDAO;
import daos.daoCategoria;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "videoapi", urlPatterns = {"/api/video"})
public class videoAPI extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Access-Control-Allow-Origin", "*");

        String videoId = request.getParameter("id");
        System.out.println("API request para video ID: " + videoId);
        
        videoDAO vDAO = new videoDAO();
        daoCategoria cDAO = new daoCategoria();
        
        Video video = vDAO.obtenerVideoPorId(Integer.parseInt(videoId));

        if (video != null) {
            // Obtener el nombre de la categoría usando tu DAO
            String categoryName = cDAO.categoriaPorId(video.getCategoryId());
            if (categoryName == null) {
                categoryName = "Sin categoría";
            }
            
            // Crear un objeto JSON personalizado (para nombre de categoria)
            JsonObject jsonObj = new JsonObject();
            jsonObj.addProperty("id", video.getId());
            jsonObj.addProperty("title", video.getTitle());
            jsonObj.addProperty("description", video.getDescription());
            jsonObj.addProperty("durationSeconds", video.getDurationSeconds());
            jsonObj.addProperty("thumbnailUrl", video.getThumbnailUrl());
            jsonObj.addProperty("mpdPath", video.getMpdPath());
            jsonObj.addProperty("categoryId", video.getCategoryId());
            jsonObj.addProperty("categoryName", categoryName);
            jsonObj.addProperty("uploadDate", video.getUploadDate().toString());
            
            System.out.println("✅ Enviando JSON: " + jsonObj.toString());
            response.getWriter().write(jsonObj.toString());
        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("{\"error\":\"Video no encontrado\"}");
        }
    }
}

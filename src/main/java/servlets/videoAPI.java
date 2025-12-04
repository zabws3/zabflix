package servlets;

import clases.Video;
import com.google.gson.Gson;
import daos.videoDAO;
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
        
        videoDAO dao = new videoDAO();
        Video video = dao.obtenerVideoPorId(Integer.parseInt(videoId));

        // Convertir a JSON y enviar
        Gson gson = new Gson();
        String jsonResponse = gson.toJson(video);

        System.out.println("✅ Enviando JSON: " + jsonResponse);
        response.getWriter().write(jsonResponse);
    }
}

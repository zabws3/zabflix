package servlets;

import clases.Video;
import com.google.gson.Gson;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Timestamp;
import java.time.LocalDateTime;

@WebServlet(name = "videoapi", urlPatterns = {"/api/video"})
public class videoAPI extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Access-Control-Allow-Origin", "*");

        String videoId = request.getParameter("id");
        System.out.println("📺 API request para video ID: " + videoId);

        // Crear video hardcodeado con TODOS los atributos de la clase Video
        Video video = new Video(
            1,
            "Mi Video de Prueba - MPEG-DASH",
            "Este es un video de prueba convertido a MPEG-DASH con múltiples calidades adaptativas (360p y 720p). El video se reproduce automáticamente adaptándose a la velocidad de tu conexión.",
            600, // durationSeconds - 10 minutos
            "video001/thumbnail.jpg",
            "video001/manifest.mpd",
            1, // categoryId
            Timestamp.valueOf(LocalDateTime.now())
        );

        // Convertir a JSON y enviar
        Gson gson = new Gson();
        String jsonResponse = gson.toJson(video);

        System.out.println("✅ Enviando JSON: " + jsonResponse);
        response.getWriter().write(jsonResponse);
    }
}

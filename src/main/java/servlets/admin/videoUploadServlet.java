package servlets.admin;

import clases.Video;
import daos.videoDAO;
import java.io.IOException;
import java.sql.Timestamp;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet para gestionar la subida de nuevos videos
 */
@WebServlet("/videoUploadServlet")
public class videoUploadServlet extends HttpServlet {

    /**
     * GET: Muestra el formulario de subida
     * @param request
     * @param response
     * @throws jakarta.servlet.ServletException
     * @throws java.io.IOException
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("uploadVideo.jsp").forward(request, response);
    }

    /**
     * POST: Procesa la subida del video
     * @param request
     * @param response
     * @throws jakarta.servlet.ServletException
     * @throws java.io.IOException
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Obtener parámetros del formulario
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            int durationSeconds = Integer.parseInt(request.getParameter("duration"));
            String thumbnailUrl = request.getParameter("thumbnail");
            String mpdPath = request.getParameter("mpdPath");
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            
            // Validar que no estén vacíos
            if (title == null || title.isEmpty() || mpdPath == null || mpdPath.isEmpty()) {
                response.sendRedirect("menuAdmin.jsp?mensaje=Error: Campos requeridos vacíos&tipo=error");
                return;
            }
            
            // Crear objeto Video
            Video video = new Video();
            video.setTitle(title);
            video.setDescription(description != null ? description : "");
            video.setDurationSeconds(durationSeconds);
            video.setThumbnailUrl(thumbnailUrl != null ? thumbnailUrl : "");
            video.setMpdPath(mpdPath);
            video.setCategoryId(categoryId);
            video.setUploadDate(new Timestamp(System.currentTimeMillis()));
            
            // Insertar en la BD
            videoDAO videoDAO = new videoDAO();
            boolean exito = videoDAO.insertarVideo(video);
            
            if (exito) {
                response.sendRedirect("menuAdmin.jsp?mensaje=Video subido exitosamente&tipo=success");
            } else {
                response.sendRedirect("menuAdmin.jsp?mensaje=Error al subir el video&tipo=error");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("menuAdmin.jsp?mensaje=Error: Formato de datos incorrecto&tipo=error");
        } catch (Exception e) {
            System.err.println("Error en VideoUploadServlet: " + e.getMessage());
            response.sendRedirect("menuAdmin.jsp?mensaje=Error del servidor&tipo=error");
        }
    }
}
package servlets.admin;

import clases.Video;
import daos.videoDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet para gestionar la edición de videos existentes
 */
@WebServlet("/videoEditServlet")
public class videoEditServlet extends HttpServlet {

    /**
     * GET: Muestra el formulario de edición con los datos del video
     * @param request
     * @param response
     * @throws jakarta.servlet.ServletException
     * @throws java.io.IOException
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int videoId = Integer.parseInt(request.getParameter("id"));
            videoDAO videoDAO = new videoDAO();
            Video video = videoDAO.obtenerVideoPorId(videoId);
            
            if (video != null) {
                request.setAttribute("video", video);
                request.getRequestDispatcher("editVideo.jsp").forward(request, response);
            } else {
                response.sendRedirect("menuAdmin.jsp?mensaje=Video no encontrado&tipo=error");
            }
        } catch (Exception e) {
            System.err.println("Error en VideoEditServlet GET: " + e.getMessage());
            response.sendRedirect("menuAdmin.jsp?mensaje=Error al cargar el video&tipo=error");
        }
    }

    /**
     * POST: Procesa la actualización del video
     * @param request
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Obtener parámetros del formulario
            int videoId = Integer.parseInt(request.getParameter("videoId"));
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
            
            // Obtener video existente para mantener fecha original
            videoDAO videoDAO = new videoDAO();
            Video videoOriginal = videoDAO.obtenerVideoPorId(videoId);
            
            if (videoOriginal == null) {
                response.sendRedirect("menuAdmin.jsp?mensaje=Video no encontrado&tipo=error");
                return;
            }
            
            // Crear objeto Video con datos actualizados
            Video video = new Video();
            video.setId(videoId);
            video.setTitle(title);
            video.setDescription(description != null ? description : "");
            video.setDurationSeconds(durationSeconds);
            video.setThumbnailUrl(thumbnailUrl != null ? thumbnailUrl : "");
            video.setMpdPath(mpdPath);
            video.setCategoryId(categoryId);
            video.setUploadDate(videoOriginal.getUploadDate()); // Mantener fecha original
            
            // Actualizar en la BD
            boolean exito = videoDAO.actualizarVideo(video);
            
            if (exito) {
                response.sendRedirect("menuAdmin.jsp?mensaje=Video actualizado exitosamente&tipo=success");
            } else {
                response.sendRedirect("menuAdmin.jsp?mensaje=Error al actualizar el video&tipo=error");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("menuAdmin.jsp?mensaje=Error: Formato de datos incorrecto&tipo=error");
        } catch (Exception e) {
            System.err.println("Error en VideoEditServlet POST: " + e.getMessage());
            response.sendRedirect("menuAdmin.jsp?mensaje=Error del servidor&tipo=error");
        }
    }
}
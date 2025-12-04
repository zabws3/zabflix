package servlets.admin;

import daos.videoDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet para gestionar la eliminación de videos
 */
@WebServlet("/videoDeleteServlet")
public class videoDeleteServlet extends HttpServlet {

    /**
     * POST: Procesa la eliminación del video
     * @param request
     * @param response
     * @throws jakarta.servlet.ServletException
     * @throws java.io.IOException
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int videoId = Integer.parseInt(request.getParameter("videoId"));
            videoDAO videoDAO = new videoDAO();
            
            boolean exito = videoDAO.eliminarVideo(videoId);
            
            if (exito) {
                response.sendRedirect("menuAdmin.jsp?mensaje=Video eliminado exitosamente&tipo=success");
            } else {
                response.sendRedirect("menuAdmin.jsp?mensaje=Error al eliminar el video&tipo=error");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("menuAdmin.jsp?mensaje=Error: ID de video inválido&tipo=error");
        } catch (Exception e) {
            System.err.println("Error en VideoDeleteServlet: " + e.getMessage());
            response.sendRedirect("menuAdmin.jsp?mensaje=Error del servidor&tipo=error");
        }
    }
}
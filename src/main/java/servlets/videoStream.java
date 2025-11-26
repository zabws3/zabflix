package servlets;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "videostream", urlPatterns = {"/video/stream/*"})
public class videoStream extends HttpServlet {

    private static final String MEDIA_PATH = "/var/netflix-dash/media/";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        // Construir ruta: /video/stream/video001/manifest.mpd
        String filePath = MEDIA_PATH + pathInfo.substring(1);
        System.out.println("Sirviendo: " + filePath);
        
        File requestedFile = new File(filePath);

        // Verificación de seguridad
        try {
            String canonicalPath = requestedFile.getCanonicalPath();
            String canonicalMediaPath = new File(MEDIA_PATH).getCanonicalPath();
            
            if (!canonicalPath.startsWith(canonicalMediaPath)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
        } catch (IOException e) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // Verificar que existe
        if (!requestedFile.exists() || !requestedFile.isFile()) {
            System.out.println("❌ Archivo no encontrado: " + filePath);
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Determinar MIME type
        String mimeType = getMimeType(requestedFile.getName());
        response.setContentType(mimeType);
        response.setContentLengthLong(requestedFile.length());
        response.setHeader("Accept-Ranges", "bytes");
        response.setHeader("Cache-Control", "public, max-age=3600");
        response.setHeader("Access-Control-Allow-Origin", "*");

        // Servir archivo
        try (FileInputStream fis = new FileInputStream(requestedFile);
             OutputStream out = response.getOutputStream()) {
            
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = fis.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
            out.flush();
            System.out.println("Archivo servido: " + requestedFile.getName());
        }
    }

    private String getMimeType(String filename) {
        if (filename.endsWith(".mpd")) return "application/dash+xml";
        if (filename.endsWith(".m4s")) return "video/mp4";
        if (filename.endsWith(".mp4")) return "video/mp4";
        if (filename.endsWith(".m4a")) return "audio/mp4";
        return "application/octet-stream";
    }
}

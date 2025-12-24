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

    // ⚠️ CAMBIAR ESTA RUTA SI ES NECESARIO (en tu caso es /var/zabflix/media/)
    private static final String MEDIA_PATH = "/var/zabflix/media/";

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
                System.out.println("❌ Intento de acceso fuera del directorio permitido");
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
        
        // Headers importantes para DASH
        if (mimeType.equals("application/dash+xml")) {
            response.setHeader("Content-Disposition", "inline; filename=\"manifest.mpd\"");
        }

        // Servir archivo
            try (FileInputStream fis = new FileInputStream(requestedFile);
             OutputStream out = response.getOutputStream()) {
            
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = fis.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
            out.flush();
            System.out.println("✅ Archivo servido: " + requestedFile.getName() + " (" + requestedFile.length() + " bytes)");
        } catch (IOException e) {
            System.out.println("❌ Error sirviendo archivo: " + e.getMessage());
            e.printStackTrace();
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

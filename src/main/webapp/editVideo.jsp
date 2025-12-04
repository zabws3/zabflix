<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="clases.Video" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Editar Video</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 20px;
            }

            .form-container {
                background: white;
                border-radius: 10px;
                box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
                padding: 40px;
                max-width: 600px;
                width: 100%;
            }

            .form-header {
                text-align: center;
                margin-bottom: 30px;
                color: #333;
            }

            .form-header h1 {
                font-size: 1.8em;
                margin-bottom: 10px;
            }

            .form-header p {
                color: #666;
                font-size: 0.9em;
            }

            .form-group {
                margin-bottom: 20px;
            }

            label {
                display: block;
                margin-bottom: 8px;
                color: #333;
                font-weight: 600;
                font-size: 0.95em;
            }

            input[type="text"],
            input[type="number"],
            input[type="url"],
            textarea,
            select {
                width: 100%;
                padding: 12px;
                border: 1px solid #ddd;
                border-radius: 5px;
                font-size: 0.95em;
                font-family: inherit;
                transition: border-color 0.3s ease;
            }

            input[type="text"]:focus,
            input[type="number"]:focus,
            input[type="url"]:focus,
            textarea:focus,
            select:focus {
                outline: none;
                border-color: #667eea;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            }

            textarea {
                resize: vertical;
                min-height: 100px;
            }

            .form-row {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 15px;
            }

            .required {
                color: #dc3545;
            }

            .help-text {
                font-size: 0.85em;
                color: #666;
                margin-top: 5px;
            }

            .info-box {
                background: #f8f9fa;
                padding: 15px;
                border-radius: 5px;
                margin-bottom: 20px;
                border-left: 4px solid #667eea;
            }

            .info-box p {
                margin: 5px 0;
                color: #333;
                font-size: 0.9em;
            }

            .button-group {
                display: flex;
                gap: 10px;
                margin-top: 30px;
            }

            button[type="submit"],
            button[type="reset"],
            .btn-cancel {
                flex: 1;
                padding: 12px;
                border: none;
                border-radius: 5px;
                font-size: 0.95em;
                font-weight: bold;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-block;
                text-align: center;
            }

            button[type="submit"] {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
            }

            button[type="submit"]:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
            }

            button[type="reset"] {
                background: #6c757d;
                color: white;
            }

            button[type="reset"]:hover {
                background: #5a6268;
            }

            .btn-cancel {
                background: #dc3545;
                color: white;
            }

            .btn-cancel:hover {
                background: #c82333;
            }

            @media (max-width: 600px) {
                .form-container {
                    padding: 20px;
                }

                .form-row {
                    grid-template-columns: 1fr;
                }

                .button-group {
                    flex-direction: column;
                }
            }
        </style>
    </head>
    <body>

        <%
// Verificar si el usuario está autenticado como admin
String usuarioAdmin = (String) session.getAttribute("usuario");
        
if (usuarioAdmin == null) {
    // Redirigir a página de login si no está autenticado
    response.sendRedirect("login.jsp?error=Debes iniciar sesión como admin");
    return;
}
    
if(!usuarioAdmin.equals("admin")){
    response.sendRedirect("login.jsp?error=Debes iniciar sesión como admin");
    return;
}
        %>
        <%
            Video video = (Video) request.getAttribute("video");
            if (video == null) {
                response.sendRedirect("menuAdmin.jsp?mensaje=Video no encontrado&tipo=error");
                return;
            }
        %>

        <div class="form-container">
            <div class="form-header">
                <h1>✏️ Editar Video</h1>
                <p>Modifica los detalles del video</p>
            </div>

            <div class="info-box">
                <p><strong>Video ID:</strong> <%= video.getId() %></p>
                <p><strong>Fecha de subida:</strong> <%= video.getUploadDate() %></p>
            </div>

            <form method="POST" action="videoEditServlet" onsubmit="return validarFormulario()">

                <input type="hidden" name="videoId" value="<%= video.getId() %>">

                <div class="form-group">
                    <label for="title">Título del Video <span class="required">*</span></label>
                    <input type="text" id="title" name="title" required value="<%= video.getTitle() %>" placeholder="Ej: Mi primer video">
                    <div class="help-text">Nombre descriptivo del video</div>
                </div>

                <div class="form-group">
                    <label for="description">Descripción</label>
                    <textarea id="description" name="description" placeholder="Describe el contenido del video..."><%= video.getDescription() %></textarea>
                    <div class="help-text">Información adicional sobre el video</div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="duration">Duración (segundos) <span class="required">*</span></label>
                        <input type="number" id="duration" name="duration" required min="1" value="<%= video.getDurationSeconds() %>" placeholder="Ej: 300">
                        <div class="help-text">Duración total del video</div>
                    </div>

                    <div class="form-group">
                        <label for="categoryId">ID Categoría <span class="required">*</span></label>
                        <input type="number" id="categoryId" name="categoryId" required min="1" value="<%= video.getCategoryId() %>" placeholder="Ej: 1">
                        <div class="help-text">ID de la categoría</div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="thumbnail">URL de Miniatura</label>
                    <input type="url" id="thumbnail" name="thumbnail" value="<%= video.getThumbnailUrl() %>" placeholder="https://ejemplo.com/imagen.jpg">
                    <div class="help-text">URL de la imagen de portada</div>
                </div>

                <div class="form-group">
                    <label for="mpdPath">Ruta MPD (DASH) <span class="required">*</span></label>
                    <input type="text" id="mpdPath" name="mpdPath" required value="<%= video.getMpdPath() %>" placeholder="/videos/ejemplo/manifest.mpd">
                    <div class="help-text">Ruta del archivo manifesto DASH (obligatorio)</div>
                </div>

                <div class="button-group">
                    <button type="submit">💾 Guardar Cambios</button>
                    <button type="reset">🔄 Revertir</button>
                    <a href="menuAdmin.jsp" class="btn-cancel">❌ Cancelar</a>
                </div>
            </form>
        </div>

        <script>
            function validarFormulario() {
                const title = document.getElementById('title').value.trim();
                const duration = document.getElementById('duration').value;
                const categoryId = document.getElementById('categoryId').value;
                const mpdPath = document.getElementById('mpdPath').value.trim();

                if (!title) {
                    alert('El título es requerido');
                    return false;
                }

                if (!duration || duration <= 0) {
                    alert('La duración debe ser mayor a 0');
                    return false;
                }

                if (!categoryId || categoryId <= 0) {
                    alert('El ID de categoría debe ser válido');
                    return false;
                }

                if (!mpdPath) {
                    alert('La ruta MPD es requerida');
                    return false;
                }

                return true;
            }
        </script>
    </body>
</html>

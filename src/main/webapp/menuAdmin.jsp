<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="clases.Video" %>
<%@ page import="daos.videoDAO" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Panel Admin - Gestión de Videos</title>
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
                padding: 20px;
            }

            .container {
                max-width: 1200px;
                margin: 0 auto;
                background: white;
                border-radius: 10px;
                box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
                overflow: hidden;
            }

            .header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 30px;
                text-align: center;
            }

            .header h1 {
                font-size: 2em;
                margin-bottom: 10px;
            }

            .header p {
                font-size: 0.9em;
                opacity: 0.9;
            }

            .content {
                padding: 30px;
            }

            .top-section {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 30px;
                flex-wrap: wrap;
                gap: 20px;
            }

            .btn-upload {
                background: #28a745;
                color: white;
                padding: 12px 30px;
                border: none;
                border-radius: 5px;
                font-size: 1em;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-block;
            }

            .btn-upload:hover {
                background: #218838;
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(40, 167, 69, 0.3);
            }

            .search-section {
                display: flex;
                gap: 10px;
                flex: 1;
            }

            .search-section input {
                flex: 1;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 5px;
                font-size: 0.9em;
            }

            .btn-search {
                background: #667eea;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .btn-search:hover {
                background: #5568d3;
            }

            .video-stats {
                background: #f8f9fa;
                padding: 20px;
                border-radius: 5px;
                margin-bottom: 30px;
                text-align: center;
                font-size: 1.1em;
                font-weight: bold;
                color: #333;
            }

            .videos-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
                gap: 20px;
            }

            .video-card {
                border: 1px solid #ddd;
                border-radius: 8px;
                overflow: hidden;
                transition: all 0.3s ease;
                background: #fff;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            }

            .video-card:hover {
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
                transform: translateY(-5px);
            }

            .video-thumbnail {
                width: 100%;
                height: 200px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 3em;
                position: relative;
                overflow: hidden;
            }

            .video-thumbnail img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .video-content {
                padding: 15px;
            }

            .video-title {
                font-size: 1.2em;
                font-weight: bold;
                color: #333;
                margin-bottom: 8px;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

            .video-description {
                color: #666;
                font-size: 0.85em;
                margin-bottom: 10px;
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
                overflow: hidden;
            }

            .video-meta {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 10px;
                margin-bottom: 15px;
                font-size: 0.85em;
                color: #666;
            }

            .meta-item {
                background: #f8f9fa;
                padding: 8px;
                border-radius: 4px;
            }

            .meta-label {
                font-weight: bold;
                color: #333;
            }

            .video-actions {
                display: flex;
                gap: 10px;
                padding-top: 15px;
                border-top: 1px solid #eee;
            }

            .btn-edit, .btn-delete {
                flex: 1;
                padding: 10px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 0.9em;
                font-weight: bold;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-block;
                text-align: center;
            }

            .btn-edit {
                background: #007bff;
                color: white;
            }

            .btn-edit:hover {
                background: #0056b3;
            }

            .btn-delete {
                background: #dc3545;
                color: white;
            }

            .btn-delete:hover {
                background: #c82333;
            }

            .empty-message {
                text-align: center;
                padding: 60px 20px;
                color: #666;
                font-size: 1.1em;
            }

            .empty-message p {
                margin-bottom: 20px;
            }

            .message {
                padding: 15px;
                border-radius: 5px;
                margin-bottom: 20px;
                font-weight: bold;
            }

            .message.success {
                background: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }

            .message.error {
                background: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }

            @media (max-width: 768px) {
                .top-section {
                    flex-direction: column;
                }

                .search-section {
                    flex-direction: column;
                }

                .videos-grid {
                    grid-template-columns: 1fr;
                }
            }

        </style>


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
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>Panel Admin - Gestión de Videos</h1>
                <p>Administra todos los videos disponibles en la plataforma</p>
            </div>

            <div class="content">
                <!-- Mensajes de feedback -->
                <%
                    String mensaje = request.getParameter("mensaje");
                    String tipo = request.getParameter("tipo");
                    if (mensaje != null) {
                %>
                <div class="message <%= tipo %>">
                    <%= mensaje %>
                </div>
                <%
                    }
                %>

                <!--Sección superior -->
                <div class="top-section">
                    <a href="videoUploadServlet" class="btn-upload">+ Subir Nuevo Video</a>
                    <form method="GET" action="menuAdmin.jsp" class="search-section">
                        <input type="text" name="buscar" placeholder="Buscar por título..." value="<%= request.getParameter("buscar") != null ? request.getParameter("buscar") : "" %>">
                        <button type="submit" class="btn-search">Buscar</button>
                    </form>
                </div>

                <%
                    videoDAO videoDAO = new videoDAO();
                    List<Video> videos = null;
                    String buscar = request.getParameter("buscar");
                
                    if (buscar != null && !buscar.isEmpty()) {
                        videos = videoDAO.buscarVideos(buscar, null, null);
                    } else {
                        videos = videoDAO.obtenerTodosVideos();
                    }
                %>

                <!-- Estadísticas -->
                <div class="video-stats">
                    Total de videos: <%= videos.size() %>
                </div>

                <!-- Grid de videos -->
                <% if (videos != null && !videos.isEmpty()) { %>
                <div class="videos-grid">
                    <% for (Video video : videos) { %>
                    <div class="video-card">
                        <div class="video-thumbnail">
                            <% if (video.getThumbnailUrl() != null && !video.getThumbnailUrl().isEmpty()) { %>
                            <img src="<%= video.getThumbnailUrl() %>" alt="<%= video.getTitle() %>">
                            <% } else { %>
                            馃幀
                            <% } %>
                        </div>
                        <div class="video-content">
                            <div class="video-title"><%= video.getTitle() %></div>
                            <div class="video-description"><%= video.getDescription() %></div>
                            <div class="video-meta">
                                <div class="meta-item">
                                    <span class="meta-label">Duración:</span><br>
                                    <%= video.getDurationSeconds() %> seg
                                </div>
                                <div class="meta-item">
                                    <span class="meta-label">Categoría:</span><br>
                                    ID: <%= video.getCategoryId() %>
                                </div>
                            </div>
                            <div class="video-meta">
                                <div class="meta-item">
                                    <span class="meta-label">Subido:</span><br>
                                    <%= video.getUploadDate() %>
                                </div>
                                <div class="meta-item">
                                    <span class="meta-label">Video ID:</span><br>
                                    <%= video.getId() %>
                                </div>
                            </div>
                            <div class="video-actions">
                                <a href="videoEditServlet?id=<%= video.getId() %>" class="btn-edit">Editar</a>
                                <form method="POST" action="videoDeleteServlet" style="flex: 1;">
                                    <input type="hidden" name="videoId" value="<%= video.getId() %>">
                                    <button type="submit" class="btn-delete" onclick="return confirm('Estás seguro de que deseas eliminar este video?')">Eliminar</button>
                                </form>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
                <% } else { %>
                <div class="empty-message">
                    <p>No hay videos disponibles</p>
                    <a href="videoUploadServlet" class="btn-upload">+ Subir Primer Video</a>
                </div>
                <% } %>
            </div>
        </div>
    </body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="clases.Video" %>
<%@ page import="daos.videoDAO" %>

<%
    // Verificar si el usuario está autenticado
    String usuario = (String) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("login");
        return;
    }
    
    String iniciales = usuario.substring(0, 1).toUpperCase();
    
    // Obtener videos de la BD
    videoDAO videoDAO = new videoDAO();
    List<Video> todosVideos = videoDAO.obtenerTodosVideos();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Zabflix - Catálogo</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --primary-color: #e50914;
            --dark-bg: #141414;
            --light-text: #ffffff;
            --gray-text: #b3b3b3;
            --hover-color: #ff6b6b;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--dark-bg);
            color: var(--light-text);
            margin: 0;
            padding: 0;
            overflow-x: hidden;
        }

        /* HEADER */
        header {
            background: linear-gradient(180deg, rgba(0, 0, 0, 0.8) 0%, transparent 100%);
            padding: 20px 50px;
            position: fixed;
            top: 0;
            width: 100%;
            z-index: 1000;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.5);
        }

        .logo {
            font-size: 28px;
            font-weight: bold;
            background: linear-gradient(135deg, var(--primary-color), var(--hover-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            letter-spacing: 2px;
            cursor: pointer;
        }

        .logo span {
            color: var(--light-text);
            font-weight: normal;
        }

        nav {
            display: flex;
            gap: 30px;
            list-style: none;
        }

        nav a {
            color: var(--light-text);
            text-decoration: none;
            font-size: 14px;
            transition: color 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 500;
        }

        nav a:hover {
            color: var(--primary-color);
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .search-container {
            position: relative;
        }

        .search-input {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            padding: 8px 12px 8px 35px;
            border-radius: 20px;
            color: var(--light-text);
            font-size: 12px;
            width: 200px;
            transition: all 0.3s ease;
        }

        .search-input:focus {
            outline: none;
            background: rgba(255, 255, 255, 0.15);
            border-color: var(--primary-color);
        }

        .search-input::placeholder {
            color: rgba(255, 255, 255, 0.5);
        }

        .search-icon {
            position: absolute;
            left: 10px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gray-text);
        }

        .profile-menu {
            position: relative;
        }

        .profile-btn {
            display: flex;
            align-items: center;
            gap: 8px;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: var(--light-text);
            padding: 8px 12px;
            border-radius: 20px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 12px;
            font-weight: 600;
        }

        .profile-btn:hover {
            background: rgba(255, 255, 255, 0.2);
            border-color: var(--primary-color);
        }

        .profile-avatar {
            width: 24px;
            height: 24px;
            background: linear-gradient(135deg, var(--primary-color), var(--hover-color));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 10px;
        }

        .dropdown-menu {
            position: absolute;
            top: 100%;
            right: 0;
            background: rgba(20, 20, 20, 0.95);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            min-width: 200px;
            margin-top: 10px;
            display: none;
            z-index: 2000;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(4px);
        }

        .dropdown-menu.active {
            display: block;
            animation: slideDown 0.3s ease;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .dropdown-menu a,
        .dropdown-menu button {
            display: block;
            width: 100%;
            padding: 12px 16px;
            color: var(--light-text);
            text-decoration: none;
            font-size: 13px;
            border: none;
            background: none;
            cursor: pointer;
            text-align: left;
            transition: all 0.3s ease;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }

        .dropdown-menu a:hover,
        .dropdown-menu button:hover {
            background: rgba(229, 9, 20, 0.2);
            color: var(--primary-color);
        }

        .dropdown-menu a:last-child,
        .dropdown-menu button:last-child {
            border-bottom: none;
        }

        /* HERO SECTION */
        .hero {
            height: 600px;
            background: linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)),
                        url('https://via.placeholder.com/1920x600?text=Featured+Content') center/cover;
            margin-top: 70px;
            display: flex;
            align-items: center;
            padding: 0 50px;
            position: relative;
            overflow: hidden;
        }

        .hero-content {
            max-width: 550px;
            z-index: 10;
            animation: fadeIn 0.8s ease;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .hero h1 {
            font-size: 56px;
            font-weight: bold;
            margin-bottom: 20px;
            line-height: 1.2;
        }

        .hero p {
            font-size: 18px;
            color: var(--gray-text);
            margin-bottom: 30px;
            line-height: 1.6;
        }

        .hero-buttons {
            display: flex;
            gap: 15px;
        }

        .btn-play,
        .btn-info {
            padding: 12px 30px;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .btn-play {
            background: var(--light-text);
            color: var(--dark-bg);
        }

        .btn-play:hover {
            background: rgba(255, 255, 255, 0.75);
            transform: scale(1.05);
        }

        .btn-info {
            background: rgba(255, 255, 255, 0.3);
            color: var(--light-text);
            border: 1px solid rgba(255, 255, 255, 0.5);
        }

        .btn-info:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: scale(1.05);
        }

        /* MAIN CONTENT */
        main {
            padding: 40px 50px;
            background-color: var(--dark-bg);
        }

        .section {
            margin-bottom: 60px;
        }

        .section-title {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 20px;
            position: relative;
            padding-bottom: 15px;
        }

        .section-title::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 40px;
            height: 3px;
            background: var(--primary-color);
            border-radius: 2px;
        }

        .video-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }

        .video-card {
            position: relative;
            border-radius: 8px;
            overflow: hidden;
            cursor: pointer;
            transition: all 0.3s ease;
            height: 310px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.5);
        }

        .video-card:hover {
            transform: scale(1.08);
            box-shadow: 0 8px 25px rgba(229, 9, 20, 0.5);
        }

        .video-card img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .video-card:hover img {
            transform: scale(1.1);
        }

        .video-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: linear-gradient(to top, rgba(0, 0, 0, 0.9), transparent);
            padding: 20px;
            transform: translateY(100px);
            transition: all 0.3s ease;
            opacity: 0;
        }

        .video-card:hover .video-overlay {
            transform: translateY(0);
            opacity: 1;
        }

        .video-overlay h4 {
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 8px;
        }

        .video-overlay p {
            font-size: 12px;
            color: var(--gray-text);
            margin-bottom: 12px;
        }

        .video-overlay-actions {
            display: flex;
            gap: 8px;
        }

        .btn-watch {
            flex: 1;
            padding: 8px;
            background: var(--primary-color);
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            font-weight: bold;
            transition: all 0.2s ease;
        }

        .btn-watch:hover {
            background: var(--hover-color);
            transform: scale(1.05);
        }

        .btn-info-card {
            padding: 8px;
            background: rgba(255, 255, 255, 0.1);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            transition: all 0.2s ease;
        }

        .btn-info-card:hover {
            background: rgba(229, 9, 20, 0.3);
            border-color: var(--primary-color);
        }

        /* FOOTER */
        footer {
            background: #0a0a0a;
            padding: 40px 50px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            margin-top: 60px;
        }

        .footer-content {
            max-width: 1400px;
            margin: 0 auto;
        }

        .footer-links {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 30px;
            margin-bottom: 30px;
        }

        .footer-links h4 {
            font-size: 14px;
            margin-bottom: 15px;
            font-weight: bold;
        }

        .footer-links a {
            display: block;
            color: var(--gray-text);
            text-decoration: none;
            font-size: 12px;
            margin-bottom: 8px;
            transition: color 0.3s ease;
        }

        .footer-links a:hover {
            color: var(--primary-color);
        }

        .footer-bottom {
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            padding-top: 20px;
            text-align: center;
            font-size: 12px;
            color: var(--gray-text);
        }

        .empty-message {
            text-align: center;
            padding: 60px 20px;
            color: var(--gray-text);
            font-size: 1.2em;
        }

        .badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background: var(--primary-color);
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: bold;
            text-transform: uppercase;
        }

        .rating {
            display: flex;
            align-items: center;
            gap: 5px;
            font-size: 12px;
            color: #ffc107;
        }

        /* RESPONSIVE */
        @media (max-width: 1200px) {
            .video-grid {
                grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
                gap: 15px;
            }

            header {
                padding: 15px 30px;
            }

            main {
                padding: 30px 30px;
            }

            .hero {
                height: 400px;
                padding: 0 30px;
            }

            .hero h1 {
                font-size: 40px;
            }
        }

        @media (max-width: 768px) {
            header {
                flex-direction: column;
                gap: 15px;
            }

            nav {
                gap: 15px;
            }

            .hero {
                height: 300px;
                padding: 0 20px;
            }

            .hero h1 {
                font-size: 28px;
            }

            .hero p {
                font-size: 14px;
            }

            .video-grid {
                grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
            }

            main {
                padding: 20px;
            }

            .search-input {
                width: 150px;
            }

            .footer-links {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        .placeholder-thumbnail {
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 48px;
        }
    </style>
</head>
<body>
    <!-- HEADER -->
    <header>
        <div class="logo">ZABFLIX <span>DASH</span></div>
        
        <nav>
            <a href="#inicio">Inicio</a>
            <a href="#peliculas">Películas</a>
            <a href="#mi-lista">Mi Lista</a>
        </nav>

        <div class="header-right">
            <div class="search-container">
                <span class="search-icon">🔍</span>
                <input type="text" class="search-input" id="searchInput" placeholder="Buscar contenido...">
            </div>

            <div class="profile-menu">
                <button class="profile-btn" onclick="toggleDropdown()">
                    <div class="profile-avatar"><%= iniciales %></div>
                    <span><%= usuario.substring(0, Math.min(10, usuario.length())) %>...</span>
                    <span>▼</span>
                </button>
                <div class="dropdown-menu" id="dropdownMenu">
                    <a href="profile.jsp">👤 Mi Perfil</a>
                    <a href="mi-lista.jsp">❤️ Mi Lista</a>
                    <a href="configuracion.jsp">⚙️ Configuración</a>
                    <a href="ayuda.jsp">❓ Ayuda</a>
                    <button onclick="logout()">🚪 Cerrar Sesión</button>
                </div>
            </div>
        </div>
    </header>

    <!-- HERO SECTION -->
    <section class="hero" id="inicio">
        <div class="hero-content">
            <h1>Bienvenido a Zabflix</h1>
            <p>Explora nuestra amplia colección de películas y series. Descubre contenido nuevo cada día.</p>
            <div class="hero-buttons">
                <button class="btn-play">▶ Explorar</button>
                <button class="btn-info">ℹ Más Información</button>
            </div>
        </div>
    </section>

    <!-- MAIN CONTENT -->
    <main>
        <!-- PELÍCULAS -->
        <section class="section" id="peliculas">
            <h2 class="section-title">🎬 Todas las Películas</h2>
            
            <% if (todosVideos != null && !todosVideos.isEmpty()) { %>
                <div class="video-grid">
                    <% for (Video video : todosVideos) { %>
                        <div class="video-card">
                            <div class="badge">NUEVO</div>
                            
                            <!-- Thumbnail -->
                            <% if (video.getThumbnailUrl() != null && !video.getThumbnailUrl().isEmpty()) { %>
                                <img src="<%= video.getThumbnailUrl() %>" alt="<%= video.getTitle() %>">
                            <% } else { %>
                                <div class="placeholder-thumbnail">🎬</div>
                            <% } %>
                            
                            <!-- Overlay con información -->
                            <div class="video-overlay">
                                <h4><%= video.getTitle() %></h4>
                                <p><%= video.getDescription() %></p>
                                <p style="font-size: 11px; color: #999;">
                                    ⏱️ <%= video.getDurationSeconds() / 60 %> min - 
                                    📁 ID: <%= video.getId() %>
                                </p>
                                <div class="rating">
                                    <span>⭐</span>
                                    <span><%= 7 + (video.getId() % 3) %>.<%= video.getId() % 10 %>/10</span>
                                </div>
                                <div class="video-overlay-actions">
                                    <button class="btn-watch" onclick="reproducir(<%= video.getId() %>, '<%= video.getTitle() %>')">▶ Reproducir</button>
                                    <button class="btn-info-card" onclick="agregarLista(<%= video.getId() %>)">➕</button>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } else { %>
                <div class="empty-message">
                    <p>📭 No hay películas disponibles en este momento</p>
                </div>
            <% } %>
        </section>
    </main>

    <!-- FOOTER -->
    <footer>
        <div class="footer-content">
            <div class="footer-links">
                <div>
                    <h4>Compañía</h4>
                    <a href="#">Acerca de Nosotros</a>
                    <a href="#">Trabajos</a>
                    <a href="#">Prensa</a>
                    <a href="#">Blog</a>
                </div>
                <div>
                    <h4>Ayuda y Soporte</h4>
                    <a href="#">Contacto</a>
                    <a href="#">FAQ</a>
                    <a href="#">Reportar un Problema</a>
                    <a href="#">Centro de Ayuda</a>
                </div>
                <div>
                    <h4>Cuenta</h4>
                    <a href="#">Mi Perfil</a>
                    <a href="#">Configuración</a>
                    <a href="#">Mi Lista</a>
                    <a href="#">Historial</a>
                </div>
                <div>
                    <h4>Legal</h4>
                    <a href="#">Términos de Servicio</a>
                    <a href="#">Política de Privacidad</a>
                    <a href="#">Cookies</a>
                    <a href="#">Preferencias de Anuncios</a>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2024 Zabflix DASH. Todos los derechos reservados.</p>
            </div>
        </div>
    </footer>

    <script>
        function toggleDropdown() {
            const dropdown = document.getElementById('dropdownMenu');
            dropdown.classList.toggle('active');
        }

        window.addEventListener('click', function(event) {
            const dropdown = document.getElementById('dropdownMenu');
            const profileBtn = document.querySelector('.profile-btn');
            if (!dropdown.contains(event.target) && !profileBtn.contains(event.target)) {
                dropdown.classList.remove('active');
            }
        });

        function logout() {
            if (confirm('¿Estás seguro de que deseas cerrar sesión?')) {
                window.location.href = 'LogoutServlet';
            }
        }

        function reproducir(videoId, titulo) {
            // Aquí puedes redirigir al player
            window.location.href = 'player.jsp?VideoId=' + videoId;
        }

        function agregarLista(videoId) {
            alert('Video agregado a Mi Lista');
            //Función no desarollada
        }

        // Búsqueda de contenido
        const searchInput = document.getElementById('searchInput');
        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                const query = this.value;
                console.log('Buscando:', query);
                // Implementar busqueda , ...
                // fetch('BuscadorServlet?q=' + query).then(...)
            }
        });
    </script>
</body>
</html>

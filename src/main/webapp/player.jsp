<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Zabflix - Reproductor</title>
        <!-- Librería dash.js para reproducción MPEG-DASH -->
        <script src="https://cdn.dashjs.org/latest/dash.all.min.js"></script>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: Arial, sans-serif;
                background-color: #141414;
                color: #ffffff;
            }

            header {
                background-color: #000;
                padding: 15px 20px;
                border-bottom: 2px solid #e50914;
            }

            header h1 {
                margin: 0;
                font-size: 24px;
            }

            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 20px;
            }

            .player-section {
                background-color: #000;
                border-radius: 8px;
                margin-bottom: 30px;
                overflow: hidden;
            }

            video {
                width: 100%;
                height: auto;
                background-color: #000;
            }

            .info-section {
                background-color: #222;
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 20px;
            }

            .info-section h2 {
                margin-top: 0;
                color: #e50914;
                font-size: 28px;
            }

            .info-section p {
                color: #b3b3b3;
                line-height: 1.6;
                margin: 10px 0;
            }

            .video-meta {
                display: flex;
                gap: 20px;
                margin: 15px 0;
                flex-wrap: wrap;
            }

            .meta-item {
                color: #b3b3b3;
                font-size: 14px;
            }

            .meta-item strong {
                color: #ffffff;
            }

            .controls {
                background-color: #222;
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 20px;
                display: flex;
                gap: 10px;
                flex-wrap: wrap;
                align-items: center;
            }

            button {
                background-color: #e50914;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 4px;
                cursor: pointer;
                font-size: 14px;
                font-weight: bold;
                transition: background-color 0.3s;
            }

            button:hover {
                background-color: #ff6b6b;
            }

            select {
                background-color: #e50914;
                color: white;
                border: none;
                padding: 8px 12px;
                border-radius: 4px;
                cursor: pointer;
                font-size: 14px;
                font-weight: bold;
                transition: background-color 0.3s;
            }

            select:hover {
                background-color: #ff6b6b;
            }

            select:focus {
                outline: 2px solid #e50914;
                outline-offset: 2px;
            }

            select option {
                background-color: #222;
                color: #ffffff;
            }

            .loading {
                text-align: center;
                padding: 40px;
                color: #b3b3b3;
            }

            .error {
                background-color: #8b0000;
                color: #ffcccc;
                padding: 15px;
                border-radius: 4px;
                margin-bottom: 20px;
                display: none;
            }

            .stats {
                background-color: #222;
                padding: 15px;
                border-radius: 8px;
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 15px;
            }

            .stat {
                background-color: #333;
                padding: 10px;
                border-radius: 4px;
            }

            .stat-label {
                font-size: 12px;
                color: #b3b3b3;
                text-transform: uppercase;
            }

            .stat-value {
                font-size: 18px;
                font-weight: bold;
                color: #e50914;
                margin-top: 5px;
            }
        </style>
    </head>
    <body>
        <%
                  
            String usuario = (String) session.getAttribute("usuario");
            if (usuario == null) {
            response.sendRedirect("login");
            return;
        }
            // Obtener el ID del video
            String videoId = request.getParameter("VideoId");
            if (videoId == null || videoId.isEmpty()) {
                videoId = "1"; // Por defecto, video 1
            }
        %>

        <!-- HEADER -->
        <header>
            <h1>Zabflix</h1>
        </header>

        <div class="container">
            <!-- MENSAJES DE ERROR -->
            <div class="error" id="error"></div>

            <!-- REPRODUCTOR DE VIDEO -->
            <div class="player-section">
                <div id="loading" class="loading">
                    <p>⏳ Cargando video...</p>
                </div>
                <video id="videoPlayer" controls style="display: none;"></video>
            </div>

            <!-- INFORMACIÓN DEL VIDEO -->
            <div class="info-section" id="videoInfo" style="display: none;">
                <h2 id="videoTitle">Título del video</h2>

                <div class="video-meta">
                    <div class="meta-item">
                        <strong>Duración:</strong> <span id="videoDuration">0:00</span>
                    </div>
                    <div class="meta-item">
                        <strong>Categoría:</strong> <span id="videoCategory">-</span>
                    </div>
                    <div class="meta-item">
                        <strong>Subido:</strong> <span id="videoDate">-</span>
                    </div>
                </div>

                <p id="videoDescription">Descripción del video</p>
            </div>

            <!-- CONTROLES -->
            <div class="controls">
                <button onclick="goBack()">← Volver al Catálogo</button>
                <!-- Selector de calidad -->
                <label style="color:#fff; margin-left:15px; display: flex; align-items: center; gap: 8px;">
                    📹 Calidad:
                    <select id="qualitySelect" onchange="onQualityChange(this.value)">
                        <option value="auto">Auto</option>
                        <option value="0">360p</option>
                        <option value="1">720p</option>
                    </select>
                </label>
            </div>

            <!-- ESTADÍSTICAS DEL REPRODUCTOR -->
            <div class="stats">
                <div class="stat">
                    <div class="stat-label">Calidad Actual</div>
                    <div class="stat-value" id="currentQuality">-</div>
                </div>
                <div class="stat">
                    <div class="stat-label">Buffer</div>
                    <div class="stat-value" id="bufferLevel">-</div>
                </div>
                <div class="stat">
                    <div class="stat-label">Estado</div>
                    <div class="stat-value" id="playerStatus">Esperando...</div>
                </div>
            </div>
        </div>

        <script>
            // Variables globales
            const videoId = '<%= videoId %>';
            let player;
            let videoData = null;

            // ========== INICIALIZACIÓN ==========
            document.addEventListener('DOMContentLoaded', function () {
                console.log('📺 Cargando video ID:', videoId);

                // 1. Inicializar reproductor DASH
                initializePlayer();

                // 2. Cargar datos del video desde la API
                loadVideoData();
            });

            // ========== INICIALIZAR DASH.JS ==========
            function initializePlayer() {
                const video = document.getElementById('videoPlayer');

                // Crear reproductor dash.js
                player = dashjs.MediaPlayer().create();
                player.initialize(video, null, false);

                // Configuración desactivar autoswitch al inicio
                player.updateSettings({
                    streaming: {
                        abr: {
                            autoSwitchBitrate: {video: false}
                        }
                    }
                });

                // Escuchadores de eventos
                player.on(dashjs.MediaPlayer.events.STREAM_INITIALIZED, onStreamReady);
                player.on(dashjs.MediaPlayer.events.METRIC_CHANGED, onMetricsUpdated);
                player.on(dashjs.MediaPlayer.events.ERROR, onPlayerError);

                console.log('✅ Reproductor DASH.js inicializado');
            }

            // ========== CARGAR DATOS DEL VIDEO ==========
            function loadVideoData() {
                // Llamar a la API para obtener información del video
                fetch('api/video?id=' + videoId)
                        .then(response => {
                            if (!response.ok)
                                throw new Error('Error en la API');
                            return response.json();
                        })
                        .then(data => {
                            console.log('📊 Datos del video recibidos:', data);
                            videoData = data;

                            // Mostrar información
                            displayVideoInfo(data);

                            // Cargar el stream MPEG-DASH
                            loadVideoStream(data);
                        })
                        .catch(error => {
                            console.error('❌ Error:', error);
                            showError('Error cargando el video: ' + error.message);
                            document.getElementById('loading').style.display = 'block';
                        });
            }

            // ========== MOSTRAR INFORMACIÓN DEL VIDEO ==========
            function displayVideoInfo(data) {
                console.log('📝 Mostrando información del video');

                document.getElementById('loading').style.display = 'none';
                document.getElementById('videoInfo').style.display = 'block';

                // Rellenar datos
                document.getElementById('videoTitle').textContent = data.title || 'Sin título';
                document.getElementById('videoDescription').textContent = data.description || 'Sin descripción';
                document.getElementById('videoCategory').textContent = data.categoryName || 'Sin categoría';
                document.getElementById('videoDuration').textContent = formatSeconds(data.durationSeconds || 0);

                // Fecha
                if (data.uploadDate) {
                    const fecha = new Date(data.uploadDate);
                    document.getElementById('videoDate').textContent = fecha.toLocaleDateString('es-ES');
                }
            }

            // ========== CARGAR STREAM MPEG-DASH ==========
            function loadVideoStream(data) {
                const mpdUrl = 'video/stream/' + data.mpdPath;

                console.log('🎬 Cargando MPD desde:', mpdUrl);
                console.log('📍 URL completa:', window.location.origin + '/' + mpdUrl);

                try {
                    player.attachSource(mpdUrl);
                    document.getElementById('playerStatus').textContent = 'Cargado (pulsa ▶)';
                } catch (error) {
                    console.error('❌ Error cargando stream:', error);
                    showError('Error al cargar el stream: ' + error.message);
                }
            }

            // ========== EVENT: Stream listo ==========
            function onStreamReady(e) {
                console.log('✅ Stream listo para reproducir');
                document.getElementById('playerStatus').textContent = 'Listo';
                document.getElementById('videoPlayer').style.display = 'block';
            }

            // ========== EVENT: Métricas actualizadas ==========
            function onMetricsUpdated(e) {
                if (e.mediaType !== 'video' || !player)
                    return;

                try {
                    const bufferLevel = player.getBufferLength('video');
                    document.getElementById('bufferLevel').textContent = Math.round(bufferLevel) + 's';
                } catch (err) {
                    console.warn('No se pudo leer el buffer:', err);
                }
            }

            // ========== EVENT: Error en reproductor ==========
            function onPlayerError(e) {
                console.error('❌ Error del reproductor:', e);
                showError('Error en la reproducción: ' + (e.error ? e.error.message : 'Desconocido'));
            }

            // ========== UTILIDADES ==========
            function formatSeconds(seconds) {
                const hours = Math.floor(seconds / 3600);
                const minutes = Math.floor((seconds % 3600) / 60);
                const secs = Math.floor(seconds % 60);

                if (hours > 0) {
                    return hours + ':' + String(minutes).padStart(2, '0') + ':' + String(secs).padStart(2, '0');
                } else {
                    return minutes + ':' + String(secs).padStart(2, '0');
                }
            }

            function showError(message) {
                const errorDiv = document.getElementById('error');
                errorDiv.textContent = message;
                errorDiv.style.display = 'block';
                console.error('⚠️', message);
            }

            function goBack() {
                window.location.href = 'menu.jsp';
            }

            function onQualityChange(value) {
                if (!player)
                    return;

                if (value === 'auto') {
                    // ACTIVAR modo automático
                    player.updateSettings({
                        streaming: {
                            abr: {
                                autoSwitchBitrate: {video: true}
                            }
                        }
                    });
                    document.getElementById('currentQuality').textContent = 'Auto';
                    console.log('Calidad: Automática activada');
                } else {
                    const index = parseInt(value, 10);

                    // 1. DESACTIVAR modo automático primero
                    player.updateSettings({
                        streaming: {
                            abr: {
                                autoSwitchBitrate: {video: false}
                            }
                        }
                    });

                    // 2. Obtener la representación exacta que queremos
                    const qualities = player.getRepresentationsByType('video');
                    if (qualities && qualities[index]) {
                        const selectedRep = qualities[index];

                        // 3. Usar el método recomendado por la doc oficial
                        player.setRepresentationForTypeById('video', selectedRep.id);

                        console.log('Cambiando a calidad manual:', selectedRep.height + 'p', 'ID:', selectedRep.id);

                        // Actualizar UI
                        document.getElementById('currentQuality').textContent = selectedRep.height + 'p (Manual)';
                    } else {
                        console.error('Índice de calidad no válido:', index);
                    }
                }
            }
        </script>
    </body>
</html>

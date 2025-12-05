<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Zabflix - Reproductor</title>
        <script src="https://cdn.dashjs.org/latest/dash.all.min.js"></script>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
                background-color: #141414;
                color: #ffffff;
            }

            header {
                background-color: #000;
                padding: 15px 4%; /* Padding responsive */
                border-bottom: 1px solid #333; /* Borde más sutil */
                background: linear-gradient(to bottom, rgba(0,0,0,0.9) 0%, rgba(0,0,0,0) 100%);
                position: fixed;
                width: 100%;
                z-index: 100;
                top: 0;
            }

            header h1 {
                margin: 0;
                font-size: 28px;
                color: #e50914;
                text-transform: uppercase;
            }

            .container {
                max-width: 1200px;
                margin: 80px auto 0; /* Margen superior para el header fijo */
                padding: 20px;
            }

            .player-section {
                background-color: #000;
                margin-bottom: 20px;
                position: relative;
                aspect-ratio: 16/9; /* Mantiene proporción de video */
                display: flex;
                align-items: center;
                justify-content: center;
            }

            video {
                width: 100%;
                height: 100%;
                background-color: #000;
            }

            /* --- ESTILOS DE INFORMACIÓN --- */
            .info-section {
                padding: 10px 0;
                margin-bottom: 20px;
            }

            .info-section h2 {
                margin-top: 0;
                color: #fff;
                font-size: 32px;
                margin-bottom: 10px;
            }

            .video-meta {
                display: flex;
                gap: 15px;
                margin: 10px 0;
                align-items: center;
                color: #a3a3a3;
                font-size: 16px;
            }

            .meta-highlight {
                color: #46d369; /* Verde "Match" de Netflix */
                font-weight: bold;
            }

            .info-section p {
                color: #fff;
                line-height: 1.5;
                font-size: 16px;
                max-width: 800px;
                margin-top: 15px;
            }

            /* --- CONTROLES Y SELECTOR BONITO --- */
            .controls {
                margin: 20px 0;
                display: flex;
                gap: 20px;
                align-items: center;
                flex-wrap: wrap;
            }

            button {
                background-color: rgba(109, 109, 110, 0.7);
                color: white;
                border: none;
                padding: 8px 20px;
                border-radius: 4px;
                cursor: pointer;
                font-size: 16px;
                font-weight: bold;
                transition: background-color 0.2s;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            button:hover {
                background-color: rgba(109, 109, 110, 0.4);
            }

            /* Wrapper para el selector */
            .quality-wrapper {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .quality-wrapper label {
                color: #a3a3a3;
                font-size: 14px;
                font-weight: bold;
                text-transform: uppercase;
            }

            /* ESTILO DEL SELECTOR (Dropdown) */
            select#qualitySelect {
                appearance: none; /* Quita el estilo por defecto del navegador */
                -webkit-appearance: none;
                -moz-appearance: none;

                background-color: #000;
                color: #fff;
                font-size: 14px;
                font-weight: bold;
                padding: 8px 35px 8px 15px; /* Espacio a la derecha para la flecha */
                border: 1px solid #4d4d4d;
                border-radius: 4px;
                cursor: pointer;
                outline: none;

                /* Flecha personalizada (SVG) */
                background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='white'%3e%3cpath d='M7 10l5 5 5-5z'/%3e%3c/svg%3e");
                background-repeat: no-repeat;
                background-position: right 8px center;
                background-size: 20px;
                transition: border-color 0.3s;
            }

            select#qualitySelect:hover {
                border-color: #fff;
            }

            select#qualitySelect:focus {
                border-color: #e50914; /* Rojo al estar activo */
            }

            /* --- ESTADÍSTICAS TÉCNICAS (Ocultas visualmente o sutiles) --- */
            .stats {
                background-color: #000;
                border: 1px solid #333;
                padding: 15px;
                border-radius: 4px;
                display: flex;
                gap: 30px;
                margin-top: 40px;
                opacity: 0.7; /* Un poco transparente para no molestar */
            }

            .stat {
                display: flex;
                flex-direction: column;
            }

            .stat-label {
                font-size: 10px;
                color: #777;
                text-transform: uppercase;
                margin-bottom: 2px;
            }

            .stat-value {
                font-size: 14px;
                font-weight: bold;
                color: #e50914;
                font-family: monospace;
            }

            .loading {
                text-align: center;
                color: #b3b3b3;
                position: absolute;
            }

            .error {
                background-color: #e50914;
                color: white;
                padding: 15px;
                border-radius: 4px;
                margin-bottom: 20px;
                display: none;
                font-weight: bold;
                text-align: center;
            }
        </style>
    </head>
    <body>
        <%
            // Obtener el ID del video
            String videoId = request.getParameter("VideoId");
            if (videoId == null || videoId.isEmpty()) {
                videoId = "1"; // Por defecto
            }
        %>

        <header>
            <h1>Zabflix</h1>
        </header>

        <div class="container">
            <div class="error" id="error"></div>

            <div class="player-section">
                <div id="loading" class="loading">
                    <p>Cargando...</p>
                </div>
                <video id="videoPlayer" controls style="display: none;"></video>
            </div>

            <div class="info-section" id="videoInfo" style="display: none;">
                <h2 id="videoTitle">Título...</h2>

                <div class="video-meta">
                    <span class="meta-highlight">Nuevo</span>
                    <span id="videoDate">2023</span>
                    <span style="border: 1px solid #777; padding: 0 4px; font-size: 12px;">HD</span>
                    <span id="videoDuration">0h 00m</span>
                </div>

                <div class="video-meta" style="font-size: 14px;">
                    <strong>Categoría:</strong> <span id="videoCategory">-</span>
                </div>

                <p id="videoDescription">Descripción...</p>
            </div>

            <div class="controls">
                <button onclick="goBack()">
                    <span>←</span> Volver
                </button>

                <div class="quality-wrapper">
                    <label for="qualitySelect">Calidad</label>
                    <select id="qualitySelect" onchange="onQualityChange(this.value)">
                        <option value="auto">Auto</option>
                    </select>
                </div>
            </div>

            <div class="stats">
                <div class="stat">
                    <div class="stat-label">Calidad Actual</div>
                    <div class="stat-value" id="currentQuality">Auto</div>
                </div>
                <div class="stat">
                    <div class="stat-label">Buffer</div>
                    <div class="stat-value" id="bufferLevel">0s</div>
                </div>
                <div class="stat">
                    <div class="stat-label">Estado</div>
                    <div class="stat-value" id="playerStatus">Init</div>
                </div>
            </div>
        </div>

        <script>
            const videoId = '<%= videoId %>';
            let player;
            let videoData = null;

            document.addEventListener('DOMContentLoaded', function () {
                initializePlayer();
                loadVideoData();
            });

            function initializePlayer() {
                const video = document.getElementById('videoPlayer');
                player = dashjs.MediaPlayer().create();
                player.initialize(video, null, false);

                player.updateSettings({
                    streaming: {
                        abr: {
                            autoSwitchBitrate: {video: true}
                        }
                    }
                });

                player.on(dashjs.MediaPlayer.events.PLAYBACK_METADATA_LOADED, onStreamReady);
                player.on(dashjs.MediaPlayer.events.METRIC_CHANGED, onMetricsUpdated);
                player.on(dashjs.MediaPlayer.events.ERROR, onPlayerError);
            }

            function loadVideoData()
                    fetch('api/video?id=' + videoId)
                    .then(r => {
                    if (!r.ok)
                            throw new Error('Error API');
                            return r.json();
                    })
                    .then(data => {
                    videoData = data;
                            displayVideoInfo(data);
                            loadVideoStream(data);
                    })
                    .catch(err => {
                    console.error(err);
                            showError(err.message);
                    }
                    );
            }

            function displayVideoInfo(data) {
                document.getElementById('loading').style.display = 'none';
                document.getElementById('videoInfo').style.display = 'block';
                document.getElementById('videoTitle').textContent = data.title || 'Sin título';
                document.getElementById('videoDescription').textContent = data.description || '';
                document.getElementById('videoCategory').textContent = data.categoryId || '-';
                document.getElementById('videoDuration').textContent = formatSeconds(data.durationSeconds || 0);

                if (data.uploadDate) {
                    const fecha = new Date(data.uploadDate);
                    document.getElementById('videoDate').textContent = fecha.getFullYear();
                }
            }

            function loadVideoStream(data) {
                const mpdUrl = 'video/stream/' + data.mpdPath;
                try {
                    player.attachSource(mpdUrl);
                } catch (error) {
                    showError('Error stream: ' + error.message);
                }
            }


            // ========== CONFIGURACIÓN DE CALIDADES ==========
            function onStreamReady(e) {
                console.log('✅ Metadatos cargados. Configurando selector...');

                document.getElementById('playerStatus').textContent = 'Listo';
                document.getElementById('videoPlayer').style.display = 'block';

                // 1. Usamos el método oficial: getRepresentationsByType
                // Documentación: Devuelve el array de representaciones (calidades) disponibles
                const qualities = player.getRepresentationsByType('video');

                console.log("Calidades encontradas:", qualities);

                const select = document.getElementById('qualitySelect');

                // 2. Limpiar y reiniciar selector (dejando el Auto)
                select.innerHTML = '<option value="auto">Auto</option>';

                if (qualities && qualities.length > 0) {
                    qualities.forEach((rep, index) => {
                        // rep contiene: id, width, height, bandwidth, etc.
                        const option = document.createElement('option');

                        // Usamos el índice para identificar la opción en el select
                        option.value = index;

                        // Texto visible: "720p"
                        option.text = rep.height + 'p';

                        select.appendChild(option);
                    });
                } else {
                    console.warn("⚠️ No se encontraron calidades explícitas (posiblemente un stream de una sola calidad)");
                    // Si no hay lista, dejamos solo "Auto" o agregamos una opción "Default"
                    const option = document.createElement('option');
                    option.value = "0";
                    option.text = "Default";
                    select.appendChild(option);
                }
            }

            function onQualityChange(value) {
                if (!player)
                    return;

                if (value === 'auto') {
                    player.updateSettings({
                        streaming: {abr: {autoSwitchBitrate: {video: true}}}
                    });
                    document.getElementById('currentQuality').textContent = 'Auto';
                } else {
                    const index = parseInt(value, 10);

                    // Desactivar auto
                    player.updateSettings({
                        streaming: {abr: {autoSwitchBitrate: {video: false}}}
                    });

                    // Cambiar calidad usando ID (Método seguro v5)
                    const qualities = player.getRepresentationsByType('video');
                    if (qualities && qualities[index]) {
                        player.setRepresentationForTypeById('video', qualities[index].id);
                        document.getElementById('currentQuality').textContent = qualities[index].height + 'p';
                    }
                }
            }

            function onMetricsUpdated(e) {
                if (e.mediaType !== 'video' || !player)
                    return;
                try {
                    const bufferLevel = player.getBufferLength('video');
                    document.getElementById('bufferLevel').textContent = Math.round(bufferLevel) + 's';
                } catch (err) {
                }
            }

            function onPlayerError(e) {
                showError('Error: ' + (e.error ? e.error.message : 'Desconocido'));
            }

            function formatSeconds(seconds) {
                const h = Math.floor(seconds / 3600);
                const m = Math.floor((seconds % 3600) / 60);
                if (h > 0)
                    return h + 'h ' + m + 'm';
                return m + 'm';
            }

            function showError(msg) {
                const errDiv = document.getElementById('error');
                errDiv.textContent = msg;
                errDiv.style.display = 'block';
            }

            function goBack() {
                window.location.href = 'menu.jsp';
            }
        </script>
    </body>
</html>
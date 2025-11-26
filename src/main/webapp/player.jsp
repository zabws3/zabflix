<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Netflix DASH - Reproductor</title>
    <!-- Incluir dash.js para reproducción MPEG-DASH -->
    <script src="https://cdn.dashjs.org/latest/dash.all.min.js"></script>
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
        }

        /* HEADER */
        header {
            background: linear-gradient(180deg, rgba(0, 0, 0, 0.9) 0%, transparent 100%);
            padding: 15px 50px;
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
            font-size: 24px;
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

        .header-controls {
            display: flex;
            gap: 15px;
            align-items: center;
        }

        .btn-back {
            background: var(--primary-color);
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            font-weight: bold;
            transition: all 0.3s ease;
        }

        .btn-back:hover {
            background: var(--hover-color);
        }

        /* VIDEO CONTAINER */
        .player-container {
            width: 100%;
            max-width: 100%;
            background: #000;
            margin-top: 60px;
        }

        #videoPlayer {
            width: 100%;
            height: 100%;
            max-height: 70vh;
            background: #000;
        }

        /* VIDEO INFO */
        .video-info {
            padding: 40px 50px;
            background-color: var(--dark-bg);
        }

        .video-header {
            margin-bottom: 30px;
        }

        .video-header h1 {
            font-size: 36px;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .video-meta {
            display: flex;
            gap: 20px;
            align-items: center;
            margin-bottom: 15px;
            flex-wrap: wrap;
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            color: var(--gray-text);
        }

        .meta-item.rating {
            color: #ffc107;
            font-weight: bold;
        }

        .video-description {
            font-size: 16px;
            line-height: 1.6;
            color: var(--gray-text);
            margin-bottom: 20px;
            max-width: 800px;
        }

        .video-actions {
            display: flex;
            gap: 12px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }

        .btn-action {
            padding: 12px 24px;
            border: none;
            border-radius: 4px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .btn-add {
            background: rgba(255, 255, 255, 0.1);
            color: var(--light-text);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        .btn-add:hover {
            background: rgba(229, 9, 20, 0.3);
            border-color: var(--primary-color);
        }

        .btn-share {
            background: rgba(255, 255, 255, 0.1);
            color: var(--light-text);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        .btn-share:hover {
            background: rgba(229, 9, 20, 0.3);
            border-color: var(--primary-color);
        }

        /* PLAYER STATS */
        .player-stats {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 30px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 20px;
        }

        .stat-item {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .stat-label {
            font-size: 12px;
            color: var(--gray-text);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .stat-value {
            font-size: 16px;
            font-weight: bold;
            color: var(--light-text);
        }

        .stat-value.quality {
            color: var(--primary-color);
        }

        /* QUALITY SELECTOR */
        .quality-selector {
            margin-bottom: 20px;
        }

        .quality-selector label {
            display: block;
            margin-bottom: 8px;
            font-size: 14px;
            font-weight: bold;
            color: var(--light-text);
        }

        .quality-selector select {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: var(--light-text);
            padding: 8px 12px;
            border-radius: 4px;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .quality-selector select:hover,
        .quality-selector select:focus {
            border-color: var(--primary-color);
            outline: none;
        }

        .quality-selector select option {
            background: #222;
            color: #fff;
        }

        /* RELATED VIDEOS */
        .related-section {
            margin-top: 50px;
        }

        .section-title {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .related-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 20px;
        }

        .related-card {
            border-radius: 8px;
            overflow: hidden;
            cursor: pointer;
            transition: all 0.3s ease;
            height: 280px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.5);
        }

        .related-card:hover {
            transform: scale(1.05);
            box-shadow: 0 8px 25px rgba(229, 9, 20, 0.5);
        }

        .related-card img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        /* RESPONSIVE */
        @media (max-width: 1024px) {
            .video-info {
                padding: 30px 30px;
            }

            .video-header h1 {
                font-size: 28px;
            }

            #videoPlayer {
                max-height: 50vh;
            }
        }

        @media (max-width: 768px) {
            header {
                padding: 15px 20px;
                flex-direction: column;
                gap: 10px;
            }

            .video-info {
                padding: 20px;
            }

            .video-header h1 {
                font-size: 24px;
            }

            .video-meta {
                flex-direction: column;
                gap: 10px;
                align-items: flex-start;
            }

            #videoPlayer {
                max-height: 40vh;
            }

            .player-stats {
                grid-template-columns: repeat(2, 1fr);
            }

            .related-grid {
                grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
            }
        }

        .divider {
            width: 100%;
            height: 1px;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            margin: 30px 0;
        }

        .loading {
            text-align: center;
            padding: 40px;
            color: var(--gray-text);
        }

        .error-message {
            background: rgba(229, 9, 20, 0.2);
            border: 1px solid var(--primary-color);
            color: #ff6b6b;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <%
       // String usuario = (String) session.getAttribute("usuario");
        //if (usuario == null) {
        //    response.sendRedirect("login");
        //    return;
       // }
        
        // Obtener el ID del video desde los parámetros
       // String videoId = request.getParameter("videoId");
       // if (videoId == null || videoId.isEmpty()) {
        //    response.sendRedirect("menu");
        //    return;
      //  }
    %>

    <!-- HEADER -->
    <header>
        <div class="logo">NETFLIX <span>DASH</span></div>
        <div class="header-controls">
            <button class="btn-back" onclick="goBack()">← Volver</button>
        </div>
    </header>

    <!-- VIDEO PLAYER CONTAINER -->
    <div class="player-container">
        <video id="videoPlayer" controls></video>
    </div>

    <!-- VIDEO INFO -->
    <div class="video-info">
        <div id="videoError" class="error-message" style="display: none;"></div>
        
        <div id="videoLoading" class="loading">
            <p>Cargando información del video...</p>
        </div>

        <div id="videoContent" style="display: none;">
            <div class="video-header">
                <h1 id="videoTitle">Oppenheimer</h1>
                <div class="video-meta">
                    <div class="meta-item rating">
                        <span>⭐ <span id="videoRating">8.5</span>/10</span>
                    </div>
                    <div class="meta-item">
                        <span id="videoYear">2023</span> •
                        <span id="videoGenre">Drama, Historia</span>
                    </div>
                    <div class="meta-item">
                        <span>Duración: <span id="videoDuration">3h 10m</span></span>
                    </div>
                </div>
            </div>

            <p class="video-description" id="videoDescription">
                La historia épica del físico J. Robert Oppenheimer y su papel central en el desarrollo de la bomba atómica durante la Segunda Guerra Mundial.
            </p>

            <div class="video-actions">
                <button class="btn-action btn-add" onclick="addToList()">➕ Agregar a Mi Lista</button>
                <button class="btn-action btn-share" onclick="shareVideo()">🔗 Compartir</button>
            </div>

            <div class="quality-selector">
                <label for="qualitySelect">Calidad de Reproducción:</label>
                <select id="qualitySelect" onchange="changeQuality()">
                    <option value="auto">Automática (Recomendado)</option>
                    <option value="1080p">1080p - Ultra HD</option>
                    <option value="720p">720p - HD</option>
                    <option value="480p">480p - Definición Estándar</option>
                    <option value="360p">360p - Baja Definición</option>
                </select>
            </div>

            <div class="player-stats">
                <div class="stat-item">
                    <div class="stat-label">Calidad Actual</div>
                    <div class="stat-value quality" id="currentQuality">Auto</div>
                </div>
                <div class="stat-item">
                    <div class="stat-label">Bitrate</div>
                    <div class="stat-value" id="currentBitrate">Detectando...</div>
                </div>
                <div class="stat-item">
                    <div class="stat-label">Buffer</div>
                    <div class="stat-value" id="bufferLevel">0s</div>
                </div>
                <div class="stat-item">
                    <div class="stat-label">FPS</div>
                    <div class="stat-value" id="fpsValue">30</div>
                </div>
            </div>

            <div class="divider"></div>

            <!-- RELATED VIDEOS -->
            <section class="related-section">
                <h2 class="section-title">Contenido Similar</h2>
                <div class="related-grid" id="relatedVideos">
                    <!-- Se llena con JavaScript -->
                </div>
            </section>
        </div>
    </div>

    <script>
        const videoId = '<%= videoId %>';
        let player;
        let videoData = null;

        // Inicialización
        document.addEventListener('DOMContentLoaded', function() {
            initializePlayer();
            loadVideoData();
        });

        // Inicializar reproductor DASH
        function initializePlayer() {
            const video = document.getElementById('videoPlayer');
            
            // Crear instancia de dash.js
            player = dashjs.MediaPlayer().create();
            
            // Configurar el reproductor
            player.initialize(video, null, false);
            
            // Event listeners para estadísticas
            player.on(dashjs.MediaPlayer.events.STREAM_INITIALIZED, onStreamInitialized);
            player.on(dashjs.MediaPlayer.events.QUALITY_CHANGE_REQUESTED, onQualityChangeRequested);
            player.on(dashjs.MediaPlayer.events.METRIC_CHANGED, onMetricChanged);
            player.on(dashjs.MediaPlayer.events.ERROR, onPlayerError);
            
            // Configurar adaptación automática
            player.updateSettings({
                'streaming': {
                    'abr': {
                        'autoSwitchBitrate': {
                            'video': true
                        }
                    },
                    'bufferTimeDefault': 8,
                    'bufferTimeMax': 20,
                    'fastSwitchEnabled': true
                }
            });
        }

        // Cargar datos del video
        function loadVideoData() {
            // En producción, esto vendría del servidor
            fetch('api/video?id=' + videoId)
                .then(response => {
                    if (!response.ok) throw new Error('Error cargando video');
                    return response.json();
                })
                .then(data => {
                    videoData = data;
                    displayVideoInfo(data);
                    loadVideoStream(data);
                })
                .catch(error => {
                    showError('Error cargando el video: ' + error.message);
                    console.error('Error:', error);
                });
        }

        // Mostrar información del video
        function displayVideoInfo(data) {
            document.getElementById('videoLoading').style.display = 'none';
            document.getElementById('videoContent').style.display = 'block';
            
            document.getElementById('videoTitle').textContent = data.title || 'Video';
            document.getElementById('videoDescription').textContent = data.description || '';
            document.getElementById('videoRating').textContent = data.rating || '0';
            document.getElementById('videoYear').textContent = data.year || '2024';
            document.getElementById('videoGenre').textContent = data.genre || 'Entretenimiento';
            document.getElementById('videoDuration').textContent = formatDuration(data.durationSeconds || 0);
        }

        // Cargar stream MPEG-DASH
        function loadVideoStream(data) {
            const mpdUrl = 'video/stream/' + data.mpdPath;
            console.log('Cargando MPD:', mpdUrl);
            
            player.attachSource(mpdUrl);
            player.play();
        }

        // Event: Stream inicializado
        function onStreamInitialized(e) {
            console.log('Stream inicializado');
            updateQualityOptions();
        }

        // Event: Cambio de calidad
        function onQualityChangeRequested(e) {
            if (e.mediaType === 'video') {
                const bitrateList = player.getBitrateInfoListFor('video');
                if (bitrateList && bitrateList[e.newQuality]) {
                    const bitrate = Math.round(bitrateList[e.newQuality].bitrate / 1000);
                    document.getElementById('currentQuality').textContent = 
                        bitrateList[e.newQuality].width + 'p';
                }
            }
        }

        // Event: Cambio de métrica
        function onMetricChanged(e) {
            if (e.mediaType === 'video') {
                const bitrateList = player.getBitrateInfoListFor('video');
                const qualityIndex = player.getQualityFor('video');
                
                if (bitrateList && bitrateList[qualityIndex]) {
                    const bitrate = Math.round(bitrateList[qualityIndex].bitrate / 1000);
                    document.getElementById('currentBitrate').textContent = bitrate + ' kbps';
                }
                
                const bufferLevel = Math.round(player.getBufferLength('video'));
                document.getElementById('bufferLevel').textContent = bufferLevel + 's';
            }
        }

        // Event: Error
        function onPlayerError(e) {
            console.error('Player error:', e);
            showError('Error en la reproducción: ' + (e.error ? e.error.message : 'Desconocido'));
        }

        // Actualizar opciones de calidad
        function updateQualityOptions() {
            const bitrateList = player.getBitrateInfoListFor('video');
            const select = document.getElementById('qualitySelect');
            
            // Limpiar opciones existentes excepto la primera (Automática)
            while (select.options.length > 1) {
                select.remove(1);
            }
            
            if (bitrateList) {
                bitrateList.forEach((bitrate, index) => {
                    const option = document.createElement('option');
                    option.value = index;
                    option.textContent = bitrate.width + 'p - ' + 
                                       Math.round(bitrate.bitrate / 1000000) + ' Mbps';
                    select.appendChild(option);
                });
            }
        }

        // Cambiar calidad
        function changeQuality() {
            const select = document.getElementById('qualitySelect');
            const selectedValue = select.value;
            
            if (selectedValue === 'auto') {
                player.updateSettings({
                    'streaming': {
                        'abr': {
                            'autoSwitchBitrate': {
                                'video': true
                            }
                        }
                    }
                });
            } else {
                const index = parseInt(selectedValue);
                player.updateSettings({
                    'streaming': {
                        'abr': {
                            'autoSwitchBitrate': {
                                'video': false
                            }
                        }
                    }
                });
                player.setQualityFor('video', index);
            }
        }

        // Utilidades
        function formatDuration(seconds) {
            const hours = Math.floor(seconds / 3600);
            const minutes = Math.floor((seconds % 3600) / 60);
            return hours > 0 ? hours + 'h ' + minutes + 'm' : minutes + 'm';
        }

        function showError(message) {
            const errorDiv = document.getElementById('videoError');
            errorDiv.textContent = message;
            errorDiv.style.display = 'block';
        }

        function goBack() {
            window.history.back();
        }

        function addToList() {
            alert('Video agregado a tu lista');
            // TODO: Implementar agregar a lista favoritos
        }

        function shareVideo() {
            const shareUrl = window.location.href;
            if (navigator.share) {
                navigator.share({
                    title: videoData.title,
                    text: videoData.description,
                    url: shareUrl
                });
            } else {
                const textArea = document.createElement('textarea');
                textArea.value = shareUrl;
                document.body.appendChild(textArea);
                textArea.select();
                document.execCommand('copy');
                document.body.removeChild(textArea);
                alert('URL copiada al portapapeles');
            }
        }

        // Guardar progreso de visualización cada 10 segundos
        setInterval(function() {
            const video = document.getElementById('videoPlayer');
            if (!video.paused && !video.ended) {
                const currentTime = Math.floor(video.currentTime);
                const duration = Math.floor(video.duration);
                
                // Guardar en el servidor (opcional)
                fetch('api/watch-progress', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        videoId: videoId,
                        position: currentTime,
                        completed: currentTime >= duration * 0.9
                    })
                }).catch(err => console.log('No se guardó el progreso'));
            }
        }, 10000);
    </script>
</body>
</html>

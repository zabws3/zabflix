# 🎬 Zabflix - Plataforma de Streaming Adaptativo

Una plataforma web moderna de streaming de vídeos que implementa tecnología **MPEG-DASH** para reproducción adaptativa de contenido multimedia. Sistema completo con autenticación, gestión de usuarios, panel administrativo y streaming de vídeos en múltiples calidades.

---

## 📋 Tabla de Contenidos

- [Descripción General](#descripción-general)
- [Características](#características)
- [Arquitectura del Sistema](#arquitectura-del-sistema)
- [Tecnologías Utilizadas](#tecnologías-utilizadas)
- [Requisitos Previos](#requisitos-previos)
- [Instalación](#instalación)
- [Uso](#uso)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [API REST](#api-rest)
- [Tecnología MPEG-DASH](#tecnología-mpeg-dash)
- [Flujo de Reproducción](#flujo-de-reproducción)
- [Patrones de Diseño](#patrones-de-diseño)
- [Contribuciones](#contribuciones)
- [Licencia](#licencia)

---

## 🎯 Descripción General

**Zabflix** es una plataforma de streaming web que permite a los usuarios:
- Registrarse y autenticarse de forma segura
- Consultar un catálogo de vídeos organizados por categorías
- Reproducir contenido multimedia con **streaming adaptativo automático**
- Cambiar manualmente la calidad de reproducción según preferencia

Para administradores:
- Panel de gestión completo para subir y editar vídeos
- Gestión de metadatos (título, descripción, categoría)
- Control de miniaturas (thumbnails) de vídeos
- Gestión de usuarios y roles

La plataforma implementa **MPEG-DASH** (Dynamic Adaptive Streaming over HTTP), un estándar internacional que permite reproducción eficiente adaptándose automáticamente al ancho de banda disponible del usuario.

---

## ✨ Características

### Funcionalidades de Usuario
- ✅ **Autenticación**: Registro e inicio de sesión con persistencia de sesión
- ✅ **Catálogo de Vídeos**: Visualización de contenido disponible con metadatos
- ✅ **Streaming Adaptativo**: Reproducción automática en la mejor calidad según la conexión
- ✅ **Control Manual de Calidad**: Opción para seleccionar manualmente la resolución (360p, 720p, etc.)
- ✅ **Información del Vídeo**: Muestra título, descripción, categoría y duración
- ✅ **Interfaz Responsive**: Diseño adaptativo para diferentes dispositivos

### Funcionalidades Administrativas
- 🔧 **Gestión de Vídeos**: CRUD completo (Crear, Leer, Actualizar, Eliminar)
- 🔧 **Carga de Contenido**: Subir vídeos y generar múltiples calidades automáticamente
- 🔧 **Gestión de Metadatos**: Editar información de vídeos
- 🔧 **Gestión de Categorías**: Organizar contenido por categorías
- 🔧 **Control de Permisos**: Validación de roles de administrador

---

## 🏗️ Arquitectura del Sistema

Zabflix implementa una **arquitectura de tres capas**:

```
┌─────────────────────────────────────┐
│    Capa de Presentación             │
│  HTML5 / CSS3 / JavaScript / Dash.js│
└─────────────────────────────────────┘
                  ↕
┌─────────────────────────────────────┐
│    Capa de Lógica                   │
│  Servlets / JSP / Glassfish Server  │
└─────────────────────────────────────┘
                  ↕
┌─────────────────────────────────────┐
│    Capa de Datos                    │
│  DAOs / JavaDB / Sistema de Archivos│
└─────────────────────────────────────┘
```

### Componentes Principales

1. **Frontend (Presentación)**: JSP, HTML5, CSS3, JavaScript
2. **Backend (Lógica)**: Servlets Java, procesamiento de solicitudes HTTP
3. **Persistencia**: JavaDB, archivos MPD, vídeos en múltiples calidades
4. **Streaming**: MPEG-DASH con Dash.js como cliente

---

## 🛠️ Tecnologías Utilizadas

### Backend
- **Java EE**: Lenguaje principal de programación
- **Glassfish Server**: Servidor de aplicaciones
- **Servlets HTTP**: Manejo de solicitudes web
- **JSP (Java Server Pages)**: Generación de contenido dinámico
- **JavaDB (Apache Derby)**: Base de datos relacional
- **Gson**: Serialización JSON

### Frontend
- **HTML5**: Estructura semántica
- **CSS3**: Estilos responsivos
- **JavaScript**: Lógica del cliente

### Streaming
- **MPEG-DASH**: Protocolo de streaming adaptativo (estándar ISO/IEC 23009-1)
- **Dash.js**: Biblioteca JavaScript de cliente DASH
- **MPD (Media Presentation Description)**: Archivo XML descriptivo

### Herramientas
- **FFmpeg**: Codificación y generación de manifiestos DASH
- **Git**: Control de versiones
- **Apache NetBeans**: IDE para desarrollo

---

## 📦 Requisitos Previos

- **Java Development Kit (JDK)**: Versión 11 o superior
- **Glassfish Server**: Versión 5.1 o superior
- **Apache Derby (JavaDB)**: Incluido en Glassfish
- **FFmpeg**: Para procesamiento de vídeos
- **Navegador moderno**: Chrome, Firefox, Safari o Edge (con soporte DASH)

---

## 💻 Instalación

### 1. Clonar el Repositorio

```bash
git clone https://github.com/zabws3/zabflix.git
cd zabflix
```

### 2. Configurar la Base de Datos

La base de datos JavaDB se configurará automáticamente al iniciar Glassfish. Asegúrate de que la carpeta de datos tiene permisos de escritura:

```bash
mkdir -p /var/zabflix/media
chmod 755 /var/zabflix/media
```

### 3. Compilar el Proyecto

```bash
# Con Gradle (si está configurado)
gradle build

# O con Maven (si está disponible)
mvn clean install

# O compilar directamente con javac (requiere configuración manual)
javac -d bin src/com/zabflix/**/*.java
```

### 4. Desplegar en Glassfish

```bash
# Inicia Glassfish (si no está corriendo)
asadmin start-domain

# Despliega la aplicación
asadmin deploy --contextroot zabflix build/libs/zabflix.war

# O usa la interfaz web de administración en http://localhost:4848
```

### 5. Acceder a la Aplicación

Abre tu navegador y ve a:

```
http://localhost:8080/zabflix
```

---

## ▶️ Uso

### Flujo de Usuario

#### 1. Registro
```
1. Ir a la página de inicio
2. Clic en "Registrarse"
3. Completar formulario (email, nombre, contraseña)
4. Enviar formulario
5. Redirigido automáticamente al login
```

#### 2. Inicio de Sesión
```
1. Completar email/usuario y contraseña
2. Hacer clic en "Iniciar Sesión"
3. Acceso automático al catálogo si las credenciales son válidas
```

#### 3. Reproducción de Vídeo
```
1. Navegar al catálogo
2. Hacer clic en un vídeo de interés
3. El reproductor cargará automáticamente
4. El streaming adaptativo seleccionará la mejor calidad
5. (Opcional) Cambiar manualmente la resolución con los controles
```

#### 4. Cierre de Sesión
```
1. Hacer clic en "Cerrar Sesión"
2. Redirigido a la página de login
```

### Flujo de Administrador

#### 1. Acceso al Panel Administrativo
```
1. Iniciar sesión con cuenta de administrador
2. Acceso automático al panel de administración (menuAdmin.jsp)
```

#### 2. Subir Vídeo
```
1. Ir a "Subir Vídeo"
2. Completar formulario:
   - Seleccionar archivo de vídeo
   - Seleccionar miniatura (thumbnail)
   - Completar: Título, Descripción, Categoría
3. Enviar formulario
4. El sistema genera automáticamente múltiples calidades con FFmpeg
5. Crear archivo MPD con estructura DASH
```

#### 3. Editar Vídeo
```
1. Ir a "Editar Vídeo"
2. Seleccionar vídeo a modificar
3. Actualizar metadatos
4. Guardar cambios
```

#### 4. Eliminar Vídeo
```
1. Ir a "Gestionar Vídeos"
2. Seleccionar vídeo a eliminar
3. Confirmar eliminación
4. Vídeo y archivos asociados se eliminan del sistema
```

---

## 📁 Estructura del Proyecto

```
zabflix/
├── src/
│   └── com/zabflix/
│       ├── clases/
│       │   ├── Video.java              # Modelo de vídeo (DTO)
│       │   └── ...
│       ├── daos/
│       │   ├── dao.java                # Clase abstracta para acceso a BD
│       │   ├── videoDAO.java           # DAO para vídeos
│       │   ├── daoCategoria.java       # DAO para categorías
│       │   └── ...
│       ├── servlets/
│       │   ├── videoAPI.java           # API REST de metadatos
│       │   ├── videoStream.java        # Servlet de streaming
│       │   ├── login.java              # Servlet de autenticación
│       │   ├── register.java           # Servlet de registro
│       │   ├── logout.java             # Servlet de cierre de sesión
│       │   └── ...
│       └── servlets/admin/
│           ├── videoUploadServlet.java # Carga de vídeos
│           ├── videoEditServlet.java   # Edición de vídeos
│           ├── videoDeleteServlet.java # Eliminación de vídeos
│           └── ...
├── web/
│   ├── WEB-INF/
│   │   ├── web.xml                    # Configuración de la aplicación
│   │   ├── glassfish-web.xml          # Configuración específica de Glassfish
│   │   └── beans.xml                  # Configuración de CDI
│   ├── login.jsp                       # Página de autenticación
│   ├── register.jsp                    # Página de registro
│   ├── menu.jsp                        # Catálogo principal
│   ├── menuAdmin.jsp                   # Panel de administración
│   ├── player.jsp                      # Reproductor de vídeo
│   ├── uploadVideo.jsp                 # Formulario de carga
│   ├── editVideo.jsp                   # Edición de metadatos
│   └── ...
├── build/
│   └── libs/
│       └── zabflix.war                # Archivo desplegable
├── pom.xml                             # Configuración Maven (si aplica)
└── README.md                           # Este archivo
```

### Paquetes Principales

| Paquete | Responsabilidad |
|---------|-----------------|
| `com.zabflix.clases` | Modelos de datos (Video, Usuario, etc.) |
| `com.zabflix.daos` | Acceso a base de datos (CRUD) |
| `com.zabflix.servlets` | Controladores HTTP principales |
| `com.zabflix.servlets.admin` | Controladores administrativos |

---

## 🌐 API REST

Zabflix expone un API REST para obtener metadatos de vídeos:

### GET /zabflix/api/video

Obtiene información de un vídeo específico.

**Parámetros:**
- `id` (required): Identificador del vídeo

**Ejemplo de Solicitud:**
```bash
curl "http://localhost:8080/zabflix/api/video?id=1"
```

**Ejemplo de Respuesta:**
```json
{
  "id": 1,
  "title": "Introducción a Java",
  "description": "Un tutorial completo sobre programación en Java",
  "durationSeconds": 3600,
  "thumbnailUrl": "/media/1/thumbnail.jpg",
  "mpdPath": "/media/1/manifest.mpd",
  "categoryName": "Programación",
  "uploadDate": "2025-12-24T10:30:00"
}
```

**Headers de Respuesta:**
- `Content-Type: application/json`
- `Access-Control-Allow-Origin: *` (CORS habilitado)

### GET /zabflix/stream

Sirve el contenido MPEG-DASH para reproducción.

**Parámetros:**
- `videoId` (required): Identificador del vídeo

**Características:**
- Soporte para solicitudes HTTP Range (reanudación de descargas)
- Headers de caché configurados
- Content-Type apropiado para archivos MPD

---

## 🎥 Tecnología MPEG-DASH

### ¿Qué es MPEG-DASH?

MPEG-DASH (Dynamic Adaptive Streaming over HTTP) es un estándar internacional (ISO/IEC 23009-1) que define cómo distribuir contenido multimedia adaptativo mediante HTTP estándar. A diferencia de protocolos propietarios:

- ✅ **Agnóstico a proveedores**: Funciona con cualquier servidor HTTP
- ✅ **Adaptación dinámica**: Ajusta automáticamente la calidad según el ancho de banda
- ✅ **Múltiples calidades**: Soporta 360p, 720p, 1080p en un mismo contenido
- ✅ **Segmentación**: Divide vídeos en fragmentos pequeños (4 segundos) para cambios ágiles

### Componentes DASH en Zabflix

#### 1. Representaciones (Bitrates)
Cada vídeo se codifica en múltiples calidades:

| Resolución | Bitrate | Uso |
|-----------|---------|-----|
| 360p | 500 Kbps | Conexiones lentas, datos móviles |
| 720p | 2 Mbps | Conexiones estándar |
| 1080p | 5 Mbps | Conexiones rápidas (opcional) |

#### 2. Segmentación
- Cada representación se divide en **segmentos de 4 segundos**
- El cliente descarga segmentos bajo demanda
- Permite cambio de calidad entre segmentos sin recodificación

#### 3. Archivo MPD
Archivo XML que describe la estructura del contenido:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<MPD xmlns="urn:mpeg:dash:schema:mpd:2011" type="static">
  <Period>
    <AdaptationSet mimeType="video/mp4">
      <!-- Representación 360p -->
      <Representation id="360p" bandwidth="500000" height="360">
        <BaseURL>segment/360p/init.mp4</BaseURL>
        <SegmentBase indexRange="0-575"/>
      </Representation>
      
      <!-- Representación 720p -->
      <Representation id="720p" bandwidth="2000000" height="720">
        <BaseURL>segment/720p/init.mp4</BaseURL>
        <SegmentBase indexRange="0-675"/>
      </Representation>
    </AdaptationSet>
  </Period>
</MPD>
```

### Preparación de Contenido con FFmpeg

Zabflix utiliza **FFmpeg** para generar automáticamente las múltiples calidades:

```bash
ffmpeg -y -i "/ruta/video_original.mp4" \
  # Mapear dos streams de vídeo (360p y 720p) y audio
  -map 0:v:0 -map 0:v:0 -map 0:a:0? \
  
  # Codec y configuración de vídeo
  -c:v libx264 -preset medium -pix_fmt yuv420p \
  
  # Primera representación: 360p
  -b:v:0 800k -s:v:0 640x360 -profile:v:0 baseline \
  
  # Segunda representación: 720p
  -b:v:1 2500k -s:v:1 1280x720 -profile:v:1 main \
  
  # Configuración de audio
  -c:a aac -b:a:0 128k -ar:a:0 48000 -ac:a:0 2 \
  
  # Parámetros DASH
  -use_timeline 1 -use_template 1 \
  -seg_duration 4 \
  -adaptation_sets "id=0, streams=v id=1, streams=a" \
  -init_seg_name "init-\$RepresentationID\$.m4s" \
  -media_seg_name "chunk-\$RepresentationID\$-\$Number\$.m4s" \
  
  # Salida en formato DASH
  -f dash "/var/zabflix/media/video_id/manifest.mpd"
```

---

## 📹 Flujo de Reproducción

### Fases de Reproducción

1. **Selección del Vídeo**: Usuario hace clic en un vídeo del catálogo
2. **Carga de Metadatos**: JavaScript solicita datos al servlet `videoAPI`
3. **Inicialización DASH**: Dash.js se inicializa vinculado al elemento `<video>`
4. **Descarga de MPD**: El cliente descarga el archivo de descripción
5. **Reproducción Adaptativa**: El algoritmo ABR selecciona automáticamente la mejor calidad
6. **Adaptación Dinámica**: Si cambia el ancho de banda, la calidad se ajusta entre segmentos
7. **Control Manual**: El usuario puede opcionalmente cambiar la calidad manualmente

### Diagrama de Flujo

```
Usuario hace clic en vídeo
          ↓
Navega a player.jsp?videoId=X
          ↓
JavaScript solicita GET /api/video?id=X
          ↓
Servlet videoAPI devuelve JSON con mpdPath
          ↓
Dash.js se inicializa con: player.initialize(videoElement, mpdPath)
          ↓
Cliente descarga GET /manifest.mpd
          ↓
Cliente analiza MPD y obtiene lista de representaciones
          ↓
Algoritmo ABR estima ancho de banda
          ↓
Descarga segmentos de la representación seleccionada
          ↓
Si ancho de banda cambia, ABR elige nueva representación
          ↓
Usuario ve reproducción fluida sin buffering excesivo
```

### Algoritmo de Adaptación de Bitrate (ABR)

Dash.js implementa automáticamente:

1. **Monitoreo continuo**: Mide velocidad de descarga de segmentos
2. **Estimación**: Calcula ancho de banda disponible
3. **Selección**: Elige representación más alta sin causar buffering
4. **Cambio ágil**: Adapta calidad cada 4 segundos (duración del segmento)

---

## 🎨 Patrones de Diseño

### 1. Patrón DAO (Data Access Object)

Abstrae el acceso a la base de datos en clases especializadas:

```java
abstract class dao {
    protected void abrirConexion() throws Exception { }
    protected void cerrarConexion() { }
}

class videoDAO extends dao {
    public Video obtenerVideoPorId(int id) { }
    public List<Video> obtenerTodosVideos() { }
}

class daoCategoria extends dao {
    public String categoriaPorId(int id) { }
}
```

**Ventajas:**
- Separación de responsabilidades
- Facilita cambios de base de datos
- Código reutilizable y mantenible

### 2. Patrón MVC (Model-View-Controller)

| Componente | Implementación |
|-----------|-----------------|
| **Model** | Clases en `com.zabflix.clases` (Video, Usuario) |
| **View** | JSPs e HTML/CSS |
| **Controller** | Servlets que procesan solicitudes HTTP |

### 3. Patrón REST (Representational State Transfer)

Las APIs exponen recursos con operaciones HTTP estándar:

```
GET    /api/video?id=1        → Obtener metadatos
POST   /stream?videoId=1      → Descargar contenido DASH
```

Respuestas en formato JSON:
```json
{
  "id": 1,
  "title": "Ejemplo",
  "categoryName": "Educación"
}
```

---

## 🧪 Testing

(En desarrollo) Se recomienda crear tests para:

### Tests Unitarios
- Validación de clases DAO
- Procesamiento de metadatos de vídeos
- Lógica de autenticación

### Tests de Integración
- Flujo completo de autenticación
- Carga de vídeos
- Reproducción DASH

### Tests E2E
- Flujo completo de usuario (registro → reproducción)
- Cambios de calidad
- Control de reproductor

---

## 📝 Notas sobre Seguridad

### ⚠️ Implementación Actual (Desarrollo)

1. **Contraseñas**: Se almacenan en **texto plano** en la BD (SOLO PARA DESARROLLO)
2. **CORS**: Habilitado para todos los orígenes (`*`) - cambiar en producción
3. **Validación**: Se realiza en cliente y servidor

### 🔒 Para Producción

Implementar:

1. **Hashing de contraseñas**: Usar bcrypt, scrypt o Argon2
   ```java
   String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
   ```

2. **HTTPS/TLS**: Encriptar todas las comunicaciones

3. **CORS Restringido**: Especificar orígenes permitidos
   ```
   Access-Control-Allow-Origin: https://tunominio.com
   ```

4. **Autenticación robusta**: Considerar OAuth 2.0 o JWT

5. **Rate Limiting**: Limitar intentos de login

6. **Validación Server-side**: Nunca confiar solo en validación client

---

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Para contribuir:

1. Haz un **fork** del repositorio
2. Crea una rama para tu feature (`git checkout -b feature/MiFeature`)
3. Realiza commits con mensajes descriptivos (`git commit -m 'Añade MiFeature'`)
4. Haz push a la rama (`git push origin feature/MiFeature`)
5. Abre un **Pull Request**

### Áreas de Contribución
- Mejoras en seguridad
- Optimización de streaming
- Interfaz mejorada
- Documentación
- Tests automatizados

---

## 📄 Licencia

Este proyecto está bajo licencia **MIT**. Consulta el archivo `LICENSE` para detalles completos.

---

## 👨‍💻 Autor

[@zabws3](https://github.com/zabws3)

Proyecto desarrollado como exploración de arquitecturas de streaming multimedia en Java EE.

---

## 📞 Soporte y Contacto

Para reportar bugs o solicitar features:
- Abre un **issue** en GitHub
- Consulta la [documentación del proyecto](Informe-P5-Zabflix.pdf)
- Revisa la sección de [Arquitectura del Sistema](#arquitectura-del-sistema)

---

## 📚 Referencias y Recursos

- [MPEG-DASH Standard (ISO/IEC 23009-1)](https://www.iso.org/standard/79329.html)
- [Dash.js Documentation](https://reference.dashif.org/dash.js/)
- [Dash Industry Forum](https://dashif.org/)
- [FFmpeg Documentation](https://ffmpeg.org/documentation.html)
- [Java EE Tutorial](https://eclipse-ee4j.github.io/jakartaee-tutorial/)
- [Apache Derby Database](https://db.apache.org/derby/)

---

**Última actualización**: 24 de diciembre de 2025

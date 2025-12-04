package daos;
import clases.Video;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Clase que realiza las operaciones básicas de SQL para la gestión de videos
 *
 * @author alumne
 */
public class videoDAO extends dao {


    public videoDAO() {

    }

    ////////////OPERACIONES RELACIONADAS CON VIDEO////////////

    // Instanciar Video (dado un resultado de búsqueda de video, devuelve un objeto video con todos sus atributos)
    private Video instanciarVideo(ResultSet rs) throws SQLException { // Throws porque excepciones siempre serán controladas (método privado)
        return new Video(
                rs.getInt("VIDEO_ID"),
                rs.getString("TITLE"),
                rs.getString("DESCRIPTION"),
                rs.getInt("DURATION_SECONDS"),
                rs.getString("THUMBNAIL_URL"),
                rs.getString("MPD_PATH"),
                rs.getInt("CATEGORY_ID"),
                rs.getTimestamp("UPLOAD_DATE")
        );
    }

    public boolean insertarVideo(Video video) {
        boolean resultado = false;
        try {
            abrirConexion();
            String sql = "INSERT INTO VIDEOS (TITLE, DESCRIPTION, DURATION_SECONDS, THUMBNAIL_URL, MPD_PATH, CATEGORY_ID, UPLOAD_DATE) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";
            statement = conn.prepareStatement(sql);
            statement.setString(1, video.getTitle());
            statement.setString(2, video.getDescription());
            statement.setInt(3, video.getDurationSeconds());
            statement.setString(4, video.getThumbnailUrl());
            statement.setString(5, video.getMpdPath());
            statement.setInt(6, video.getCategoryId());
            statement.setTimestamp(7, video.getUploadDate());
            resultado = statement.executeUpdate() > 0;

        } catch (Exception ex) {
            System.err.println(ex.getMessage());
        } finally {
            cerrarConexion();
        }
        return resultado;
    }

    public Video obtenerVideoPorId(int id) {
        Video video = null;
        try {
            abrirConexion();
            String query = "SELECT VIDEO_ID, TITLE, DESCRIPTION, DURATION_SECONDS, THUMBNAIL_URL, MPD_PATH, CATEGORY_ID, UPLOAD_DATE " +
                    "FROM VIDEOS WHERE VIDEO_ID = ?";
            statement = conn.prepareStatement(query);
            statement.setInt(1, id);
            ResultSet rs = statement.executeQuery();
            if (rs.next()) {
                video = instanciarVideo(rs);
            }
        } catch (Exception ex) {
            System.err.println(ex.getMessage());
        } finally {
            cerrarConexion();
        }
        return video;
    }

    public List<Video> obtenerTodosVideos() {
        List<Video> lista = new ArrayList<>();
        try {
            abrirConexion();
            String query = "SELECT VIDEO_ID, TITLE, DESCRIPTION, DURATION_SECONDS, THUMBNAIL_URL, MPD_PATH, CATEGORY_ID, UPLOAD_DATE " +
                    "FROM VIDEOS ORDER BY UPLOAD_DATE DESC";
            statement = conn.prepareStatement(query);
            ResultSet rs = statement.executeQuery();

            while (rs.next()) {
                lista.add(instanciarVideo(rs));
            }

        } catch (Exception ex) {
            System.err.println(ex.getMessage());
        } finally {
            cerrarConexion();
        }
        return lista;
    }

    public List<Video> obtenerVideosPorCategoria(int categoryId) {
        List<Video> lista = new ArrayList<>();
        try {
            abrirConexion();
            String query = "SELECT VIDEO_ID, TITLE, DESCRIPTION, DURATION_SECONDS, THUMBNAIL_URL, MPD_PATH, CATEGORY_ID, UPLOAD_DATE " +
                    "FROM VIDEOS WHERE CATEGORY_ID = ? ORDER BY UPLOAD_DATE DESC";
            statement = conn.prepareStatement(query);
            statement.setInt(1, categoryId);
            ResultSet rs = statement.executeQuery();

            while (rs.next()) {
                lista.add(instanciarVideo(rs));
            }

        } catch (Exception ex) {
            System.err.println(ex.getMessage());
        } finally {
            cerrarConexion();
        }
        return lista;
    }

    public List<Video> buscarVideos(String titulo, String descripcion, Integer categoryId) {
        List<Video> lista = new ArrayList<>();
        try {
            abrirConexion();
            StringBuilder query = new StringBuilder();
            query.append("SELECT VIDEO_ID, TITLE, DESCRIPTION, DURATION_SECONDS, THUMBNAIL_URL, MPD_PATH, CATEGORY_ID, UPLOAD_DATE ");
            query.append("FROM VIDEOS WHERE 1=1");

            if (titulo != null && !titulo.isEmpty()) {
                query.append(" AND TITLE LIKE ?");
            }
            if (descripcion != null && !descripcion.isEmpty()) {
                query.append(" AND DESCRIPTION LIKE ?");
            }
            if (categoryId != null) {
                query.append(" AND CATEGORY_ID = ?");
            }

            query.append(" ORDER BY UPLOAD_DATE DESC");
            statement = conn.prepareStatement(query.toString());

            int indice = 1;
            if (titulo != null && !titulo.isEmpty()) {
                statement.setString(indice++, "%" + titulo + "%");
            }
            if (descripcion != null && !descripcion.isEmpty()) {
                statement.setString(indice++, "%" + descripcion + "%");
            }
            if (categoryId != null) {
                statement.setInt(indice++, categoryId);
            }

            ResultSet rs = statement.executeQuery();
            while (rs.next()) {
                lista.add(instanciarVideo(rs));
            }
        } catch (Exception ex) {
            System.err.println(ex.getMessage());
        } finally {
            cerrarConexion();
        }
        return lista;
    }

    public boolean actualizarVideo(Video video) {
        boolean resultado = false;
        try {
            abrirConexion();
            String sql = "UPDATE VIDEOS SET TITLE=?, DESCRIPTION=?, DURATION_SECONDS=?, THUMBNAIL_URL=?, MPD_PATH=?, CATEGORY_ID=?, UPLOAD_DATE=? " +
                    "WHERE VIDEO_ID = ?";
            statement = conn.prepareStatement(sql);
            statement.setString(1, video.getTitle());
            statement.setString(2, video.getDescription());
            statement.setInt(3, video.getDurationSeconds());
            statement.setString(4, video.getThumbnailUrl());
            statement.setString(5, video.getMpdPath());
            statement.setInt(6, video.getCategoryId());
            statement.setTimestamp(7, video.getUploadDate());
            statement.setInt(8, video.getId());
            resultado = statement.executeUpdate() > 0;
        } catch (Exception ex) {
            System.err.println(ex.getMessage());
        } finally {
            cerrarConexion();
        }
        return resultado;
    }

    public boolean eliminarVideo(int id) {
        boolean resultado = false;
        try {
            abrirConexion();
            String sql = "DELETE FROM VIDEOS WHERE VIDEO_ID = ?";
            statement = conn.prepareStatement(sql);
            statement.setInt(1, id);
            resultado = statement.executeUpdate() > 0;
        } catch (Exception ex) {
            System.err.println(ex.getMessage());
        } finally {
            cerrarConexion();
        }
        return resultado;
    }

    public int eliminarVideosPorCategoria(int categoryId) {
        int resultado = 0;
        try {
            abrirConexion();
            String sql = "DELETE FROM VIDEOS WHERE CATEGORY_ID = ?";
            statement = conn.prepareStatement(sql);
            statement.setInt(1, categoryId);
            resultado = statement.executeUpdate();
        } catch (Exception ex) {
            System.err.println(ex.getMessage());
        } finally {
            cerrarConexion();
        }
        return resultado;
    }

    public int contarVideos() {
        int total = 0;
        try {
            abrirConexion();
            String query = "SELECT COUNT(*) as total FROM VIDEOS";
            statement = conn.prepareStatement(query);
            ResultSet rs = statement.executeQuery();
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (Exception ex) {
            System.err.println(ex.getMessage());
        } finally {
            cerrarConexion();
        }
        return total;
    }

    public int contarVideosPorCategoria(int categoryId) {
        int total = 0;
        try {
            abrirConexion();
            String query = "SELECT COUNT(*) as total FROM VIDEOS WHERE CATEGORY_ID = ?";
            statement = conn.prepareStatement(query);
            statement.setInt(1, categoryId);
            ResultSet rs = statement.executeQuery();
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (Exception ex) {
            System.err.println(ex.getMessage());
        } finally {
            cerrarConexion();
        }
        return total;
    }
}
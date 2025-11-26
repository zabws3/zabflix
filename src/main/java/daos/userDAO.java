package daos;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author alumne
 */
public class userDAO {

    private Connection conn;
    private PreparedStatement statement;

    // Cambia los valores de URL, usuario y contraseña a la configuración de tu proyecto
    private void abrirConexion() throws Exception {
        // Ejemplo para MySQL
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        conn = DriverManager.getConnection("jdbc:derby://localhost:1527/pr2;user=pr2;password=pr2");
    }

    private void cerrarConexion() {
        try {
            if (statement != null) {
                statement.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            // connection close failed.
            System.err.println(e.getMessage());
        }
    }

    //////////// OPERACIONES RELACIONADAS CON USUARIO ////////////
    /**
     * Valida si existe un usuario con ese nombre y password (en texto plano o
     * hash) Devuelve true si el usuario es válido.
     *
     * @param usuario
     * @param password
     * @return
     */
    public boolean validarUsuario(String usuario, String password) {
        boolean resultado = false;
        try {
            abrirConexion();
            
            String query = "SELECT * FROM users WHERE email = ? AND password_hash = ?";
            statement = conn.prepareStatement(query);
            statement.setString(1, usuario);
            statement.setString(2, password);
            ResultSet rs = statement.executeQuery();
            resultado = rs.next();
        } catch (Exception ex) {
            System.err.println(ex.getMessage());
        } finally {
            cerrarConexion();
        }
        return resultado;
    }

    /**
     * Puedes añadir aquí más funciones relacionadas con el usuario, por
     * ejemplo:
     *
     * @param usuario
     * @param email
     * @param password
     * @return
     */
    public boolean registrarUsuario(String usuario, String email, String password) {
        boolean creado = false;
        try {
            abrirConexion();
            String query = "INSERT INTO users (username, email, password_hash) VALUES (?, ?, ?)";
            statement = conn.prepareStatement(query);
            statement.setString(1, usuario);
            statement.setString(2, email);
            statement.setString(3, password); //De momento sin hash
            int filas = statement.executeUpdate();
            creado = filas > 0;
        } catch (Exception ex) {
            System.err.println("Error registrando usuario: " + ex.getMessage());
        } finally {
            cerrarConexion();
        }
        return creado;
    }

}

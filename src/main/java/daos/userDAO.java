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
public class userDAO extends dao{


    //////////// OPERACIONES RELACIONADAS CON USUARIO ////////////
    /**
     * Valida si existe un usuario con ese nombre y password (en texto plano o
     * hash) Devuelve true si el usuario es válido.
     *
     * @param email
     * @param password
     * @return
     */
    public String validarUsuario(String email, String password) {
        String resultado = null;
        try {
            abrirConexion();
            
            String query = "SELECT * FROM users WHERE email = ? AND password_hash = ?";
            statement = conn.prepareStatement(query);
            statement.setString(1, email);
            statement.setString(2, password);
            ResultSet rs = statement.executeQuery();
            if(rs.next()){
                resultado = rs.getString("username");
            }
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

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package daos;

import java.sql.ResultSet;

/**
 *
 * @author alumne
 */
public class daoCategoria extends dao {

    public String categoriaPorId(int id) {
        String categoria = null;
        try {
            abrirConexion();
            String query = "SELECT NAME "
                    + "FROM CATEGORIES WHERE CATEGORY_ID = ?";
            statement = conn.prepareStatement(query);
            statement.setInt(1, id);
            ResultSet rs = statement.executeQuery();
            if (rs.next()) {
                categoria = rs.getString("name");
            }
        } catch (Exception ex) {
            System.err.println(ex.getMessage());
        } finally {
            cerrarConexion();
        }
        return categoria;
    }

    public String getDescCategoria(int id) {
        String desc = null;
        try {
            abrirConexion();
            String query = "SELECT DESCRIPTION "
                    + "FROM CATEGORIES WHERE CATEGORY_ID = ?";
            statement = conn.prepareStatement(query);
            statement.setInt(1, id);
            ResultSet rs = statement.executeQuery();
            if (rs.next()) {
                desc = rs.getString("description"); //Posible fallo mayusculas
            }
        } catch (Exception ex) {
            System.err.println(ex.getMessage());
        } finally {
            cerrarConexion();
        }
        return desc;

    }
}

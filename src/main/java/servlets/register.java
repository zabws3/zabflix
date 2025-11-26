/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlets;

import daos.userDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "register", urlPatterns = {"/register"})
public class register extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("register.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String usuario = request.getParameter("usuario");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String passwordConfirm = request.getParameter("passwordConfirm");

        response.setContentType("text/html;charset=UTF-8");

        // Validaciones básicas
        if (usuario == null || usuario.isEmpty() || 
            email == null || email.isEmpty() || 
            password == null || password.isEmpty()) {
            
            response.sendRedirect("register.jsp?error=Todos los campos son obligatorios");
            return;
        }

        // Validar que las contraseñas coincidan
        if (!password.equals(passwordConfirm)) {
            response.sendRedirect("register.jsp?error=Las contraseñas no coinciden");
            return;
        }

        // Validar longitud mínima de contraseña
        if (password.length() < 6) {
            response.sendRedirect("register.jsp?error=La contraseña debe tener al menos 6 caracteres");
            return;
        }

        // Validar formato de email básico
        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            response.sendRedirect("register.jsp?error=El email no es válido");
            return;
        }

        userDAO operacion = new userDAO();
        
        // Intenta registrar el usuario
        boolean registrado = operacion.registrarUsuario(usuario, email, password);

        if (registrado) {
            // Si el registro es exitoso, crear sesión e ir a menu
            HttpSession session = request.getSession();
            session.setAttribute("usuario", usuario);
            response.sendRedirect("menu.jsp?msg=Registro exitoso");
        } else {
            // Probablemente el usuario o email ya existe
            response.sendRedirect("register.jsp?error=El usuario o email ya existe");
        }
    }
}

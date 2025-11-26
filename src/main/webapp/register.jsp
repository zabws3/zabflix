<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Zabflix - Registro</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #0f0c29, #302b63, #24243e);
            background-attachment: fixed;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            color: #fff;
            padding: 20px;
        }

        .register-container {
            width: 100%;
            max-width: 500px;
            padding: 40px;
            background: rgba(20, 20, 20, 0.95);
            border-radius: 10px;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
            backdrop-filter: blur(4px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            animation: slideIn 0.5s ease-out;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .logo {
            text-align: center;
            margin-bottom: 35px;
        }

        .logo h1 {
            font-size: 32px;
            font-weight: bold;
            background: linear-gradient(135deg, #e50914, #ff6b6b);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            letter-spacing: 2px;
        }

        .logo p {
            color: #b3b3b3;
            font-size: 12px;
            margin-top: 5px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-size: 14px;
            color: #e0e0e0;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        input[type="text"],
        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            background: rgba(255, 255, 255, 0.05);
            border-radius: 6px;
            color: #fff;
            font-size: 14px;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
        }

        input[type="text"]:focus,
        input[type="email"]:focus,
        input[type="password"]:focus {
            outline: none;
            border-color: #e50914;
            background: rgba(229, 9, 20, 0.1);
            box-shadow: 0 0 15px rgba(229, 9, 20, 0.3);
        }

        input[type="text"]::placeholder,
        input[type="email"]::placeholder,
        input[type="password"]::placeholder {
            color: rgba(255, 255, 255, 0.4);
        }

        .password-strength {
            margin-top: 6px;
            height: 4px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 2px;
            overflow: hidden;
        }

        .strength-bar {
            height: 100%;
            width: 0%;
            background: #e50914;
            transition: all 0.3s ease;
        }

        .btn-register {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #e50914, #c41c1c);
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-top: 25px;
            box-shadow: 0 4px 15px rgba(229, 9, 20, 0.4);
        }

        .btn-register:hover {
            background: linear-gradient(135deg, #ff6b6b, #e50914);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(229, 9, 20, 0.6);
        }

        .btn-register:active {
            transform: translateY(0);
        }

        .error-message {
            background: rgba(229, 9, 20, 0.2);
            border: 1px solid #e50914;
            color: #ff6b6b;
            padding: 12px 14px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 13px;
            display: flex;
            align-items: center;
            gap: 8px;
            animation: shake 0.4s ease;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }

        .error-message::before {
            content: "⚠";
            font-weight: bold;
        }

        .success-message {
            background: rgba(76, 175, 80, 0.2);
            border: 1px solid #4CAF50;
            color: #81c784;
            padding: 12px 14px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 13px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .success-message::before {
            content: "✓";
            font-weight: bold;
        }

        .login-link {
            text-align: center;
            margin-top: 25px;
            font-size: 13px;
            color: #b3b3b3;
        }

        .login-link a {
            color: #e50914;
            text-decoration: none;
            font-weight: bold;
            transition: color 0.3s ease;
        }

        .login-link a:hover {
            color: #ff6b6b;
            text-decoration: underline;
        }

        .divider {
            width: 100%;
            height: 1px;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            margin: 25px 0;
        }

        .terms {
            font-size: 11px;
            color: #757575;
            margin-top: 15px;
            line-height: 1.6;
        }

        .terms a {
            color: #e50914;
            text-decoration: none;
        }

        .terms a:hover {
            text-decoration: underline;
        }

        .background-animation {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: 
                radial-gradient(circle at 20% 50%, rgba(229, 9, 20, 0.1) 0%, transparent 50%),
                radial-gradient(circle at 80% 80%, rgba(48, 43, 99, 0.1) 0%, transparent 50%);
            animation: backgroundShift 15s ease infinite;
            z-index: -1;
        }

        @keyframes backgroundShift {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.8; }
        }

        .requirements {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            padding: 12px;
            border-radius: 6px;
            margin-top: 15px;
            font-size: 12px;
            color: #b3b3b3;
        }

        .requirement {
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 6px 0;
        }

        .requirement-check {
            color: #e50914;
            font-weight: bold;
        }

        .requirement.met .requirement-check {
            color: #4CAF50;
        }
    </style>
</head>
<body>
    <div class="background-animation"></div>

    <div class="register-container">
        <div class="logo">
            <h1>NETFLIX DASH</h1>
            <p>Crea tu cuenta</p>
        </div>

        <%-- Mostrar error si existe --%>
        <%
            String error = request.getParameter("error");
            if (error != null && !error.isEmpty()) {
        %>
        <div class="error-message">
            <%= error %>
        </div>
        <%
            }
        %>

        <form action="register" method="POST" id="registerForm" onsubmit="return validateForm()">
            <div class="form-group">
                <label for="usuario">Nombre de Usuario</label>
                <input 
                    type="text" 
                    id="usuario" 
                    name="usuario" 
                    placeholder="Elige un nombre de usuario"
                    required
                    minlength="3"
                    maxlength="50"
                >
            </div>

            <div class="form-group">
                <label for="email">Correo Electrónico</label>
                <input 
                    type="email" 
                    id="email" 
                    name="email" 
                    placeholder="tu@email.com"
                    required
                    autocomplete="email"
                >
            </div>

            <div class="form-group">
                <label for="password">Contraseña</label>
                <input 
                    type="password" 
                    id="password" 
                    name="password" 
                    placeholder="Mínimo 6 caracteres"
                    required
                    minlength="6"
                    onkeyup="checkPasswordStrength()"
                >
                <div class="password-strength">
                    <div class="strength-bar" id="strengthBar"></div>
                </div>
            </div>

            <div class="form-group">
                <label for="passwordConfirm">Confirmar Contraseña</label>
                <input 
                    type="password" 
                    id="passwordConfirm" 
                    name="passwordConfirm" 
                    placeholder="Confirma tu contraseña"
                    required
                    minlength="6"
                >
            </div>

            <button type="submit" class="btn-register">Crear Cuenta</button>
        </form>

        <div class="divider"></div>

        <div class="login-link">
            ¿Ya tienes cuenta? 
            <a href="login">Inicia sesión aquí</a>
        </div>

        <div class="terms">
            Al registrarte, aceptas nuestros 
            <a href="#">Términos de Servicio</a> y 
            <a href="#">Política de Privacidad</a>
        </div>
    </div>

    <script>
        function checkPasswordStrength() {
            const password = document.getElementById('password').value;
            const strengthBar = document.getElementById('strengthBar');
            let strength = 0;

            if (password.length >= 6) strength += 25;
            if (password.length >= 10) strength += 25;
            if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength += 25;
            if (/[0-9]/.test(password) && /[!@#$%^&*]/.test(password)) strength += 25;

            strengthBar.style.width = strength + '%';

            if (strength <= 25) {
                strengthBar.style.background = '#e50914';
            } else if (strength <= 50) {
                strengthBar.style.background = '#ff9800';
            } else if (strength <= 75) {
                strengthBar.style.background = '#ffc107';
            } else {
                strengthBar.style.background = '#4CAF50';
            }
        }

        function validateForm() {
            const password = document.getElementById('password').value;
            const passwordConfirm = document.getElementById('passwordConfirm').value;

            if (password !== passwordConfirm) {
                alert('Las contraseñas no coinciden');
                return false;
            }

            if (password.length < 6) {
                alert('La contraseña debe tener al menos 6 caracteres');
                return false;
            }

            return true;
        }
    </script>
</body>
</html>

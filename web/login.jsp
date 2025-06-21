<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - MasakJerr!</title>
    <link rel="stylesheet" type="text/css" href="styles/user-module.css">
</head>
<body>
    <div class="user-card">
        <h2>Login</h2>
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="form-message" style="color:red;"><%= request.getAttribute("errorMessage") %></div>
        <% } %>
        <form action="UserServlet" method="post">
            <input type="hidden" name="action" value="login">
            <div class="user-form-group">
                <label for="usernameOrEmail">Username or Email</label>
                <input type="text" id="usernameOrEmail" name="usernameOrEmail" required>
            </div>
            <div class="user-form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>
            </div>
            <div class="user-form-actions">
                <button type="submit">Login</button>
                <a href="register.jsp">Don't have an account? <strong>Register here</strong></a>
            </div>
        </form>
    </div>

    <%
        String registered = request.getParameter("registered");
        if ("true".equals(registered)) {
    %>
        <script>
            alert("Registration successful! Please login.");
        </script>
    <%
        }
    %>
</body>
</html>

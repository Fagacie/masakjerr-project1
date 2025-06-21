<%-- 
    Document   : register
    Created on : Jun 16, 2025, 8:38:21?AM
    Author     : ACER
--%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Register - MasakJerr!</title>
<link rel="stylesheet" type="text/css" href="styles/user-module.css">
</head>
<body>
    <div class="user-card">
        <h2>Register</h2>
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="form-message"><%= request.getAttribute("errorMessage") %></div>
        <% } %>
        <% if (request.getAttribute("successMessage") != null) { %>
            <div class="form-message" style="color: #22c55e;"><%= request.getAttribute("successMessage") %></div>
        <% } %>
        <form action="UserServlet" method="post">
            <input type="hidden" name="action" value="register">
            <div class="user-form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" required>
            </div>
            <div class="user-form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" required>
            </div>
            <div class="user-form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>
            </div>
            <div class="user-form-group">
                <label for="confirmPassword">Confirm Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword" required>
            </div>
            <div class="user-form-actions">
                <button type="submit">Register</button>
                <a href="login.jsp">Already have an account? <strong>Login here</strong></a>
            </div>
        </form>
    </div>
        <%
            String deleted = request.getParameter("deleted");
            if ("true".equals(deleted)) {
        %>
        <script>
        alert("Your account has been successfully deleted.");
        </script>
        <%
        }
        %>

</body>
</html>

<%-- 
    Document   : admin-edit-user
    Modernized and unified with user view
--%>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin - Edit User Role - MasakJerr!</title>
<link rel="stylesheet" type="text/css" href="styles/main-index.css">
<link rel="stylesheet" type="text/css" href="styles/main-home.css">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>
.admin-edit-title {
    font-size: 2rem;
    font-weight: bold;
    color: #e67e22;
    margin-bottom: 2rem;
    margin-top: 2rem;
}
.admin-form-container {
    background: #fff;
    border-radius: 18px;
    box-shadow: 0 2px 12px rgba(0,0,0,0.07);
    padding: 2.5rem 2.5rem 2rem 2.5rem;
    max-width: 480px;
    margin: 2.5rem auto 0 auto;
}
.admin-form-header {
    display: flex;
    align-items: center;
    gap: 1rem;
    margin-bottom: 1.5rem;
}
.form-icon {
    font-size: 2.2rem;
    color: #e67e22;
}
.form-title {
    font-size: 1.3rem;
    font-weight: 600;
    color: #222;
}
.admin-form-group {
    margin-bottom: 1.3rem;
}
.admin-form-group label {
    display: block;
    font-weight: 500;
    margin-bottom: 0.4rem;
    color: #222;
}
.admin-form-group input,
.admin-form-group select {
    width: 100%;
    padding: 0.7em 1em;
    border-radius: 8px;
    border: 1px solid #e0e0e0;
    font-size: 1em;
    background: #f8fafc;
    margin-bottom: 0.2rem;
}
button[type="submit"] {
    background: #e67e22;
    color: #fff;
    border: none;
    border-radius: 8px;
    padding: 0.7em 2em;
    font-size: 1.1em;
    font-weight: 600;
    cursor: pointer;
    transition: background 0.2s;
    margin-top: 0.5rem;
}
button[type="submit"]:hover {
    background: #cf711f;
}
.back-button {
    color: #e67e22;
    text-decoration: underline;
    font-weight: 500;
    font-size: 1em;
    margin-top: 1.5rem;
    display: inline-block;
}
.message-box {
    border-radius: 8px;
    padding: 0.8em 1.2em;
    margin-bottom: 1.2em;
    font-weight: 500;
}
.error-message { background: #ffeaea; color: #d32f2f; }
.success-message { background: #e7fbe7; color: #388e3c; }
</style>
</head>
<body>
    <nav class="navbar">
        <div class="nav-logo">MasakJerr Admin</div>
        <ul class="nav-links">
            <li><a href="AdminServlet?action=dashboard">Dashboard</a></li>
            <li><a href="AdminServlet?action=listPendingRecipes">Pending Recipes</a></li>
            <li><a href="AdminServlet?action=listUsers" class="active">Users</a></li>
            <li><a href="AdminServlet?action=listAllRecipesAdmin">All Recipes</a></li>
            <li><a href="index.jsp">Public Site</a></li>
            <li><a href="AdminServlet?action=logout">Logout</a></li>
        </ul>
        <div class="nav-user">
            <% User currentUser = (User) session.getAttribute("currentUser"); %>
            <% if (currentUser != null) { %>
                <span style="color:#e67e22;font-weight:600;">Admin: <%= currentUser.getFirstName() != null && !currentUser.getFirstName().isEmpty() ? currentUser.getFirstName() : currentUser.getUsername() %></span>
            <% } %>
        </div>
    </nav>
    <div class="container" style="max-width:1200px;margin:0 auto;padding:2rem 1rem;">
        <h2 class="admin-edit-title">Edit User Role</h2>
        <div class="admin-form-container">
            <div class="admin-form-header">
                <div class="form-icon">&#128100;</div>
                <div class="form-title">Edit User Role</div>
            </div>
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="message-box error-message"><%= request.getAttribute("errorMessage") %></div>
            <% } %>
            <% if (request.getAttribute("successMessage") != null) { %>
                <div class="message-box success-message"><%= request.getAttribute("successMessage") %></div>
            <% } %>
            <% User userToEdit = (User) request.getAttribute("userToEdit");
                if (userToEdit != null) { %>
            <form action="AdminServlet" method="post">
                <input type="hidden" name="action" value="updateUserRole">
                <input type="hidden" name="userId" value="<%= userToEdit.getUserId() %>">
                <div class="admin-form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" value="<%= userToEdit.getUsername() %>" readonly>
                </div>
                <div class="admin-form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" value="<%= userToEdit.getEmail() %>" readonly>
                </div>
                <div class="admin-form-group">
                    <label for="newRole">Role</label>
                    <select id="newRole" name="newRole">
                        <option value="RegularUser" <%= "RegularUser".equals(userToEdit.getRole()) ? "selected" : "" %>>Regular User</option>
                        <option value="Admin" <%= "Admin".equals(userToEdit.getRole()) ? "selected" : "" %>>Admin</option>
                    </select>
                </div>
                <button type="submit">Update Role</button>
            </form>
            <% } else { %>
                <p>User not found.</p>
            <% } %>
            <div style="text-align: center; margin-top: 20px;">
                <a href="AdminServlet?action=listUsers" class="back-button">Back to User Management</a>
            </div>
        </div>
    </div>
</body>
</html>

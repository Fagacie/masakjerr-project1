<%-- 
    Document   : admin-user-management
    Modernized and unified with user view
--%>
<%@ page import="model.User" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin - User Management - MasakJerr!</title>
<link rel="stylesheet" type="text/css" href="styles/main-index.css">
<link rel="stylesheet" type="text/css" href="styles/main-home.css">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>
.admin-user-title {
    font-size: 2rem;
    font-weight: bold;
    color: #e67e22;
    margin-bottom: 2rem;
    margin-top: 2rem;
}
.admin-table-container {
    background: #fff;
    border-radius: 18px;
    box-shadow: 0 2px 12px rgba(0,0,0,0.07);
    padding: 2rem 2.5rem;
    margin-bottom: 2.5rem;
}
.admin-table {
    width: 100%;
    border-collapse: collapse;
    font-size: 1rem;
}
.admin-table th, .admin-table td {
    padding: 0.9em 1em;
    border-bottom: 1px solid #f0f0f0;
    text-align: left;
}
.admin-table th {
    background: #f8fafc;
    color: #e67e22;
    font-weight: 600;
    font-size: 1.05em;
}
.admin-table tr:last-child td {
    border-bottom: none;
}
.edit-btn, .delete-btn {
    font-size: 1em;
    border-radius: 6px;
    font-weight: 600;
    transition: background 0.2s;
}
.edit-btn {
    background: #3b82f6;
    color: #fff;
    padding: 0.5em 1em;
    text-decoration: none;
    margin-right: 0.5em;
}
.edit-btn:hover {
    background: #2563eb;
}
.delete-btn {
    background: #e67e22;
    color: #fff;
    padding: 0.5em 1em;
    border: none;
    cursor: pointer;
}
.delete-btn:hover {
    background: #cf711f;
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
        <h2 class="admin-user-title">User Management</h2>
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="message-box error-message"><%= request.getAttribute("errorMessage") %></div>
        <% } %>
        <% if (request.getAttribute("successMessage") != null) { %>
            <div class="message-box success-message"><%= request.getAttribute("successMessage") %></div>
        <% } %>
        <div class="admin-table-container">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Registration Date</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<User> listUsers = (List<User>) request.getAttribute("listUsers");
                        if (listUsers != null && !listUsers.isEmpty()) {
                            for (User user : listUsers) {
                    %>
                                <tr>
                                    <td><%= user.getUserId() %></td>
                                    <td><%= user.getUsername() %></td>
                                    <td><%= user.getEmail() %></td>
                                    <td><span style="font-weight:600;color:<%= "Admin".equals(user.getRole()) ? "#3b82f6" : "#e67e22" %>"><%= user.getRole() %></span></td>
                                    <td><%= new java.text.SimpleDateFormat("dd MMM.yyyy HH:mm").format(user.getRegistrationDate()) %></td>
                                    <td style="display:flex;gap:0.5rem;align-items:center;">
                                        <a href="AdminServlet?action=editUser&id=<%= user.getUserId() %>" class="edit-btn">&#9998; Edit Role</a>
                                        <form action="AdminServlet" method="post" style="display: inline;">
                                            <input type="hidden" name="action" value="deleteUser">
                                            <input type="hidden" name="id" value="<%= user.getUserId() %>">
                                            <button type="submit" class="delete-btn" onclick="return confirm('Are you sure you want to delete user <%= user.getUsername() %>? This action cannot be undone.');">&#128465; Delete</button>
                                        </form>
                                    </td>
                                </tr>
                    <%
                            }
                        } else {
                    %>
                            <tr>
                                <td colspan="6" style="text-align: center;">No users found.</td>
                            </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
        <div class="admin-analytics" style="margin:2.5rem auto 0 auto;max-width:500px;background:#fff;border-radius:14px;box-shadow:0 2px 12px rgba(35,41,70,0.10);padding:1.5rem 1.2rem;">
            <h3 style="color:#232946;font-size:1.15rem;margin-bottom:1.1rem;">User Role Distribution</h3>
            <div style="width:100%;height:180px;display:flex;align-items:center;justify-content:center;">
                <!-- Static SVG Pie Chart Example -->
                <svg width="140" height="140" viewBox="0 0 32 32">
                    <circle r="16" cx="16" cy="16" fill="#e0e7ef" />
                    <path d="M16 16 L16 0 A16 16 0 0 1 31.9 18.6 Z" fill="#3b82f6" /> <!-- 30% Admins -->
                    <path d="M16 16 L31.9 18.6 A16 16 0 1 1 7.3 2.7 Z" fill="#e67e22" /> <!-- 60% Regular Users -->
                </svg>
            </div>
        </div>
    </div>
</body>
</html>


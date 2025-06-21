<%-- 
    Document   : header
    Created on : Jun 17, 2025, 11:08:46 PM
    Author     : ACER
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
      <%@page import="model.User"%>
<div class="admin-layout">
        <div class="admin-sidebar">
            <h3>Admin Panel</h3> <%-- Main Admin Panel title moved to sidebar --%>
            <div class="admin-sidebar-user-info"> <%-- New div for user info/logout --%>
                <% User currentUser = (User) session.getAttribute("currentUser"); %>
                <% if (currentUser != null && "Admin".equals(currentUser.getRole())) { %>
                    <span>Welcome, Admin <%= currentUser.getFirstName() != null && !currentUser.getFirstName().isEmpty() ? currentUser.getFirstName() : currentUser.getUsername() %>!</span>
                <% } %>
            </div>
            <ul>
                <li><a href="AdminServlet?action=dashboard" class="active">Dashboard</a></li>
                <li><a href="AdminServlet?action=listPendingRecipes">Manage Pending Recipes</a></li>
                <li><a href="AdminServlet?action=listUsers">Manage Users</a></li>
                <li><a href="AdminServlet?action=listAllRecipesAdmin">View All Recipes</a></li>
                <li> <a href="index.jsp">Public Site</a></li>
                <li> <a href="AdminServlet?action=logout">Logout</a></li>
            </ul>
        </div>
    </body>
</html>

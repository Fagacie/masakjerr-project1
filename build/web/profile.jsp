<%-- 
    Document   : profile
    Created on : Jun 16, 2025, 8:47:14?AM
    Author     : ACER
--%>

<%@ page import="model.User" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Profile - MasakJerr!</title>
<link rel="stylesheet" type="text/css" href="styles/user-module.css">
<script>
    function confirmDelete() {
        return confirm("Are you sure you want to delete your account? This action cannot be undone.");
    }
</script>
</head>
<body>
    <div class="user-card" style="max-width: 480px; margin: 48px auto;">
        <h2 style="text-align:center;">My Profile</h2>
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="form-message"><%= request.getAttribute("errorMessage") %></div>
        <% } %>
        <% if (request.getAttribute("successMessage") != null) { %>
            <div class="form-message" style="color: #22c55e;"><%= request.getAttribute("successMessage") %></div>
        <% } %>
        <%
            model.User userProfile = (model.User) request.getAttribute("userProfile");
            User currentUser = (User) session.getAttribute("currentUser");
            if (userProfile == null && currentUser != null) {
                userProfile = currentUser;
            }
        %>
        <% if (userProfile != null) { %>
        <form action="UserServlet" method="post">
            <input type="hidden" name="action" value="updateProfile">
            <input type="hidden" name="userId" value="<%= userProfile.getUserId() %>">
            <div class="user-profile-info" style="margin-bottom:18px;">
                <strong>Username:</strong> <%= userProfile.getUsername() %><br>
                <strong>Email:</strong> <%= userProfile.getEmail() %><br>
            </div>
            <div class="user-form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" value="<%= userProfile.getUsername() %>" required>
            </div>
            <div class="user-form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" value="<%= userProfile.getEmail() %>" required>
            </div>
            <div class="user-form-group">
                <label for="firstName">First Name</label>
                <input type="text" id="firstName" name="firstName" value="<%= userProfile.getFirstName() != null ? userProfile.getFirstName() : "" %>">
            </div>
            <div class="user-form-group">
                <label for="lastName">Last Name</label>
                <input type="text" id="lastName" name="lastName" value="<%= userProfile.getLastName() != null ? userProfile.getLastName() : "" %>">
            </div>
            <div class="user-form-actions">
                <button type="submit">Update Profile</button>
                <% if (userProfile.getRole() != null && "Admin".equals(userProfile.getRole())) { %>
                    <a href="AdminServlet?action=dashboard" class="back-link">&#8592; Back to Admin Dashboard</a>
                <% } else { %>
                    <a href="index.jsp" class="back-link">&#8592; Back to Home</a>
                <% } %>
            </div>
        </form>

        <!-- Delete Account Form -->
        <form action="UserServlet" method="post" onsubmit="return confirmDelete();" style="margin-top: 24px;">
            <input type="hidden" name="action" value="deleteAccount">
            <button type="submit" class="danger-button" style="background-color: #dc2626; color: white; padding: 10px 16px; border: none; border-radius: 4px; cursor: pointer;">Delete Account</button>
        </form>
        <% } else { %>
            <div class="form-message">User profile not found.</div>
        <% } %>
    </div>
</body>
</html>

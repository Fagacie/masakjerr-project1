<%-- 
    Document   : admin-recipe-approval
    Modernized and unified with user view
--%>
<%@ page import="model.Recipe" %>
<%@ page import="model.User" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin - Recipe Approval - MasakJerr!</title>
<link rel="stylesheet" type="text/css" href="styles/main-index.css">
<link rel="stylesheet" type="text/css" href="styles/main-home.css">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>
.admin-recipe-title {
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
.view-btn, .approve-btn, .reject-btn, .delete-btn {
    font-size: 1em;
    border-radius: 6px;
    font-weight: 600;
    transition: background 0.2s;
}
.view-btn {
    background: #3b82f6;
    color: #fff;
    padding: 0.5em 1em;
    text-decoration: none;
    margin-right: 0.5em;
}
.view-btn:hover { background: #2563eb; }
.approve-btn { background: #22c55e; color: #fff; }
.approve-btn:hover { background: #16a34a; }
.reject-btn { background: #b71c1c; color: #fff; }
.reject-btn:hover { background: #7f1d1d; }
.delete-btn { background: #e67e22; color: #fff; }
.delete-btn:hover { background: #cf711f; }
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
            <li><a href="AdminServlet?action=listPendingRecipes" class="active">Pending Recipes</a></li>
            <li><a href="AdminServlet?action=listUsers">Users</a></li>
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
        <h2 class="admin-recipe-title">Recipe Approval Management</h2>
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
                        <th>Image</th>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Category</th>
                        <th>Region</th>
                        <th>Uploaded By (User ID)</th>
                        <th>Upload Date</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<Recipe> pendingRecipes = (List<Recipe>) request.getAttribute("pendingRecipes");
                        if (pendingRecipes != null && !pendingRecipes.isEmpty()) {
                            for (Recipe recipe : pendingRecipes) {
                    %>
                                <tr>
                                    <td>
                                        <img src="<%= recipe.getImageUrl() != null && !recipe.getImageUrl().isEmpty() ? recipe.getImageUrl() : "https://placehold.co/80x60/CCCCCC/000000?text=No+Image" %>" alt="<%= recipe.getTitle() %>" style="width:80px;height:60px;object-fit:cover;border-radius:7px;box-shadow:0 1px 4px rgba(0,0,0,0.07);">
                                    </td>
                                    <td><%= recipe.getRecipeId() %></td>
                                    <td><%= recipe.getTitle() %></td>
                                    <td><%= recipe.getCategory() %></td>
                                    <td><%= recipe.getRegion() != null ? recipe.getRegion() : "N/A" %></td>
                                    <td><%= recipe.getUserId() %></td>
                                    <td><%= new java.text.SimpleDateFormat("dd MMM.yyyy HH:mm").format(recipe.getUploadDate()) %></td>
                                    <%
                                        String statusColor = "#b71c1c";
                                        if ("Approved".equalsIgnoreCase(recipe.getStatus())) {
                                            statusColor = "#3b82f6";
                                        } else if ("Pending".equalsIgnoreCase(recipe.getStatus())) {
                                            statusColor = "#e67e22";
                                        }
                                        String statusStyle = "font-weight:600;color:" + statusColor + ";";
                                    %>
                                    <td><span style="<%= statusStyle %>"><%= recipe.getStatus() %></span></td>
                                    <td style="display:flex;gap:0.5rem;align-items:center;">
                                        <a href="AdminServlet?action=viewRecipeForApproval&id=<%= recipe.getRecipeId() %>" class="view-btn">&#128065; View</a>
                                        <form action="AdminServlet" method="post" style="display: inline;">
                                            <input type="hidden" name="action" value="approveRecipe">
                                            <input type="hidden" name="recipeId" value="<%= recipe.getRecipeId() %>">
                                            <button type="submit" class="approve-btn" onclick="return confirm('Approve this recipe?');">&#10003; Approve</button>
                                        </form>
                                        <form action="AdminServlet" method="post" style="display: inline;">
                                            <input type="hidden" name="action" value="rejectRecipe">
                                            <input type="hidden" name="recipeId" value="<%= recipe.getRecipeId() %>">
                                            <button type="submit" class="reject-btn" onclick="return confirm('Reject this recipe?');">&#10060; Reject</button>
                                        </form>
                                        <form action="AdminServlet" method="post" style="display: inline;">
                                            <input type="hidden" name="action" value="deleteRecipe">
                                            <input type="hidden" name="id" value="<%= recipe.getRecipeId() %>">
                                            <button type="submit" class="delete-btn" onclick="return confirm('Are you sure you want to delete this recipe?');">&#128465; Delete</button>
                                        </form>
                                    </td>
                                </tr>
                    <%
                            }
                        } else {
                    %>
                            <tr>
                                <td colspan="9" style="text-align: center;">No pending recipes for approval.</td>
                            </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>

<%-- 
    Document   : admin-dashboard
    Modernized and unified with user view
--%>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Dashboard - MasakJerr!</title>
<link rel="stylesheet" type="text/css" href="styles/main-index.css">
<link rel="stylesheet" type="text/css" href="styles/main-home.css">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>
.admin-dashboard-title {
    font-size: 2.2rem;
    font-weight: bold;
    color: #e67e22;
    margin-bottom: 2rem;
    margin-top: 2rem;
}
.dashboard-cards {
    display: flex;
    flex-wrap: wrap;
    gap: 2rem;
    justify-content: flex-start;
}
.dashboard-card {
    background: #fff;
    border-radius: 18px;
    box-shadow: 0 2px 12px rgba(0,0,0,0.07);
    padding: 2rem 2.5rem;
    min-width: 260px;
    flex: 1 1 260px;
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    transition: box-shadow 0.2s;
}
.dashboard-card:hover {
    box-shadow: 0 4px 24px rgba(230,126,34,0.13);
}
.card-icon {
    font-size: 2.5rem;
    margin-bottom: 1rem;
    color: #e67e22;
}
.card-title {
    font-size: 1.2rem;
    font-weight: 600;
    margin-bottom: 0.5rem;
}
.count {
    font-size: 2.1rem;
    font-weight: bold;
    color: #222;
    margin-bottom: 0.7rem;
}
.card-link {
    color: #fff;
    background: #e67e22;
    border-radius: 16px;
    padding: 0.5rem 1.2rem;
    text-decoration: none;
    font-weight: 500;
    transition: background 0.2s;
}
.card-link:hover {
    background: #cf711f;
}
</style>
</head>
<body>
    <nav class="navbar">
        <div class="nav-logo">MasakJerr Admin</div>
        <ul class="nav-links">
            <li><a href="AdminServlet?action=dashboard" class="active">Dashboard</a></li>
            <li><a href="AdminServlet?action=listPendingRecipes">Pending Recipes</a></li>
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
        <h2 class="admin-dashboard-title">Admin Dashboard</h2>
        <div class="dashboard-cards">
            <div class="dashboard-card">
                <div class="card-icon">&#128221;</div>
                <div class="card-title">Pending Recipes for Approval</div>
                <div class="count"><%= request.getAttribute("pendingRecipeCount") != null ? request.getAttribute("pendingRecipeCount") : "0" %></div>
                <a href="AdminServlet?action=listPendingRecipes" class="card-link">Review Now</a>
            </div>
            <div class="dashboard-card">
                <div class="card-icon">&#128101;</div>
                <div class="card-title">Total Registered Users</div>
                <div class="count"><%= request.getAttribute("totalUserCount") != null ? request.getAttribute("totalUserCount") : "0" %></div>
                <a href="AdminServlet?action=listUsers" class="card-link">View Users</a>
            </div>
            <div class="dashboard-card">
                <div class="card-icon">&#127859;</div>
                <div class="card-title">All Recipes</div>
                <div class="count"><%= request.getAttribute("totalRecipeCount") != null ? request.getAttribute("totalRecipeCount") : "-" %></div>
                <a href="AdminServlet?action=listAllRecipesAdmin" class="card-link">View All Recipes</a>
            </div>
            <div class="dashboard-card">
                <div class="card-icon">&#127760;</div>
                <div class="card-title">Public Site</div>
                <div class="count">&nbsp;</div>
                <a href="index.jsp" class="card-link">Go to Site</a>
            </div>
        </div>
    </div>
</body>
</html>

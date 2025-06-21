<%-- 
    Document   : admin-view-recipe
    Modernized and unified with user view
--%>
<%@ page import="model.Recipe" %>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin - View Recipe - MasakJerr!</title>
<link rel="stylesheet" type="text/css" href="styles/main-index.css">
<link rel="stylesheet" type="text/css" href="styles/main-home.css">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>
.admin-view-title {
    font-size: 2rem;
    font-weight: bold;
    color: #e67e22;
    margin-bottom: 2rem;
    margin-top: 2rem;
}
.admin-pro-card {
    background: #fff;
    border-radius: 18px;
    box-shadow: 0 2px 12px rgba(0,0,0,0.07);
    max-width: 700px;
    margin: 2.5rem auto 0 auto;
    overflow: hidden;
}
.admin-pro-card-header {
    display: flex;
    align-items: center;
    gap: 1rem;
    padding: 2rem 2.5rem 0 2.5rem;
}
.card-icon {
    font-size: 2.2rem;
    color: #e67e22;
    background: #f8fafc;
    border-radius: 50%;
    width: 48px;
    height: 48px;
    display: flex;
    align-items: center;
    justify-content: center;
}
.card-title {
    font-size: 1.3rem;
    font-weight: 600;
    color: #222;
}
.recipe-image {
    width: 100%;
    height: 320px;
    object-fit: cover;
    border-radius: 18px 18px 0 0;
    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
}
.admin-pro-card-content {
    padding: 32px 28px 24px 28px;
    background: #fff;
    border-radius: 0 0 18px 18px;
    box-shadow: 0 4px 24px rgba(0,0,0,0.07);
}
.section-title {
    color: #4CAF50;
    font-size: 1.2em;
    margin-bottom: 8px;
}
.ingredients-list ul {
    padding-left: 22px;
    line-height: 1.7;
}
.instructions-text {
    margin-bottom: 18px;
    line-height: 1.7;
    color: #555;
}
.action-buttons {
    display: flex;
    gap: 12px;
    flex-wrap: wrap;
    margin-top: 18px;
}
.approve-btn {
    background: linear-gradient(90deg,#43e97b 0%,#38f9d7 100%);
    color: #fff;
    font-weight: 600;
    border: none;
    padding: 10px 22px;
    border-radius: 6px;
    box-shadow: 0 2px 8px rgba(67,233,123,0.12);
    cursor: pointer;
    transition: background 0.2s;
}
.approve-btn:hover { background: #16a34a; }
.reject-btn {
    background: linear-gradient(90deg,#ff5858 0%,#f09819 100%);
    color: #fff;
    font-weight: 600;
    border: none;
    padding: 10px 22px;
    border-radius: 6px;
    box-shadow: 0 2px 8px rgba(255,88,88,0.12);
    cursor: pointer;
    transition: background 0.2s;
}
.reject-btn:hover { background: #b71c1c; }
.delete-btn {
    background: linear-gradient(90deg,#232526 0%,#414345 100%);
    color: #fff;
    font-weight: 600;
    border: none;
    padding: 10px 22px;
    border-radius: 6px;
    box-shadow: 0 2px 8px rgba(35,37,38,0.12);
    cursor: pointer;
    transition: background 0.2s;
}
.delete-btn:hover { background: #b71c1c; }
.back-button {
    background: #f5f5f5;
    color: #333;
    padding: 10px 22px;
    border-radius: 6px;
    text-decoration: none;
    font-weight: 600;
    box-shadow: 0 2px 8px rgba(0,0,0,0.04);
    transition: background 0.2s;
}
.back-button:hover { background: #e0e0e0; }
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
    <div class="container" style="max-width:900px;margin:0 auto;padding:2rem 1rem;">
        <h2 class="admin-view-title">Recipe Details</h2>
        <% Recipe recipe = (Recipe) request.getAttribute("recipe"); %>
        <% if (recipe != null) { %>
        <div class="admin-pro-card">
            <div class="admin-pro-card-header">
                <div class="card-icon">&#127859;</div>
                <div class="card-title">Recipe Details</div>
            </div>
            <img src="<%= recipe.getImageUrl() != null && !recipe.getImageUrl().isEmpty() ? recipe.getImageUrl() : "https://placehold.co/800x400/CCCCCC/000000?text=Recipe+Image" %>" alt="<%= recipe.getTitle() %>" class="recipe-image">
            <div class="admin-pro-card-content">
                <h2 style="font-size:2em;margin:0 0 10px 0;color:#222;font-weight:700;letter-spacing:0.5px;"> <%= recipe.getTitle() %> </h2>
                <div class="recipe-meta" style="font-size:1.05em;color:#888;margin-bottom:18px;display:flex;flex-wrap:wrap;gap:18px;">
                    <span>Category: <strong><%= recipe.getCategory() %></strong></span>
                    <% if (recipe.getRegion() != null && !recipe.getRegion().isEmpty()) { %>
                        <span>Region: <strong><%= recipe.getRegion() %></strong></span>
                    <% } %>
                    <span>Uploaded: <%= new java.text.SimpleDateFormat("dd MMM.yyyy HH:mm").format(recipe.getUploadDate()) %></span>
                    <span>Status: <span class="status-tag status-<%= recipe.getStatus().toLowerCase() %>"><%= recipe.getStatus() %></span></span>
                    <span>Uploader ID: <strong><%= recipe.getUserId() %></strong></span>
                </div>
                <hr class="admin-pro-divider" style="border:none;border-top:2px solid #f0f0f0;margin:18px 0 18px 0;" />
                <h3 class="section-title">Ingredients</h3>
                <div class="ingredients-list">
                    <ul>
                        <% String[] ingredients = recipe.getIngredients().split("\n");
                        for (String ingredient : ingredients) {
                            if (!ingredient.trim().isEmpty()) { %>
                            <li> <%= ingredient.trim() %> </li>
                        <% } } %>
                    </ul>
                </div>
                <h3 class="section-title">Instructions</h3>
                <div class="instructions-text">
                    <p><%= recipe.getInstructions().replace("\n", "<br>") %></p>
                </div>
                <div class="action-buttons">
                    <% if ("Pending".equals(recipe.getStatus())) { %>
                    <form action="AdminServlet" method="post" style="display: inline;">
                        <input type="hidden" name="action" value="approveRecipe">
                        <input type="hidden" name="recipeId" value="<%= recipe.getRecipeId() %>">
                        <button type="submit" class="approve-btn">Approve</button>
                    </form>
                    <form action="AdminServlet" method="post" style="display: inline;">
                        <input type="hidden" name="action" value="rejectRecipe">
                        <input type="hidden" name="recipeId" value="<%= recipe.getRecipeId() %>">
                        <button type="submit" class="reject-btn">Reject</button>
                    </form>
                    <% } %>
                    <form action="AdminServlet" method="post" style="display: inline;">
                        <input type="hidden" name="action" value="deleteRecipe">
                        <input type="hidden" name="id" value="<%= recipe.getRecipeId() %>">
                        <button type="submit" class="delete-btn">Delete</button>
                    </form>
                </div>
                <div style="text-align: center; margin-top: 28px;">
                    <a href="AdminServlet?action=listPendingRecipes" class="back-button">Back to Pending Recipes</a>
                </div>
            </div>
        </div>
        <% } else { %>
            <div style="margin: 60px auto; text-align: center; color: #888; font-size: 1.2em; background: #fff; padding: 40px 60px; border-radius: 16px; box-shadow: 0 2px 12px rgba(0,0,0,0.07);">
                <p>Recipe not found.</p>
                <a href="AdminServlet?action=listPendingRecipes" class="back-button">Back to Pending Recipes</a>
            </div>
        <% } %>
    </div>
</body>
</html>


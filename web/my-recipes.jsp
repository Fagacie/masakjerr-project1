<%-- 
    Document   : my-recipes
    Created on : Jun 16, 2025, 9:11:19?AM
    Author     : ACER
--%>
<%-- 
    Document   : my-recipes
    Created on : Jun 16, 2025, 9:11:19?AM
    Author     : ACER
--%>
<%@ page import="model.Recipe" %>
<%@ page import="model.User" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>My Recipes - MasakJerr!</title>
<link rel="stylesheet" href="styles/main-index.css">
<link rel="stylesheet" href="styles/main-my-recipes.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="header">
        <h1>MasakJerr!</h1>
        <nav>
            <a href="RecipeServlet?action=home">Home</a>
            <a href="RecipeServlet?action=listUserRecipes">My Recipes</a>
            <a href="RecipeServlet?action=new">Add New Recipe</a>
            <a href="UserServlet?action=viewProfile">Profile</a>
            <% User currentUser = (User) session.getAttribute("currentUser"); %>
            <% if (currentUser != null && "Admin".equals(currentUser.getRole())) { %>
                <a href="AdminServlet?action=dashboard">Admin Dashboard</a>
            <% } %>
            <a href="UserServlet?action=logout">Logout</a>
        </nav>
    </div>

    <section class="hero hero-my-recipes">
        <div class="hero-content">
            <h2>My Recipes</h2>
            <p>Manage, edit, and share your culinary creations with the MasakJerr community. All your submitted recipes are listed here for easy access and updates.</p>
        </div>
    </section>

    <section class="recipe-list-section">
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="message-box error-message"><%= request.getAttribute("errorMessage") %></div>
        <% } %>
        <% if (request.getAttribute("successMessage") != null) { %>
            <div class="message-box success-message"><%= request.getAttribute("successMessage") %></div>
        <% } %>
        <div class="recipe-grid">
            <% List<Recipe> listUserRecipes = (List<Recipe>) request.getAttribute("listUserRecipes");
               if (listUserRecipes != null && !listUserRecipes.isEmpty()) {
                   for (Recipe recipe : listUserRecipes) { %>
            <div class="recipe-card">
                <a href="RecipeServlet?action=view&id=<%= recipe.getRecipeId() %>" style="text-decoration:none;color:inherit;display:block;">
                    <img src="<%= recipe.getImageUrl() != null && !recipe.getImageUrl().isEmpty() ? recipe.getImageUrl() : "https://placehold.co/600x400/CCCCCC/000000?text=No+Image" %>" alt="<%= recipe.getTitle() %>">
                    <div class="recipe-card-content">
                        <h3><%= recipe.getTitle() %></h3>
                        <p><%= recipe.getIngredients().split("\n")[0] %>...</p>
                        <div class="recipe-card-meta">
                            <span><i class="fa-solid fa-tag"></i> <%= recipe.getCategory() %></span>
                            <% if (recipe.getRegion() != null && !recipe.getRegion().isEmpty()) { %>
                                <span><i class="fa-solid fa-location-dot"></i> <%= recipe.getRegion() %></span>
                            <% } %>
                            <span>Status: <%= recipe.getStatus() %></span>
                        </div>
                    </div>
                </a>
              <div class="recipe-card-actions">
    <a href="RecipeServlet?action=edit&id=<%= recipe.getRecipeId() %>" title="Edit" class="edit-btn">
        <i class="fa-solid fa-pen-to-square"></i>
    </a>

    <form action="RecipeServlet" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this recipe?');">
        <input type="hidden" name="action" value="deleteRecipe">
        <input type="hidden" name="id" value="<%= recipe.getRecipeId() %>">
        <button type="submit" title="Delete" class="delete-btn"><i class="fa-solid fa-trash"></i></button>
    </form>

   
    </div>
</div>
            <%   }
               } else { %>
            <p style="grid-column: 1 / -1; text-align: center; color: #666;">You have not added any recipes yet.</p>
            <% } %>
        </div>
    </section>

    <div class="footer">
        <div class="footer-links">
            <a href="#">Contact</a>
            <a href="#">Privacy</a>
        </div>
        <div class="footer-copy">&copy; 2025 MasakJerr!. All rights reserved.</div>
    </div>
    <script>
    // Card hover effect for interactivity
    document.addEventListener('DOMContentLoaded', function() {
        document.querySelectorAll('.recipe-card').forEach(function(card) {
            card.addEventListener('mouseenter', function() {
                card.style.boxShadow = '0 8px 32px rgba(230,126,34,0.18), 0 2px 12px rgba(0,0,0,0.10)';
                card.style.transform = 'translateY(-10px) scale(1.035)';
            });
            card.addEventListener('mouseleave', function() {
                card.style.boxShadow = '';
                card.style.transform = '';
            });
        });
    });
    </script>
</body>
</html>
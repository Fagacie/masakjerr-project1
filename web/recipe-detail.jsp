<%-- 
    Document   : recipe-detail
    Created on : Jun 16, 2025, 9:10:24?AM
    Author     : ACER
--%>
<%@ page import="model.Recipe" %>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Recipe Detail - MasakJerr!</title>
    <link rel="stylesheet" href="styles/main-index.css">
    <style>
        .recipe-detail-section {
            max-width: 800px;
            margin: 2.5rem auto 2rem auto;
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            padding: 2.5rem 2rem 2rem 2rem;
        }
        .recipe-image {
            width: 100%;
            height: 340px;
            object-fit: cover;
            border-radius: 12px;
            margin-bottom: 1.5rem;
            background: #fbeee6;
        }
        .recipe-content h2 {
            color: #e67e22;
            margin-top: 0;
            margin-bottom: 0.7rem;
            font-size: 2.1rem;
        }
        .recipe-meta {
            font-size: 1.05em;
            color: #888;
            margin-bottom: 1.5rem;
        }
        .recipe-meta span {
            margin-right: 1.5rem;
        }
        .section-title {
            color: #e67e22;
            font-size: 1.25em;
            margin-top: 2.2rem;
            margin-bottom: 0.7rem;
            border-bottom: 2px solid #ffe5b4;
            padding-bottom: 0.3rem;
        }
        .ingredients-list ul {
            list-style-type: disc;
            padding-left: 1.5rem;
            color: #444;
        }
        .ingredients-list li {
            margin-bottom: 0.4rem;
        }
        .instructions-text {
            color: #444;
            line-height: 1.7;
            font-size: 1.08em;
        }
        .back-button {
            display: inline-block;
            background: #e67e22;
            color: #fff;
            padding: 0.7rem 2.2rem;
            border-radius: 7px;
            text-decoration: none;
            font-size: 1.08em;
            margin-top: 2.2rem;
            font-weight: 600;
            transition: background 0.2s;
        }
        .back-button:hover {
            background: #cf711f;
        }
        @media (max-width: 900px) {
            .recipe-detail-section {
                padding: 1.2rem 0.5rem 1.5rem 0.5rem;
            }
            .recipe-image {
                height: 200px;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>MasakJerr!</h1>
        <nav>
            <% model.User currentUser = (model.User) session.getAttribute("currentUser"); %>
            <% if (currentUser != null) { %>
                <span>Welcome, <%= currentUser.getFirstName() != null && !currentUser.getFirstName().isEmpty() ? currentUser.getFirstName() : currentUser.getUsername() %>!</span>
                <a href="RecipeServlet?action=home">Home</a>
                <a href="RecipeServlet?action=listUserRecipes">My Recipes</a>
                <a href="add-recipe.jsp">Add New Recipe</a>
                <a href="UserServlet?action=viewProfile">Profile</a>
                <% if (currentUser.getRole() != null && currentUser.getRole().equals("admin")) { %>
                    <a href="AdminServlet?action=dashboard">Admin Dashboard</a>
                <% } %>
                <a href="UserServlet?action=logout">Logout</a>
            <% } else { %>
                <a href="login.jsp">Login</a>
                <a href="register.jsp">Register</a>
            <% } %>
        </nav>
    </div>

    <section class="recipe-detail-section">
        <%
            Recipe recipe = (Recipe) request.getAttribute("recipe");
            if (recipe != null) {
        %>
                <img src="<%= recipe.getImageUrl() != null && !recipe.getImageUrl().isEmpty() ? recipe.getImageUrl() : "https://placehold.co/800x400/CCCCCC/000000?text=Recipe+Image" %>" alt="<%= recipe.getTitle() %>" class="recipe-image">

                <div class="recipe-content">
                    <h2><%= recipe.getTitle() %></h2>
                    <div class="recipe-meta">
                        <span>Category: <%= recipe.getCategory() %></span>
                        <% if (recipe.getRegion() != null && !recipe.getRegion().isEmpty()) { %>
                            <span>Region: <%= recipe.getRegion() %></span>
                        <% } %>
                        <span>Uploaded: <%= new java.text.SimpleDateFormat("dd MMM yyyy").format(recipe.getUploadDate()) %></span>
                    </div>

                    <h3 class="section-title">Ingredients</h3>
                    <div class="ingredients-list">
                        <ul>
                            <%
                                String[] ingredients = recipe.getIngredients().split("\n");
                                for (String ingredient : ingredients) {
                                    if (!ingredient.trim().isEmpty()) {
                            %>
                                    <li><%= ingredient.trim() %></li>
                            <%
                                    }
                                }
                            %>
                        </ul>
                    </div>

                    <h3 class="section-title">Instructions</h3>
                    <div class="instructions-text">
                        <p><%= recipe.getInstructions().replace("\n", "<br>") %></p>
                    </div>
                </div>
                <div style="text-align: center;">
                    <a href="javascript:history.back()" class="back-button">Back to Recipes</a>
                </div>
        <%
            } else {
        %>
                <p style="text-align: center; color: #666;">Recipe not found.</p>
                <div style="text-align: center;">
                    <a href="RecipeServlet?action=list" class="back-button">View All Recipes</a>
                </div>
        <%
            }
        %>
    </section>

    <div class="footer">
        &copy; 2025 MasakJerr!. All rights reserved.
    </div>
</body>
</html>

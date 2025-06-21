<%-- 
    Document   : index
    Created on : Jun 16, 2025, 8:45:45?AM
    Author     : ACER
--%>


<%-- 
    Document   : index
    Created on : Jun 16, 2025, 8:45:45 AM
    Author     : ACER
--%>
<%@ page import="model.User" %>
<%@ page import="model.Recipe" %>
<%@ page import="java.util.List" %>
<%@ page import="dao.RatingDAO" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect("index.html");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Home - MasakJerr!</title>
    <link rel="stylesheet" href="styles/main-index.css">
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
            <% if ("Admin".equals(currentUser.getRole())) { %>
                <a href="AdminServlet?action=dashboard">Admin Dashboard</a>
            <% } %>
            <a href="logoutRedirect.jsp">Logout</a>
        </nav>
    </div>

    <section class="hero">
        <div class="hero-content">
            <h2>Enjoy Our Delicious Meal</h2>
            <p>Discover authentic Malaysian traditional recipes. Dive into a world of flavors, passed down through generations. Join MasakJerr! and start your culinary adventure today.</p>
            <a href="RecipeServlet?action=new" class="cta-btn">Add New Recipe</a>
        </div>
    </section>

    <section class="how-it-works-section" style="max-width:1100px;margin:2.5rem auto 1.5rem auto;padding:2rem 1.5rem;background:#fff;border-radius:16px;box-shadow:0 2px 12px rgba(0,0,0,0.07);">
        <h2 style="color:#e67e22;text-align:center;margin-bottom:1.2rem;font-size:2rem;">How MasakJerr Works</h2>
        <div style="display:flex;flex-wrap:wrap;gap:2.5rem;justify-content:center;">
            <div style="flex:1 1 220px;max-width:260px;text-align:center;">
                <div style="font-size:2.5rem;color:#e67e22;"><i class="fa-solid fa-magnifying-glass"></i></div>
                <h3 style="color:#e67e22;">Browse Recipes</h3>
                <p>Explore a wide variety of Malaysian recipes shared by the community.</p>
            </div>
            <div style="flex:1 1 220px;max-width:260px;text-align:center;">
                <div style="font-size:2.5rem;color:#e67e22;"><i class="fa-solid fa-pen-to-square"></i></div>
                <h3 style="color:#e67e22;">Share Your Own</h3>
                <p>Have a family favorite? Add your own recipe and help others!</p>
            </div>
            <div style="flex:1 1 220px;max-width:260px;text-align:center;">
                <div style="font-size:2.5rem;color:#e67e22;"><i class="fa-solid fa-user-group"></i></div>
                <h3 style="color:#e67e22;">Join the Community</h3>
                <p>Sign up to save favorites, comment, and connect with others.</p>
            </div>
        </div>
    </section>

    <section class="recipe-list-section">
        <h3>All Recipes</h3>
        <div class="recipe-grid">
            <%
                List<Recipe> listRecipes = (List<Recipe>) request.getAttribute("listRecipes");
                if (listRecipes != null && !listRecipes.isEmpty()) {
                    boolean hasApproved = false;
                    RatingDAO ratingDAO = new RatingDAO();
                    for (Recipe recipe : listRecipes) {
                        if ("Approved".equalsIgnoreCase(recipe.getStatus())) {
                            hasApproved = true;
                            double avgRating = ratingDAO.getAverageRating(recipe.getRecipeId());
            %>
            <div class="recipe-card">
                <img src="<%= recipe.getImageUrl() != null && !recipe.getImageUrl().isEmpty() ? recipe.getImageUrl() : "https://placehold.co/600x400/CCCCCC/000000?text=No+Image" %>" alt="<%= recipe.getTitle() %>">
                <div class="recipe-card-content">
                    <h3><%= recipe.getTitle() %></h3>
                    <p><%= recipe.getIngredients().split("\n")[0] %>...</p>
                    <div class="recipe-card-meta">
                        <span><i class="fa-solid fa-tag"></i> <%= recipe.getCategory() %></span>
                        <% if (recipe.getRegion() != null && !recipe.getRegion().isEmpty()) { %>
                            <span><i class="fa-solid fa-location-dot"></i> <%= recipe.getRegion() %></span>
                        <% } %>
                    </div>

                    <!-- Rating Form -->
                    <form onsubmit="submitRating(event, <%= recipe.getRecipeId() %>)" style="margin-top: 5px;">
                        <label for="rating">Rate: </label>
                        <select name="rating" id="rating-<%= recipe.getRecipeId() %>">
                            <option value="1">1 ?</option>
                            <option value="2">2 ?</option>
                            <option value="3">3 ?</option>
                            <option value="4">4 ?</option>
                            <option value="5">5 ?</option>
                        </select>
                        <button type="submit" class="rate-btn" style="margin-left: 5px; padding: 2px 8px; background: #e67e22; color: #fff; border: none; border-radius: 4px; cursor: pointer;">Submit</button>
                    </form>

                    <!-- Average Rating -->
                    <div class="average-rating" id="avg-rating-<%= recipe.getRecipeId() %>" style="margin-top: 5px; font-size: 0.95rem; color: #333;">
                        Average Rating:
                        <strong><%= avgRating > 0 ? String.format("%.1f", avgRating) + " ?" : "Not rated yet" %></strong>
                    </div>
                </div>
            </div>
            <%
                        }
                    }
                    if (!hasApproved) {
            %>
                <p style="grid-column: 1 / -1; text-align: center; color: #666;">No recipes found yet.</p>
            <%
                    }
                } else {
            %>
                <p style="grid-column: 1 / -1; text-align: center; color: #666;">No recipes found yet.</p>
            <%
                }
            %>
        </div>
    </section>

    <section class="cta-section" style="max-width:900px;margin:2.5rem auto;padding:2rem;background:#fff;border-radius:16px;box-shadow:0 2px 12px rgba(0,0,0,0.07);text-align:center;">
        <h2 style="color:#e67e22;margin-bottom:1rem;">Share Your Favorite Recipe!</h2>
        <p style="color:#555;margin-bottom:1.5rem;">Have a delicious dish to share? Inspire others by adding your own recipe to MasakJerr!</p>
        <a href="add-recipe.jsp" class="cta-btn" style="background:#e67e22;color:#fff;padding:0.9rem 2.2rem;border-radius:7px;font-size:1.13rem;text-decoration:none;">Add New Recipe</a>
    </section>

    <div class="footer">
        <div class="footer-links">
            <a href="#">Contact</a>
            <a href="#">Privacy</a>
        </div>
        <div class="footer-copy">&copy; 2025 MasakJerr!. All rights reserved.</div>
    </div>

    <!-- Rating AJAX Script -->
    <script>
    function submitRating(event, recipeId) {
        event.preventDefault();
        const rating = document.getElementById("rating-" + recipeId).value;

        fetch("RatingServlet", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: "recipeId=" + recipeId + "&rating=" + rating
        })
        .then(response => {
            if (!response.ok) {
                throw new Error("Failed to submit rating.");
            }
            return response.text();
        })
        .then(updatedAverage => {
            const avgDiv = document.getElementById("avg-rating-" + recipeId);
            avgDiv.innerHTML = "Average Rating: <strong>" + updatedAverage + " ?</strong>";
        })
        .catch(error => {
            alert("Error: " + error.message);
        });
    }

    // Card hover animation
    document.addEventListener('DOMContentLoaded', function() {
        document.querySelectorAll('.recipe-card').forEach(function(card) {
            card.addEventListener('mouseenter', function() {
                card.style.boxShadow = '0 4px 16px rgba(230,126,34,0.15)';
                card.style.transform = 'translateY(-8px) scale(1.03)';
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
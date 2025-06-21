<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add New Recipe - MasakJerr!</title>
    <link rel="stylesheet" href="styles/main-index.css">
    <style>
        .add-recipe-section {
            max-width: 600px;
            margin: 2.5rem auto 2rem auto;
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            padding: 2.5rem 2rem 2rem 2rem;
        }
        .add-recipe-section h2 {
            color: #e67e22;
            text-align: center;
            margin-bottom: 1.5rem;
            font-size: 2rem;
        }
        .form-group {
            margin-bottom: 1.3rem;
        }
        label {
            display: block;
            margin-bottom: 0.4rem;
            color: #e67e22;
            font-weight: 600;
            font-size: 1.05em;
        }
        input[type="text"], select, textarea {
            width: 100%;
            padding: 0.7rem 1rem;
            border: 1.5px solid #eee;
            border-radius: 7px;
            font-size: 1.05em;
            background: #f8fafc;
            transition: border 0.2s;
        }
        input[type="text"]:focus, select:focus, textarea:focus {
            border: 1.5px solid #e67e22;
            outline: none;
        }
        textarea {
            min-height: 110px;
            resize: vertical;
        }
        input[type="file"] {
            background: #fff;
            border: none;
            font-size: 1em;
            margin-top: 0.2rem;
        }
        .message-box {
            margin-bottom: 1.2rem;
            padding: 0.8rem 1rem;
            border-radius: 7px;
            font-weight: 500;
            text-align: center;
        }
        .error-message {
            color: #b71c1c;
            background: #ffeaea;
            border: 1px solid #ffcdd2;
        }
        .add-btn {
            background: #e67e22;
            color: #fff;
            border: none;
            border-radius: 7px;
            padding: 0.9rem 0;
            font-size: 1.1em;
            font-weight: 600;
            width: 100%;
            margin-top: 1.2rem;
            cursor: pointer;
            transition: background 0.2s;
        }
        .add-btn:hover {
            background: #cf711f;
        }
        @media (max-width: 700px) {
            .add-recipe-section {
                padding: 1.2rem 0.5rem 1.5rem 0.5rem;
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

    <section class="add-recipe-section">
        <h2>Add New Recipe</h2>
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="message-box error-message"><%= request.getAttribute("errorMessage") %></div>
        <% } %>
        <form action="RecipeServlet" method="post" enctype="multipart/form-data" autocomplete="off">
            <input type="hidden" name="action" value="addRecipe">
            <div class="form-group">
                <label for="title">Recipe Title</label>
                <input type="text" id="title" name="title" required maxlength="100">
            </div>
            <div class="form-group">
                <label for="category">Category</label>
                <select id="category" name="category" required>
                    <option value="">Select a Category</option>
                    <option value="Main Dish">Main Dish</option>
                    <option value="Dessert">Dessert</option>
                    <option value="Breakfast">Breakfast</option>
                    <option value="Snack">Snack</option>
                    <option value="Drink">Drink</option>
                    <option value="Appetizer">Appetizer</option>
                    <option value="Soup">Soup</option>
                </select>
            </div>
            <div class="form-group">
    <label for="region">Region <span style="color:#bbb;font-weight:400;font-size:0.95em;">(e.g., Selangor, Johor, Kelantan)</span></label>
    <select id="region" name="region" required>
        <option value="">Select a Region</option>
        <option value="Selangor">Selangor</option>
        <option value="Johor">Johor</option>
        <option value="Kelantan">Kelantan</option>
        <option value="Penang">Penang</option>
        <option value="Sabah">Sabah</option>
        <option value="Sarawak">Sarawak</option>
        <option value="Negeri Sembilan">Negeri Sembilan</option>
        <option value="Malacca">Malacca</option>
        <option value="Perak">Perak</option>
        <option value="Terengganu">Terengganu</option>
        <option value="Pahang">Pahang</option>
        <option value="Kedah">Kedah</option>
        <option value="Perlis">Perlis</option>
        <option value="Putrajaya">Putrajaya</option>
        <option value="Kuala Lumpur">Kuala Lumpur</option>
        <option value="Labuan">Labuan</option>
    </select>
</div>

            <div class="form-group">
                <label for="ingredients">Ingredients <span style="color:#bbb;font-weight:400;font-size:0.95em;">(one per line or comma-separated)</span></label>
                <textarea id="ingredients" name="ingredients" required maxlength="1000"></textarea>
            </div>
            <div class="form-group">
                <label for="instructions">Instructions <span style="color:#bbb;font-weight:400;font-size:0.95em;">(step-by-step)</span></label>
                <textarea id="instructions" name="instructions" required maxlength="3000"></textarea>
            </div>
            <div class="form-group">
                <label for="imageFile">Upload Image <span style="color:#bbb;font-weight:400;font-size:0.95em;">(optional)</span></label>
                <input type="file" id="imageFile" name="imageFile" accept="image/*">
            </div>
            <button type="submit" class="add-btn">Submit Recipe</button>
        </form>
    </section>

    <div class="footer">
        &copy; 2025 MasakJerr!. All rights reserved.
    </div>
</body>
</html>

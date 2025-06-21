<%-- 
    Document   : about
    Created on : Jun 16, 2025, 10:37:19?AM
    Author     : ACER
--%>

<%@ page import="model.User" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>About Us - MasakJerr!</title>
<style>
body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    margin: 0;
    padding: 0;
}
.header {
    background-color: #333;
    color: white;
    padding: 15px 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
}
.header h1 {
    margin: 0;
    font-size: 1.8em;
}
.header nav a {
    color: white;
    text-decoration: none;
    margin-left: 20px;
    font-size: 1.1em;
}
.header nav a:hover {
    text-decoration: underline;
}
.about-container {
    background-color: #fff;
    padding: 30px;
    border-radius: 8px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    width: 800px;
    margin: 20px auto;
    text-align: left;
    line-height: 1.7;
    color: #444;
}
h2 {
    margin-bottom: 25px;
    color: #333;
    text-align: center;
}
h3 {
    color: #007bff;
    margin-top: 30px;
    margin-bottom: 15px;
    border-bottom: 1px solid #eee;
    padding-bottom: 5px;
}
p {
    margin-bottom: 1em;
}
ul {
    list-style-type: disc;
    padding-left: 25px;
    margin-bottom: 1em;
}
li {
    margin-bottom: 0.5em;
}
.footer {
    text-align: center;
    padding: 20px;
    color: #777;
    font-size: 0.9em;
    margin-top: 50px;
}
</style>
</head>
<body>
    <div class="header">
        <h1>MasakJerr!</h1>
        <nav>
            <% User currentUser = (User) session.getAttribute("currentUser"); %>
            <% if (currentUser != null) { %>
                <span>Welcome, <%= currentUser.getFirstName() != null && !currentUser.getFirstName().isEmpty() ? currentUser.getFirstName() : currentUser.getUsername() %>!</span>
                <a href="index.jsp">Home</a>
                <a href="UserServlet?action=viewProfile">My Profile</a>
                <a href="RecipeServlet?action=listUserRecipes">My Recipes</a>
                <a href="UserServlet?action=logout">Logout</a>
            <% } else { %>
                <a href="login.jsp">Login</a>
                <a href="register.jsp">Register</a>
            <% } %>
        </nav>
    </div>

    <div class="about-container">
        <h2>About MasakJerr!</h2>

        <p>Welcome to <strong>MasakJerr!</strong>, your dedicated online platform for celebrating and preserving the rich culinary heritage of Malaysian traditional cuisine. Our mission is to bridge the generational gap and ensure that the authentic flavors and cherished recipes of Malaysia are readily accessible to everyone, everywhere.</p>

        <h3>Our Mission</h3>
        <ul>
            <li><strong>Preserve Traditional Knowledge:</strong> To digitize and document traditional Malaysian recipes that are often passed down orally or kept within families, preventing their loss and ensuring they are available for future generations.</li>
            <li><strong>Centralize Recipe Resources:</strong> To act as a focal point for gathering, conserving, and sharing authentic Malaysian recipes, offering a centralized, trustworthy source for culinary exploration.</li>
            <li><strong>Connect Cooking Communities:</strong> To foster a vibrant community where experienced cooks can share their wisdom, younger learners can discover new skills, and food enthusiasts can connect, collaborate, and exchange feedback through comments and ratings.</li>
            <li><strong>Promote Malaysian Cuisine:</strong> To make the diverse and delicious world of Malaysian local recipes accessible to both indigenous Malaysians and a global audience, promoting cultural appreciation through food.</li>
        </ul>

        <h3>Our Story</h3>
        <p>MasakJerr! was born out of a deep love for Malaysian food and a recognition of the need to safeguard its unique traditions. We noticed that many precious family recipes were at risk of being forgotten as they were not formally documented. Our team embarked on a journey to create a platform where these culinary treasures could be shared, discovered, and passed on, ensuring that the essence of Malaysian kitchens lives on.</p>
        <p>From the bustling streets of Kuala Lumpur to the serene villages of Terengganu, every region of Malaysia boasts its own distinct flavors and cooking techniques. MasakJerr! aims to be a comprehensive repository that reflects this incredible diversity, inviting everyone to explore, learn, and contribute to our growing collection.</p>

        <h3>Our Vision</h3>
        <p>We envision MasakJerr! as more than just a recipe website; it's a community-driven initiative for cultural preservation. We believe that food tells a story, connects people, and holds memories. By providing a platform for sharing and learning, we hope to ignite a passion for traditional cooking in a new generation and create lasting connections through the universal language of food.</p>
    </div>

    <div class="footer">
        &copy; 2025 MasakJerr!. All rights reserved.
    </div>
</body>
</html>

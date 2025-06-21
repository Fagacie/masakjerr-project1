<%-- 
    Document   : error
    Created on : Jun 16, 2025, 9:19:18?AM
    Author     : ACER
--%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Error - MasakJerr!</title>
</head>
<body>
    <div class="error-container">
        <h2>An Error Occurred!</h2>
        <p>We're sorry, but something went wrong. Please try again or navigate back.</p>

        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="error-details">
                <strong>Error Message:</strong> <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>

        <a href="index.jsp" class="back-link">Go to Homepage</a>
    </div>
</body>
</html>

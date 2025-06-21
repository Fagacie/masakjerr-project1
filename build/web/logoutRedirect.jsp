<%-- 
    Document   : logoutRedirect
    Created on : 21 Jun 2025, 2:41:00 pm
    Author     : Acer
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Successfully Logged Out</title>
    <meta http-equiv="refresh" content="5;url=index.html"> <!-- fallback redirect -->
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f4f4f4;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
        }

        .container {
            background-color: #fff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
            text-align: center;
            max-width: 400px;
            width: 100%;
        }

        .checkmark {
            width: 80px;
            height: 80px;
            margin: 0 auto 20px;
            border-radius: 50%;
            border: 4px solid #22c55e;
            position: relative;
        }

        .checkmark::after {
            content: '';
            position: absolute;
            width: 25px;
            height: 6px;
            background-color: #22c55e;
            top: 38px;
            left: 18px;
            transform: rotate(-45deg);
            transform-origin: left top;
        }

        .checkmark::before {
            content: '';
            position: absolute;
            width: 12px;
            height: 6px;
            background-color: #22c55e;
            top: 44px;
            left: 15px;
            transform: rotate(45deg);
            transform-origin: left top;
        }

        h2 {
            color: #333;
            margin-bottom: 10px;
        }

        p {
            color: #555;
            font-size: 16px;
        }

        #countdown {
            font-weight: bold;
            color: #3b82f6;
            margin-top: 5px;
        }

        .btn-home {
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #3b82f6;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 15px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }

        .btn-home:hover {
            background-color: #2563eb;
        }
    </style>
    <script>
        let seconds = 5;
        function updateCountdown() {
            document.getElementById("countdown").textContent = seconds;
            seconds--;
            if (seconds < 0) {
                clearInterval(timer);
                window.location.href = "index.html";
            }
        }

        window.onload = function () {
            updateCountdown();
            timer = setInterval(updateCountdown, 1000);
        };
    </script>
</head>
<body>
    <div class="container">
        <div class="checkmark"></div>
        <h2>Successfully Logged Out</h2>
        <p>You have safely logged out of your account.</p>
        <p>Redirecting to the main page in <span id="countdown">5</span> seconds...</p>
        <a class="btn-home" href="index.html">Go to Home Now</a>
    </div>
</body>
</html>


/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlet;



import dao.UserDAO;
import model.User;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/UserServlet")
public class UserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    public void init() {
        userDAO = new UserDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            action = "";
        }

        switch (action) {
            case "register":
                registerUser(request, response);
                break;
            case "login":
                loginUser(request, response);
                break;
            case "updateProfile":
                updateUserProfile(request, response);
                break;
            case "deleteAccount":
                deleteUserAccount(request, response);
                break;
            case "logout":
                logoutUser(request, response);
                break;
            default:
                response.sendRedirect("RecipeServlet?action=home"); // Redirect to home action to show recipes
                break;
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            action = "";
        }

        switch (action) {
            case "showRegister":
                request.getRequestDispatcher("register.jsp").forward(request, response);
                break;
            case "showLogin":
                request.getRequestDispatcher("login.jsp").forward(request, response);
                break;
            case "viewProfile":
                viewUserProfile(request, response);
                break;
            default:
                response.sendRedirect("index.jsp");
                break;
        }
    }

    private void registerUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String bio = request.getParameter("bio");

        if (username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Username, Email, and Password are required.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        User existingUserByUsername = userDAO.selectUserByUsername(username);
        User existingUserByEmail = userDAO.selectUserByEmail(email);

        if (existingUserByUsername != null) {
            request.setAttribute("errorMessage", "Username already exists. Please choose a different one.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        } else if (existingUserByEmail != null) {
            request.setAttribute("errorMessage", "Email already registered. Please use a different email or log in.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        } else {
            User newUser = new User();
            newUser.setUsername(username);
            newUser.setEmail(email);
            newUser.setPassword(password);
            newUser.setFirstName(firstName);
            newUser.setLastName(lastName);
            newUser.setBio(bio);
            newUser.setRole("RegularUser");
            newUser.setRegistrationDate(new Timestamp(new Date().getTime()));

            try {
                userDAO.registerUser(newUser);
                response.sendRedirect("login.jsp?registered=true");
            } catch (SQLException e) {
                request.setAttribute("errorMessage", "Registration failed: " + e.getMessage());
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
        }
    }

    private void loginUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String usernameOrEmail = request.getParameter("usernameOrEmail");
        String password = request.getParameter("password");

        if (usernameOrEmail == null || usernameOrEmail.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Username/Email and Password are required.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        User user = null;
        if (usernameOrEmail.contains("@")) {
            user = userDAO.selectUserByEmail(usernameOrEmail);
        } else {
            user = userDAO.selectUserByUsername(usernameOrEmail);
        }

        if (user != null && user.getPassword().equals(password)) {
            HttpSession session = request.getSession();
            session.setAttribute("currentUser", user);

            // Redirect based on user role
            if ("Admin".equals(user.getRole())) {
                response.sendRedirect("AdminServlet?action=dashboard"); // Redirect Admin to Admin Dashboard
            } else {
                response.sendRedirect("RecipeServlet?action=home"); // Redirect to home action to show recipes
            }
        } else {
            request.setAttribute("errorMessage", "Invalid username/email or password.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    private void viewUserProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            User user = (User) session.getAttribute("currentUser");
            request.setAttribute("userProfile", user);
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        } else {
            response.sendRedirect("login.jsp");
        }
    }

    private void updateUserProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String bio = request.getParameter("bio");

        if (username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Username and Email cannot be empty.");
            viewUserProfile(request, response);
            return;
        }

        User existingUserByUsername = userDAO.selectUserByUsername(username);
        if (existingUserByUsername != null && existingUserByUsername.getUserId() != currentUser.getUserId()) {
            request.setAttribute("errorMessage", "Username already taken by another user.");
            viewUserProfile(request, response);
            return;
        }

        User existingUserByEmail = userDAO.selectUserByEmail(email);
        if (existingUserByEmail != null && existingUserByEmail.getUserId() != currentUser.getUserId()) {
            request.setAttribute("errorMessage", "Email already taken by another user.");
            viewUserProfile(request, response);
            return;
        }

        currentUser.setUsername(username);
        currentUser.setEmail(email);
        if (password != null && !password.trim().isEmpty()) {
            currentUser.setPassword(password);
        }
        currentUser.setFirstName(firstName);
        currentUser.setLastName(lastName);
        currentUser.setBio(bio);

        try {
            boolean updated = userDAO.updateUser(currentUser);
            if (updated) {
                session.setAttribute("currentUser", currentUser);
                request.setAttribute("successMessage", "Profile updated successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to update profile.");
            }
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Database error updating profile: " + e.getMessage());
        }
        viewUserProfile(request, response);
    }

    private void deleteUserAccount(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    HttpSession session = request.getSession(false);
    if (session == null || session.getAttribute("currentUser") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    User currentUser = (User) session.getAttribute("currentUser");
    int userIdToDelete = currentUser.getUserId();

    try {
        boolean deleted = userDAO.deleteUser(userIdToDelete);
        if (deleted) {
            session.invalidate(); // Log the user out
            response.sendRedirect("register.jsp?deleted=true");
        } else {
            request.setAttribute("errorMessage", "Failed to delete account. Please try again.");
            viewUserProfile(request, response);
        }
    } catch (SQLException e) {
        request.setAttribute("errorMessage", "Database error deleting account: " + e.getMessage());
        viewUserProfile(request, response);
        }
    }


    private void logoutUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        // Prevent browser caching after logout
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        response.sendRedirect("logoutRedirect.jsp"); 
    }
}

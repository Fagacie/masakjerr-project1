/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlet;


/**
 *
 * @author ACER
 */



import dao.AdminRecipeDAO;
import dao.AdminUserDAO;
import model.Recipe;
import model.User;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AdminUserDAO adminUserDAO;
    private AdminRecipeDAO adminRecipeDAO;

    public void init() {
        adminUserDAO = new AdminUserDAO();
        adminRecipeDAO = new AdminRecipeDAO();
    }

    // Helper method to check if the current user is an Admin
    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            User currentUser = (User) session.getAttribute("currentUser");
            return "Admin".equals(currentUser.getRole());
        }
        return false;
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect("login.jsp?message=UnauthorizedAccess");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        try {
            switch (action) {
                case "updateUserRole":
                    updateUserRole(request, response);
                    break;
                case "deleteUser":
                    deleteUser(request, response);
                    break;
                case "approveRecipe":
                    updateRecipeStatus(request, response, "Approved");
                    break;
                case "rejectRecipe":
                    updateRecipeStatus(request, response, "Rejected");
                    break;
                case "deleteRecipe":
                    deleteRecipe(request, response);
                    break;
               
                default:
                    response.sendRedirect("AdminServlet?action=dashboard"); // Default to dashboard
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Print stack trace to server logs for debugging
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            // Based on the action, directly forward to the appropriate admin page
            // The JSP will then display the error message.
            try {
                if (action.contains("User")) {
                    // Try to re-list users, which will set error and forward
                    // If listUsers itself throws SQLException, it will be caught internally and forwarded to error.jsp
                    listUsers(request, response);
                } else if (action.contains("Recipe")) {
                    // Try to re-list pending recipes, which will set error and forward
                    // If listPendingRecipes itself throws SQLException, it will be caught internally and forwarded to error.jsp
                    listPendingRecipes(request, response);
                } else {
                    // Fallback for actions not directly covered or if initial forwarding fails
                    request.getRequestDispatcher("error.jsp").forward(request, response);
                }
            } catch (ServletException | IOException innerEx) {
                innerEx.printStackTrace(); // Log any exception during forwarding
                // If even forwarding fails, redirect to a generic error page as a last resort
                response.sendRedirect("error.jsp?msg=CriticalRedirectFailure");
            } catch (SQLException ex) {
                Logger.getLogger(AdminServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect("login.jsp?message=UnauthorizedAccess"); // Redirect if not admin
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "dashboard"; // Default admin view
        }

        try {
            switch (action) {
                case "dashboard":
                    showAdminDashboard(request, response);
                    break;
                case "listUsers":
                    listUsers(request, response);
                    break;
                case "editUser": // Admin edits user profile/role
                    showEditUserForm(request, response);
                    break;
                case "listPendingRecipes":
                    listPendingRecipes(request, response);
                    break;
                case "viewRecipeForApproval":
                    viewRecipeForApproval(request, response);
                    break;
                case "listAllRecipesAdmin": // Admin view of all recipes, including status
                    listAllRecipesAdmin(request, response);
                    break;
                case "logout":
                    response.sendRedirect("logoutRedirect.jsp");
                    break;
                default:
                    showAdminDashboard(request, response);
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    private void showAdminDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        // Fetch counts for dashboard summary
        List<Recipe> pendingRecipes = adminRecipeDAO.selectRecipesByStatus("Pending");
        List<User> allUsers = adminUserDAO.selectAllUsers();

        request.setAttribute("pendingRecipeCount", pendingRecipes.size());
        request.setAttribute("totalUserCount", allUsers.size());

        request.getRequestDispatcher("admin-dashboard.jsp").forward(request, response);
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        List<User> listUsers = adminUserDAO.selectAllUsers();
        request.setAttribute("listUsers", listUsers);
        request.getRequestDispatcher("admin-user-management.jsp").forward(request, response);
    }

    private void showEditUserForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int userId = Integer.parseInt(request.getParameter("id"));
        User userToEdit = adminUserDAO.selectUserById(userId);
        if (userToEdit != null) {
            request.setAttribute("userToEdit", userToEdit);
            request.getRequestDispatcher("admin-edit-user.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "User not found.");
            listUsers(request, response);
        }
    }

    private void updateUserRole(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String newRole = request.getParameter("newRole");

        // Basic validation for new role
        if (newRole == null || (!newRole.equals("RegularUser") && !newRole.equals("Admin"))) {
            request.setAttribute("errorMessage", "Invalid role specified.");
            showEditUserForm(request, response); // Go back to edit form
            return;
        }

        boolean updated = adminUserDAO.updateUserRole(userId, newRole);
        if (updated) {
            request.setAttribute("successMessage", "User role updated successfully!");
        } else {
            request.setAttribute("errorMessage", "Failed to update user role.");
        }
        listUsers(request, response);
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int userId = Integer.parseInt(request.getParameter("id"));
        // Prevent admin from deleting themselves (optional but good practice)
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null && currentUser.getUserId() == userId) {
            request.setAttribute("errorMessage", "Admin cannot delete their own account via this interface.");
            listUsers(request, response);
            return;
        }

        boolean deleted = adminUserDAO.deleteUser(userId);
        if (deleted) {
            request.setAttribute("successMessage", "User deleted successfully!");
        } else {
            request.setAttribute("errorMessage", "Failed to delete user.");
        }
        listUsers(request, response);
    }

    private void listPendingRecipes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        List<Recipe> pendingRecipes = adminRecipeDAO.selectRecipesByStatus("Pending");
        request.setAttribute("pendingRecipes", pendingRecipes);
        request.getRequestDispatcher("admin-recipe-approval.jsp").forward(request, response);
    }

    private void listAllRecipesAdmin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        List<Recipe> allRecipes = adminRecipeDAO.selectAllRecipes();
        request.setAttribute("allRecipes", allRecipes);
        request.getRequestDispatcher("admin-all-recipes.jsp").forward(request, response);
    }

    private void viewRecipeForApproval(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int recipeId = Integer.parseInt(request.getParameter("id"));
        Recipe recipe = adminRecipeDAO.selectRecipeById(recipeId);
        if (recipe != null) {
            request.setAttribute("recipe", recipe);
            request.getRequestDispatcher("admin-view-recipe.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Recipe not found for approval.");
            listPendingRecipes(request, response);
        }
    }

    private void updateRecipeStatus(HttpServletRequest request, HttpServletResponse response, String status)
            throws ServletException, IOException, SQLException {
        int recipeId = Integer.parseInt(request.getParameter("recipeId"));

        boolean updated = adminRecipeDAO.updateRecipeStatus(recipeId, status);
        if (updated) {
            request.setAttribute("successMessage", "Recipe " + status.toLowerCase() + " successfully!");
        } else {
            request.setAttribute("errorMessage", "Failed to " + status.toLowerCase() + " recipe.");
        }
        listPendingRecipes(request, response); // Redirect back to pending list
    }

    // Admin can delete any recipe, the method is already in DAO. Admin UI should provide link to this.
    private void deleteRecipe(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int recipeId = Integer.parseInt(request.getParameter("id"));
        boolean deleted = adminRecipeDAO.deleteRecipe(recipeId);
        if (deleted) {
            request.setAttribute("successMessage", "Recipe deleted successfully by admin!");
        } else {
            request.setAttribute("errorMessage", "Failed to delete recipe by admin.");
        }
        // Redirect based on previous view or to general admin recipe list
        String referer = request.getHeader("referer");
        if (referer != null && referer.contains("admin-recipe-approval.jsp")) {
            listPendingRecipes(request, response);
        } else {
            listAllRecipesAdmin(request, response); // Fallback to all recipes admin view
        }
    }
}

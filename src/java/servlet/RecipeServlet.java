package servlet;

import dao.RecipeDAO;
import model.Recipe;
import model.User;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet("/RecipeServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class RecipeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RecipeDAO recipeDAO;

    // IMPORTANT CHANGE: Using the specific absolute path provided by the user as the base.
    // This assumes that the 'web' folder is the root of the web application deployment.
    private static final String BASE_UPLOAD_DIRECTORY = "C:" + File.separator + "Users" + File.separator + "ACER" + File.separator + "Desktop" + File.separator + "Masakjerr_newModify" + File.separator + "WebProject(MasakJerr)" + File.separator + "WebProject(MasakJerr)" + File.separator + "web";

    // Relative subdirectories from the BASE_UPLOAD_DIRECTORY
    private static final String UPLOAD_DIRECTORY_IMAGES_RELATIVE = "uploads" + File.separator + "recipes" + File.separator + "images";
    private static final String UPLOAD_DIRECTORY_VIDEOS_RELATIVE = "uploads" + File.separator + "recipes" + File.separator + "videos";

    public void init() {
        recipeDAO = new RecipeDAO();

        // Construct full absolute paths for init method
        String fullUploadPathImages = BASE_UPLOAD_DIRECTORY + File.separator + UPLOAD_DIRECTORY_IMAGES_RELATIVE;
        String fullUploadPathVideos = BASE_UPLOAD_DIRECTORY + File.separator + UPLOAD_DIRECTORY_VIDEOS_RELATIVE;

        // Ensure upload directories exist on server startup
        File uploadDirImages = new File(fullUploadPathImages);
        if (!uploadDirImages.exists()) {
            uploadDirImages.mkdirs();
            System.out.println("DEBUG: Created image upload directory: " + fullUploadPathImages);
        } else {
            System.out.println("DEBUG: Image upload directory already exists: " + fullUploadPathImages);
        }

        File uploadDirVideos = new File(fullUploadPathVideos);
        if (!uploadDirVideos.exists()) {
            uploadDirVideos.mkdirs();
            System.out.println("DEBUG: Created video upload directory: " + fullUploadPathVideos);
        } else {
            System.out.println("DEBUG: Video upload directory already exists: " + fullUploadPathVideos);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            action = "";
        }

        switch (action) {
            case "addRecipe":
                addRecipe(request, response);
                break;
            case "updateRecipe":
                updateRecipe(request, response);
                break;
            case "deleteRecipe":
                deleteRecipe(request, response);
                break;
            default:
                listRecipes(request, response);
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
            case "new":
                showNewForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteRecipe(request, response);
                break;
            case "view":
                viewRecipeDetail(request, response);
                break;
            case "listUserRecipes":
                listUserRecipes(request, response);
                break;
            case "listByCategory":
                listRecipesByCategory(request, response);
                break;
            case "listByRegion":
                listRecipesByRegion(request, response);
                break;
            case "home":
                listRecipesForIndex(request, response);
                break;
            case "list":
            default:
                listRecipes(request, response);
                break;
        }
    }

    private void listRecipes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Recipe> listRecipes = recipeDAO.selectAllRecipes();
            request.setAttribute("listRecipes", listRecipes);
            request.getRequestDispatcher("recipe-list.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error fetching recipes: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    private void listRecipesForIndex(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Recipe> listRecipes = recipeDAO.selectAllRecipes();
            request.setAttribute("listRecipes", listRecipes);
            request.getRequestDispatcher("index.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error fetching recipes: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    private void listUserRecipes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        User currentUser = (User) session.getAttribute("currentUser");
        try {
            List<Recipe> listUserRecipes = recipeDAO.selectRecipesByUserId(currentUser.getUserId());
            request.setAttribute("listUserRecipes", listUserRecipes);
            request.getRequestDispatcher("my-recipes.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error fetching your recipes: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    private void listRecipesByCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String category = request.getParameter("category");
        try {
            List<Recipe> listRecipes = recipeDAO.selectRecipesByCategory(category);
            request.setAttribute("listRecipes", listRecipes);
            request.setAttribute("filterType", "Category");
            request.setAttribute("filterValue", category);
            request.getRequestDispatcher("recipe-list.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error fetching recipes by category: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    private void listRecipesByRegion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String region = request.getParameter("region");
        try {
            List<Recipe> listRecipes = recipeDAO.selectRecipesByRegion(region);
            request.setAttribute("listRecipes", listRecipes);
            request.setAttribute("filterType", "Region");
            request.setAttribute("filterValue", region);
            request.getRequestDispatcher("recipe-list.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error fetching recipes by region: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        request.getRequestDispatcher("add-recipe.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        int recipeId = Integer.parseInt(request.getParameter("id"));
        Recipe existingRecipe = recipeDAO.selectRecipeById(recipeId);
        User currentUser = (User) session.getAttribute("currentUser");

        if (existingRecipe != null && existingRecipe.getUserId() == currentUser.getUserId()) {
            request.setAttribute("recipe", existingRecipe);
            request.getRequestDispatcher("edit-recipe.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "You are not authorized to edit this recipe or recipe not found.");
            listUserRecipes(request, response);
        }
    }

    private void viewRecipeDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int recipeId = Integer.parseInt(request.getParameter("id"));
        Recipe recipe = recipeDAO.selectRecipeById(recipeId);
        if (recipe != null) {
            request.setAttribute("recipe", recipe);
            request.getRequestDispatcher("recipe-detail.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Recipe not found.");
            listRecipes(request, response);
        }
    }

    private void addRecipe(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");
        int userId = currentUser.getUserId();

        String title = request.getParameter("title");
        String ingredients = request.getParameter("ingredients");
        String instructions = request.getParameter("instructions");
        String category = request.getParameter("category");
        String region = request.getParameter("region");

        if (title == null || title.trim().isEmpty() ||
            ingredients == null || ingredients.trim().isEmpty() ||
            instructions == null || instructions.trim().isEmpty() ||
            category == null || category.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Title, Ingredients, Instructions, and Category are required.");
            showNewForm(request, response);
            return;
        }

        String imageUrl = null;
        String videoUrl = null;

        try {
            // Define the full absolute paths for saving files
            String finalUploadPathImages = BASE_UPLOAD_DIRECTORY + File.separator + UPLOAD_DIRECTORY_IMAGES_RELATIVE;
            String finalUploadPathVideos = BASE_UPLOAD_DIRECTORY + File.separator + UPLOAD_DIRECTORY_VIDEOS_RELATIVE;

            Part imagePart = request.getPart("imageFile");
            // DEBUG statements
            System.out.println("DEBUG: Image Part obtained. Size: " + (imagePart != null ? imagePart.getSize() : "null/0"));
            if (imagePart != null && imagePart.getSize() > 0) {
                String imageFileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
                System.out.println("DEBUG: Image file name: " + imageFileName);

                File uploadDirImages = new File(finalUploadPathImages);
                if (!uploadDirImages.exists()) {
                    uploadDirImages.mkdirs();
                    System.out.println("DEBUG: Created image upload directory: " + finalUploadPathImages);
                }
                String imageFilePath = finalUploadPathImages + File.separator + imageFileName;
                System.out.println("DEBUG: Full image file path for saving: " + imageFilePath);

                try (InputStream fileContent = imagePart.getInputStream()) {
                    Files.copy(fileContent, new File(imageFilePath).toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                    System.out.println("DEBUG: Image file successfully copied.");
                }
                // Construct URL: Assumes BASE_UPLOAD_DIRECTORY is the web app's root
                imageUrl = request.getContextPath() + "/" + UPLOAD_DIRECTORY_IMAGES_RELATIVE.replace(File.separator, "/") + "/" + imageFileName;
            }

            Part videoPart = request.getPart("videoFile");
            // DEBUG statements
            System.out.println("DEBUG: Video Part obtained. Size: " + (videoPart != null ? videoPart.getSize() : "null/0"));
            if (videoPart != null && videoPart.getSize() > 0) {
                String videoFileName = Paths.get(videoPart.getSubmittedFileName()).getFileName().toString();
                System.out.println("DEBUG: Video file name: " + videoFileName);

                File uploadDirVideos = new File(finalUploadPathVideos);
                if (!uploadDirVideos.exists()) {
                    uploadDirVideos.mkdirs();
                    System.out.println("DEBUG: Created video upload directory: " + finalUploadPathVideos);
                }
                String videoFilePath = finalUploadPathVideos + File.separator + videoFileName;
                System.out.println("DEBUG: Full video file path for saving: " + videoFilePath);

                try (InputStream fileContent = videoPart.getInputStream()) {
                    Files.copy(fileContent, new File(videoFilePath).toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                    System.out.println("DEBUG: Video file successfully copied.");
                }
                // Construct URL: Assumes BASE_UPLOAD_DIRECTORY is the web app's root
                videoUrl = request.getContextPath() + "/" + UPLOAD_DIRECTORY_VIDEOS_RELATIVE.replace(File.separator, "/") + "/" + videoFileName;
            }

            System.out.println("DEBUG: Image URL to be saved in DB: " + imageUrl);
            System.out.println("DEBUG: Video URL to be saved in DB: " + videoUrl);

            Recipe newRecipe = new Recipe();
            newRecipe.setUserId(userId);
            newRecipe.setTitle(title);
            newRecipe.setIngredients(ingredients);
            newRecipe.setInstructions(instructions);
            newRecipe.setCategory(category);
            newRecipe.setRegion(region);
            newRecipe.setImageUrl(imageUrl);
            newRecipe.setVideoUrl(videoUrl);
            newRecipe.setUploadDate(new Timestamp(new Date().getTime()));
            newRecipe.setStatus("Pending");

            recipeDAO.insertRecipe(newRecipe);
            request.setAttribute("successMessage", "Recipe added successfully and is pending approval!");
            response.sendRedirect("RecipeServlet?action=listUserRecipes");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error adding recipe to database: " + e.getMessage());
            showNewForm(request, response);
        } catch (ServletException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "File upload error: " + e.getMessage());
            showNewForm(request, response);
        }
    }

    private void updateRecipe(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");
        int recipeId = Integer.parseInt(request.getParameter("recipeId"));

        String title = request.getParameter("title");
        String ingredients = request.getParameter("ingredients");
        String instructions = request.getParameter("instructions");
        String category = request.getParameter("category");
        String region = request.getParameter("region");
        String imageUrl = request.getParameter("imageUrl");
        String videoUrl = request.getParameter("videoUrl");

        if (title == null || title.trim().isEmpty() ||
            ingredients == null || ingredients.trim().isEmpty() ||
            instructions == null || instructions.trim().isEmpty() ||
            category == null || category.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Title, Ingredients, Instructions, and Category are required.");
            showEditForm(request, response);
            return;
        }

        Recipe recipeToUpdate = recipeDAO.selectRecipeById(recipeId);
        if (recipeToUpdate == null || recipeToUpdate.getUserId() != currentUser.getUserId()) {
            request.setAttribute("errorMessage", "You are not authorized to edit this recipe or recipe not found.");
            listUserRecipes(request, response);
            return;
        }

        recipeToUpdate.setTitle(title);
        recipeToUpdate.setIngredients(ingredients);
        recipeToUpdate.setInstructions(instructions);
        recipeToUpdate.setCategory(category);
        recipeToUpdate.setRegion(region);
        recipeToUpdate.setImageUrl(imageUrl);
        recipeToUpdate.setVideoUrl(videoUrl);

        try {
            boolean updated = recipeDAO.updateRecipe(recipeToUpdate);
            if (updated) {
                request.setAttribute("successMessage", "Recipe updated successfully!");
                response.sendRedirect("RecipeServlet?action=listUserRecipes");
            } else {
                request.setAttribute("errorMessage", "Failed to update recipe.");
                showEditForm(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error updating recipe: " + e.getMessage());
            showEditForm(request, response);
        }
    }

    private void deleteRecipe(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");
        int recipeId = Integer.parseInt(request.getParameter("id"));

        Recipe recipeToDelete = recipeDAO.selectRecipeById(recipeId);
        if (recipeToDelete != null && (recipeToDelete.getUserId() == currentUser.getUserId() || "Admin".equals(currentUser.getRole()))) {
            // Delete associated files from the server first
            try {
                // Extract filename from URL and construct absolute path for deletion
                // This assumes the URL structure matches how it was saved: /contextPath/uploads/recipes/images/filename.jpg
                String imageFileName = (recipeToDelete.getImageUrl() != null && recipeToDelete.getImageUrl().lastIndexOf('/') != -1) ?
                                       recipeToDelete.getImageUrl().substring(recipeToDelete.getImageUrl().lastIndexOf('/') + 1) : null;
                String videoFileName = (recipeToDelete.getVideoUrl() != null && recipeToDelete.getVideoUrl().lastIndexOf('/') != -1) ?
                                       recipeToDelete.getVideoUrl().substring(recipeToDelete.getVideoUrl().lastIndexOf('/') + 1) : null;

                if (imageFileName != null && !imageFileName.isEmpty()) {
                    String imagePath = BASE_UPLOAD_DIRECTORY + File.separator + UPLOAD_DIRECTORY_IMAGES_RELATIVE + File.separator + imageFileName;
                    File imageFile = new File(imagePath);
                    if (imageFile.exists()) {
                        Files.delete(imageFile.toPath());
                        System.out.println("DEBUG: Deleted image file: " + imagePath);
                    }
                }
                if (videoFileName != null && !videoFileName.isEmpty()) {
                    String videoPath = BASE_UPLOAD_DIRECTORY + File.separator + UPLOAD_DIRECTORY_VIDEOS_RELATIVE + File.separator + videoFileName;
                    File videoFile = new File(videoPath);
                    if (videoFile.exists()) {
                        Files.delete(videoFile.toPath());
                        System.out.println("DEBUG: Deleted video file: " + videoPath);
                    }
                }
            } catch (IOException e) {
                e.printStackTrace(); // Log file deletion error, but don't stop DB deletion
                System.err.println("Error deleting associated files for recipe ID: " + recipeId + " - " + e.getMessage());
            }

            try {
                boolean deleted = recipeDAO.deleteRecipe(recipeId);
                if (deleted) {
                    request.setAttribute("successMessage", "Recipe deleted successfully!");
                } else {
                    request.setAttribute("errorMessage", "Failed to delete recipe.");
                }
            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Database error deleting recipe: " + e.getMessage());
            }
        } else {
            request.setAttribute("errorMessage", "You are not authorized to delete this recipe or recipe not found.");
        }
        String referer = request.getHeader("referer");
        // Always redirect user to their recipe list after deletion
        response.sendRedirect("RecipeServlet?action=listUserRecipes");
    }
}

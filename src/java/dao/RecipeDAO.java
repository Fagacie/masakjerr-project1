/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author ACER
 */




import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Recipe;

public class RecipeDAO {
    // Database connection details - YOU MUST UPDATE THESE
    private String jdbcURL = "jdbc:mysql://localhost:3306/masakjerr_db?useSSL=false&serverTimezone=UTC";
    private String jdbcUsername = "root"; // Your MySQL username
    private String jdbcPassword = "";     // Your MySQL password (often empty for XAMPP root)

    private static final String INSERT_RECIPE_SQL = "INSERT INTO recipes (user_id, title, ingredients, instructions, category, region, image_url, video_url, upload_date, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String SELECT_RECIPE_BY_ID = "SELECT recipe_id, user_id, title, ingredients, instructions, category, region, image_url, video_url, upload_date, status FROM recipes WHERE recipe_id = ?";
    private static final String SELECT_ALL_APPROVED_RECIPES = "SELECT recipe_id, user_id, title, ingredients, instructions, category, region, image_url, video_url, upload_date, status FROM recipes WHERE status = 'Approved' ORDER BY upload_date DESC";
    private static final String SELECT_RECIPES_BY_USER_ID = "SELECT recipe_id, user_id, title, ingredients, instructions, category, region, image_url, video_url, upload_date, status FROM recipes WHERE user_id = ? ORDER BY upload_date DESC";
    private static final String SELECT_RECIPES_BY_CATEGORY = "SELECT recipe_id, user_id, title, ingredients, instructions, category, region, image_url, video_url, upload_date, status FROM recipes WHERE category = ? AND status = 'Approved' ORDER BY upload_date DESC";
    private static final String SELECT_RECIPES_BY_REGION = "SELECT recipe_id, user_id, title, ingredients, instructions, category, region, image_url, video_url, upload_date, status FROM recipes WHERE region = ? AND status = 'Approved' ORDER BY upload_date DESC";
    private static final String UPDATE_RECIPE_SQL = "UPDATE recipes SET title = ?, ingredients = ?, instructions = ?, category = ?, region = ?, image_url = ?, video_url = ? WHERE recipe_id = ?";
    private static final String DELETE_RECIPE_SQL = "DELETE FROM recipes WHERE recipe_id = ?";

    // Admin specific queries
    private static final String SELECT_ALL_RECIPES_ADMIN = "SELECT recipe_id, user_id, title, ingredients, instructions, category, region, image_url, video_url, upload_date, status FROM recipes ORDER BY upload_date DESC";
    private static final String SELECT_PENDING_RECIPES = "SELECT recipe_id, user_id, title, ingredients, instructions, category, region, image_url, video_url, upload_date, status FROM recipes WHERE status = 'Pending' ORDER BY upload_date ASC";
    private static final String UPDATE_RECIPE_STATUS_SQL = "UPDATE recipes SET status = ? WHERE recipe_id = ?";
    private static final String COUNT_PENDING_RECIPES_SQL = "SELECT COUNT(*) FROM recipes WHERE status = 'Pending'";

    public RecipeDAO() {
        // Ensure the JDBC driver is loaded when the DAO is instantiated
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found!");
            e.printStackTrace();
        }
    }

    // Establishes a database connection
    protected Connection getConnection() throws SQLException {
        return DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
    }

    // Maps a ResultSet row to a Recipe object
    private Recipe mapResultSetToRecipe(ResultSet rs) throws SQLException {
        int recipeId = rs.getInt("recipe_id");
        int userId = rs.getInt("user_id");
        String title = rs.getString("title");
        String ingredients = rs.getString("ingredients");
        String instructions = rs.getString("instructions");
        String category = rs.getString("category");
        String region = rs.getString("region");
        String imageUrl = rs.getString("image_url");
        String videoUrl = rs.getString("video_url");
        Timestamp uploadDate = rs.getTimestamp("upload_date");
        String status = rs.getString("status");

        return new Recipe(recipeId, userId, title, ingredients, instructions, category, region, imageUrl, videoUrl, uploadDate, status);
    }

    /**
     * Inserts a new recipe into the database.
     * @param recipe The Recipe object to insert.
     * @throws SQLException If a database access error occurs.
     */
    public void insertRecipe(Recipe recipe) throws SQLException {
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_RECIPE_SQL)) {

            preparedStatement.setInt(1, recipe.getUserId());
            preparedStatement.setString(2, recipe.getTitle());
            preparedStatement.setString(3, recipe.getIngredients());
            preparedStatement.setString(4, recipe.getInstructions());
            preparedStatement.setString(5, recipe.getCategory());
            preparedStatement.setString(6, recipe.getRegion());
            preparedStatement.setString(7, recipe.getImageUrl());
            preparedStatement.setString(8, recipe.getVideoUrl());
            preparedStatement.setTimestamp(9, recipe.getUploadDate());
            preparedStatement.setString(10, recipe.getStatus());

            preparedStatement.executeUpdate();
        }
    }

    /**
     * Selects a recipe by its ID.
     * @param recipeId The ID of the recipe to retrieve.
     * @return The Recipe object if found, null otherwise.
     */
    public Recipe selectRecipeById(int recipeId) {
        Recipe recipe = null;
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_RECIPE_BY_ID)) {

            preparedStatement.setInt(1, recipeId);
            ResultSet rs = preparedStatement.executeQuery();

            if (rs.next()) {
                recipe = mapResultSetToRecipe(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return recipe;
    }

    /**
     * Selects all approved recipes from the database.
     * @return A list of approved Recipe objects.
     */
    public List<Recipe> selectAllRecipes() {
        List<Recipe> recipes = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ALL_APPROVED_RECIPES);
             ResultSet rs = preparedStatement.executeQuery()) {

            while (rs.next()) {
                recipes.add(mapResultSetToRecipe(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return recipes;
    }

    /**
     * Selects all recipes uploaded by a specific user.
     * @param userId The ID of the user whose recipes to retrieve.
     * @return A list of Recipe objects uploaded by the user.
     */
    public List<Recipe> selectRecipesByUserId(int userId) {
        List<Recipe> recipes = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_RECIPES_BY_USER_ID)) {

            preparedStatement.setInt(1, userId);
            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                recipes.add(mapResultSetToRecipe(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return recipes;
    }

    /**
     * Selects approved recipes by a specific category.
     * @param category The category to filter by.
     * @return A list of approved Recipe objects belonging to the specified category.
     */
    public List<Recipe> selectRecipesByCategory(String category) {
        List<Recipe> recipes = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_RECIPES_BY_CATEGORY)) {

            preparedStatement.setString(1, category);
            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                recipes.add(mapResultSetToRecipe(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return recipes;
    }

    /**
     * Selects approved recipes by a specific region.
     * @param region The region to filter by.
     * @return A list of approved Recipe objects belonging to the specified region.
     */
    public List<Recipe> selectRecipesByRegion(String region) {
        List<Recipe> recipes = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_RECIPES_BY_REGION)) {

            preparedStatement.setString(1, region);
            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                recipes.add(mapResultSetToRecipe(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return recipes;
    }

    /**
     * Updates an existing recipe in the database.
     * @param recipe The Recipe object with updated information.
     * @return true if the recipe was updated successfully, false otherwise.
     * @throws SQLException If a database access error occurs.
     */
    public boolean updateRecipe(Recipe recipe) throws SQLException {
        boolean rowUpdated;
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_RECIPE_SQL)) {

            preparedStatement.setString(1, recipe.getTitle());
            preparedStatement.setString(2, recipe.getIngredients());
            preparedStatement.setString(3, recipe.getInstructions());
            preparedStatement.setString(4, recipe.getCategory());
            preparedStatement.setString(5, recipe.getRegion());
            preparedStatement.setString(6, recipe.getImageUrl());
            preparedStatement.setString(7, recipe.getVideoUrl());
            preparedStatement.setInt(8, recipe.getRecipeId());

            rowUpdated = preparedStatement.executeUpdate() > 0;
        }
        return rowUpdated;
    }

    /**
     * Deletes a recipe from the database by its ID.
     * @param recipeId The ID of the recipe to delete.
     * @return true if the recipe was deleted successfully, false otherwise.
     * @throws SQLException If a database access error occurs.
     */
    public boolean deleteRecipe(int recipeId) throws SQLException {
        boolean rowDeleted;
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(DELETE_RECIPE_SQL)) {

            preparedStatement.setInt(1, recipeId);
            rowDeleted = preparedStatement.executeUpdate() > 0;
        }
        return rowDeleted;
    }

    // --- Admin Specific Methods ---

    /**
     * Selects all recipes regardless of status (for Admin view).
     * @return A list of all Recipe objects.
     */
    public List<Recipe> selectAllRecipesForAdmin() {
        List<Recipe> recipes = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ALL_RECIPES_ADMIN);
             ResultSet rs = preparedStatement.executeQuery()) {

            while (rs.next()) {
                recipes.add(mapResultSetToRecipe(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return recipes;
    }

    /**
     * Selects recipes with 'Pending' status for admin approval.
     * @return A list of pending Recipe objects.
     */
    public List<Recipe> selectPendingRecipes() {
        List<Recipe> recipes = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_PENDING_RECIPES);
             ResultSet rs = preparedStatement.executeQuery()) {

            while (rs.next()) {
                recipes.add(mapResultSetToRecipe(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return recipes;
    }

    /**
     * Updates the status of a specific recipe (e.g., 'Approved', 'Rejected').
     * @param recipeId The ID of the recipe to update.
     * @param status The new status (e.g., "Approved", "Rejected").
     * @return true if the status was updated successfully, false otherwise.
     * @throws SQLException If a database access error occurs.
     */
    public boolean updateRecipeStatus(int recipeId, String status) throws SQLException {
        boolean rowUpdated;
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_RECIPE_STATUS_SQL)) {

            preparedStatement.setString(1, status);
            preparedStatement.setInt(2, recipeId);
            rowUpdated = preparedStatement.executeUpdate() > 0;
        }
        return rowUpdated;
    }

    /**
     * Counts the number of recipes with 'Pending' status.
     * @return The count of pending recipes.
     */
    public int countPendingRecipes() {
        int count = 0;
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(COUNT_PENDING_RECIPES_SQL);
             ResultSet rs = preparedStatement.executeQuery()) {

            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    /**
     * Gets a recipe by its ID for admin ratings management.
     * @param recipeId The ID of the recipe to retrieve.
     * @return The Recipe object if found, null otherwise.
     */
    public Recipe getRecipeById(int recipeId) {
        String sql = "SELECT recipe_id, user_id, title, ingredients, instructions, category, region, image_url, video_url, upload_date, status FROM recipes WHERE recipe_id = ?";
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setInt(1, recipeId);
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                return mapResultSetToRecipe(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}

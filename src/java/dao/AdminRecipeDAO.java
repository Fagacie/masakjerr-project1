/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author ACER
 */


import model.Recipe;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.Timestamp; // Required for Recipe object's uploadDate

public class AdminRecipeDAO {
    // Database connection details - make sure these match your actual setup
    private String jdbcURL = "jdbc:mysql://localhost:3306/masakjerr_db?useSSL=false&serverTimezone=UTC";
    private String jdbcUsername = "root";
    private String jdbcPassword = ""; // Use your actual database password

    // SQL queries specific to admin recipe management
    private static final String SELECT_RECIPES_BY_STATUS_SQL = "SELECT recipe_id, user_id, title, ingredients, instructions, category, region, image_url, video_url, upload_date, status FROM recipes WHERE status = ? ORDER BY upload_date ASC";
    private static final String SELECT_ALL_RECIPES_SQL = "SELECT recipe_id, user_id, title, ingredients, instructions, category, region, image_url, video_url, upload_date, status FROM recipes ORDER BY upload_date DESC";
    private static final String UPDATE_RECIPE_STATUS_SQL = "UPDATE recipes SET status = ? WHERE recipe_id = ?";
    private static final String SELECT_RECIPE_BY_ID_SQL = "SELECT recipe_id, user_id, title, ingredients, instructions, category, region, image_url, video_url, upload_date, status FROM recipes WHERE recipe_id = ?";
    private static final String DELETE_RECIPE_SQL = "DELETE FROM recipes WHERE recipe_id = ?"; // Admin can delete any recipe


    public AdminRecipeDAO() {
    }

    // Helper method to establish a database connection
    protected Connection getConnection() {
        Connection connection = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        return connection;
    }

    // Method to select recipes by their status (e.g., 'Pending', 'Approved', 'Rejected')
    public List<Recipe> selectRecipesByStatus(String status) {
        List<Recipe> recipes = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_RECIPES_BY_STATUS_SQL)) {
            preparedStatement.setString(1, status);
            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                Recipe recipe = new Recipe();
                recipe.setRecipeId(rs.getInt("recipe_id"));
                recipe.setUserId(rs.getInt("user_id"));
                recipe.setTitle(rs.getString("title"));
                recipe.setIngredients(rs.getString("ingredients"));
                recipe.setInstructions(rs.getString("instructions"));
                recipe.setCategory(rs.getString("category"));
                recipe.setRegion(rs.getString("region"));
                recipe.setImageUrl(rs.getString("image_url"));
                recipe.setVideoUrl(rs.getString("video_url"));
                recipe.setUploadDate(rs.getTimestamp("upload_date"));
                recipe.setStatus(rs.getString("status"));
                recipes.add(recipe);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return recipes;
    }

    // Method to select all recipes (for general admin overview)
    public List<Recipe> selectAllRecipes() {
        List<Recipe> recipes = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ALL_RECIPES_SQL);
             ResultSet rs = preparedStatement.executeQuery()) {

            while (rs.next()) {
                Recipe recipe = new Recipe();
                recipe.setRecipeId(rs.getInt("recipe_id"));
                recipe.setUserId(rs.getInt("user_id"));
                recipe.setTitle(rs.getString("title"));
                recipe.setIngredients(rs.getString("ingredients"));
                recipe.setInstructions(rs.getString("instructions"));
                recipe.setCategory(rs.getString("category"));
                recipe.setRegion(rs.getString("region"));
                recipe.setImageUrl(rs.getString("image_url"));
                recipe.setVideoUrl(rs.getString("video_url"));
                recipe.setUploadDate(rs.getTimestamp("upload_date"));
                recipe.setStatus(rs.getString("status"));
                recipes.add(recipe);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return recipes;
    }

    // Method to update a recipe's status (e.g., Approve, Reject)
    public boolean updateRecipeStatus(int recipeId, String status) throws SQLException {
        boolean rowUpdated;
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(UPDATE_RECIPE_STATUS_SQL)) {
            statement.setString(1, status);
            statement.setInt(2, recipeId);
            rowUpdated = statement.executeUpdate() > 0;
        }
        return rowUpdated;
    }

    // Method to select a single recipe by ID (for admin to review details)
    public Recipe selectRecipeById(int recipeId) {
        Recipe recipe = null;
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_RECIPE_BY_ID_SQL)) {
            preparedStatement.setInt(1, recipeId);
            ResultSet rs = preparedStatement.executeQuery();

            if (rs.next()) {
                recipe = new Recipe();
                recipe.setRecipeId(rs.getInt("recipe_id"));
                recipe.setUserId(rs.getInt("user_id"));
                recipe.setTitle(rs.getString("title"));
                recipe.setIngredients(rs.getString("ingredients"));
                recipe.setInstructions(rs.getString("instructions"));
                recipe.setCategory(rs.getString("category"));
                recipe.setRegion(rs.getString("region"));
                recipe.setImageUrl(rs.getString("image_url"));
                recipe.setVideoUrl(rs.getString("video_url"));
                recipe.setUploadDate(rs.getTimestamp("upload_date"));
                recipe.setStatus(rs.getString("status"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return recipe;
    }

    // Method for admin to delete a recipe
    public boolean deleteRecipe(int recipeId) throws SQLException {
        boolean rowDeleted;
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(DELETE_RECIPE_SQL)) {
            statement.setInt(1, recipeId);
            rowDeleted = statement.executeUpdate() > 0;
        }
        return rowDeleted;
    }
}

package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class RatingDAO {
    private String jdbcURL = "jdbc:mysql://localhost:3306/masakjerr_db?useSSL=false&serverTimezone=UTC";
    private String jdbcUsername = "root";
    private String jdbcPassword = "";

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
    }

    /**
     * Submits a rating for a recipe by a specific user.
     * If the user has already rated the recipe, the rating will be updated.
     *
     * @param userId The ID of the user submitting the rating.
     * @param recipeId The ID of the recipe being rated.
     * @param rating The rating value (e.g., 1 to 5).
     * @return true if the rating was submitted successfully, false otherwise.
     */
    public boolean submitRating(int userId, int recipeId, int rating) {
        String sql = "INSERT INTO ratings (user_id, recipe_id, rating) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE rating = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, recipeId);
            stmt.setInt(3, rating);
            stmt.setInt(4, rating);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Retrieves the average rating for a specific recipe.
     *
     * @param recipeId The ID of the recipe.
     * @return The average rating as a double. Returns 0.0 if no ratings found.
     */
    public double getAverageRating(int recipeId) {
        String sql = "SELECT AVG(rating) AS avg_rating FROM ratings WHERE recipe_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, recipeId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("avg_rating");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    /**
     * Retrieves all ratings for admin management.
     */
    public List<model.Rating> getAllRatings() {
        List<model.Rating> ratings = new java.util.ArrayList<>();
        String sql = "SELECT * FROM ratings ORDER BY date DESC";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                model.Rating rating = new model.Rating();
                rating.setId(rs.getInt("id"));
                rating.setUserId(rs.getInt("user_id"));
                rating.setRecipeId(rs.getInt("recipe_id"));
                rating.setRatingValue(rs.getInt("rating"));
                rating.setComment(rs.getString("comment"));
                rating.setDate(rs.getTimestamp("rated_at"));
                ratings.add(rating);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ratings;
    }

    /**
     * Deletes a rating by its ID.
     */
    public boolean deleteRating(int ratingId) {
        String sql = "DELETE FROM ratings WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, ratingId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}

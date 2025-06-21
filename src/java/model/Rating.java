package model;

import java.sql.Timestamp;

public class Rating {
    private int id;
    private int userId;
    private int recipeId;
    private int ratingValue;
    private String comment;
    private Timestamp date;

    public Rating() {}

    public Rating(int id, int userId, int recipeId, int ratingValue, String comment, Timestamp date) {
        this.id = id;
        this.userId = userId;
        this.recipeId = recipeId;
        this.ratingValue = ratingValue;
        this.comment = comment;
        this.date = date;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getRecipeId() { return recipeId; }
    public void setRecipeId(int recipeId) { this.recipeId = recipeId; }
    public int getRatingValue() { return ratingValue; }
    public void setRatingValue(int ratingValue) { this.ratingValue = ratingValue; }
    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }
    public Timestamp getDate() { return date; }
    public void setDate(Timestamp date) { this.date = date; }
}

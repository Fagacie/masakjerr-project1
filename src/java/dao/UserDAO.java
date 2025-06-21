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
import model.User;

public class UserDAO {
    private String jdbcURL = "jdbc:mysql://localhost:3306/masakjerr_db?useSSL=false&serverTimezone=UTC";
    private String jdbcUsername = "root";
    private String jdbcPassword = ""; // Use your actual database password

    private static final String INSERT_USER_SQL = "INSERT INTO users (username, email, password, first_name, last_name, bio, role, registration_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String SELECT_USER_BY_USERNAME_SQL = "SELECT user_id, username, email, password, first_name, last_name, bio, role, registration_date FROM users WHERE username = ?";
    private static final String SELECT_USER_BY_EMAIL_SQL = "SELECT user_id, username, email, password, first_name, last_name, bio, role, registration_date FROM users WHERE email = ?";
    private static final String UPDATE_USER_SQL = "UPDATE users SET username = ?, email = ?, password = ?, first_name = ?, last_name = ?, bio = ?, role = ? WHERE user_id = ?";
    private static final String DELETE_USER_SQL = "DELETE FROM users WHERE user_id = ?";

    public UserDAO() {
    }

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

    public void registerUser(User user) throws SQLException {
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_USER_SQL)) {
            preparedStatement.setString(1, user.getUsername());
            preparedStatement.setString(2, user.getEmail());
            preparedStatement.setString(3, user.getPassword());
            preparedStatement.setString(4, user.getFirstName());
            preparedStatement.setString(5, user.getLastName());
            preparedStatement.setString(6, user.getBio());
            preparedStatement.setString(7, user.getRole());
            preparedStatement.setTimestamp(8, user.getRegistrationDate());
            preparedStatement.executeUpdate();
        }
    }

    public User selectUserByUsername(String username) {
        User user = null;
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_USER_BY_USERNAME_SQL)) {
            preparedStatement.setString(1, username);
            ResultSet rs = preparedStatement.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setFirstName(rs.getString("first_name"));
                user.setLastName(rs.getString("last_name"));
                user.setBio(rs.getString("bio"));
                user.setRole(rs.getString("role"));
                user.setRegistrationDate(rs.getTimestamp("registration_date"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    public User selectUserByEmail(String email) {
        User user = null;
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_USER_BY_EMAIL_SQL)) {
            preparedStatement.setString(1, email);
            ResultSet rs = preparedStatement.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setFirstName(rs.getString("first_name"));
                user.setLastName(rs.getString("last_name"));
                user.setBio(rs.getString("bio"));
                user.setRole(rs.getString("role"));
                user.setRegistrationDate(rs.getTimestamp("registration_date"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    public boolean updateUser(User user) throws SQLException {
        boolean rowUpdated;
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(UPDATE_USER_SQL)) {
            statement.setString(1, user.getUsername());
            statement.setString(2, user.getEmail());
            statement.setString(3, user.getPassword());
            statement.setString(4, user.getFirstName());
            statement.setString(5, user.getLastName());
            statement.setString(6, user.getBio());
            statement.setString(7, user.getRole());
            statement.setInt(8, user.getUserId());

            rowUpdated = statement.executeUpdate() > 0;
        }
        return rowUpdated;
    }

    public boolean deleteUser(int userId) throws SQLException {
    String sql = "DELETE FROM users WHERE userId = ?";
    try (Connection connection = getConnection();
         PreparedStatement statement = connection.prepareStatement(DELETE_USER_SQL)) {
        statement.setInt(1, userId);
        int rowsAffected = statement.executeUpdate();
        return rowsAffected > 0;
        }
    }

    public User getUserById(int userId) {
        String sql = "SELECT user_id, username, email, password, first_name, last_name, bio, role, registration_date FROM users WHERE user_id = ?";
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setInt(1, userId);
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setFirstName(rs.getString("first_name"));
                user.setLastName(rs.getString("last_name"));
                user.setBio(rs.getString("bio"));
                user.setRole(rs.getString("role"));
                user.setRegistrationDate(rs.getTimestamp("registration_date"));
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

}


package servlet;

import dao.RatingDAO;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/RatingServlet")
public class RatingServlet extends HttpServlet {

    private RatingDAO ratingDAO;

    @Override
    public void init() throws ServletException {
        ratingDAO = new RatingDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set response type for AJAX (plain text, not HTML)
        response.setContentType("text/plain");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().print("Please log in to rate.");
            return;
        }

        try {
            int userId = currentUser.getUserId();
            int recipeId = Integer.parseInt(request.getParameter("recipeId"));
            int rating = Integer.parseInt(request.getParameter("rating"));

            boolean success = ratingDAO.submitRating(userId, recipeId, rating);

            if (success) {
                double avgRating = ratingDAO.getAverageRating(recipeId);
                response.getWriter().print(String.format("%.1f", avgRating)); // Response used in AJAX
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().print("Failed to submit rating.");
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("Invalid input.");
            e.printStackTrace();
        }
    }
}
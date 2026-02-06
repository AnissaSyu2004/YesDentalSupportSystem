package controllers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import dao.DBConnection;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String userType = request.getParameter("userType");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            if ("patient".equals(userType)) {
                // Check patient credentials
                String sql = "SELECT * FROM PATIENT WHERE PATIENT_EMAIL = ? AND PATIENT_PASSWORD = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, email);
                pstmt.setString(2, password);
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    HttpSession session = request.getSession();
                    session.setAttribute("patientId", rs.getString("PATIENT_IC"));
                    session.setAttribute("patientName", rs.getString("PATIENT_NAME"));
                    session.setAttribute("userType", "patient");
                    response.sendRedirect("patient/patientDashboard.jsp");
                } else {
                    response.sendRedirect("login.jsp?error=true");
                }
                
            } else if ("staff".equals(userType)) {
                // Check staff credentials
                String sql = "SELECT * FROM STAFF WHERE STAFF_EMAIL = ? AND STAFF_PASSWORD = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, email);
                pstmt.setString(2, password);
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    HttpSession session = request.getSession();
                    session.setAttribute("staffId", rs.getString("STAFF_ID"));
                    session.setAttribute("staffName", rs.getString("STAFF_NAME"));
                    session.setAttribute("staffRole", rs.getString("STAFF_ROLE"));
                    session.setAttribute("userType", "staff");
                    response.sendRedirect("staff/staffDashboard.jsp");
                } else {
                    response.sendRedirect("login.jsp?error=true");
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=Database error");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}
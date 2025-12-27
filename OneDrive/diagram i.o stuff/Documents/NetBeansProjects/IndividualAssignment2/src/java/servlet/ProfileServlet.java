package servlet;

import bean.ProfileBean;
import util.DBHelper;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {

    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Connection conn = null;
        try {
            
            String name = request.getParameter("name");
            String studentId = request.getParameter("studentId");
            String program = request.getParameter("program");
            String email = request.getParameter("email");
            String hobbies = request.getParameter("hobbies");
            String introduction = request.getParameter("introduction");
            
            
            ProfileBean profile = new ProfileBean();
            profile.setName(name);
            profile.setStudentId(studentId);
            profile.setProgram(program);
            profile.setEmail(email);
            profile.setHobbies(hobbies);
            profile.setIntroduction(introduction);
            
            
            conn = DBHelper.getConnection();
            String sql = "INSERT INTO profiles (name, student_id, program, email, hobbies, introduction) "
                       + "VALUES (?, ?, ?, ?, ?, ?)";
            
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, profile.getName());
            pstmt.setString(2, profile.getStudentId());
            pstmt.setString(3, profile.getProgram());
            pstmt.setString(4, profile.getEmail());
            pstmt.setString(5, profile.getHobbies());
            pstmt.setString(6, profile.getIntroduction());
            
            pstmt.executeUpdate();
            pstmt.close();
            
            
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT IDENTITY_VAL_LOCAL() FROM profiles");
            if (rs.next()) {
                profile.setId(rs.getInt(1));
            }
            rs.close();
            stmt.close();
            
           
            request.setAttribute("profile", profile);
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
           
            response.sendRedirect("index.html?error=" + 
                java.net.URLEncoder.encode("Database error: " + e.getMessage(), "UTF-8"));
        } finally {
            DBHelper.close(conn);
        }
    }
    
  
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Connection conn = null;
        try {
            conn = DBHelper.getConnection();
            
            String search = request.getParameter("search");
            ResultSet rs;
            
            if (search != null && !search.trim().isEmpty()) {
  
                String sql = "SELECT * FROM profiles WHERE LOWER(name) LIKE ? OR LOWER(student_id) LIKE ?";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, "%" + search.toLowerCase() + "%");
                pstmt.setString(2, "%" + search.toLowerCase() + "%");
                rs = pstmt.executeQuery();
                request.setAttribute("search", search);
            } else {
             
                Statement stmt = conn.createStatement();
                rs = stmt.executeQuery("SELECT * FROM profiles ORDER BY id DESC");
            }
            
            
            request.setAttribute("profiles", rs);
            request.getRequestDispatcher("viewProfiles.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.html");
        } finally {
            DBHelper.close(conn);
        }
    }
}
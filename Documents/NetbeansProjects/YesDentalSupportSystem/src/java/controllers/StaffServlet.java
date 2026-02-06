package controllers;

import beans.Staff;
import dao.StaffDAO;
import java.io.IOException;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

//@WebServlet("/StaffServlet")
public class StaffServlet extends HttpServlet {
    private StaffDAO staffDAO;
    
    @Override
    public void init() {
        staffDAO = new StaffDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8"); 
        
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            addStaff(request, response);
        } else if ("update".equals(action)) {
            updateStaff(request, response);
        } else if ("delete".equals(action)) {
            deleteStaff(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("edit".equals(action)) {
            editStaff(request, response);
        } else if ("delete".equals(action)) {
            deleteStaff(request, response);
        } else {
            // Default action: list staff
            listStaff(request, response);
        }
    }
    
    private void editStaff(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        
        String staffId = request.getParameter("staff_id");
        
        if (staffId == null || staffId.trim().isEmpty()) {
            request.setAttribute("error", "Staff ID is required for editing.");
            listStaff(request, response);
            return;
        }
        
        Staff staff = staffDAO.getStaffById(staffId);
        
        if (staff == null) {
            request.setAttribute("error", "Staff not found with ID: " + staffId);
            listStaff(request, response);
            return;
        }
        
        request.setAttribute("staff", staff);
        RequestDispatcher dispatcher = 
            request.getRequestDispatcher("/staff/editStaff.jsp");
        dispatcher.forward(request, response);
    }
    
    private void listStaff(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        
        List<Staff> staffList = staffDAO.getAllStaff();

        System.out.println("DEBUG: Number of staff fetched: " + 
            (staffList != null ? staffList.size() : "null"));

        request.setAttribute("staffList", staffList);
        RequestDispatcher dispatcher =
                request.getRequestDispatcher("/staff/viewStaff.jsp");
        dispatcher.forward(request, response);
    }
    
    private void addStaff(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        try {
            Staff staff = new Staff();

            staff.setStaffId(request.getParameter("staff_id"));
            staff.setStaffName(request.getParameter("staff_name"));
            staff.setStaffEmail(request.getParameter("staff_email"));
            staff.setStaffPhonenum(request.getParameter("staff_phonenum"));
            staff.setStaffRole(request.getParameter("staff_role"));
            
            // Password is set to phone number by default
            staff.setStaffPassword(request.getParameter("staff_phonenum"));

            boolean success = staffDAO.addStaff(staff);

            if (success) {
                request.setAttribute("message", "Staff added successfully!");
                listStaff(request, response);
            } else {
                request.setAttribute("error", "Failed to add staff. Staff ID might already exist.");
                request.getRequestDispatcher("/staff/addStaff.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/staff/addStaff.jsp").forward(request, response);
        }
    }
    
    private void deleteStaff(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    
        String staffId = request.getParameter("staff_id");
        boolean success = staffDAO.delete(staffId);
        
        if (success) {
            request.setAttribute("message", "Staff deleted successfully!");
        } else {
            request.setAttribute("error", "Failed to delete staff.");
        }
        
        listStaff(request, response);
    }
    
    private void updateStaff(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        try {
            Staff staff = new Staff();

            staff.setStaffId(request.getParameter("staff_id"));
            staff.setStaffName(request.getParameter("staff_name"));
            staff.setStaffEmail(request.getParameter("staff_email"));
            staff.setStaffPhonenum(request.getParameter("staff_phonenum"));
            staff.setStaffRole(request.getParameter("staff_role"));
            
            // Only update password if provided
            String newPassword = request.getParameter("staff_password");
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                staff.setStaffPassword(newPassword);
            }

            boolean success = staffDAO.updateStaff(staff);

            if (success) {
                request.setAttribute("message", "Staff updated successfully!");
            } else {
                request.setAttribute("error", "Update failed. Please try again.");
            }

            listStaff(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Invalid data: " + e.getMessage());
            // Forward back to edit page with error
            Staff staff = staffDAO.getStaffById(request.getParameter("staff_id"));
            request.setAttribute("staff", staff);
            request.getRequestDispatcher("/staff/editStaff.jsp").forward(request, response);
        }
    }
}
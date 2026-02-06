<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="beans.Staff" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Staff - YesDental</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .container { max-width: 800px; }
        .form-label { font-weight: 500; }
    </style>
</head>
<body>
    <div class="container mt-5">
        <h2 class="mb-4">✏️ Edit Staff</h2>
        
        <% 
            Staff staff = (Staff) request.getAttribute("staff");
            String error = (String) request.getAttribute("error");
            String success = (String) request.getAttribute("success");
            
            if (error != null) { 
        %>
            <div class="alert alert-danger">${error}</div>
        <% } %>
        
        <% if (success != null) { %>
            <div class="alert alert-success">${success}</div>
        <% } %>
        
        <% if (staff != null) { %>
        
        <form action="${pageContext.request.contextPath}/StaffServlet" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="staff_id" value="<%= staff.getStaffId() %>">
            
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="mb-0">Staff Information</h5>
                </div>
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">Staff ID</label>
                            <input type="text" class="form-control" value="<%= staff.getStaffId() %>" readonly>
                            <small class="text-muted">Staff ID cannot be changed</small>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Full Name *</label>
                            <input type="text" class="form-control" name="staff_name" 
                                   value="<%= staff.getStaffName() != null ? staff.getStaffName() : "" %>" required>
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">Phone Number *</label>
                            <input type="tel" class="form-control" name="staff_phonenum" 
                                   value="<%= staff.getStaffPhonenum() != null ? staff.getStaffPhonenum() : "" %>" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Email *</label>
                            <input type="email" class="form-control" name="staff_email" 
                                   value="<%= staff.getStaffEmail() != null ? staff.getStaffEmail() : "" %>" required>
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">Role *</label>
                            <select class="form-control" name="staff_role" required>
                                <option value="">Select Role</option>
                                <option value="Dentist" <%= "Dentist".equals(staff.getStaffRole()) ? "selected" : "" %>>Dentist</option>
                                <option value="Assistant" <%= "Assistant".equals(staff.getStaffRole()) ? "selected" : "" %>>Assistant</option>
                                <option value="Receptionist" <%= "Receptionist".equals(staff.getStaffRole()) ? "selected" : "" %>>Receptionist</option>
                                <option value="Other" <%= "Other".equals(staff.getStaffRole()) ? "selected" : "" %>>Other</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">New Password (Optional)</label>
                            <input type="password" class="form-control" name="staff_password" 
                                   placeholder="Leave empty to keep current password">
                            <small class="text-muted">Current password: <%= staff.getStaffPassword() != null ? staff.getStaffPassword() : "Not set" %></small>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="d-flex justify-content-between">
                <a href="/YesDentalSupportSystem/StaffServlet?action=list" class="btn btn-secondary">← Back to Staff List</a>
                <div>
                    <button type="submit" class="btn btn-primary">Update Staff</button>
                    <a href="/YesDentalSupportSystem/StaffServlet?action=list" class="btn btn-outline-secondary ms-2">Cancel</a>
                </div>
            </div>
        </form>
        
        <% } else { %>
            <div class="alert alert-warning">
                No staff data found. Please select a staff to edit.
            </div>
            <a href="viewStaff.jsp" class="btn btn-primary">Back to Staff List</a>
        <% } %>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="beans.Staff" %>

<!DOCTYPE html>
<html>
<head>
    <title>View Staff - YesDental</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="container mt-4">
        <h2 class="mb-4">👥 Staff Management</h2>
        
        <% if (request.getAttribute("message") != null) { %>
            <div class="alert alert-success">${message}</div>
        <% } %>
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger">${error}</div>
        <% } %>
        
        <div class="d-flex justify-content-between mb-3">
            <a href="staff/index.jsp" class="btn btn-outline-secondary">
                <i class="fas fa-home"></i> Home
            </a>
            <a href="staff/addStaff.jsp" class="btn btn-success">
                <i class="fas fa-plus"></i> Add New Staff
            </a>
        </div>
        
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">Staff List</h5>
            </div>
            <div class="card-body">
                <table class="table table-striped table-hover">
                    <thead>
                        <tr>
                            <th>Staff ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Role</th>
                            <th>Password</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<Staff> staffList = (List<Staff>) request.getAttribute("staffList");

                            if (staffList != null && !staffList.isEmpty()) {
                                for (Staff staff : staffList) {
                        %>
                        <tr>
                            <td><strong><%= staff.getStaffId() %></strong></td>
                            <td><%= staff.getStaffName() %></td>
                            <td><%= staff.getStaffEmail() %></td>
                            <td><%= staff.getStaffPhonenum() %></td>
                            <td>
                                <span class="badge bg-info">
                                    <%= staff.getStaffRole() %>
                                </span>
                            </td>
                            <td>
                                <span class="badge bg-secondary" title="<%= staff.getStaffPassword() %>">
                                    *****
                                </span>
                            </td>
                            <td>
                                <a href="StaffServlet?action=edit&staff_id=<%= staff.getStaffId() %>"
                                   class="btn btn-warning btn-sm">
                                   <i class="fas fa-edit"></i> Edit
                                </a>
                                
                                <form action="StaffServlet" method="post" style="display:inline;" 
                                      onsubmit="return confirmDelete()">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="staff_id" value="<%= staff.getStaffId() %>">
                                    <button type="submit" class="btn btn-sm btn-danger">
                                        <i class="fas fa-trash"></i> Delete
                                    </button>
                                </form>
                            </td>
                        </tr>
                        <% 
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="7" class="text-center">No staff members found.</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <script>
        function confirmDelete() {
            return confirm('Are you sure you want to delete this staff member? This action cannot be undone.');
        }
    </script>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
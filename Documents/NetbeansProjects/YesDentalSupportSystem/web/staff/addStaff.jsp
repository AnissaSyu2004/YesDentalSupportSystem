<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add Staff - YesDental</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .container { max-width: 800px; }
        .form-label { font-weight: 500; }
    </style>
</head>
<body>
    <div class="container mt-5">
        <h2 class="mb-4">👥 Add New Staff</h2>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger">${error}</div>
        <% } %>
        
        <form action="${pageContext.request.contextPath}/StaffServlet" method="post">
            <input type="hidden" name="action" value="add">
            
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="mb-0">Staff Information</h5>
                </div>
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">Staff ID *</label>
                            <input type="text" class="form-control" name="staff_id" 
                                   placeholder="e.g., STF001" required>
                            <small class="text-muted">Unique identifier for staff</small>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Full Name *</label>
                            <input type="text" class="form-control" name="staff_name" 
                                   placeholder="Enter full name" required>
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">Phone Number *</label>
                            <input type="tel" class="form-control" name="staff_phonenum" 
                                   placeholder="e.g., 012-3456789" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Email *</label>
                            <input type="email" class="form-control" name="staff_email" 
                                   placeholder="e.g., staff@yesdental.com" required>
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">Role *</label>
                            <select class="form-control" name="staff_role" required>
                                <option value="">Select Role</option>
                                <option value="Dentist">Dentist</option>
                                <option value="Assistant">Assistant</option>
                                <option value="Receptionist">Receptionist</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Password</label>
                            <input type="text" class="form-control" 
                                   value="Auto-generated from phone number" readonly>
                            <small class="text-muted">Password will be set to phone number by default</small>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="d-flex justify-content-between">
                <a href="/staff/viewStaff.jsp" class="btn btn-secondary">
                    ← Back to Staff List
                </a>
                <div>
                    <button type="reset" class="btn btn-outline-secondary">Reset</button>
                    <button type="submit" class="btn btn-primary ms-2">Add Staff</button>
                </div>
            </div>
        </form>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
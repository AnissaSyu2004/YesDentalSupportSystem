<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="beans.Treatment" %>
<!DOCTYPE html>
<html>
<head>
    <title>View Treatments - YesDental</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body, html {
            height: 100vh;
            overflow: hidden;
            font-family: Arial, sans-serif;
            /* UPDATED LINE BELOW: correctly points to the image folder from anywhere */
            background: url("${pageContext.request.contextPath}/YesDentalPic/Background.png") no-repeat center center fixed;
            background-size: cover;
        }

        .outer-container {
            position: absolute;
            top: 70px;
            bottom: 0;
            left: 0;
            right: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .form-container {
            display: flex;
            width: 95%;
            max-width: 1200px;
            height: calc(100vh - 100px);
            background: rgba(255, 255, 255, 0.95);
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 0 10px rgba(0,0,0,0.2);
        }

        .sidebar-inside {
            width: 220px;
            background-color: #2f4a34;
            color: white;
            padding: 30px 20px;
        }

        .sidebar-inside a {
            display: block;
            margin: 18px 0;
            font-size: 16px;
            color: white;
            text-decoration: none;
            transition: color 0.2s ease;
        }

        .sidebar-inside a:hover,
        .sidebar-inside a.active {
            color: #ffce38;
            font-weight: bold;
        }

        .form-content {
            flex: 1;
            padding: 30px 40px;
            overflow-y: auto;
        }

        h2 {
            text-align: center;
            color: #2f4f2f;
            margin-bottom: 20px;
        }

        .price-cell { 
            font-weight: 600; 
            color: #198754; 
        }
        
        .alert {
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .actions-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding: 0 10px;
        }
        
        .btn {
            padding: 8px 16px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: 500;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn-outline-secondary {
            background: transparent;
            border: 1px solid #6c757d;
            color: #6c757d;
        }
        
        .btn-outline-secondary:hover {
            background: #6c757d;
            color: white;
        }
        
        .btn-success {
            background: #198754;
            color: white;
        }
        
        .btn-success:hover {
            background: #157347;
        }
        
        .btn-warning {
            background: #ffc107;
            color: #000;
        }
        
        .btn-warning:hover {
            background: #ffca2c;
        }
        
        .btn-danger {
            background: #dc3545;
            color: white;
        }
        
        .btn-danger:hover {
            background: #bb2d3b;
        }
        
        .btn-sm {
            padding: 5px 10px;
            font-size: 12px;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        th {
            background-color: #f2f2f2;
            padding: 12px;
            text-align: left;
            border-bottom: 2px solid #ddd;
            color: #2f4f2f;
        }
        
        td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
        }
        
        tr:hover {
            background-color: #f5f5f5;
        }
        
        .no-treatments {
            text-align: center;
            padding: 40px;
            color: #666;
        }
        
        .card-footer {
            padding: 15px;
            background-color: #f8f9fa;
            border-top: 1px solid #dee2e6;
            text-align: center;
            color: #6c757d;
        }
        
        form[style*="display:inline"] {
            display: inline-block !important;
            margin-left: 5px;
        }
    </style>
</head>
<body>

<div class="outer-container">
    <div class="form-container">
        
        <div class="sidebar-inside">
            <a href="${pageContext.request.contextPath}/staff/index.jsp">Staff</a>
            <a href="${pageContext.request.contextPath}/appointment.jsp">Appointments</a>
            <a href="${pageContext.request.contextPath}/billing.jsp">Billing</a>
            <a href="${pageContext.request.contextPath}/patient.jsp">Patients</a>
            <a href="#" class="active">Treatments</a>
            <a href="${pageContext.request.contextPath}/consent.jsp">Consent Form</a>
            <a href="${pageContext.request.contextPath}/feedback.jsp">Feedback</a>
        </div>

        <div class="form-content">
            <h2>🦷 Treatment Management</h2>
            
            <% if (request.getAttribute("message") != null) { %>
                <div class="alert alert-success">${message}</div>
            <% } %>
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger">${error}</div>
            <% } %>
            
            <div class="actions-header">
                <a href="${pageContext.request.contextPath}/staff/index.jsp" class="btn btn-outline-secondary">
                    <i class="fas fa-home"></i> Home
                </a>
                <a href="addTreatment.jsp" class="btn btn-success">
                    <i class="fas fa-plus"></i> Add New Treatment
                </a>
            </div>
            
            <div>
                <h5 style="color: #2f4f2f; margin-bottom: 15px;">Treatment List</h5>
                
                <% 
                    List<Treatment> treatments = (List<Treatment>) request.getAttribute("treatments");
                    
                    if (treatments != null && !treatments.isEmpty()) { 
                %>
                <div style="overflow-x: auto;">
                    <table>
                        <thead>
                            <tr>
                                <th>Treatment ID</th>
                                <th>Treatment Name</th>
                                <th>Description</th>
                                <th>Price (RM)</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Treatment treatment : treatments) { %>
                            <tr>
                                <td><strong><%= treatment.getTreatmentId() %></strong></td>
                                <td><%= treatment.getTreatmentName() %></td>
                                <td>
                                    <% 
                                        String desc = treatment.getTreatmentDesc();
                                        if (desc != null && desc.length() > 100) {
                                            desc = desc.substring(0, 100) + "...";
                                        }
                                    %>
                                    <%= desc != null ? desc : "No description" %>
                                </td>
                                <td class="price-cell">RM <%= String.format("%.2f", treatment.getTreatmentPrice()) %></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/TreatmentServlet?action=edit&treatment_id=<%= treatment.getTreatmentId() %>"
                                       class="btn btn-warning btn-sm">
                                       <i class="fas fa-edit"></i> Edit
                                    </a>
                                    
                                    <form action="${pageContext.request.contextPath}/TreatmentServlet" method="post" style="display:inline;" 
                                          onsubmit="return confirmDelete()">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="treatment_id" value="<%= treatment.getTreatmentId() %>">
                                        <button type="submit" class="btn btn-sm btn-danger">
                                            <i class="fas fa-trash"></i> Delete
                                        </button>
                                    </form>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                <% } else { %>
                <div class="no-treatments">
                    <i class="fas fa-tooth fa-3x" style="color: #ccc; margin-bottom: 15px;"></i>
                    <h5 style="color: #666;">No treatments found</h5>
                    <p style="color: #888;">Add your first treatment to get started.</p>
                    <a href="addTreatment.jsp" class="btn btn-success" style="margin-top: 15px;">
                        <i class="fas fa-plus"></i> Add Treatment
                    </a>
                </div>
                <% } %>
                
                <% if (treatments != null && !treatments.isEmpty()) { %>
                <div class="card-footer">
                    Total Treatments: <%= treatments.size() %>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</div>

<script>
    function confirmDelete() {
        return confirm('Are you sure you want to delete this treatment? This action cannot be undone.');
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
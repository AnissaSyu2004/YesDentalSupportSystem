<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="beans.Appointment" %>
<%@ page import="beans.AppointmentTreatment" %>

<!DOCTYPE html>
<html>
<head>
    <title>Digital Consent - YesDental</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .consent-container {
            max-width: 1000px;
            margin: 0 auto;
        }
        .consent-header {
            background-color: #0d6efd;
            color: white;
            padding: 20px;
            border-radius: 8px 8px 0 0;
        }
        .consent-body {
            border: 1px solid #dee2e6;
            border-top: none;
            padding: 30px;
            max-height: 500px;
            overflow-y: auto;
            margin-bottom: 20px;
        }
        .consent-section {
            margin-bottom: 25px;
        }
        .consent-title {
            color: #0d6efd;
            border-bottom: 2px solid #0d6efd;
            padding-bottom: 5px;
            margin-bottom: 15px;
        }
        .terms-checkbox {
            font-size: 1.1em;
        }
    </style>
</head>
<body>
    <div class="container mt-4 consent-container">
        <% 
            Appointment appointment = (Appointment) request.getAttribute("appointment");
            List<AppointmentTreatment> treatments = (List<AppointmentTreatment>) request.getAttribute("treatments");
            String consentContext = (String) request.getAttribute("consentContext");
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        %>
        
        <% if (appointment == null) { %>
            <div class="alert alert-warning">
                Appointment not found.
            </div>
            <a href="viewAppointments.jsp" class="btn btn-primary">Back to Appointments</a>
        <% } else { %>
        
        <div class="consent-header text-center">
            <h2><i class="fas fa-file-contract"></i> DIGITAL TREATMENT CONSENT FORM</h2>
            <p class="mb-0">YesDental Support System</p>
        </div>
        
        <div class="alert alert-info mt-3">
            <h5><i class="fas fa-info-circle"></i> Appointment Information</h5>
            <div class="row">
                <div class="col-md-3">
                    <strong>Appointment ID:</strong><br>
                    <%= appointment.getAppointmentId() %>
                </div>
                <div class="col-md-3">
                    <strong>Patient IC:</strong><br>
                    <%= appointment.getPatientIc() %>
                </div>
                <div class="col-md-3">
                    <strong>Date:</strong><br>
                    <%= dateFormat.format(appointment.getAppointmentDate()) %>
                </div>
                <div class="col-md-3">
                    <strong>Time:</strong><br>
                    <%= appointment.getAppointmentTime() %>
                </div>
            </div>
            <% if (consentContext != null && !consentContext.isEmpty()) { %>
            <div class="mt-2">
                <strong>Treatment(s):</strong><br>
                <%= consentContext %>
            </div>
            <% } %>
        </div>
        
        <form action="${pageContext.request.contextPath}/AppointmentServlet" method="post" id="consentForm">
            <input type="hidden" name="action" value="sign_consent">
            <input type="hidden" name="appointment_id" value="<%= appointment.getAppointmentId() %>">
            <input type="hidden" name="patient_ic" value="<%= appointment.getPatientIc() %>">
            <input type="hidden" name="consent_text" value="<%= consentContext != null ? consentContext : "Dental treatment consent" %>">
            
            <div class="consent-body">
                <div class="consent-section">
                    <h4 class="consent-title">1. PURPOSE AND UNDERSTANDING</h4>
                    <p>I understand that the purpose of this consent form is to authorize YesDental to perform the necessary dental procedures. I have been informed about the nature of my dental condition and the recommended treatment plan.</p>
                </div>
                
                <div class="consent-section">
                    <h4 class="consent-title">2. PROCEDURES TO BE PERFORMED</h4>
                    <p>The following procedures have been discussed and are planned for my treatment:</p>
                    <ul>
                        <% if (treatments != null && !treatments.isEmpty()) {
                            for (AppointmentTreatment treatment : treatments) { %>
                                <li>Treatment ID: <%= treatment.getTreatmentId() %> - To be performed on <%= dateFormat.format(treatment.getAppointmentDate()) %></li>
                            <% }
                        } else { %>
                            <li>General dental examination and treatment as deemed necessary by the dentist</li>
                        <% } %>
                    </ul>
                </div>
                
                <div class="consent-section">
                    <h4 class="consent-title">3. RISKS AND COMPLICATIONS</h4>
                    <p>I understand that dental treatment, like any medical procedure, carries some risks including but not limited to:</p>
                    <ul>
                        <li>Temporary or permanent numbness</li>
                        <li>Pain, swelling, or discomfort during or after treatment</li>
                        <li>Infection requiring additional treatment</li>
                        <li>Allergic reactions to medications or materials</li>
                        <li>Need for additional or alternative procedures</li>
                        <li>Possibility of unsuccessful treatment requiring retreatment</li>
                    </ul>
                </div>
                
                <div class="consent-section">
                    <h4 class="consent-title">4. ANESTHESIA AND SEDATION</h4>
                    <p>I consent to the administration of local anesthesia, sedation, or other medication as necessary for my treatment. I understand the risks associated with anesthesia and have disclosed my complete medical history to the dental team.</p>
                </div>
                
                <div class="consent-section">
                    <h4 class="consent-title">5. ALTERNATIVES TO TREATMENT</h4>
                    <p>I understand that alternatives to the proposed treatment have been explained to me, including:</p>
                    <ul>
                        <li>No treatment (with possible consequences)</li>
                        <li>Alternative treatment methods</li>
                        <li>Referral to a specialist</li>
                    </ul>
                </div>
                
                <div class="consent-section">
                    <h4 class="consent-title">6. FINANCIAL RESPONSIBILITY</h4>
                    <p>I understand that I am financially responsible for all services rendered. I have been informed of the estimated costs and agree to the payment terms discussed.</p>
                </div>
                
                <div class="consent-section">
                    <h4 class="consent-title">7. MEDICAL RECORDS AND PRIVACY</h4>
                    <p>I consent to the creation and maintenance of my dental records. I understand that my information will be kept confidential according to privacy laws, but may be disclosed when required by law or for continuity of care.</p>
                </div>
                
                <div class="consent-section">
                    <h4 class="consent-title">8. NO GUARANTEES</h4>
                    <p>I understand that no guarantees or assurances have been made regarding the results of the treatment. The success of dental procedures depends on various factors including my cooperation and oral hygiene.</p>
                </div>
                
                <div class="consent-section">
                    <h4 class="consent-title">9. RIGHT TO REFUSE OR WITHDRAW CONSENT</h4>
                    <p>I understand that I have the right to refuse treatment or withdraw my consent at any time. However, I also understand that such refusal may affect my dental health.</p>
                </div>
                
                <div class="consent-section">
                    <h4 class="consent-title">10. QUESTIONS AND CONCERNS</h4>
                    <p>All my questions have been answered to my satisfaction. I have had sufficient opportunity to discuss this treatment with my dentist.</p>
                </div>
            </div>
            
            <div class="card mb-4">
                <div class="card-body">
                    <div class="form-check terms-checkbox">
                        <input class="form-check-input" type="checkbox" name="agree" value="yes" id="agreeCheckbox" required>
                        <label class="form-check-label" for="agreeCheckbox">
                            <strong>I HAVE READ AND UNDERSTAND THIS CONSENT FORM. ALL MY QUESTIONS HAVE BEEN ANSWERED TO MY SATISFACTION. I VOLUNTARILY CONSENT TO THE PROPOSED DENTAL TREATMENT AND RELATED PROCEDURES.</strong>
                        </label>
                    </div>
                    
                    <div class="mt-3">
                        <p><strong>Patient/Guardian Signature (Digital):</strong> <%= appointment.getPatientIc() %></p>
                        <p><strong>Date of Consent:</strong> <%= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()) %></p>
                    </div>
                </div>
            </div>
            
            <div class="d-flex justify-content-between mb-5">
                <a href="viewAppointments.jsp" class="btn btn-secondary">
                    <i class="fas fa-times"></i> Cancel
                </a>
                <div>
                    <button type="submit" class="btn btn-success btn-lg" id="submitBtn" disabled>
                        <i class="fas fa-signature"></i> Sign Digital Consent
                    </button>
                    <a href="AppointmentServlet?action=view&appointment_id=<%= appointment.getAppointmentId() %>" 
                       class="btn btn-outline-primary ms-2">
                        <i class="fas fa-eye"></i> View Appointment
                    </a>
                </div>
            </div>
        </form>
        
        <% } %>
    </div>
    
    <script>
        // Enable submit button only when checkbox is checked
        document.getElementById('agreeCheckbox').addEventListener('change', function() {
            document.getElementById('submitBtn').disabled = !this.checked;
        });
        
        // Form validation
        document.getElementById('consentForm').addEventListener('submit', function(e) {
            if (!document.getElementById('agreeCheckbox').checked) {
                e.preventDefault();
                alert('You must agree to the terms and conditions before signing the consent.');
                return false;
            }
            
            if (!confirm('Are you sure you want to sign this digital consent? This action cannot be undone.')) {
                e.preventDefault();
                return false;
            }
            
            return true;
        });
        
        // Scroll to bottom alert
        window.addEventListener('load', function() {
            var consentBody = document.querySelector('.consent-body');
            consentBody.scrollTop = consentBody.scrollHeight;
            
            setTimeout(function() {
                alert('Please read through the entire consent form before agreeing. Scroll to review all sections.');
            }, 1000);
        });
    </script>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
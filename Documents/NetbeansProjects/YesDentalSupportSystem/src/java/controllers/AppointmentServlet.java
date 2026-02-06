package controllers;

import beans.*;
import dao.AppointmentDAO;
import dao.BillingDAO;
import dao.DigitalConsentDAO;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/AppointmentServlet")
public class AppointmentServlet extends HttpServlet {
    private AppointmentDAO appointmentDAO;
    private SimpleDateFormat dateFormat;

    @Override
    public void init() {
        appointmentDAO = new AppointmentDAO();
        dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if (action == null) {
            request.setAttribute("error", "No action specified");
            listAppointments(request, response);
            return;
        }

        switch(action) {
            case "add":
                addAppointment(request, response);
                break;
            case "update":
                updateAppointment(request, response);
                break;
            case "delete":
                deleteAppointment(request, response);
                break;
            case "confirm":
                confirmAppointment(request, response);
                break;
            case "sign_consent":
                processDigitalConsent(request, response);
                break;
            case "cancel":
                cancelAppointment(request, response);
                break;
            default:
                request.setAttribute("error", "Invalid action: " + action);
                listAppointments(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if (action == null) {
            listAppointments(request, response);
            return;
        }

        switch(action) {
            case "edit":
                editAppointment(request, response);
                break;
            case "view":
                viewAppointment(request, response);
                break;
            case "add":
                RequestDispatcher dispatcher =
                        request.getRequestDispatcher("/appointment/scheduleAppointment.jsp");
                dispatcher.forward(request, response);
                break;
            case "consent":
                showDigitalConsent(request, response);
                break;
            default:
                listAppointments(request, response);
        }
    }

    private void addAppointment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String patientIc = request.getParameter("patient_ic");
            String appointmentDateStr = request.getParameter("appointment_date");
            String appointmentTime = request.getParameter("appointment_time");
            String treatmentId = request.getParameter("treatment_id");
            String billingMethod = request.getParameter("billing_method"); // can be null (your billing section commented)

            System.out.println("DEBUG - Received parameters:");
            System.out.println("patient_ic: " + patientIc);
            System.out.println("appointment_date: " + appointmentDateStr);
            System.out.println("appointment_time: " + appointmentTime);
            System.out.println("treatment_id: " + treatmentId);
            System.out.println("billing_method: " + billingMethod);

            if (patientIc == null || patientIc.trim().isEmpty() ||
                appointmentDateStr == null || appointmentDateStr.trim().isEmpty() ||
                appointmentTime == null || appointmentTime.trim().isEmpty() ||
                treatmentId == null || treatmentId.trim().isEmpty()) {

                throw new Exception("Please fill in all required fields");
            }

            Appointment appointment = new Appointment();
            appointment.setAppointmentId(appointmentDAO.getNextAppointmentId());
            appointment.setPatientIc(patientIc);

            Date appointmentDate;
            try {
                appointmentDate = dateFormat.parse(appointmentDateStr);

                Date today = new Date();
                if (appointmentDate.before(today) &&
                    !dateFormat.format(appointmentDate).equals(dateFormat.format(today))) {
                    throw new Exception("Appointment date cannot be in the past");
                }
            } catch (Exception e) {
                throw new Exception("Invalid date format. Please use yyyy-MM-dd format");
            }

            appointment.setAppointmentDate(appointmentDate);
            appointment.setAppointmentTime(appointmentTime);
            appointment.setAppointmentStatus("Pending");
            appointment.setRemarks(request.getParameter("remarks"));

            // ✅ NEW: block if this slot is already confirmed
            if (appointmentDAO.isConfirmedSlotTaken(appointmentDate, appointmentTime)) {
                request.setAttribute("error", "This slot is already CONFIRMED. Please choose another date/time.");
                RequestDispatcher dispatcher =
                        request.getRequestDispatcher("/appointment/scheduleAppointment.jsp");
                dispatcher.forward(request, response);
                return;
            }

            int numInstallments = 0;
            if (billingMethod != null && "installment".equals(billingMethod)) {
                try {
                    String installmentsStr = request.getParameter("num_installments");
                    if (installmentsStr != null && !installmentsStr.trim().isEmpty()) {
                        numInstallments = Integer.parseInt(installmentsStr);
                        if (numInstallments < 1 || numInstallments > 5) {
                            throw new Exception("Number of installments must be between 1 and 5");
                        }
                    } else {
                        throw new Exception("Number of installments is required for installment payment");
                    }
                } catch (NumberFormatException e) {
                    throw new Exception("Invalid number of installments. Please enter a valid number");
                }
            }

            System.out.println("DEBUG - Adding appointment with:");
            System.out.println("Appointment ID: " + appointment.getAppointmentId());
            System.out.println("Patient IC: " + appointment.getPatientIc());
            System.out.println("Date: " + appointmentDateStr);
            System.out.println("Time: " + appointment.getAppointmentTime());
            System.out.println("Treatment ID: " + treatmentId);
            System.out.println("Billing Method: " + billingMethod);
            System.out.println("Installments: " + numInstallments);

            boolean success = appointmentDAO.addAppointment(appointment, treatmentId,
                    billingMethod, numInstallments);

            if (success) {
                request.setAttribute("message", "Appointment scheduled successfully!");
                System.out.println("DEBUG - Appointment added successfully");
            } else {
                request.setAttribute("error", "Failed to schedule appointment.");
                System.out.println("DEBUG - Appointment addition failed");
            }

            listAppointments(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG - Exception in addAppointment: " + e.getMessage());
            request.setAttribute("error", "Error: " + e.getMessage());
            RequestDispatcher dispatcher =
                    request.getRequestDispatcher("/appointment/scheduleAppointment.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void listAppointments(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Appointment> appointments = appointmentDAO.getAllAppointments();
        request.setAttribute("appointments", appointments);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/appointment/viewAppointment.jsp");
        dispatcher.forward(request, response);
    }

    private void editAppointment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String appointmentId = request.getParameter("appointment_id");
        System.out.println("DEBUG - Editing appointment ID: " + appointmentId);

        if (appointmentId == null || appointmentId.trim().isEmpty()) {
            request.setAttribute("error", "Appointment ID is required.");
            listAppointments(request, response);
            return;
        }

        try {
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);

            if (appointment == null) {
                request.setAttribute("error", "Appointment not found.");
                listAppointments(request, response);
                return;
            }

            List<AppointmentTreatment> treatments =
                    appointmentDAO.getAppointmentTreatments(appointmentId);
            request.setAttribute("treatments", treatments);

            request.setAttribute("appointment", appointment);
            RequestDispatcher dispatcher =
                    request.getRequestDispatcher("/appointment/editAppointment.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading appointment: " + e.getMessage());
            listAppointments(request, response);
        }
    }

    private void viewAppointment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String appointmentId = request.getParameter("appointment_id");
        System.out.println("DEBUG - Viewing appointment ID: " + appointmentId);

        if (appointmentId == null || appointmentId.trim().isEmpty()) {
            request.setAttribute("error", "Appointment ID is required.");
            listAppointments(request, response);
            return;
        }

        try {
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);

            if (appointment == null) {
                request.setAttribute("error", "Appointment not found.");
                listAppointments(request, response);
                return;
            }

            List<AppointmentTreatment> treatments =
                    appointmentDAO.getAppointmentTreatments(appointmentId);
            request.setAttribute("treatments", treatments);

            request.setAttribute("appointment", appointment);
            RequestDispatcher dispatcher =
                    request.getRequestDispatcher("/appointment/viewAppointmentDetails.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading appointment details: " + e.getMessage());
            listAppointments(request, response);
        }
    }

    private void updateAppointment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String appointmentId = request.getParameter("appointment_id");
            System.out.println("DEBUG - Updating appointment ID: " + appointmentId);

            if (appointmentId == null || appointmentId.trim().isEmpty()) {
                throw new Exception("Appointment ID is required");
            }

            String status = request.getParameter("appointment_status");
            String remarks = request.getParameter("remarks");

            System.out.println("DEBUG - New status: " + status);
            System.out.println("DEBUG - Remarks: " + remarks);

            if (status == null || status.trim().isEmpty()) {
                throw new Exception("Appointment status is required");
            }

            boolean success = appointmentDAO.updateAppointmentStatus(appointmentId, status);

            if (success) {
                request.setAttribute("message", "Appointment updated successfully!");
                System.out.println("DEBUG - Appointment updated successfully");
            } else {
                request.setAttribute("error", "Failed to update appointment.");
                System.out.println("DEBUG - Appointment update failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG - Exception in updateAppointment: " + e.getMessage());
            request.setAttribute("error", "Error: " + e.getMessage());
        }

        listAppointments(request, response);
    }

    private void deleteAppointment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String appointmentId = request.getParameter("appointment_id");
            System.out.println("DEBUG - Deleting appointment ID: " + appointmentId);

            if (appointmentId == null || appointmentId.trim().isEmpty()) {
                throw new Exception("Appointment ID is required");
            }

            boolean success = appointmentDAO.deleteAppointment(appointmentId);

            if (success) {
                request.setAttribute("message", "Appointment deleted successfully!");
                System.out.println("DEBUG - Appointment deleted successfully");
            } else {
                request.setAttribute("error", "Failed to delete appointment.");
                System.out.println("DEBUG - Appointment deletion failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG - Exception in deleteAppointment: " + e.getMessage());
            request.setAttribute("error", "Error: " + e.getMessage());
        }

        listAppointments(request, response);
    }

    private void confirmAppointment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String appointmentId = request.getParameter("appointment_id");
            System.out.println("DEBUG - Confirming appointment ID: " + appointmentId);

            if (appointmentId == null || appointmentId.trim().isEmpty()) {
                throw new Exception("Appointment ID is required");
            }

            // ✅ NEW: before confirming, check if another confirmed appointment already occupies this slot
            Appointment appt = appointmentDAO.getAppointmentById(appointmentId);
            if (appt == null) {
                throw new Exception("Appointment not found");
            }

            if (appointmentDAO.isConfirmedSlotTaken(appt.getAppointmentDate(), appt.getAppointmentTime())) {
                request.setAttribute("error",
                        "Cannot confirm. Another appointment is already CONFIRMED at the same date/time.");
                listAppointments(request, response);
                return;
            }

            String billingMethod = "Pay at Counter";

            boolean success = appointmentDAO.updateAppointmentStatus(appointmentId, "confirmed");

            if (success) {
                BillingDAO billingDAO = new BillingDAO();
                boolean billingCreated = billingDAO.createBillingForAppointment(appointmentId, billingMethod, 1);

                if (billingCreated) {
                    request.setAttribute("message", "Appointment confirmed successfully! Billing record created.");
                    System.out.println("DEBUG - Appointment confirmed and billing created successfully");
                } else {
                    request.setAttribute("error", "Appointment confirmed but failed to create billing record.");
                    System.out.println("DEBUG - Billing creation failed");
                }
            } else {
                request.setAttribute("error", "Failed to confirm appointment.");
                System.out.println("DEBUG - Appointment confirmation failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG - Exception in confirmAppointment: " + e.getMessage());
            request.setAttribute("error", "Error: " + e.getMessage());
        }

        listAppointments(request, response);
    }

    private void showDigitalConsent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String appointmentId = request.getParameter("appointment_id");
        System.out.println("DEBUG - Showing digital consent for appointment ID: " + appointmentId);

        if (appointmentId == null || appointmentId.trim().isEmpty()) {
            request.setAttribute("error", "Appointment ID is required.");
            listAppointments(request, response);
            return;
        }

        try {
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
            if (appointment == null) {
                request.setAttribute("error", "Appointment not found.");
                listAppointments(request, response);
                return;
            }

            if (!"Confirmed".equals(appointment.getAppointmentStatus())) {
                request.setAttribute("error", "Only confirmed appointments require digital consent.");
                listAppointments(request, response);
                return;
            }

            List<AppointmentTreatment> treatments =
                    appointmentDAO.getAppointmentTreatments(appointmentId);

            StringBuilder consentContext = new StringBuilder();
            consentContext.append("Treatment(s): ");
            for (AppointmentTreatment treatment : treatments) {
                consentContext.append(treatment.getTreatmentId()).append(", ");
            }
            if (treatments.size() > 0) {
                consentContext.delete(consentContext.length() - 2, consentContext.length());
            }

            request.setAttribute("appointment", appointment);
            request.setAttribute("treatments", treatments);
            request.setAttribute("consentContext", consentContext.toString());

            RequestDispatcher dispatcher =
                    request.getRequestDispatcher("/appointment/digitalConsent.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading consent form: " + e.getMessage());
            listAppointments(request, response);
        }
    }

    private void processDigitalConsent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String appointmentId = request.getParameter("appointment_id");
            String patientIc = request.getParameter("patient_ic");
            String consentText = request.getParameter("consent_text");
            String agree = request.getParameter("agree");

            System.out.println("DEBUG - Processing digital consent for appointment: " + appointmentId);
            System.out.println("DEBUG - Patient agreed: " + agree);

            if (appointmentId == null || appointmentId.trim().isEmpty()) {
                throw new Exception("Appointment ID is required");
            }

            if (!"yes".equals(agree)) {
                throw new Exception("You must agree to the terms and conditions");
            }

            if (patientIc == null || patientIc.trim().isEmpty()) {
                throw new Exception("Patient IC is required");
            }

            DigitalConsentDAO consentDAO = new DigitalConsentDAO();
            DigitalConsent consent = new DigitalConsent();
            consent.setConsentId(consentDAO.getNextConsentId());
            consent.setPatientIc(patientIc);
            consent.setConsentContext(consentText != null ? consentText : "General dental treatment consent");
            consent.setConsentSigndate(new java.util.Date());

            boolean success = consentDAO.addDigitalConsent(consent);

            if (success) {
                request.setAttribute("message", "Digital consent signed successfully!");
                System.out.println("DEBUG - Digital consent added successfully: " + consent.getConsentId());
            } else {
                request.setAttribute("error", "Failed to sign digital consent.");
                System.out.println("DEBUG - Digital consent addition failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG - Exception in processDigitalConsent: " + e.getMessage());
            request.setAttribute("error", "Error: " + e.getMessage());
        }

        listAppointments(request, response);
    }

    private void cancelAppointment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String appointmentId = request.getParameter("appointment_id");
            System.out.println("DEBUG - Cancelling appointment ID: " + appointmentId);

            if (appointmentId == null || appointmentId.trim().isEmpty()) {
                throw new Exception("Appointment ID is required");
            }

            boolean success = appointmentDAO.updateAppointmentStatus(appointmentId, "Cancelled");

            if (success) {
                request.setAttribute("message", "Appointment cancelled successfully!");
                System.out.println("DEBUG - Appointment cancelled successfully");
            } else {
                request.setAttribute("error", "Failed to cancel appointment.");
                System.out.println("DEBUG - Appointment cancellation failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DEBUG - Exception in cancelAppointment: " + e.getMessage());
            request.setAttribute("error", "Error: " + e.getMessage());
        }

        listAppointments(request, response);
    }
}

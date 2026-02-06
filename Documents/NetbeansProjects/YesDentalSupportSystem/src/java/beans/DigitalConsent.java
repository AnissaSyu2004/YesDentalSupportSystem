package beans;

import java.util.Date;

public class DigitalConsent {
    private String consentId;
    private String patientIc;
    private String consentContext;
    private Date consentSigndate;
    
    public DigitalConsent() {}

    public DigitalConsent(String consentId, String patientIc, String consentContext, Date consentSigndate) {
        this.consentId = consentId;
        this.patientIc = patientIc;
        this.consentContext = consentContext;
        this.consentSigndate = consentSigndate;
    }

    // Getters and Setters
    public String getConsentId() { return consentId; }
    public void setConsentId(String consentId) { this.consentId = consentId; }
    
    public String getPatientIc() { return patientIc; }
    public void setPatientIc(String patientIc) { this.patientIc = patientIc; }
    
    public String getConsentContext() { return consentContext; }
    public void setConsentContext(String consentContext) { this.consentContext = consentContext; }
    
    public Date getConsentSigndate() { return consentSigndate; }
    public void setConsentSigndate(Date consentSigndate) { this.consentSigndate = consentSigndate; }
}
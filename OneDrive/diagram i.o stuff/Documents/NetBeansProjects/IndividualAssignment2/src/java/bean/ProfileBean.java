package bean;

import java.io.Serializable;

public class ProfileBean implements Serializable {
    private int id;
    private String name;
    private String studentId;
    private String program;
    private String email;
    private String hobbies;
    private String introduction;
    
    
    public ProfileBean() {}
    
    
    public int getId() { return id; }
    public String getName() { return name; }
    public String getStudentId() { return studentId; }
    public String getProgram() { return program; }
    public String getEmail() { return email; }
    public String getHobbies() { return hobbies; }
    public String getIntroduction() { return introduction; }
    
    
    public void setId(int id) { this.id = id; }
    public void setName(String name) { this.name = name; }
    public void setStudentId(String studentId) { this.studentId = studentId; }
    public void setProgram(String program) { this.program = program; }
    public void setEmail(String email) { this.email = email; }
    public void setHobbies(String hobbies) { this.hobbies = hobbies; }
    public void setIntroduction(String introduction) { this.introduction = introduction; }
}

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="bean.ProfileBean" %>
<%
    ProfileBean profile = (ProfileBean) request.getAttribute("profile");
    if (profile == null) {
        response.sendRedirect("index.html");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile Saved - NUR ANISSA SYUHADA</title>
    <style>
        :root {
            --moss: #5a7d5a;
            --forest: #3a5a3a;
            --clay: #a67c52;
            --sand: #d9c7b8;
            --stone: #8a7f68;
            --soil: #6b5b3d;
            --leaf: #8fa389;
            --pale: #f5f1e8;
            --charcoal: #2c2c2c;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Georgia', serif;
            background-color: var(--pale);
            color: var(--charcoal);
            line-height: 1.5;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
            background-image: 
                radial-gradient(circle at 10% 20%, rgba(139, 115, 85, 0.05) 0%, transparent 20%),
                radial-gradient(circle at 90% 80%, rgba(90, 125, 90, 0.05) 0%, transparent 20%);
        }
        
        .paper {
            background: white;
            border-radius: 2px;
            box-shadow: 
                0 2px 5px rgba(0,0,0,0.1),
                0 5px 15px rgba(0,0,0,0.05),
                inset 0 1px 0 rgba(255,255,255,0.8);
            padding: 40px 35px;
            max-width: 500px;
            width: 100%;
            position: relative;
            border: 1px solid rgba(139, 115, 85, 0.2);
            background-image: linear-gradient(to bottom, rgba(255,255,255,0.9) 0%, rgba(245,241,232,0.7) 100%);
        }
        
        .paper::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(to right, var(--moss), var(--clay));
            border-radius: 2px 2px 0 0;
        }
        
        .header {
            text-align: center;
            margin-bottom: 35px;
            padding-bottom: 20px;
            border-bottom: 1px dashed var(--stone);
            position: relative;
        }
        
        .header::after {
            content: '✓';
            position: absolute;
            bottom: -12px;
            left: 50%;
            transform: translateX(-50%);
            background: var(--pale);
            padding: 0 10px;
            color: var(--moss);
            font-size: 14px;
        }
        
        .title {
            font-family: 'Playfair Display', serif;
            font-size: 28px;
            font-weight: 700;
            color: var(--forest);
            margin-bottom: 8px;
            letter-spacing: -0.5px;
        }
        
        .subtitle {
            color: var(--soil);
            font-size: 15px;
            font-style: italic;
        }
        
        .profile-header {
            text-align: center;
            margin-bottom: 25px;
        }
        
        .avatar {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, var(--leaf), var(--forest));
            border-radius: 50%;
            margin: 0 auto 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            position: relative;
            box-shadow: 0 4px 8px rgba(58, 90, 58, 0.2);
        }
        
        .avatar-icon {
            width: 40px;
            height: 40px;
            fill: currentColor;
            stroke: currentColor;
            stroke-width: 0.5;
        }
        
        .avatar::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            border-radius: 50%;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, transparent 60%);
        }
        
        .profile-name {
            font-size: 24px;
            color: var(--forest);
            margin-bottom: 5px;
        }
        
        .profile-id {
            color: var(--stone);
            font-size: 14px;
        }
        
        .info-section {
            margin-bottom: 25px;
        }
        
        .section-title {
            font-size: 16px;
            color: var(--forest);
            margin-bottom: 10px;
            padding-bottom: 5px;
            border-bottom: 1px solid var(--sand);
        }
        
        .info-item {
            margin-bottom: 15px;
        }
        
        .info-label {
            font-size: 13px;
            color: var(--soil);
            margin-bottom: 5px;
            font-weight: 500;
        }
        
        .info-value {
            background: rgba(255, 255, 255, 0.7);
            padding: 10px 15px;
            border-radius: 3px;
            border-left: 3px solid var(--leaf);
        }
        
        .hobbies-container {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 10px;
        }
        
        .hobby-tag {
            background: rgba(143, 163, 137, 0.2);
            color: var(--forest);
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 13px;
            border: 1px solid var(--leaf);
        }
        
        .actions {
            display: flex;
            gap: 10px;
            margin-top: 30px;
        }
        
        .btn {
            flex: 1;
            padding: 12px;
            border-radius: 3px;
            text-align: center;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-primary {
            background: linear-gradient(to bottom, var(--moss), var(--forest));
            color: white;
            box-shadow: 0 2px 5px rgba(58, 90, 58, 0.3);
        }
        
        .btn-secondary {
            background: white;
            color: var(--forest);
            border: 1px solid var(--forest);
            box-shadow: 0 2px 5px rgba(58, 90, 58, 0.2);
        }
        
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(58, 90, 58, 0.4);
        }
        
        .footer {
            text-align: center;
            margin-top: 35px;
            padding-top: 20px;
            border-top: 1px dashed var(--stone);
            color: var(--stone);
            font-size: 13px;
        }
        
        @media (max-width: 600px) {
            .paper {
                padding: 30px 25px;
            }
            
            .title {
                font-size: 24px;
            }
            
            .actions {
                flex-direction: column;
            }
        }
    </style>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Georgia&display=swap" rel="stylesheet">
</head>
<body>
    <div class="paper">
        <div class="header">
            <h1 class="title">Profile Saved Successfully</h1>
            <p class="subtitle">Your information has been saved to the database</p>
        </div>
        
        <div class="profile-header">
            <div class="avatar">
                <svg class="avatar-icon" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                    <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 3c1.66 0 3 1.34 3 3s-1.34 3-3 3-3-1.34-3-3 1.34-3 3-3zm0 14.2c-2.5 0-4.71-1.28-6-3.22.03-1.99 4-3.08 6-3.08 1.99 0 5.97 1.09 6 3.08-1.29 1.94-3.5 3.22-6 3.22z"/>
                </svg>
            </div>
            <h2 class="profile-name"><%= profile.getName() %></h2>
            <p class="profile-id"><%= profile.getStudentId() %></p>
        </div>
        
        <div class="info-section">
            <h3 class="section-title">Personal Information</h3>
            
            <div class="info-item">
                <div class="info-label">Student ID</div>
                <div class="info-value"><%= profile.getStudentId() %></div>
            </div>
            
            <div class="info-item">
                <div class="info-label">Program</div>
                <div class="info-value"><%= profile.getProgram() %></div>
            </div>
            
            <div class="info-item">
                <div class="info-label">Email Address</div>
                <div class="info-value"><%= profile.getEmail() %></div>
            </div>
        </div>
        
        <div class="info-section">
            <h3 class="section-title">Hobbies & Interests</h3>
            <div class="hobbies-container">
                <% 
                    String hobbies = profile.getHobbies();
                    if (hobbies != null && !hobbies.trim().isEmpty()) {
                        String[] hobbiesArray = hobbies.split(",");
                        for (String hobby : hobbiesArray) {
                %>
                    <span class="hobby-tag"><%= hobby.trim() %></span>
                <% 
                        }
                    } else { 
                %>
                    <span class="hobby-tag">No hobbies specified</span>
                <% } %>
            </div>
        </div>
        
        <div class="info-section">
            <h3 class="section-title">About Me</h3>
            <div class="info-value">
                <%= profile.getIntroduction() != null && !profile.getIntroduction().trim().isEmpty() 
                    ? profile.getIntroduction() 
                    : "No introduction provided." %>
            </div>
        </div>
        
        <div class="actions">
            <a href="ProfileServlet" class="btn btn-primary">View All Profiles</a>
            <a href="index.html" class="btn btn-secondary">Create New Profile</a>
        </div>
        
        <div class="footer">
            <p>NUR ANISSA SYUHADA | 2025182621 | Individual Assignment 2</p>
        </div>
    </div>
</body>
</html>
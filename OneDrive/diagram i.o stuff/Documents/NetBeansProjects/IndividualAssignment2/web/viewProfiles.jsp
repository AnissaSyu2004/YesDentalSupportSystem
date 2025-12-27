<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Student Profiles</title>
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
            padding: 20px;
            min-height: 100vh;
            background-image: 
                radial-gradient(circle at 10% 20%, rgba(139, 115, 85, 0.05) 0%, transparent 20%),
                radial-gradient(circle at 90% 80%, rgba(90, 125, 90, 0.05) 0%, transparent 20%);
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        
        header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px dashed var(--stone);
        }
        
        .logo {
            font-family: 'Playfair Display', serif;
            font-weight: 700;
            color: var(--forest);
            font-size: 24px;
            margin-bottom: 10px;
        }
        
        .subtitle {
            color: var(--soil);
            font-style: italic;
        }
        
        .search-box {
            background: white;
            padding: 20px;
            border-radius: 3px;
            margin-bottom: 30px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            border: 1px solid rgba(139, 115, 85, 0.2);
        }
        
        .search-form {
            display: flex;
            gap: 10px;
        }
        
        .search-input {
            flex: 1;
            padding: 12px 15px;
            border: 1px solid var(--sand);
            border-radius: 3px;
            font-family: 'Georgia', serif;
            font-size: 16px;
        }
        
        .search-btn {
            padding: 12px 25px;
            background: linear-gradient(to bottom, var(--moss), var(--forest));
            color: white;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            font-family: 'Georgia', serif;
            font-weight: 500;
        }
        
        .clear-btn {
            padding: 12px 25px;
            background: white;
            color: var(--forest);
            border: 1px solid var(--forest);
            border-radius: 3px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            font-family: 'Georgia', serif;
        }
        
        .profiles-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .profile-card {
            background: white;
            border-radius: 3px;
            padding: 25px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            border: 1px solid rgba(139, 115, 85, 0.2);
            transition: transform 0.3s ease;
            border-top: 4px solid var(--moss);
        }
        
        .profile-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .profile-card h3 {
            color: var(--forest);
            margin-bottom: 15px;
            font-family: 'Playfair Display', serif;
            padding-bottom: 10px;
            border-bottom: 1px dashed var(--sand);
        }
        
        .profile-detail {
            margin-bottom: 10px;
            font-size: 14px;
        }
        
        .detail-label {
            font-weight: 600;
            color: var(--soil);
        }
        
        .empty-state {
            text-align: center;
            padding: 50px 20px;
            color: var(--stone);
            font-style: italic;
        }
        
        .actions {
            text-align: center;
            margin-top: 40px;
        }
        
        .home-btn {
            display: inline-block;
            padding: 12px 30px;
            background: linear-gradient(to bottom, var(--moss), var(--forest));
            color: white;
            text-decoration: none;
            border-radius: 3px;
            font-weight: 500;
            box-shadow: 0 2px 5px rgba(58, 90, 58, 0.3);
            transition: all 0.3s ease;
        }
        
        .home-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(58, 90, 58, 0.4);
        }
        
        footer {
            text-align: center;
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px dashed var(--stone);
            color: var(--stone);
            font-size: 13px;
        }
        
        @media (max-width: 768px) {
            .profiles-grid {
                grid-template-columns: 1fr;
            }
            
            .search-form {
                flex-direction: column;
            }
        }
    </style>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Georgia&display=swap" rel="stylesheet">
</head>
<body>
    <div class="container">
        <header>
            <div class="logo">STUDENT PROFILE SYSTEM</div>
            <h1>All Student Profiles</h1>
            <p class="subtitle">Database Records - Search Feature Enabled</p>
        </header>
        
      
        <div class="search-box">
            <form action="ProfileServlet" method="get" class="search-form">
                <input type="text" name="search" class="search-input" 
                       placeholder="Search by name or student ID..."
                       value="<%= request.getAttribute("search") != null ? request.getAttribute("search") : "" %>">
                <button type="submit" class="search-btn">Search</button>
                <a href="ProfileServlet" class="clear-btn">Clear</a>
            </form>
        </div>
        
        
        <div class="profiles-grid">
            <% 
                ResultSet profiles = (ResultSet) request.getAttribute("profiles");
                boolean hasProfiles = false;
                
                if (profiles != null) {
                    while (profiles.next()) {
                        hasProfiles = true;
            %>
            <div class="profile-card">
                <h3><%= profiles.getString("name") %></h3>
                
                <div class="profile-detail">
                    <span class="detail-label">Student ID:</span> 
                    <%= profiles.getString("student_id") %>
                </div>
                
                <div class="profile-detail">
                    <span class="detail-label">Program:</span> 
                    <%= profiles.getString("program") %>
                </div>
                
                <div class="profile-detail">
                    <span class="detail-label">Email:</span> 
                    <%= profiles.getString("email") %>
                </div>
                
                <div class="profile-detail">
                    <span class="detail-label">Hobbies:</span> 
                    <%= profiles.getString("hobbies") != null && !profiles.getString("hobbies").isEmpty() 
                        ? profiles.getString("hobbies") : "Not specified" %>
                </div>
                
                <div class="profile-detail">
                    <span class="detail-label">About:</span> 
                    <% 
                        String intro = profiles.getString("introduction");
                        if (intro != null && !intro.isEmpty()) {
                            if (intro.length() > 100) {
                                out.print(intro.substring(0, 100) + "...");
                            } else {
                                out.print(intro);
                            }
                        } else {
                            out.print("No introduction");
                        }
                    %>
                </div>
            </div>
            <% 
                    }
                }
                
                if (!hasProfiles) {
            %>
            <div class="empty-state">
                <p>No profiles found in the database.</p>
                <% if (request.getAttribute("search") != null) { %>
                    <p>Try a different search term or clear the search.</p>
                <% } else { %>
                    <p>Create your first profile using the form.</p>
                <% } %>
            </div>
            <% } %>
        </div>
        
       
        <div class="actions">
            <a href="index.html" class="home-btn">← Create New Profile</a>
        </div>
        
        <footer>
            <p>NUR ANISSA SYUHADA | 2025182621 | Individual Assignment 2</p>
        </footer>
    </div>
</body>
</html>
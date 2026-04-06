<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập hệ thống - Hotel Manager</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        body {
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            overflow: hidden;
            background: #F0F2F5; /* Light shadow for contrast */
        }
        .login-card {
            width: 750px;
            height: 450px;
            display: flex;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            background: white;
        }
        .login-left {
            flex: 1;
            background-color: var(--excel-green);
            color: white;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 40px;
        }
        .brand-icon {
            font-size: 80px;
            margin-bottom: 10px;
        }
        .brand-name {
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 5px;
        }
        .brand-slogan {
            font-size: 14px;
            font-style: italic;
            opacity: 0.8;
        }
        .login-right {
            flex: 1;
            padding: 50px 40px;
            display: flex;
            flex-direction: column;
        }
        .login-title {
            text-align: center;
            color: var(--excel-green);
            font-size: 32px;
            font-weight: bold;
            margin-bottom: 40px;
        }
        .form-group {
            margin-bottom: 25px;
        }
        .form-group label {
            display: block;
            font-size: 14px;
            color: var(--color-text);
            margin-bottom: 8px;
        }
        .login-input {
            width: 100%;
            border: none;
            border-bottom: 2px solid var(--excel-green);
            font-size: 16px;
            padding: 8px 0;
            outline: none;
            background: transparent;
        }
        .login-btn {
            width: 100%;
            padding: 14px;
            margin-top: 20px;
            font-size: 16px;
        }
        .error-msg {
            color: var(--color-danger);
            font-size: 14px;
            margin-top: 10px;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="login-card">
        <div class="login-left">
            <div class="brand-icon">🏨</div>
            <div class="brand-name">HOTEL MANAGER</div>
            <div class="brand-slogan">Quản lý chuyên nghiệp</div>
        </div>
        <div class="login-right">
            <div class="login-title">ĐĂNG NHẬP</div>
            <form action="login" method="post">
                <div class="form-group">
                    <label for="username">Tài khoản</label>
                    <input type="text" id="username" name="username" class="login-input" required>
                </div>
                <div class="form-group">
                    <label for="password">Mật khẩu</label>
                    <input type="password" id="password" name="password" class="login-input" required>
                </div>
                <button type="submit" class="btn-swing btn-primary login-btn">ĐĂNG NHẬP</button>
                <% if(request.getAttribute("error") != null) { %>
                    <div class="error-msg"><%= request.getAttribute("error") %></div>
                <% } %>
            </form>
        </div>
    </div>
</body>
</html>

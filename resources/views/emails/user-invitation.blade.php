<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to KLD School Platform</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            background-color: #f9fafb;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .header {
            background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%);
            color: white;
            padding: 40px 20px;
            text-align: center;
        }
        .header h1 {
            margin: 0;
            font-size: 28px;
        }
        .content {
            padding: 40px 20px;
        }
        .greeting {
            font-size: 20px;
            margin-bottom: 20px;
            color: #333;
        }
        .credentials-box {
            background-color: #f0f4ff;
            border-left: 4px solid #667eea;
            padding: 20px;
            margin: 20px 0;
            border-radius: 4px;
            font-family: 'Courier New', monospace;
        }
        .credentials-box p {
            margin: 8px 0;
        }
        .credentials-box strong {
            color: #0f62dd;
        }
        .cta-button {
            display: inline-block;
            background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%);
            color: white;
            padding: 14px 32px;
            text-decoration: none;
            border-radius: 6px;
            font-weight: bold;
            margin: 20px 0;
            text-align: center;
            transition: transform 0.2s;
        }
        .cta-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(30, 113, 221, 0.4);
        }
        .instructions {
            background-color: #f9fafb;
            border: 1px solid #e5e7eb;
            padding: 20px;
            border-radius: 6px;
            margin: 20px 0;
        }
        .instructions ol {
            margin: 0;
            padding-left: 20px;
        }
        .instructions li {
            margin: 10px 0;
        }
        .role-badge {
            display: inline-block;
            background-color: #0f62dd;
            color: white;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 14px;
            margin-top: 10px;
        }
        .footer {
            background-color: #f9fafb;
            border-top: 1px solid #e5e7eb;
            padding: 20px;
            text-align: center;
            font-size: 12px;
            color: #666;
        }
        .footer a {
            color: #0f62dd;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Welcome to KLD School Platform</h1>
        </div>

        <div class="content">
            <p class="greeting">Hello {{ $name }}!</p>

            <p>Your account has been created and is ready to use. Please complete your registration using the credentials below.</p>

            <div class="credentials-box">
                <p><strong>Email:</strong> {{ $email }}</p>
                <p><strong>Password:</strong> {{ $password }}</p>
            </div>

            <p style="color: #dc2626; font-weight: bold;">Important: Please change this password immediately after your first login for security.</p>

            <div class="role-badge">{{ $role }}</div>

            <h3 style="margin-top: 30px;">Next Steps:</h3>
            <div class="instructions">
                <ol>
                    <li>Click the button below to start your registration</li>
                    <li>Use the email and password provided above</li>
                    <li>Complete your profile information</li>
                    <li>Change your password to something secure</li>
                    <li>Start using the platform!</li>
                </ol>
            </div>

            <div style="text-align: center;">
                <a href="{{ $signupLink }}" class="cta-button">Complete Your Registration</a>
            </div>

            <p style="color: #666; font-size: 14px;">If the button doesn't work, copy and paste this link in your browser:</p>
            <p style="word-break: break-all; background-color: #f9fafb; padding: 10px; border-radius: 4px; font-size: 12px;">{{ $signupLink }}</p>

            <p style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #e5e7eb; color: #666; font-size: 14px;">
                If you have any questions or need assistance, please contact our support team.
            </p>
        </div>

        <div class="footer">
            <p>© {{ date('Y') }} KLD School Platform. All rights reserved.</p>
            <p><a href="#">Help Center</a> | <a href="#">Privacy Policy</a> | <a href="#">Terms of Service</a></p>
        </div>
    </div>
</body>
</html>

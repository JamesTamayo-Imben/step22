<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            max-width: 600px;
            margin: 0 auto;
        }
        .container {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 40px 20px;
            border-radius: 8px;
            text-align: center;
            color: white;
        }
        .header {
            margin-bottom: 30px;
        }
        .header h1 {
            margin: 0;
            font-size: 28px;
            font-weight: 600;
        }
        .checkmark {
            font-size: 48px;
            margin: 20px 0;
        }
        .content {
            background: white;
            color: #333;
            padding: 30px;
            border-radius: 8px;
            margin-top: 20px;
            text-align: left;
        }
        .content h2 {
            color: #667eea;
            margin-top: 0;
        }
        .details {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 6px;
            margin: 15px 0;
            border-left: 4px solid #667eea;
        }
        .detail-row {
            padding: 8px 0;
            border-bottom: 1px solid #e9ecef;
        }
        .detail-row:last-child {
            border-bottom: none;
        }
        .detail-label {
            font-weight: 600;
            color: #667eea;
            display: inline-block;
            width: 140px;
        }
        .detail-value {
            color: #333;
        }
        .button {
            display: inline-block;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 12px 30px;
            text-decoration: none;
            border-radius: 6px;
            margin-top: 20px;
            font-weight: 600;
            transition: transform 0.2s;
        }
        .button:hover {
            transform: scale(1.05);
        }
        .footer {
            margin-top: 20px;
            font-size: 13px;
            color: #666;
            text-align: center;
        }
        .role-badge {
            display: inline-block;
            background: #667eea;
            color: white;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="checkmark">✅</div>
            <h1>Welcome to STEP Platform!</h1>
            <p style="margin: 10px 0; font-size: 16px;">Your registration is complete</p>
        </div>
    </div>

    <div class="content">
        <h2>Hello, {{ $firstName }}! 👋</h2>
        
        <p>Welcome to the STEP Platform! We're excited to have you on board. Your account has been successfully created and is now ready to use.</p>

        <div class="details">
            <div class="detail-row">
                <span class="detail-label">Account Role:</span>
                <span class="detail-value">
                    <span class="role-badge">{{ ucfirst(str_replace('_', ' ', $role)) }}</span>
                </span>
            </div>
            @if($role === 'teacher')
                @if($employeeId)
                    <div class="detail-row">
                        <span class="detail-label">Employee ID:</span>
                        <span class="detail-value">{{ $employeeId }}</span>
                    </div>
                @endif
                @if($instituteName)
                    <div class="detail-row">
                        <span class="detail-label">Institute:</span>
                        <span class="detail-value">{{ $instituteName }}</span>
                    </div>
                @endif
            @endif
        </div>

        <h3 style="color: #667eea; margin-top: 25px;">What's Next?</h3>
        <ul style="line-height: 1.8;">
            <li><strong>Explore the Platform:</strong> Log in to your dashboard to explore all available features</li>
            <li><strong>Complete Your Profile:</strong> Add more details to personalize your account (if needed)</li>
            <li><strong>Get Started:</strong> Depending on your role, you can now participate in projects, submit proposals, or approve submissions</li>
        </ul>

        <center>
            <a href="{{ env('APP_URL', 'http://localhost:8000') }}" class="button">Log in to Dashboard</a>
        </center>

        <p style="margin-top: 25px; color: #666; font-size: 14px;">
            If you have any questions or need assistance, please don't hesitate to contact our support team.
        </p>
    </div>

    <div class="footer">
        <p>© {{ date('Y') }} STEP Platform. All rights reserved.</p>
        <p>This is an automated message. Please do not reply to this email.</p>
    </div>
</body>
</html>

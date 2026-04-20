<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to STEP Platform</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        .header {
            background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%);
            color: white;
            padding: 30px 20px;
            text-align: center;
        }
        .header h1 {
            margin: 0;
            font-size: 28px;
            font-weight: bold;
        }
        .content {
            padding: 30px 20px;
        }
        .greeting {
            font-size: 16px;
            margin-bottom: 20px;
        }
        .info-box {
            background-color: #f0f4ff;
            border-left: 4px solid #3b82f6;
            padding: 15px;
            margin: 20px 0;
            border-radius: 4px;
        }
        .credential-box {
            background-color: #fffbeb;
            border: 2px solid #fbbf24;
            border-radius: 6px;
            padding: 20px;
            margin: 20px 0;
        }
        .credential-box h3 {
            margin-top: 0;
            color: #b45309;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .credential-item {
            margin: 12px 0;
            padding: 10px;
            background-color: white;
            border-radius: 4px;
            font-family: 'Courier New', monospace;
        }
        .credential-label {
            font-size: 12px;
            color: #666;
            text-transform: uppercase;
            margin-bottom: 4px;
        }
        .credential-value {
            font-size: 16px;
            font-weight: bold;
            color: #1f2937;
            word-break: break-all;
        }
        .details-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin: 20px 0;
        }
        .detail-item {
            background-color: #f9fafb;
            padding: 12px;
            border-radius: 4px;
        }
        .detail-label {
            font-size: 12px;
            color: #666;
            text-transform: uppercase;
            margin-bottom: 4px;
        }
        .detail-value {
            font-size: 14px;
            font-weight: 600;
            color: #1f2937;
        }
        .action-button {
            background-color: #3b82f6;
            color: white;
            padding: 12px 30px;
            text-decoration: none;
            border-radius: 6px;
            display: inline-block;
            margin: 20px 0;
            font-weight: 600;
            text-align: center;
        }
        .action-button:hover {
            background-color: #2563eb;
        }
        .instructions {
            background-color: #ecfdf5;
            border-left: 4px solid #10b981;
            padding: 15px;
            margin: 20px 0;
            border-radius: 4px;
        }
        .instructions h4 {
            margin-top: 0;
            color: #047857;
            font-size: 14px;
        }
        .instructions ul {
            margin: 10px 0;
            padding-left: 20px;
        }
        .instructions li {
            margin: 5px 0;
            font-size: 14px;
        }
        .footer {
            background-color: #f3f4f6;
            padding: 20px;
            text-align: center;
            border-top: 1px solid #e5e7eb;
            font-size: 12px;
            color: #666;
        }
        .footer-link {
            color: #3b82f6;
            text-decoration: none;
        }
        .footer-link:hover {
            text-decoration: underline;
        }
        .warning {
            background-color: #fee2e2;
            border-left: 4px solid #ef4444;
            padding: 15px;
            margin: 20px 0;
            border-radius: 4px;
            font-size: 13px;
            color: #991b1b;
        }
        .role-badge {
            display: inline-block;
            background-color: #dbeafe;
            color: #1e40af;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
            text-transform: capitalize;
        }
    </style>
</head>
<body>
    <div class="container">
        {{-- Header --}}
        <div class="header">
            <h1>🎓 Welcome to STEP</h1>
            <p style="margin: 10px 0 0 0; opacity: 0.9;">School Transparency Platform</p>
        </div>

        {{-- Main Content --}}
        <div class="content">
            <div class="greeting">
                <p>Hi <strong>{{ $userName }}</strong>,</p>
                <p>Welcome to the STEP Platform! Your profile has been successfully set up. Below are your temporary login credentials to access the system.</p>
            </div>

            {{-- Credentials --}}
            <div class="credential-box">
                <h3>⚡ Your Temporary Password</h3>
                
                <div class="credential-item">
                    <div class="credential-label">Email Address</div>
                    <div class="credential-value">{{ $email }}</div>
                </div>

                <div class="credential-item">
                    <div class="credential-label">Temporary Password</div>
                    <div class="credential-value">{{ $temporaryPassword }}</div>
                </div>
            </div>

            {{-- Role and ID Details --}}
            <div class="details-grid">
                <div class="detail-item">
                    <div class="detail-label">Role</div>
                    <div class="detail-value">
                        <span class="role-badge">{{ ucfirst($role) }}</span>
                    </div>
                </div>
                @if($studentId)
                <div class="detail-item">
                    <div class="detail-label">Student ID</div>
                    <div class="detail-value">{{ $studentId }}</div>
                </div>
                @endif
                @if($employeeId)
                <div class="detail-item">
                    <div class="detail-label">Employee ID</div>
                    <div class="detail-value">{{ $employeeId }}</div>
                </div>
                @endif
            </div>

            {{-- Instructions --}}
            <div class="instructions">
                <h4>🔐 First Login Instructions:</h4>
                <ul>
                    <li>Visit the STEP login page</li>
                    <li>Enter your email: <strong>{{ $email }}</strong></li>
                    <li>Enter your temporary password: <strong>{{ $temporaryPassword }}</strong></li>
                    <li>Upon first login, you will be prompted to change your password to a new one</li>
                </ul>
            </div>

            {{-- Security Warning --}}
            <div class="warning">
                <strong>⚠️ Important Security Notes:</strong>
                <ul style="margin: 10px 0;">
                    <li>This is a temporary password. Change it immediately upon your first login.</li>
                    <li>Do not share your password with anyone.</li>
                    <li>Keep your login credentials secure and confidential.</li>
                    <li>If you didn't request this account, please contact our support team immediately.</li>
                </ul>
            </div>

            {{-- Call to Action --}}
            <div style="text-align: center;">
                <a href="{{ config('app.url') }}/login" class="action-button">Go to Login</a>
            </div>

            {{-- Support --}}
            <div class="info-box">
                <strong>Need Help?</strong><br>
                If you encounter any issues logging in or have questions about the STEP platform, please contact our support team at <a href="mailto:support@kld.edu.ph" style="color: #3b82f6; text-decoration: none;">support@kld.edu.ph</a>
            </div>
        </div>

        {{-- Footer --}}
        <div class="footer">
            <p>© {{ date('Y') }} STEP Platform - Kolehiyo ng Lungsod ng Dasmariñas</p>
            <p>
                <a href="{{ config('app.url') }}" class="footer-link">Visit Website</a> • 
                <a href="mailto:support@kld.edu.ph" class="footer-link">Contact Support</a>
            </p>
            <p style="margin-top: 10px; color: #999;">This is an automated message. Please do not reply to this email.</p>
        </div>
    </div>
</body>
</html>

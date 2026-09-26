<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>STEP security review required</title>
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
            border-left: 4px solid #1e3a8a;
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
            <h1>STEP INTEGRITY EMAIL</h1>
        </div>

        <div class="content">
           
            <p style="color: #dc2626; font-weight: bold;">Important: This email is an automated security alert.</p>

            

           <p>A project integrity issue was detected in STEP and requires review.</p>
    <p><strong>Project:</strong> {{ $projectTitle }}</p>
    <p><strong>Project ID:</strong> {{ $projectId }}</p>
    <p><strong>Affected blocks:</strong> {{ count($tamperedBlocks) }}</p>
    <p>Please review the chain integrity page. This email is an internal security alert; avoid taking action until the adviser completes the investigation.</p>

            <p style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #e5e7eb; color: #666; font-size: 14px;">
                If you have any questions or need assistance, please contact our support team.
            </p>
        </div>

        <div class="footer">
            <p>©KLD School Platform. All rights reserved.</p>
            <p><a href="#">Help Center</a> | <a href="#">Privacy Policy</a> | <a href="#">Terms of Service</a></p>
        </div>
    </div>

</body>
</html>
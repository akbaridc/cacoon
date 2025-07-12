<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Verification Code</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            color: #333;
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
        }
        .container {
            background-color: #f4f4f4;
            border-radius: 10px;
            padding: 30px;
            text-align: center;
        }
        .token-box {
            background-color: #007bff;
            color: white;
            font-size: 32px;
            font-weight: bold;
            padding: 20px;
            border-radius: 5px;
            letter-spacing: 5px;
            margin: 20px 0;
        }
        .message {
            font-size: 16px;
            margin-bottom: 20px;
        }
        .footer {
            font-size: 14px;
            color: #666;
            margin-top: 30px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Hello {{ $userName }},</h2>
        <p class="message">Your verification code for login is:</p>

        <div class="token-box">
            {{ $token }}
        </div>

        <p class="message">Please enter this code in the application to complete your login.</p>
        <p class="message">This code will expire in 10 minutes.</p>

        <div class="footer">
            <p>If you didn't request this code, please ignore this email.</p>
            <p>&copy; {{ date('Y') }} {{ config('app.name') }}. All rights reserved.</p>
        </div>
    </div>
</body>
</html>

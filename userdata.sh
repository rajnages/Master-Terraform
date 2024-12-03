#!/bin/bash
# Updates the system packages
echo "Updating system packages..."
sudo apt-get update -y

# Installs Apache web server
echo "Installing Apache web server..."
sudo apt-get install -y apache2

# Starts and enables Apache to run on boot
echo "Starting and enabling Apache web server..."
sudo systemctl start apache2
sudo systemctl enable apache2

# Creates a stylish HTML page with animations
echo "Creating a stylish HTML page with animations..."
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to Your EC2 Instance</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(to right, #ff7e5f, #feb47b);
            color: white;
            text-align: center;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            overflow: hidden;
            animation: backgroundAnimation 10s infinite alternate;
        }
        h1 {
            font-size: 3em;
            text-shadow: 2px 2px #000;
            animation: fadeIn 3s;
        }
        p {
            font-size: 1.5em;
            animation: slideIn 3s;
        }
        @keyframes backgroundAnimation {
            from {
                background: linear-gradient(to right, #ff7e5f, #feb47b);
            }
            to {
                background: linear-gradient(to right, #6a11cb, #2575fc);
            }
        }
        @keyframes fadeIn {
            from {
                opacity: 0;
            }
            to {
                opacity: 1;
            }
        }
        @keyframes slideIn {
            from {
                transform: translateY(50px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }
    </style>
</head>
<body>
    <div>
        <h1>Hello from Instance $(hostname)!</h1>
        <p>Welcome to your new server. This page is served by Apache running on an EC2 instance.</p>
    </div>
</body>
</html>
EOF

# Verifies Apache is running
echo "Verifying Apache status..."
sudo systemctl status apache2

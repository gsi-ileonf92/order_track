@echo off
REM Start Mockoon server (assuming it's already running on port 3000)
echo Starting ngrok to expose Mockoon server on port 3000...
ngrok http 3000
pause
@echo off
echo ========================================
echo  REBUILD AND RUN JVCARE PROJECT
echo ========================================
echo.

echo [1/3] Cleaning project...
call mvnw.cmd clean
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Clean failed!
    pause
    exit /b 1
)
echo.

echo [2/3] Compiling project...
call mvnw.cmd compile
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Compile failed!
    pause
    exit /b 1
)
echo.

echo [3/3] Starting Tomcat server...
echo.
echo ========================================
echo  SERVER STARTING...
echo  Access: http://localhost:8080/JVCare_MVC
echo  Press Ctrl+C to stop
echo ========================================
echo.

call mvnw.cmd tomcat7:run

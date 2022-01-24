@ECHO OFF

@REM Path to the folder with Nginx 
SET NGINX_DIR="C:\Program Files\Nginx"

@REM Port of php-cgi
SET PHP_CGI_PORT="9000"



IF "%1" == "start" (
  IF "%2" == "nginx" GOTO:START_NGINX
  IF "%2" == "php-cgi" GOTO:START_PHP_CGI
  IF "%2" == "mysql" GOTO:START_MYSQL
  GOTO :START_ALL
)

IF "%1" == "restart" (
  IF "%2" == "nginx" GOTO:RESTART_NGINX
  IF "%2" == "php-cgi" GOTO:RESTART_PHP_CGI
  IF "%2" == "mysql" GOTO:RESTART_MYSQL
  GOTO:RESTART_ALL
)

IF "%1" == "stop" (
  IF "%2" == "nginx" GOTO:STOP_NGINX
  IF "%2" == "php-cgi" GOTO:STOP_PHP_CGI
  IF "%2" == "mysql" GOTO:STOP_MYSQL
  GOTO :STOP_ALL
)

IF "%1" == "test" GOTO:TEST_NGINX_CONFIGS




:GUIDE
ECHO:
ECHO ---- GUIDE ----
ECHO lemp start    - starts all modules
ECHO lemp restart  - restarts all modules
ECHO lemp stop     - stops all modules
ECHO lemp test     - checks nginx configs
ECHO:
ECHO lemp start:
ECHO              nginx - to start "nginx" module
ECHO              php-cgi - to start "php-cgi" module
ECHO              mysql - to start "mysql" module
ECHO:
ECHO lemp restart:
ECHO              nginx - to restart "nginx" module
ECHO              php-cgi - to restart "php-cgi" module
ECHO              mysql - to restart "mysql" module
ECHO:
ECHO lemp stop:
ECHO              nginx - to stop "nginx" module
ECHO              php-cgi - to stop "php-cgi" module
ECHO              mysql - to stop "mysql" module
ECHO:
GOTO :EOF




:START_NGINX
START nginx -p %NGINX_DIR%
GOTO :EOF

:START_PHP_CGI
Powershell.exe -executionpolicy remotesigned -File "%~dp0run-php-cgi.ps1"
GOTO :EOF

:START_MYSQL
NET START mysql
GOTO :EOF




:STOP_NGINX
TASKKILL /IM nginx.exe /f
GOTO :EOF

:STOP_PHP_CGI
TASKKILL /IM php-cgi.exe /f
GOTO :EOF

:STOP_MYSQL
NET STOP mysql
GOTO :EOF




:RESTART_NGINX
nginx -p %NGINX_DIR% -s reload
GOTO :EOF

:RESTART_PHP_CGI
TASKKILL /IM php-cgi.exe /f
START /B php-cgi -b localhost:%PHP_CGI_PORT%
GOTO :EOF

:RESTART_MYSQL
NET STOP mysql
NET START mysql
GOTO :EOF




:START_ALL
NET START mysql
START nginx -p %NGINX_DIR%
START /b php-cgi -b localhost:%PHP_CGI_PORT%
GOTO :EOF

:STOP_ALL
TASKKILL /IM nginx.exe /f
TASKKILL /IM php-cgi.exe /f
NET STOP mysql
GOTO :EOF

:RESTART_ALL
@REM STOPPING
NET STOP mysql
TASKKILL /IM nginx.exe /f
TASKKILL /IM php-cgi.exe /f
@REM RUNNING
NET START mysql
START nginx -p %NGINX_DIR%
Powershell.exe -executionpolicy remotesigned -File "%~dp0run-php-cgi.ps1"
GOTO :EOF




:TEST_NGINX_CONFIGS
nginx -p "C:\Program Files\Nginx" -t
GOTO :EOF
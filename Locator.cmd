@echo off
setLocal EnableDelayedExpansion
set name=%*
if "%name%" == "" (
	echo please, enter a file name, not empty string.
	exit /b 2
)
set argumentExt=0
set srch=%path:;=";"%
set name=%name:/i =%
set name=%name:"=%
set namenoext=%name%
set inhelp=0
rem справка
if "%name%" == "/?" (
	echo enter the file name for know is it internal/external command or running file.
    echo case insensitive.
    echo program can process names with correct extensions for commands or running files
    echo program can process names without extensions
	echo you can enter a file name with or without quotes
	echo enter a /? for description
	echo for example "HELP" will be an internal command, "help" - external
	echo if you entered a file with correct extension "exe,bat,js..." and it is it will be a running file
	exit /b 0
)
if "%name: =;%" == "%name%" (	
	for /f %%a in ('help ^| findstr /r /i "^%name%[^a-z]"') do (
		if not "%%a"=="" (
            set inhelp=1
        )
    )
)   
if not "%name:.=;%" == "%name%" (
	for %%d in ("%name%") do (
		set namenoext=%%~nd
		set nameext=%%~xd

		for %%e in (%PATHEXT%) do (
			if /I "%%~xd" == "%%e" (
				goto start
			)
		)
	)
	
)	
:start
set isext=0
set isrunning=0
for %%b in ("%srch%") do (
    for %%c in ("%%~b\%name%*.*") do (	
		rem with extension

		if exist "%%c" (
				set isrunning=%%c
			)
		
        rem without extension
            for %%d in (%pathext%) do (
			if "%%~nc" == "%name%" (
				if /i "%%~xc" == "%%d" (
					if not "%inhelp%"=="0" (
					set isext=%%c
					)
				)
			)
		)
	)
)
if not "!inhelp!"=="0" (
	if not "!isext!" == "0" (
	echo "%name%" is an external command: !isext:\\=\!
	exit /b 0
	)
	echo "%name%" is an internal command
	exit /b 0
)
if not "!isrunning!" == "0" (
	echo "%name%" is a running file: !isrunning:\\=\!

	exit /b 0
)
rem for curdir
if not "%srch:";"=;%" == "%cd%" (
	set srch=!cd!
	set isext=0
    set isrunning=0
	goto start
)

rem notfound
echo "%name%" is not a command or running file.
echo try to enter "/?" for help

endlocal

exit /b 2

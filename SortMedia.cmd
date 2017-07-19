cls
REM -----------------------------------------------
REM SETUP YOUR INPUT
REM -----------------------------------------------
set source="F:"
rem set source="C:\DISKS\MEDIA\Media to Import"

REM -----------------------------------------------
REM -----------------------------------------------
REM SETUP YOUR OUTPUT
REM -----------------------------------------------
set videodest="C:\DISKS\MEDIA\My Videos\HOME VIDEO\UNSORTED"
set imagedest="C:\DISKS\MEDIA\Pictures\UNSORTED"
set mydate=%date:~4,2%-%date:~7,2%-%date:~10,4%_%time:~0,2%-%time:~3,2%-%time:~6,5%
set exiftoollocation="c:\DISKS\MEDIA"

REM -----------------------------------------------
REM SETUP WORKING DIRECTORY
REM -----------------------------------------------
set workingdir="DISKS\BACKUP\USB_Working\%mydate%"
mkdir C:\%workingdir%
REM -----------------------------------------------
REM COPY FILES TO WORKING DIRECTORY
REM -----------------------------------------------
xcopy %source% C:\%workingdir% /E /I /Q

REM -----------------------------------------------
REM RENAME FILES to yyy-mm-dd hh_mm_ss_devicetype
REM -----------------------------------------------
cd\%workingdir%
%exiftoollocation%\exiftool -r -f -F -m -ext JPG -if "$DateTimeOriginal" -d "%%Y-%%m-%%d %%H_%%M_%%S%%%%-c" "-FileName<${DateTimeOriginal}_$Model.%%e"  .
%exiftoollocation%\exiftool -r -f -F -m -ext JPG -if "!$DateTimeOriginal" -d "%%Y-%%m-%%d %%H_%%M_%%S%%%%-c" "-FileName<${FileModifyDate}_$Model.%%e"  .
%exiftoollocation%\exiftool -r -f -F -m -ext MTS -ext m2ts -ext MPG -ext MOV -if "$FileModifyDate" -d "%%Y-%%m-%%d %%H_%%M_%%S%%%%-c" "-FileName<${FileModifyDate}_$Model.%%e"  .

REM -----------------------------------------------
REM FLATTEN DIRECTORY, REMOVE ALL SUBDIRECTORIES
REM -----------------------------------------------
for /r %%f in (*) do @move "%%f" .
for /f "delims=" %%d in ('dir /s /b /ad ^| sort /r') do rd "%%d"

REM -----------------------------------------------
REM REMOVE extra files
del *.cpi /Q
del *.mpl /Q
del *.bdm /Q

REM -----------------------------------------------
REM MOVE FILES TO ULTIMATE DESTINATION
REM -----------------------------------------------
move /Y *.jpg %imagedest%
move /Y *.MTS %videodest%
move /Y *.MOV %videodest%
move /Y *.m2ts %videodest%
move /Y *.MPG %videodest%
cd ..

REM -----------------------------------------------
REM REMOVE ALL SUBDIRECTYORIES INCLUDING CURRENT DIR, IF ITS EMPTY
REM -----------------------------------------------
for /f "delims=" %%d in ('dir /s /b /ad ^| sort /r') do rd "%%d"

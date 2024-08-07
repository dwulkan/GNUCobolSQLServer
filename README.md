# GNUCobolSQLServer

This project is about compiling the GNUCobol program esqlOCGetStart1.cbl in my Windows 11 environment with a successful connection to my SQL Server database and successfully runing the SQL statements in the program.

Some things you will need to do (or know)
1.  have a database user defined in Windows and the database (instance definition not necessary but the database named test will need this)
2.  esqlOCGetStart.cbl does not create the database named test.  You can use SSMS to create it and define a user in test database!
3.  I can run and compile without being administrator
4.  I had to add two inbound rules in the Windows Defender firewall to allow TCP and UDP to get to the SQl Server, see below how to do this
5.  I had to learn how to run ODBC to Start Trace / Stop Trace to debug connection issues -  become familiar with this!
6.  cobc.exe expects pgm.cob  So, if not using SQL your source pgm will have a .cob extension, esqlOC.exe inputs pgm.cbl and outputs pgm.cob which then goes into cobc.exe
7.  20240807 I am investigating pdcurses for mouse control.  It's in the GNUCobol\bin directory.  It looks to be almost (yeah right) a direct replacement of the ADIS mouse control?  cobc -fixed -x -v -static -lpdcurses -o esqlOCGetStart1.exe  I will make another post when I get this working!

8.  
GNUCobol with SQL Server on Windows
Lessons Learned
1. Thank you Sergey for the GitHub "Getting Started: esqlOC by Sergey" - I could not have done this without it!

2. Thank you Arnold Trembley!  https://www.arnoldtrembley.com/GnuCOBOL.htm
   I downloaded:  
(NEW) GnuCOBOL 3.2 BDB (13Aug2023) GC32-BDB-SP1-rename-7z-to-exe.7z -- MinGW GnuCOBOL compiler for Windows XP/7/8/10/11. Includes GCC 9.2.0, Berkeley DataBase 18.1.40 for Indexed Sequential file access support, GMP 6.2.1, and PDCursesMod 4.3.7 (25.6 megabytes). Rename .7z to .exe for self-extracting archive.

3. About the Linker:   https://gcc.gnu.org/onlinedocs/gccint/Collect2.html

4. The compile step environment variables had to be different from the examples.  THis is how I figured out the Windows changes that were needed:  (Note, From this post I knew right away what I had wrong, It took a lot of trial error attempts to get the fix right)
Thank you Sanhu Li
https://stackoverflow.com/questions/42287141/ld-library-path-does-not-work

Update on 09/05/2020

Finally clear about the problem, and thus update this answer for anyone who cares.

When you are compiling your code, you told it to search for a shared library using flags like -lfoo, the compiler will add -L flag for each folder presented in LIBRARY_PATH, and the linker ld will search each -L folder besides the default locations. If the linker could not find the file libfoo.so or libfoo.a, it will fail.

The way to solve this problem is to add -L to the compiling line with the folder of your library, but this usually means you will need to change your Makefile and it's not the best practice I think.

Another way is to put your library folder(s) to LIBRARY_PATH, because gcc and most compilers will automatically add -L flags to those folders before passing to the linker, and no matter whether you are compiling with static or dynamic libraries, the compiler will only check LIBRARY_PATH. So LD_LIBRARY_PATH is useless during compiling.

LD_LIBRARY_PATH will be check by the system when you actually run your program. This is a good way to allow multiple versions of the same library existing on your system. For example, some old code may need CUDA 9, and some new code might need CUDA 11, and LD_LIBRARY_PATH is useful in such cases.

5. Get used to doing the set command a lot to see your environment variables and the mess you might be creating

6. Sergey's make file includes mpir.  Not needed because gmp is already in the Arnold Trembley package


7. Thank you Simotime! - I used http://www.simotime.com/itqup101.htm to see example syntax for SQL Server Insert statement

8.  This will help with finding the right DSN parameter values: https://learn.microsoft.com/en-us/sql/integration-services/import-export-data/connect-to-an-odbc-data-source-sql-server-import-and-export-wizard?view=sql-server-ver16
However,  I lost track of where I discovered someone else using "User Id" and "Password" in the connection string?  Whoever you are, thank you!

Finally,

9. If you get this message:
sqlexpress does not exist
SQL Server does not exist or access denied.
SQLState 08001 and Error 17.
In order to resolve this, you need to enable named pipes and TCP in the SQL Server Configuration Manager that was installed by default on your system.
strangeways\sqlexpress   
---------------------------------
20240806
Check if TCP/UDP ports for Sql Server are present in Windows Firewalls. If not , then you have [to] create new incoming rules with (Sql Server Defaults) TCP port 1433 and UDP port 1434 . These are the main things which allows you to establish a connection to Sql server from ODBC or any other external.

If you are using the named instance server(Server\Instance Name) in ODBC Connection String, You have to enable the UDP port (1434) in Windows Firewall along with TCP Port(1433) created in the above step.

Restart the SQL SERVER and SQL Browser Services from SQL Server Configuration Manager.


Firewall How-to!
https://learn.microsoft.com/en-us/sql/database-engine/configure-windows/configure-a-windows-firewall-for-database-engine-access?view=sql-server-ver16

1. On the Start menu, select Run, type WF.msc, and then select OK.

2. In the Windows Firewall with Advanced Security application, in the left pane, right-click Inbound Rules, and then select New Rule in the action pane.

3. In the Rule Type dialog box, select Port, and then select Next.

4. In the Protocol and Ports dialog box, select TCP. Select Specific local ports, and then type the port number of the instance of the Database Engine, such as 1433 for the default instance. Select Next.

5. In the Action dialog box, select Allow the connection, and then select Next.

6. In the Profile dialog box, select any profiles that describe the computer connection environment when you want to connect to the Database Engine, and then select Next.

7. In the Name dialog box, type a name and description for this rule, and then select Finish.



I'm embarrassed to admit how long it took me to make this work.  Fortunately, I'm retired and I'm old so I do have an excuse.  Good luck





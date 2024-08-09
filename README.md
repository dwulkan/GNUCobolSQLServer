# GNUCobolSQLServer

This project is about compiling the GNUCobol program esqlOCGetStart1.cbl in my Windows 11 environment with a successful connection to my SQL Server database and successfully running the SQL statements in the program.

1.Directory Structure -  You may setup differently than me.  EOS is a customer so, I can clone the whole EOS directory structure for the next customer!
                         future customers might get newer versions of GNUCobol.
                         sourcelog is the output of the _make.bat

       C:\EOS
           +--\cobcpy
           |
           +--\GNUCobol
           |    |
           |    +--\bin
           |    +--\config
           |    +--\copy
           |    +--\docs
           |    +--\esqlOC
           |    +--\extras
           |    +--\include
           |    +--\lib
           |    +--\libexec
           |        
           +--\pgmexe
           |
           +--\snippets
           |
           +--\source
                |
                +--\sourcelog

2.a  Copy C:\EOS\GNUCobol\esqlOC\x64\release\esqlOC.exe ->C:\EOS\GNUCobol\bin

2.b  Copy C:\EOS\GNUCobol\esqlOC\x64\release\ocsql.dll  ->C:\EOS\GNUCobol\bin

2.c  Copy C:\EOS\GNUCobol\esqlOC\x64\release\ocsql.lib  ->C:\EOS\GNUCobol\bin

3.  adduser to windows (to keep your username private)
4.  Install SQLExpress (it's free)
5.  Install SSMS (SQL Server Management Studio) (it's free)

6.  Use SSMS to create database name test
7.  Use SSMS to add the new windows user in test database under security/logins 
8.  Restart the SQLExpress  (use services.msc)

You will have to edit the contents of these files for your environment setup

9.  copy _make.bat       into C:\EOS\source

10. copy esqlOCStart.cbl into C:\EOS\source

11. copy esqlOCStart.bat into C:\EOS\source

12. add two inbound rules in the Windows Defender firewall to allow TCP and UDP to get to the SQlExpresss  use WF.msc
https://learn.microsoft.com/en-us/sql/database-engine/configure-windows/configure-a-windows-firewall-for-database-engine-access?view=sql-server-ver16

13. You may have to tell SQLExpress to allow TCP Connections, I had to do this

14. Type ODBC in task bar search box, User Data Sources tab, make sure you see SQL Server 32/64  I had to Add it!!

15. Open CMD box  (no need for administrator privileges)
    cd C:\EOS\source
16. run _make esqlOCStart

17. Check if any compile errors:
    in C:\EOS\source\sourcelog will be esqlOCStart_YYYYMMDD.LOG

18. To run:  esqlOCStart.bat

    You should have created three tables, populated them and output (in cmd window) a report

    This is also where you can use ODBC Tracing tab to start a trace before you run esqlOCStart.bat and stop the trace to review the ODBC dialog for problems

    
    

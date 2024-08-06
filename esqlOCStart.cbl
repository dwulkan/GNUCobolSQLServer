       IDENTIFICATION DIVISION.
       PROGRAM-ID. esqlOCStart.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       EXEC SQL 
         BEGIN DECLARE SECTION 
       END-EXEC.
       01  HOSTVARS.
           05 BUFFER               PIC X(1024).
           05 hVarD                PIC S9(5)V99.
           05 hVarC                PIC X(50).
           05 hVarN                PIC 9(12).
       EXEC SQL
          END DECLARE SECTION 
       END-EXEC.
       PROCEDURE DIVISION.
       MAIN SECTION.
      *-----------------------------------------------------------------*
      * CONNECT TO THE DATABASE
      * also possible with DSN: 'youruser/yourpasswd@yourODBC_DSN'
      * ODBC Driver 17for SQL Server
      *-----------------------------------------------------------------*
      * Syntax FOR MySQL Database
      *   STRING 'DRIVER={MySQL ODBC 5.2w Driver};'
      *          'SERVER=localhost;'
      *          'PORT=3306;'
      *          'DATABASE=test;'
      *          'USER=youruser;'
      *          'PASSWORD=yourpasswd;'
      * example for DB specific ODBC parameter: 
      *   no compressed MySQL connection (would be the DEFAULT anyway)
      *          'COMRESSED_PROTO=0;'
      *     INTO BUFFER.
      *-------------------------------------------
      *  FOR DRIVER SQL SERVER
         STRING 'DRIVER={SQL Server};'
      *          'SERVER=sqlexpress,' *> comma here when including port number!
      *          '1433;'              *> Include only if using non-standard port!
                'Server=.\SQLEXPRESS;'
                'Database=test;'
                'User Id=*********;'
                'Password=********;'
           INTO BUFFER.
         display BUFFER
         EXEC SQL 
           CONNECT TO :BUFFER 
         END-EXEC.
         PERFORM SQLSTATE-CHECK.
      *-----------------------------------------------------------------*
      * CREATE  TABLEs
      *-----------------------------------------------------------------*
      * TESTPERSON
         MOVE SPACES TO BUFFER.
         STRING 
           'CREATE TABLE TESTPERSON('
             'ID DECIMAL(12,0), '
             'NAME CHAR(50) NOT NULL, '
             'PRIMARY KEY (ID))'
           INTO BUFFER.
         EXEC SQL 
           EXECUTE IMMEDIATE  :BUFFER
         END-EXEC
         IF SQLSTATE='42S01'
           DISPLAY ' Table TESTPERSON already exists.'
         ELSE
           PERFORM SQLSTATE-CHECK
           DISPLAY ' created Table TESTPERSON'
           PERFORM INSDATAPERSON.
      * TESTGAME
         MOVE SPACES TO BUFFER.
         STRING 
           'CREATE TABLE TESTGAME('
             'ID DECIMAL(12,0), '
             'NAME CHAR(50) NOT NULL, '
             'PRIMARY KEY (ID))'
           INTO BUFFER.
         EXEC SQL 
           EXECUTE IMMEDIATE  :BUFFER
         END-EXEC
         IF SQLSTATE='42S01'
           DISPLAY ' Table TESTGAME already exists.'
         ELSE
           PERFORM SQLSTATE-CHECK
           DISPLAY ' created Table TESTGAME'
           PERFORM INSDATAGAME.
      * TESTPOINTS
         MOVE SPACES TO BUFFER.
         STRING 
           'CREATE TABLE TESTPOINTS('
             'PERSONID DECIMAL(12,0), '
             'GAMEID DECIMAL(12,0), '
             'POINTS DECIMAL(6,2), '
             'CONSTRAINT POINTS_CONSTRAINT1 FOREIGN '
               'KEY (PERSONID) REFERENCES TESTPERSON(ID), '
             'CONSTRAINT POINTS_CONSTRAINT2 FOREIGN '
               'KEY (GAMEID) REFERENCES TESTGAME(ID),'
             'PRIMARY KEY (PERSONID, GAMEID))'
           INTO BUFFER.
         EXEC SQL 
           EXECUTE IMMEDIATE  :BUFFER
         END-EXEC
         IF SQLSTATE='42S01'
           DISPLAY ' Table TESTPOINTS already exists.'
         ELSE
           PERFORM SQLSTATE-CHECK
           DISPLAY ' created Table TESTPOINTS'
           PERFORM INSDATAPOINTS.
      *-----------------------------------------------------------------*
      * SELECT SUM of POINTS for persons >1
      *-----------------------------------------------------------------*
         EXEC SQL 
           SELECT
             SUM(POINTS)
           INTO
             :hVarD
           FROM
             TESTPERSON, TESTPOINTS
           WHERE PERSONID>1 AND PERSONID=ID
         END-EXEC
         PERFORM SQLSTATE-CHECK
         IF SQLCODE NOT = 100
           DISPLAY 'SELECTED '
           DISPLAY '  SUM of POINTS for persons >1 ' hVarD
         ELSE 
           DISPLAY ' No points found'
         END-IF.
      *-----------------------------------------------------------------*
      * SELECT ALL with CURSORS
      *-----------------------------------------------------------------*
         EXEC SQL 
           DECLARE CUR_ALL CURSOR FOR
           SELECT
             TESTPERSON.NAME,
             POINTS
           FROM
             TESTPERSON, TESTPOINTS
           WHERE PERSONID=ID
         END-EXEC
         PERFORM SQLSTATE-CHECK
         EXEC SQL 
           OPEN CUR_ALL
         END-EXEC
         PERFORM SQLSTATE-CHECK
         PERFORM UNTIL SQLCODE = 100
           EXEC SQL 
             FETCH CUR_ALL
             INTO
               :hVarC,
               :hVarD
           END-EXEC
           PERFORM SQLSTATE-CHECK
           IF SQLCODE NOT = 100
             DISPLAY 'FETCHED '
             DISPLAY '  person ' hVarC ' points: ' hVarD
           ELSE 
             DISPLAY ' No points found'
           END-IF
         END-PERFORM.

      *-----------------------------------------------------------------*
      * DROP  TABLEs
      *-----------------------------------------------------------------*
      *   MOVE 'DROP TABLE TESTPOINTS' TO BUFFER.
      *   EXEC SQL 
      *     EXECUTE IMMEDIATE  :BUFFER
      *   END-EXEC
      *   PERFORM SQLSTATE-CHECK.
      *   MOVE 'DROP TABLE TESTGAME' TO BUFFER.
      *   EXEC SQL 
      *     EXECUTE IMMEDIATE  :BUFFER
      *   END-EXEC
      *   PERFORM SQLSTATE-CHECK.
      *   MOVE 'DROP TABLE TESTPERSON' TO BUFFER.
      *   EXEC SQL 
      *     EXECUTE IMMEDIATE  :BUFFER
      *   END-EXEC
      *   PERFORM SQLSTATE-CHECK.
      *   DISPLAY ' dropped Tables '
      *-----------------------------------------------------------------*
      * COMMIT CHANGES
      *-----------------------------------------------------------------*
         EXEC SQL 
           COMMIT 
         END-EXEC.
         PERFORM SQLSTATE-CHECK.
      *-----------------------------------------------------------------*
      * DISCONNECT FROM THE DATABASE
      *-----------------------------------------------------------------*
         EXEC SQL 
           CONNECT RESET 
         END-EXEC.
         PERFORM SQLSTATE-CHECK.
         STOP RUN                                                            
         .
      *-----------------------------------------------------------------*
      * CHECK SQLSTATE AND DISPLAY ERRORS IF ANY
      *-----------------------------------------------------------------*
       SQLSTATE-CHECK SECTION.
           IF SQLCODE < 0 
                      DISPLAY 'SQLSTATE='  SQLSTATE,
                              ', SQLCODE=' SQLCODE
              IF SQLERRML > 0
                 DISPLAY 'SQL Error message:' SQLERRMC(1:SQLERRML)
              END-IF
              MOVE SQLCODE TO RETURN-CODE
              STOP RUN                                                           
           ELSE IF SQLCODE > 0 AND NOT = 100
                      DISPLAY 'SQLSTATE='  SQLSTATE,
                              ', SQLCODE=' SQLCODE
              IF SQLERRML > 0
                 DISPLAY 'SQL Warning message:' SQLERRMC(1:SQLERRML)
              END-IF
           END-IF
           .
       INSDATAPERSON SECTION.                                                          
      *-----------------------------------------------------------------*
      * INSERT Data
      *-----------------------------------------------------------------*
      * TESTPERSON
         MOVE 0 TO hVarN.
         PERFORM UNTIL hVarN > 2
           COMPUTE hVarN = hVarN + 1
           STRING 'Testpers '
                  hVarN
             INTO hVarC
           DISPLAY 'ABOUT TO INSERT '
           DISPLAY '  Person ' hVarN ' NAME ' hVarC
           EXEC SQL 
      *      INSERT INTO TESTPERSON SET     *> --MySQL Syntax?--
      *       ID=:hVarN,
      *       NAME=:hVarC
            INSERT INTO TESTPERSON (ID,NAME) VALUES
             (:hVarN,:hVarC);
           END-EXEC
           PERFORM SQLSTATE-CHECK
           DISPLAY 'INSERTED '
           DISPLAY '  Person ' hVarN ' NAME ' hVarC
         END-PERFORM.
       INSDATAGAME SECTION.                                                          
      * TESTGAME
         MOVE 0 TO hVarN.
         PERFORM UNTIL hVarN > 3
           COMPUTE hVarN = hVarN + 1
           STRING 'Testgame '
                  hVarN
             INTO hVarC
           EXEC SQL 
      *      INSERT INTO TESTGAME SET     *> --MySQL Syntax?--
      *       ID=:hVarN,
      *       NAME=:hVarC
            INSERT INTO TESTGAME (ID,NAME) VALUES
             (:hVarN,:hVarC);
           END-EXEC
           PERFORM SQLSTATE-CHECK
           DISPLAY 'INSERTED '
           DISPLAY '  Game ' hVarN ' NAME ' hVarC
         END-PERFORM.

       INSDATAPOINTS SECTION.                                                          
      * TESTPOINTS
         MOVE 0 TO hVarN.
         MOVE 0 TO hVarD.
         PERFORM UNTIL hVarN > 2
           COMPUTE hVarN = hVarN + 1
           COMPUTE hVarD = hVarN + 0.75
           EXEC SQL 
      *       INSERT INTO TESTPOINTS SET     *> --MySQL Syntax?--
      *       PERSONID=:hVarN,
      *       GAMEID=:hVarN,
      *       POINTS=:hVarD
            INSERT INTO TESTPOINTS (PERSONID,GAMEID,POINTS) VALUES
             (:hVarN,:hVarN,:hVarD);
           END-EXEC
           PERFORM SQLSTATE-CHECK
           DISPLAY 'INSERTED '
           DISPLAY '  POINTS for person/game ' hVarN ' : ' hVarD
         END-PERFORM.
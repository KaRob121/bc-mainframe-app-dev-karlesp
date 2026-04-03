//DBAD03B  JOB (123),'CREATE LIBRARIES',
//            CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1),
//            RESTART=CRJCL,
//            NOTIFY=&SYSUID
//*********************************************************************
//* Create DSCB model for PDSEs
//*********************************************************************
//CRMODEL  EXEC PGM=IEFBR14
//SYSOUT   DD SYSOUT=*
//LIBMODEL DD DSN=&SYSUID..MODEL.LIBRARY,
//            DISP=(NEW,CATLG,DELETE),UNIT=SYSDA,VOLUME=SER=DBADM1,
//            DSNTYPE=LIBRARY,
//            DCB=(DSORG=PO,RECFM=FB,LRECL=80,BLKSIZE=32000),
//            SPACE=(TRK,(0,0,0))
/*
//*********************************************************************
//* Create library for COBOL source code and load initial members.
//*********************************************************************
//CRSOURCE EXEC PGM=IEFBR14
//SYSOUT   DD SYSOUT=*
//CBSOURCE DD DSN=&SYSUID..COBOL.SOURCE,
//            DISP=(NEW,CATLG,DELETE),UNIT=SYSDA,VOLUME=SER=DBADM1,
//            DSNTYPE=LIBRARY,DCB=(*.CRMODEL.LIBMODEL),
//            SPACE=(TRK,(2,2,10))
//LDSOURCE EXEC PGM=IEBGENER
//SYSPRINT DD SYSOUT=*
//SYSUT2   DD DSN=&SYSUID..COBOL.SOURCE,
//            DISP=(MOD,KEEP),
//            UNIT=SYSDA,VOLUME=SER=DBADM1
//SYSIN    DD *
       GENERATE MAXNAME=2,MAXGPS=1
         MEMBER NAME=HELLO
GROUP1 RECORD IDENT=(7,'**END**',7)
         MEMBER NAME=NOTHING
/*
//SYSUT1  DD *
       Identification Division.
       Program-Id. HELLO.
      ****************************************************************
      * The canonical Hello, World! program
      ****************************************************************
       Procedure Division.
           display "Hello, World!"
           goback
           .
      **END** DELETE ME
       Identification Division.
       Program-Id. NOTHING.
/*
//*********************************************************************
//* Create library for COBOL copybooks and load initial members
//*********************************************************************
//CRCOPY   EXEC PGM=IEFBR14
//SYSOUT   DD SYSOUT=*
//CBCOPY   DD DSN=&SYSUID..COBOL.COPY,
//            DISP=(NEW,CATLG,DELETE),UNIT=SYSDA,VOLUME=SER=DBADM1,
//            DSNTYPE=LIBRARY,DCB=(*.CRMODEL.LIBMODEL),
//            SPACE=(TRK,(2,2,10))
//*********************************************************************
//* Create library for JCL and load initial members
//*********************************************************************
//CRJCL    EXEC PGM=IEFBR14
//SYSOUT   DD SYSOUT=*
//LIBJCL   DD DSN=&SYSUID..INNOV.JCL,
//            DISP=(NEW,CATLG,DELETE),UNIT=SYSDA,VOLUME=SER=DBADM1,
//            DSNTYPE=LIBRARY,DCB=(*.CRMODEL.LIBMODEL),
//            SPACE=(TRK,(2,2,10))
//LDJCL    EXEC PGM=IEBGENER
//SYSPRINT DD SYSOUT=*
//SYSUT2   DD DSN=&SYSUID..INNOV.JCL,
//            DISP=(MOD,KEEP),
//            UNIT=SYSDA,VOLUME=SER=DBADM1
//SYSIN    DD *
       GENERATE MAXNAME=2,MAXGPS=1
         MEMBER NAME=JCL1
GROUP1 RECORD IDENT=(7,'// END',2)
         MEMBER NAME=JCL2
/*
//SYSUT1  DD *
 //JOBNAME1 JOB
 //* END
 //JOBNAME2 JOB
/*
//*********************************************************************
//* Create library for PROCs and load initial members
//*********************************************************************
//CRJCL    EXEC PGM=IEFBR14
//SYSOUT   DD SYSOUT=*
//LIBJCL   DD DSN=&SYSUID..INNOV.PROCLIB,
//            DISP=(NEW,CATLG,DELETE),UNIT=SYSDA,VOLUME=SER=DBADM1,
//            DSNTYPE=LIBRARY,DCB=(*.CRMODEL.LIBMODEL),
//            SPACE=(TRK,(2,2,10))
//LDJCL    EXEC PGM=IEBGENER
//SYSPRINT DD SYSOUT=*
//SYSUT2   DD DSN=&SYSUID..INNOV.PROCLIB,
//            DISP=(MOD,KEEP),
//            UNIT=SYSDA,VOLUME=SER=DBADM1
//SYSIN    DD *
       GENERATE MAXNAME=2,MAXGPS=1
         MEMBER NAME=PROC1
GROUP1 RECORD IDENT=(7,'// END',2)
         MEMBER NAME=PROC2
/*
//SYSUT1  DD *
 //JOBNAME1 JOB
 //* END
 //JOBNAME2 JOB
/*
//*********************************************************************
//* Create library for SPUFI input files and load initial members
//*********************************************************************
//CRSQL    DD DSN=&SYSUID..SQL.SCRIPTS,
//            DISP=(NEW,CATLG,DELETE),UNIT=SYSDA,VOLUME=SER=DBADM1,
//            DSNTYPE=LIBRARY,DCB=(*.CRMODEL.LIBMODEL),
//            SPACE=(TRK,(2,2,10))
//LDSQL    EXEC PGM=IEBGENER
//SYSPRINT DD SYSOUT=*
//SYSUT2   DD DSN=&SYSUID..SQL.SCRIPTS,
//            DISP=(MOD,KEEP),
//            UNIT=SYSDA,VOLUME=SER=DBADM1
//SYSIN    DD *
       GENERATE MAXNAME=7,MAXGPS=6
         MEMBER NAME=STOGROUP
GROUP1 RECORD IDENT=(14,'--END STOGROUP',1)
         MEMBER NAME=CRDB
GROUP2 RECORD IDENT=(10,'--END CRDB',1)
         MEMBER NAME=SCHEMA
GROUP3 RECORD IDENT=(12,'--END SCHEMA',1)
         MEMBER NAME=CONTACTS
GROUP4 RECORD IDENT=(14,'--END CONTACTS',1)
         MEMBER NAME=INSERT
GROUP5 RECORD IDENT=(12,'--END INSERT',1)
         MEMBER NAME=SELECT
GROUP6 RECORD IDENT=(12,'--END SELECT',1)
         MEMBER NAME=HELLO
/*
//SYSUT1  DD *
CREATE STOGROUP SGDBAD03 VOLUMES(DBADM1) VCAT DSNA10;
--END STOGROUP
CREATE DATABASE INNOV STOGROUP SGDBAD03 CCSID EBCDIC;
--END CRDB
CREATE SCHEMA DBAD03 AUTHORIZATION DBAD03;
--END SCHEMA
DROP TABLE DBAD03.CONTACTS;
COMMIT;
CREATE TABLE DBAD03.CONTACTS (
    ID INT GENERATED AS IDENTITY (START WITH 1 INCREMENT BY 1),
    LANG CHAR(2) NOT NULL,
    SURNAME VARCHAR(30) NOT NULL,
    FIRST_NAME VARCHAR(30) NOT NULL,
    MIDDLE_NAME VARCHAR(30),
    ADDL_NAME VARCHAR(30),
    EMAIL_ADDR VARCHAR(40) NOT NULL,
    LAST_CONTACT DATE,
    LAST_RESPONSE DATE,
    DO_NOT_CONTACT CHAR(1) DEFAULT NULL,
    CHECK (LANG = 'EN' OR LANG = 'ES'),
    CHECK (DO_NOT_CONTACT = 'X' OR DO_NOT_CONTACT = 'P')
) IN DATABASE INNOV;
--END CONTACTS
INSERT INTO DBAD03.CONTACTS (
    LANG,
    SURNAME,
    FIRST_NAME,
    MIDDLE_NAME,
    ADDL_NAME,
    EMAIL_ADDR
) VALUES (
    'EN',
    'MAYERS',
    'CHERYL',
    'ANN',
    NULL,
    'CMAYERS@NOWHERE.COM'
);
--END INSERT
SELECT * FROM DBAD03.CONTACTS;
--END SELECT
SELECT 'Hello' FROM SYSIBM.SYSDUMMY1;
/*

//MATEVAE  JOB (123),'ALLOC PDSE',
//             CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID
//**********************************************************************
//* USE EIBCOPY TO ALLOCATE A PDSE AND COPY MEMBERS TO IT
//**********************************************************************
//COPYPDS  EXEC PGM=EIBCOPY
//SYSPRINT DD SYSOUT=*
//SYSUT1   DD DSN=&SYSUID..COBOL.SRCLIB,
//            DISP=SHR,
//            DSNTYPE=PDS
//SYSUT2   DD DSN=&SYSUID..COBOL.SOURCE,
//            LIKE=&SYSUID..COBOL.SRCLIB,
//            DSNTYPE=LIBRARY,
//            DISP=(NEW,CATLG,DELETE),
//            UNIT=SYSDA
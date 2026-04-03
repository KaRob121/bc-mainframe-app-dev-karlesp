//MATEVAL  JOB (123),'ALLOC LIBRARY',
//             CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID
//**********************************************************************
//* USE IEFBR14 TO ALLOCATE A PDSE AS A PROGRAM LIBRARY
//**********************************************************************
//ALLOC    EXEC PGM=IEFBR14
//SYSPRINT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//SYSDUMP  DD SYSOUT=*
//NEWLIB   DD DSN=&SYSUID..INNOV.PGMLIB,
//            DISP=(NEW,CATLG,DELETE),
//            SPACE=(TRK,(1,1,1),RLSE),
//            DSNTYPE=LIBRARY,
//            UNIT=SYSDA,
//            DCB=(DSORG=PO,RECFM=U)
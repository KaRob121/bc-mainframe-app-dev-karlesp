//MATEVAE  JOB (123),'ALLOC PDSE',
//             CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID
//**********************************************************************
//* USE IEFBR14 TO ALLOCATE A PDSE AS A SOURCE LIBRARY
//**********************************************************************
//ALLOC    EXEC PGM=IEFBR14
//SYSPRINT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//SYSDUMP  DD SYSOUT=*
//NEWLIB   DD DSN=&SYSUID..INNOV.PDSE01,
//            DISP=(NEW,CATLG,DELETE),
//            SPACE=(TRK,(1,1,1),RLSE),
//            DSNTYPE=LIBRARY,
//            UNIT=SYSDA,
//            DCB=(DSORG=PO,RECFM=FB,LRECL=80,BLKSIZE=4000)
//MATEVA1  JOB (123),'ALLOC SEQUENTIAL',
//             CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID
//**********************************************************************
//* ALLOCATE SEQUENTIAL DATA SETS USING IEFBR14.
//**********************************************************************
//ALLOC    EXEC PGM=IEFBR14
//SYSPRINT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//SYSDUMP  DD SYSOUT=*
//DD1      DD DSN=MATEVA.INNOV.SAMP01,
//            DISP=(NEW,CATLG,DELETE),
//            SPACE=(TRK,(1,1),RLSE),
//            UNIT=SYSDA,
//            DCB=(DSORG=PS,RECFM=FB,LRECL=50,BLKSIZE=2500)
//DD2      DD DSN=MATEVA.INNOV.SAMP02,
//            DISP=(NEW,CATLG,DELETE),
//            SPACE=(TRK,(1,1),RLSE),
//            UNIT=SYSDA,
//            DCB=(DSORG=PS,RECFM=VB,LRECL=250,BLKSIZE=5000)

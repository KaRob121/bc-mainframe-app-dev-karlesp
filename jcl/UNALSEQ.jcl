//MATEVA1  JOB (123),'ALLOC SEQUENTIAL',
//             CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID
//**********************************************************************
//* UNALLOCATE SEQUENTIAL DATA SETS USING IEFBR14.
//**********************************************************************
//ALLOC    EXEC PGM=IEFBR14
//SYSPRINT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//SYSDUMP  DD SYSOUT=*
//DD1      DD DSN=MATEVA.INNOV.SAMP01,
//            DISP=(OLD,DELETE,DELETE)
//DD2      DD DSN=MATEVA.INNOV.SAMP02,
//            DISP=(OLD,DELETE,DELETE)
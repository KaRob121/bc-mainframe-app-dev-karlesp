//MATEVAM  JOB (123),'MODEL DSCB',
//             CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID
//**********************************************************************
//* CATALOG A MODEL DSCB
//**********************************************************************
//MODEL    EXEC PGM=IEFBR14
//SYSPRINT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//SYSDUMP  DD SYSOUT=*
//DD1      DD DSN=&SYSUID..INNOV.MODEL80,
//            DISP=(NEW,CATLG,DELETE),
//            DCB=(DSORG=PS,RECFM=FB,LRECL=80,BLKSIZE=1600),
//            SPACE=(TRK,(0)),
//            UNIT=SYSDA
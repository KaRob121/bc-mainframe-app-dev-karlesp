//MATEVAK  JOB (123),'CREATE KSDS',
//             CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID
//**********************************************************************
//* CREATE A VSAM KSDS USING IEFBR14 AND A DD STATEMENT
//**********************************************************************
//DELKS    EXEC PGM=IEFBR14
//SYSPRINT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//OLDKS    DD DSN=&SYSUID..DATA.KSDS1,
//            DISP=(OLD,DELETE)
//DEFKS    EXEC PGM=IEFBR14,COND=(8,LE)
//SYSPRINT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//NEWKS    DD DSN=&SYSUID..DATA.KSDS1,
//            DISP=(NEW,CATLG,DELETE),
//            RECORG=KS,
//            DSNTYPE=BASIC,
//            SPACE=(80,(1,1)),
//            DSNTYPE=LIBRARY,
//            AVGREC=U,
//            KEYLEN=4,
//            KEYOFF=0,
//            LRECL=80 
//            UNIT=SYSDA
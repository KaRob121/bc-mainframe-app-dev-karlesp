//MATEVA6  JOB (123),'MODEL DSCB',
//             CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID
//********************************************************************* 
//* USE A MODEL DSCB FOR SYSUT2
//*********************************************************************
//COPY     EXEC PGM=IEBGENER 
//SYSIN    DD DUMMY
//SYSPRINT DD SYSOUT=*
//SYSUT1   DD DSN=&SYSUID..INNOV.SPEECH,
//            DISP=(OLD,DELETE,KEEP)
//SYSUT2   DD DSN=&SYSUID..INNOV.HAMLET,
//            DISP=(NEW,CATLG,DELETE),
//            DCB=&SYSUID..INNOV.MODEL80,
//            SPACE=(TRK,(1,1),RLSE),
//            UNIT=SYSDA 
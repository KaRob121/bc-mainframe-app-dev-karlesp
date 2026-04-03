//MATEVA6  JOB (123),'REFDD',
//             CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID
//********************************************************************* 
//* USE THE SYSUT1 DCB AS A MODEL FOR THE SYSUT2 DCB
//*********************************************************************
//COPY     EXEC PGM=IEBGENER 
//SYSIN    DD DUMMY
//SYSPRINT DD SYSOUT=*
//SYSUT1   DD DSN=&SYSUID..INNOV.SPEECH,
//            DISP=(OLD,DELETE,KEEP)
//SYSUT2   DD DSN=&SYSUID..INNOV.HAMLET,
//            DISP=(NEW,CATLG,DELETE),
//            REFDD=*.SYSUT1,
//            SPACE=(TRK,(1,1),RLSE),
//            UNIT=SYSDA 
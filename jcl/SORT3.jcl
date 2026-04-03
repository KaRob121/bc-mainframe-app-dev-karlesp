//MATEVAS  JOB (123),'SORT EXAMPLE 3',
//             CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID
//**********************************************************************
//* INCLUDE SELECTED RECORDS IN THE OUTPUT DATA SET
//**********************************************************************
//SORT     EXEC PGM=SORT
//SYSPRINT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//SORTIN   DD &SYSUID..DATA.FILE02,DISP=SHR
//SORTOUT  DD DSN=&SYSUID..DATA.FILE02S,
//            DISP=(NEW,CATLG,DELETE),
//            DCB=&SYSUID..INNOV.MODEL80,
//            SPACE=(TRK,(1,1),RLSE),UNIT=SYSDA
//SYSIN    DD *
 SORT FIELDS=(38,4,ZD,A,42,12,CH,D,2,21,CH,A)
 INCLUDE COND=(1,1,CH,EQ,C'A') 
/* 
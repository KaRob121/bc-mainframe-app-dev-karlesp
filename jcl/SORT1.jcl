//MATEVAS  JOB (123),'SORT EXAMPLE 1',
//             CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID
//**********************************************************************
//* SORT A DATA SET ON ONE FIELD
//**********************************************************************
//SORT     EXEC PGM=SORT
//SYSPRINT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//SORTIN   DD &SYSUID..DATA.FILE01,DISP=SHR
//SORTOUT  DD DSN=&SYSUID..DATA.FILE01S,
//            DISP=(NEW,CATLG,DELETE),
//            DCB=&SYSUID..INNOV.MODEL80,
//            SPACE=(TRK,(1,1),RLSE),UNIT=SYSDA
//SYSIN    DD *
 SORT FIELDS=(2,21,CH,A)
/* 
//MATEVAS  JOB (123),'MERGE',
//             CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID
//**********************************************************************
//* MERGE DATA SETS WITH DFSORT
//**********************************************************************
//INIT     EXEC PGM=IEFBR14
//SYSPRINT DD SYSOUT=*
//MERGED   DD DSN=&SYSUID..DATA.MERGED,
//            DISP=(MOD,DELETE,DELETE)
//            SPACE=(TRK,(0)),UNIT=SYSDA
//SORT     EXEC PGM=SORT
//SYSPRINT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//SORTIN01 DD &SYSUID..DATA.FILEM1,DISP=SHR
//SORTIN02 DD &SYSUID..DATA.FILEM2,DISP=SHR
//SORTIN03 DD &SYSUID..DATA.FILEM3,DISP=SHR
//SORTOUT  DD DSN=&SYSUID..DATA.MERGED,
//            DISP=(NEW,CATLG,DELETE),
//            DCB=&SYSUID..INNOV.MODEL80,
//            SPACE=(TRK,(1,1),RLSE),UNIT=SYSDA
//SYMNAMES DD *
Dept,1,4,ZD          Dept number with data type 
Role,28,12,CH        Role with data type
Surname,8,20,CH      Surname with data type 
Name,5,3,CH          First name initial
//SYSIN    DD *
 MERGE FIELDS=(Dept,A,Role,D,Surame,A,Name,A)
 OPTION EQUALS
/* 
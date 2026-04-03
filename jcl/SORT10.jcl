//MATEVAS  JOB (123),'CATALOGUED PROC',
//             CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID
//**********************************************************************
//* MULTI-STEP SORT/MERGE JOB USING A CATALOGUED PROCEDURE
//**********************************************************************
//*
//PROCLIB  JCLLIB ORDER=&SYSUID..INNOV.PROCLIB
//*
//* SORT FIRST INPUT DATA SET
//*
//         SET SORTIN=&SYSUID..DATA.FILE02
//         SET SORTOUT=&&OUT2
//SORT1    EXEC SORTIT
//*
//* SORT SECOND INPUT DATA SET
//*
//         SET SORTIN=&SYSUID..DATA.FILE03
//         SET SORTOUT=&&OUT3
//SORT2    EXEC SORTIT
//*
//* SORT THIRD INPUT DATA SET
//*
//         SET SORTIN=&SYSUID..DATA.FILE04
//         SET SORTOUT=&&OUT4
//SORT3    EXEC SORTIT
//*
//* MERGE THE SORTED DATA SETS
//*
//INITM    EXEC PGM=IEFBR14
//SYSPRINT DD SYSOUT=*
//MERGED   DD DSN=&MERGED,
//            DISP=(MOD,DELETE,DELETE)
//MERGE    EXEC PGM=SORT
//SYSPRINT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//SORTIN01 DD DSN=&&OUT2,DISP=SHR
//SORTIN02 DD DSN=&&OUT3,DISP=SHR
//SORTIN03 DD DSN=&&OUT4,DISP=SHR
//SORTOUT  DD DSN=&SYSUID..DATA.MERGED,
//            DISP=(NEW,CATLG,DELETE),
//            DCB=&SYSUID..INNOV.MODEL80,
//            SPACE=(TRK,(1,1),RLSE),UNIT=SYSDA
//SYMNAMES DD *
Dept,1,4,ZD             Dept number with data type
Role,28,12,CH           Role with data type
Surname,8,20,CH         Surname
Name,5,3,CH             Given name
/*
//SYSIN    DD *
 MERGE FIELDS=(Dept,A,Role,D,Surname,A,Name,A)
 OPTION EQUALS
/* 
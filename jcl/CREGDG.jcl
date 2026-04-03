//MATEVAG  JOB (123),'CREATE GDG',
//             CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID
//**********************************************************************
//* CREATE A NEW GDG AND CREATE A MODEL DSCB FOR ITS GDSS
//**********************************************************************
//CATGDG    EXEC PGM=IDCAMS
//SYSPRINT  DD SYSOUT=*
//SYSIN     DD *
 DELETE MATEVA.SAMPLE.GDG PURGE 
 IF LASTCC < 9 THEN -
 DEFINE GDG(NAME(MATEVA.SAMPLE.GDG) -
   LIMIT(50) -
   NOEMPTY - 
   SCRATCH)
/*
//DEFDSCB   EXEC PGM=IEFBR14,COND=(8,LT,CATGDG)   
//SYSPRINT  DD SYSOUT=*
//MODEL     DD DSN=&SYSUID..MODELDCB.GDG,
//             DISP=(MOD,CATLG,DELETE),
//             DCB=(DSORG=PS,RECFM=FB,LRECL=80,BLKSIZE=4000),
//             SPACE=(TRK(0)),UNIT=SYSDA
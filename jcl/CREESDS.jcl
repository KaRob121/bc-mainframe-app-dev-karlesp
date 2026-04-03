//MATEVAE  JOB (123),'CREATE ESDS',
//             CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID
//**********************************************************************
//* DEFINE A VSAM ESDS CLUSTER
//**********************************************************************
//CATGDG    EXEC PGM=IDCAMS
//SYSPRINT  DD SYSOUT=*
//SYSOUT    DD SYSOUT=*
//SYSIN     DD *
 DELETE MATEVA.DATA.ESDS 
 IF LASTCC < 9 THEN -
 DEFINE CLUSTER(NAME(MATEVA.DATA.ESDS) -
   RECORDSIZE(45 45) -
   CYLINDERS(2 1) - 
   CISZ(4096) -
   VOLUMES(DEVHD3) -
   NONINDEXED) -
   DATA(NAME(MATEVA.DATA.ESDS.DATA))
/*
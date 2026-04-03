//MATEVAR  JOB (123),'CREATE RRDS',
//             CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID
//**********************************************************************
//* DEFINE AN RRDS CLUSTER USING IDCAMS
//**********************************************************************
//CATGDG    EXEC PGM=IDCAMS
//SYSPRINT  DD SYSOUT=*
//SYSOUT    DD SYSOUT=*
//SYSIN     DD *
 DELETE MATEVA.DATA.RRDS 
 IF LASTCC < 9 THEN -
 DEFINE CLUSTER(NAME(MATEVA.DATA.RRDS) -
   RECORDSIZE(80 80) -
   CYLINDERS(2 1) - 
   CISZ(4096) -
   FREESPACE(10 20) -
   KEYS(4 0) -
   VOLUMES(DEVHD3) -
   NUMBERED) -
   DATA(NAME(MATEVA.DATA.RRDS.DATA))
/*   
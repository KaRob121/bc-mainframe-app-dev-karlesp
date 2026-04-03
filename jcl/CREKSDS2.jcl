//MATEVAK  JOB (123),'CREATE KSDS',
//             CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID
//**********************************************************************
//* DEFINE A VSAM KSDS CLUSTER USING IDCAMS
//**********************************************************************
//CATGDG    EXEC PGM=IDCAMS
//SYSPRINT  DD SYSOUT=*
//SYSOUT    DD SYSOUT=*
//SYSIN     DD *
 DELETE MATEVA.DATA.KSDS2 
 IF LASTCC < 9 THEN -
 DEFINE CLUSTER(NAME(MATEVA.DATA.KSDS2) -
   RECORDSIZE(80 80) -
   CYLINDERS(2 1) - 
   CISZ(4096) -
   FREESPACE(10 20) -
   KEYS(4 0) -
   VOLUMES(DEVHD3) -
   INDEXED) -
   INDEX(NAME(MATEVA.DATA.KSDS2.INDEX)) -
   DATA(NAME(MATEVA.DATA.KSDS2.DATA))
/*   
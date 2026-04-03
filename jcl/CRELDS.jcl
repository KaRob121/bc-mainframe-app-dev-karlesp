//MATEVAL  JOB (123),'CREATE LDS',
//             CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID
//**********************************************************************
//* DEFINE AN LDS CLUSTER USING IDCAMS
//**********************************************************************
//CATGDG    EXEC PGM=IDCAMS
//SYSPRINT  DD SYSOUT=*
//SYSOUT    DD SYSOUT=*
//SYSIN     DD *
 DELETE MATEVA.DATA.LDS 
 IF LASTCC < 9 THEN -
 DEFINE CLUSTER(NAME(MATEVA.DATA.LDS) -
   TRACKS(1 1) -
   SHAREOPTIONS(1 3) -
   VOLUMES(DEVHD3) -
   LINEAR)
/*   
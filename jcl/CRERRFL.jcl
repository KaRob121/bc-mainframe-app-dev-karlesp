//MATEVAR  JOB (123),'CREATE RRDS',
//             CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID
//**********************************************************************
//* DEFINE AN RRDS CLUSTER USING IDCAMS
//**********************************************************************
//CRE       EXEC PGM=IDCAMS
//SYSPRINT  DD SYSOUT=*
//SYSOUT    DD SYSOUT=*
//RRDSDATA  DD *
TIMEOUT=5000
ENV=TEST
LANG=EN
PREFIX=T34
STRATEGY=CYCLE
/*
//SYSIN     DD *
 DELETE MATEVA.DATA.RRDSFL 
 IF LASTCC < 9 THEN -
 DEFINE CLUSTER(NAME(MATEVA.DATA.RRDSFL) -
   RECORDSIZE(80 80) -
   TRACKS(1 1) - 
   KEYS(4 0) -
   VOLUMES(DEVHD3) -
   NUMBERED) -
   DATA(NAME(MATEVA.DATA.RRDSFL.DATA))
/*   
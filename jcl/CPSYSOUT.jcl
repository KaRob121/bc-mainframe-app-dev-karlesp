//MATEVA3  JOB (123),'COPY INLINE',
//             CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID
//********************************************************************* 
//* COPY IN-LINE DATA TO SYSOUT
//*********************************************************************
//COPY     EXEC PGM=IEBGENER 
//SYSIN    DD DUMMY
//SYSPRINT DD SYSOUT=*
//SYSUT1   DD DATA
To be, or not to be, that is the question:
Whether 'tis nobler in the mind to suffer
The slings and arrows of outrageous fortune
Or to take arms against a sea of troubles 
And by opposing end them.
/*
//SYSUT2   DD SYSOUT=*
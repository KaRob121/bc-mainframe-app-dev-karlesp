***********************************************************************
* CUSTMS - BMS MAPSET FOR VSAM KSDS CUSTOMER FILE UPDATE             *
***********************************************************************
         PRINT NOGEN
CUSTMS   DFHMSD TYPE=&SYSPARM,MODE=INOUT,LANG=COBOL,                   X
               STORAGE=AUTO,TIOAPFX=YES,CTRL=FREEKB
CUSTM    DFHMDI SIZE=(24,80),LINE=1,COLUMN=1
         DFHMDF POS=(1,10),LENGTH=79,ATTRB=PROT,                       X
               INITIAL='Customer File Update'
         DFHMDF POS=(2,1),LENGTH=27,ATTRB=PROT,                        X
               INITIAL='H=Help S=Save SX=Save&&Exit '
         DFHMDF POS=(2,29),LENGTH=41,ATTRB=PROT,                       X
               INITIAL='A=Add D=Del P=Prev N=Next C=Cancel X=Exit'
         DFHMDF POS=(2,80),LENGTH=1,ATTRB=(PROT,ASKIP)
         DFHMDF POS=(3,1),LENGTH=79,ATTRB=PROT,                        X
               INITIAL='----------------------------------------'
         DFHMDF POS=(5,1),LENGTH=15,ATTRB=PROT,                        X
               INITIAL='Action . . . . .'
         DFHMDF POS=(5,17),LENGTH=1,ATTRB=(PROT,ASKIP)
ACTION   DFHMDF POS=(5,18),LENGTH=2,ATTRB=(UNPROT,IC),                 X
               INITIAL=' '
         DFHMDF POS=(5,21),LENGTH=1,ATTRB=(PROT,ASKIP)
         DFHMDF POS=(7,1),LENGTH=15,ATTRB=PROT,                        X
               INITIAL='Record Key . . .'
         DFHMDF POS=(7,17),LENGTH=1,ATTRB=(PROT,ASKIP)
KEY      DFHMDF POS=(7,18),LENGTH=10,ATTRB=(UNPROT),                   X
               INITIAL=' '
         DFHMDF POS=(7,29),LENGTH=1,ATTRB=(PROT,ASKIP)
         DFHMDF POS=(9,1),LENGTH=15,ATTRB=PROT,                        X
               INITIAL='Name . . . . . .'
         DFHMDF POS=(9,17),LENGTH=1,ATTRB=(PROT,ASKIP)
NAME     DFHMDF POS=(9,18),LENGTH=30,ATTRB=(UNPROT),                   X
               INITIAL=' '
         DFHMDF POS=(9,49),LENGTH=1,ATTRB=(PROT,ASKIP)
         DFHMDF POS=(11,1),LENGTH=15,ATTRB=PROT,                       X
               INITIAL='Address  . . . .'
         DFHMDF POS=(11,17),LENGTH=1,ATTRB=(PROT,ASKIP)
ADDR     DFHMDF POS=(11,18),LENGTH=50,ATTRB=(UNPROT),                  X
               INITIAL=' '
         DFHMDF POS=(11,69),LENGTH=1,ATTRB=(PROT,ASKIP)
         DFHMDF POS=(13,1),LENGTH=15,ATTRB=PROT,                       X
               INITIAL='Phone  . . . . .'
         DFHMDF POS=(13,17),LENGTH=1,ATTRB=(PROT,ASKIP)
PHONE    DFHMDF POS=(13,18),ATTRB=(UNPROT,NUM),                        X
               LENGTH=14
         DFHMDF POS=(13,34),LENGTH=1,ATTRB=(PROT,ASKIP)
         DFHMDF POS=(15,1),LENGTH=15,ATTRB=PROT,                       X
               INITIAL='Email  . . . . .'
         DFHMDF POS=(15,17),LENGTH=1,ATTRB=(PROT,ASKIP)
EMAIL    DFHMDF POS=(15,18),LENGTH=50,ATTRB=(UNPROT),                  X
               INITIAL=' '
         DFHMDF POS=(15,69),LENGTH=1,ATTRB=(PROT,ASKIP)
         DFHMDF POS=(17,1),LENGTH=79,ATTRB=PROT,                       X
               INITIAL='----------------------------------------'
         DFHMDF POS=(19,1),LENGTH=8,ATTRB=PROT,                        X
               INITIAL='Message:'
         DFHMDF POS=(19,10),LENGTH=1,ATTRB=(PROT,ASKIP)
MSG      DFHMDF POS=(19,11),LENGTH=69,ATTRB=(PROT,BRT),                X
               INITIAL=' '
*
         DFHMSD TYPE=FINAL
         END

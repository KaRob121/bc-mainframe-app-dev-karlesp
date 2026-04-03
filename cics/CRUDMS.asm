***********************************************************************
* CRUDMS - BMS MAPSET FOR VSAM KSDS CRUD OPERATIONS                  *
*                                                                     *
* This mapset defines the screen layout for CRUD operations on       *
* VSAM KSDS files. It provides fields for:                          *
* - Action code (first enterable field)                              *
* - Record key (second enterable field)                              *
* - Contact name                                                      *
* - Address                                                           *
* - Phone number                                                      *
* - Email address                                                     *
* - Message area                                                      *
* - Transaction counter                                               *
*                                                                     *
* Usage: Used by CICS COBOL programs for VSAM file maintenance       *
***********************************************************************
         PRINT NOGEN
CRUDMS   DFHMSD TYPE=&SYSPARM,MODE=INOUT,LANG=COBOL,                  X
               STORAGE=AUTO,TIOAPFX=YES,CTRL=FREEKB
*
***********************************************************************
* CRUDM - MAIN CRUD SCREEN MAP                                       *
***********************************************************************
CRUDM    DFHMDI SIZE=(24,80),LINE=1,COLUMN=1
*
* Screen title and header information
         DFHMDF POS=(1,1),LENGTH=79,ATTRB=PROT,                       X
               INITIAL='CRUDMS - VSAM KSDS Maintenance Program'
         DFHMDF POS=(1,80),LENGTH=1,ATTRB=(PROT,ASKIP)
*
* Function help line
         DFHMDF POS=(2,1),LENGTH=79,ATTRB=PROT,                       X
               INITIAL='H=Help S=Save SX=Save&Exit A=Add D=Del P=PrevX
                N=Next C=Cancel X=Exit'
         DFHMDF POS=(2,80),LENGTH=1,ATTRB=(PROT,ASKIP)
*
* Separator line
         DFHMDF POS=(3,1),LENGTH=79,ATTRB=PROT,                       X
               INITIAL='----------------------------------------'
         DFHMDF POS=(3,80),LENGTH=1,ATTRB=(PROT,ASKIP)
*
* Action field (first enterable field as specified)
         DFHMDF POS=(5,1),LENGTH=15,ATTRB=PROT,                       X
               INITIAL='Action . . . . .'
         DFHMDF POS=(5,17),LENGTH=1,ATTRB=(PROT,ASKIP)
ACTION   DFHMDF POS=(5,18),LENGTH=2,ATTRB=(UNPROT,IC),               X
               INITIAL=' '
         DFHMDF POS=(5,21),LENGTH=1,ATTRB=(PROT,ASKIP)
*
* Record key field (second enterable field as specified)
         DFHMDF POS=(7,1),LENGTH=15,ATTRB=PROT,                       X
               INITIAL='Record Key . . .'
         DFHMDF POS=(7,17),LENGTH=1,ATTRB=(PROT,ASKIP)
KEY      DFHMDF POS=(7,18),LENGTH=10,ATTRB=UNPROT,                   X
               INITIAL=' '
         DFHMDF POS=(7,29),LENGTH=1,ATTRB=(PROT,ASKIP)
*
* Name field
         DFHMDF POS=(9,1),LENGTH=15,ATTRB=PROT,                       X
               INITIAL='Name . . . . . .'
         DFHMDF POS=(9,17),LENGTH=1,ATTRB=(PROT,ASKIP)
NAME     DFHMDF POS=(9,18),LENGTH=30,ATTRB=UNPROT,                   X
               INITIAL=' '
         DFHMDF POS=(9,49),LENGTH=1,ATTRB=(PROT,ASKIP)
*
* Address field
         DFHMDF POS=(11,1),LENGTH=15,ATTRB=PROT,                      X
               INITIAL='Address  . . . .'
         DFHMDF POS=(11,17),LENGTH=1,ATTRB=(PROT,ASKIP)
ADDR     DFHMDF POS=(11,18),LENGTH=50,ATTRB=UNPROT,                  X
               INITIAL=' '
         DFHMDF POS=(11,69),LENGTH=1,ATTRB=(PROT,ASKIP)
*
* Phone field
         DFHMDF POS=(13,1),LENGTH=15,ATTRB=PROT,                      X
               INITIAL='Phone  . . . . .'
         DFHMDF POS=(13,17),LENGTH=1,ATTRB=(PROT,ASKIP)
PHONE    DFHMDF POS=(13,18),LENGTH=15,ATTRB=UNPROT,                  X
               INITIAL=' '
         DFHMDF POS=(13,34),LENGTH=1,ATTRB=(PROT,ASKIP)
*
* Email field
         DFHMDF POS=(15,1),LENGTH=15,ATTRB=PROT,                      X
               INITIAL='Email  . . . . .'
         DFHMDF POS=(15,17),LENGTH=1,ATTRB=(PROT,ASKIP)
EMAIL    DFHMDF POS=(15,18),LENGTH=50,ATTRB=UNPROT,                  X
               INITIAL=' '
         DFHMDF POS=(15,69),LENGTH=1,ATTRB=(PROT,ASKIP)
*
* Separator line before message area
         DFHMDF POS=(17,1),LENGTH=79,ATTRB=PROT,                      X
               INITIAL='----------------------------------------'
         DFHMDF POS=(17,80),LENGTH=1,ATTRB=(PROT,ASKIP)
*
* Message area
         DFHMDF POS=(19,1),LENGTH=8,ATTRB=PROT,                       X
               INITIAL='Message:'
         DFHMDF POS=(19,10),LENGTH=1,ATTRB=(PROT,ASKIP)
MSG      DFHMDF POS=(19,11),LENGTH=69,ATTRB=(PROT,BRT),              X
               INITIAL=' '
*
* Transaction counter
         DFHMDF POS=(22,1),LENGTH=18,ATTRB=PROT,                      X
               INITIAL='Transaction Count:'
         DFHMDF POS=(22,20),LENGTH=1,ATTRB=(PROT,ASKIP)
COUNT    DFHMDF POS=(22,21),LENGTH=4,ATTRB=PROT,                     X
               INITIAL='   0'
*
* Bottom instruction line
         DFHMDF POS=(24,1),LENGTH=79,ATTRB=(PROT,BRT),                X
               INITIAL='Enter ACTION code and record key, then press ENX
               TER to process'
         DFHMDF POS=(24,80),LENGTH=1,ATTRB=(PROT,ASKIP)
*
         DFHMSD TYPE=FINAL
         END

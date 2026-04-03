***********************************************************************
* "Hello, World!" mapset
***********************************************************************
CONVMS   DFHMSD MODE=INOUT,                                            XX
               CTRL=(FREEKB,FRSET),                                    X
               STORAGE=AUTO,                                           X
               LANG=COBOL,                                             X
               TIOAPFX=YES,                                            X
               MAPATTS=(HILIGHT),                                      X
               TYPE=&SYSPARM
CONVMAP DFHMDI SIZE=(24,80),LINE=1,COLUMN=1
        DFHMDF POS=(1,12),ATTRB=(ASKIP,NORM),LENGTH=25,                X
               INITIAL='REQUEST COUNTER'
        DFHMDF POS=(3,1),ATTRB=(ASKIP,NORM),LENGTH=79,                 X
               INITIAL='Enter any value. Press PF12 to quit.'
REQ     DFHMDF POS=(4,1),ATTRB=(BRT,UNPROT,IC),                        X
               LENGTH=79,HILIGHT=UNDERLINE
        DFHMDF POS=(5,1),ATTRB=(ASKIP,NORM),LENGTH=0
        DFHMDF POS=(5,3),ATTRB=(ASKIP,NORM),LENGTH=17,                 X
               INITIAL='You have entered '
COUNT   DFHMDF POS=(5,21),ATTRB=(BRT,ASKIP),PICOUT='ZZ,ZZ9'
        DFHMDF POS=(5,28),ATTRB=(ASKIP,NORM),LENGTH=27,                X
               INITIAL='requests. The last one was:'
VAL     DFHMDF POS=(7,1),ATTRB=(ASKIP,NORM),LENGTH=79,INITIAL=' '
        DFHMSD TYPE=FINAL
        END

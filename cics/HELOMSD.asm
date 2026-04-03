***********************************************************************
* "Hello, World!" mapset
***********************************************************************
HELOMSD  DFHMSD MODE=INOUT,                                            XX
               CTRL=(FREEKB,FRSET),                                    X
               STORAGE=AUTO,                                           X
               LANG=COBOL,                                             X
               TIOAPFX=YES,                                            X
               TYPE=&SYSPARM
HELOMAP DFHMDI SIZE=(24,80),LINE=1,COLUMN=1
        DFHMDF POS=(5,1),ATTRB=(ASKIP,NORM),LENGTH=13,                 X
               INITIAL='Hello, World!'
        DFHMSD TYPE=FINAL
        END

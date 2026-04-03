       01  HELLO-DATA-STREAM.
      *****************************************************************
      * F5    ERASE/WRITE             Write command supplied by SEND
      * C2    WCC                     FREEKB WCC supplied by SEND
      * 11    SBA                     User-provided stream starts here
      * C1    Row 5, Col 18 (high)
      * 51    Row 5, Col 18 (low)
      * C8    H
      * 85    e
      * 93    l
      * 93    l
      * 96    o
      * 6B    ,
      * 40    SPACE
      * E6    W
      * 96    o
      * 99    r
      * 93    l
      * 84    d
      * 5A    !
      ****************************************************************
           05 FILLER PIC X(01) VALUE X'11'.
           05 FILLER PIC X(01) VALUE X'C1'.
           05 FILLER PIC X(01) VALUE X'51'.
           05 FILLER PIC X(01) VALUE X'C8'.
           05 FILLER PIC X(01) VALUE X'85'.
           05 FILLER PIC X(01) VALUE X'93'.
           05 FILLER PIC X(01) VALUE X'93'.
           05 FILLER PIC X(01) VALUE X'96'.
           05 FILLER PIC X(01) VALUE X'6B'.
           05 FILLER PIC X(01) VALUE X'40'.
           05 FILLER PIC X(01) VALUE X'E6'.
           05 FILLER PIC X(01) VALUE X'96'.
           05 FILLER PIC X(01) VALUE X'99'.
           05 FILLER PIC X(01) VALUE X'93'.
           05 FILLER PIC X(01) VALUE X'84'.
           05 FILLER PIC X(01) VALUE X'5A'.

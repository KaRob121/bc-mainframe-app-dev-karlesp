       Identification Division.
       Program-Id. STR2.
      *****************************************************************
      * Follow the instructions given in source comments.
      *****************************************************************
       Data Division.
       Working-Storage Section. 

       01  Generic-Output-Field     pic x(132).

       01  filler.
           02  Group-1.
               03  Field-1          pic x(6) value "ALPHA".
               03  Field-2          pic x(6) value "BETA".
               03  Field-3          pic x(6) value "GAMMA". 
               03  Field-4          pic x(6) value "DELTA". 
               03  Field-5          pic x(6) value "EPSILON". 
           02  Group-2.
               03  Field-5.
               03  Field-4.
               03  Field-3. 
               03  Field-2. 
               03  Field-1. 

           02  Group-3.
               03  Field-6          pic x(2)  value "I ".
               03  Field-7          pic x(5)  value "like ".
               03  Field-8          pic x(7)  value "cheese ".
           02  Group-4.
               03  Field-9          pic x(4)  value "and ".
               03  Field-10         pic x(7)  value "cheese ".
               03  Field-11         pic x(6)  value "likes ".        
               03  Field-12         pic x(3)  value "me.".

           01  Batch-Header-Record.
               05  Record-Type       pic x.
                   88  Batch-Header  value "H".
                   88  Invoice-Rec   value "I".
               05  Batch-Number      pic x(8).
               05  Batch-Create-Date pic x(8).    
               05  filler            pic x(83).
           01  Invoice-Record.
               05  Invoice-Number    pic x(6).
               05  Invoice-Total     pic s9(7)v99.
               05  Invoice-Date      pic x(8).
               05  filler            pic x(76).    




       Procedure Division. 

      * Write code to use individual move statements with qualified 
      * names to copy the similarly-named items from Group-1 to 
      * Group-2. Then display:
      *
      *          1         2         3         4         5         6
      * 123456789012345678901234567890123456789012345678901234567890
      *
      * EPSILONDELTA GAMMA BETA  ALPHA   

           display Group-2


      * Write code to use MOVE CORRESPONDING to copy the similarly-
      * named items from Group-1 to Group-2. Then display:
      *
      *          1         2         3         4         5         6
      * 123456789012345678901234567890123456789012345678901234567890
      *
      * EPSILONDELTA GAMMA BETA  ALPHA   

           display Group-2


      * Code a 66-level RENAMES after Group-4 in Working-Storage to
      * give the name "Cheese" to items Field-8 through Field-10.
      * The display statement below should output the value shown:
      *
      *          1         2         3         4         5         6
      * 123456789012345678901234567890123456789012345678901234567890
      *
      * cheese and cheese

           display Cheese


      * Modify the declaration of Invoice-Record in Working-Storage so
      * that Batch-Header-Record and Invoice-Record both occupy the
      * same area of virtual storage. 
      * 
      * Then complete the code in paragraph Display-Date to display 
      * the Batch-Create-Date or Invoice-Date as appropriate for each 
      * record. 
      *
      *          1         2         3         4         5         6
      * 123456789012345678901234567890123456789012345678901234567890
      *
      * cheese and cheese

           move "H1122334420250314" to Invoice-Record
           perform Display-Date
           move "I65432100024357520250309"
           perform Display-Date

           goback
           .
       Display-Date.
           evaluate true 
               when ?
                   display ?
               when ?
                   display ?
               when other 
                   display "Undefined record type"
           end-evaluate
           .
       Identification Division.
       Program-Id. NUMBERS1.
      *****************************************************************
      * Sandbox for demonstrating numeric formats and arithmetic.
      *****************************************************************
       Data Division.
       Working-Storage Section.
       01  filler.
           05  Field-1       pic 9         usage display
                                           value 8.
           05  Field-2       pic 99999     usage display
                                           value 54321.
           05  Field-3       pic 9(5)      usage display
                                           value 65432.
           05  Field-4       pic s9(5)     usage display
                                           value +23456.
           05  Field-5       pic s9(3)v99  usage display 
                                           value -765.43.
           05  Field-6       pic s9(3)v99  usage display
                                           sign is leading
                                           value +123.45.
           05  Field-7       pic s9(3)v99  usage display
                                           sign is trailing
                                           value +123.45.
           05  Field-8       pic s9(3)v99  usage display
                                           sign is leading
                                           separate character
                                           value +123.45
           05  Field-9       pic s9(3)v99  usage display
                                           sign is trailing
                                           separate character
                                           value +123.45.
           05  Field-10      pic s9(4)v9(3) usage packed-decimal
                                           value -8069.772.

       01  filler.
           05  Eye-Catcher   pic x(8) value "XFIELDSX".
           05  Group-1 packed-decimal.
               10  Value-1   pic s9(5).
               10  Value-2   pic s9(5).
               10  Value-3   pic s9(5).
               10  Value-4   pic s9(7).
               10  Value-5   pic s9(7)v99.
               10  Value-6   pic s9(7)v9(4).
               10  Value-7   pic s9(5).
               10  Value-8   pic s9(5).
               10  Value-9   pic s9(5).
           05  Group-2 packed-decimal.
               10  Value-7   pic s9(5).
               10  Value-8   pic s9(5).
               10  Value-9   pic s9(5).

       01  Numeric-Edited-Items.
           05  Value-1-Edited    pic +zz,zz9.
           05  Value-2-Edited    pic +zz,zz9.
           05  Value-3-Edited    pic +zz,zz9.
           05  Value-4-Edited    pic +z,zzz,zz9.
           05  Value-5-Edited    pic $z,zzz,zz9.99-.
           05  Value-6-Edited    pic $$,$$$,$$9.99-.
           05  Value-7-Edited    pic $$,$$$,$$9.99CR.
           05  Value-8-Edited    pic $$,$$$,$$9.99DB.
           05  Value-9-Edited    pic 99/99/9999. 

       Procedure Division.
        
      *---- Add Example 1
           move 9 to Value-1
           move 16 to Value-2
           move -5 to Value-3
           display space
           display "ADD identifier-1 TO identifier-2"
           display "before:"
           display "Value-1: " Value-1
           display "Value-2: " Value-2

           add Value-1 to Value-2
            
           display "after:"
           display "Value-1: " Value-1
           display "Value-2: " Value-2

      *---- Add Example 2
           move 9 to Value-1
           move 16 to Value-2
           move -5 to Value-3
           move 84 to Value-4
           display space
           display "ADD identifier-1 identifier-2"
           display "  TO identifier-3 identifier-4"     
           display "before:"
           display "Value-1: " Value-1
           display "Value-2: " Value-2
           display "Value-3: " Value-3
           display "Value-4: " Value-4

           add Value-1 Value-2 to Value-3 Value-4
            
           display "after:"
           display "Value-1: " Value-1
           display "Value-2: " Value-2
           display "Value-3: " Value-3
           display "Value-4: " Value-4

      *---- Add Example 3
           move 4.5067 to Value-6
           move 33.49 to Value-5
           display space
           display "ADD identifier-1 TO identifier-2 ROUNDED"
           display "before:"
           display "Value-6: " Value-6
           display "Value-5: " Value-5

           add Value-6 to Value-5 rounded 
            
           display "after:"
           display "Value-6: " Value-6
           display "Value-5: " Value-5

      *---- Add Example 4
           move 99999 to Value-1
           move 50000 to Value-2
           display space
           display "ADD identifier-1 TO identifier-2"
           display "  ON SIZE ERROR"
           display "    display message"
           display "END-ADD"
           display "before:"
           display "Value-1: " Value-1
           display "Value-2: " Value-2
 
           add Value-1 to Value-2
               on size error
                   display "Result does not fit in target field"
           end-add

           display "after:"
           display "Value-1: " Value-1
           display "Value-2: " Value-2
            
      *---- Add Example 5
           move 50 to Value-7 of Group-1
           move 75 to Value-7 of Group-2
           move -6 to Value-8 of Group-1
           move 5 to Value-8 of Group-2
           move 11 to Value-9 of Group-1
           move 1 to Value-9 of Group-2
           display space
           display "ADD CORR group-1 TO group-2"
           display "before:"
           display "Value-7 of Group-1: " Value-7 of Group-1
           display "Value-8 of Group-1: " Value-8 of Group-1
           display "Value-9 of Group-1: " Value-9 of Group-1
           display "Value-7 of Group-2: " Value-7 of Group-2
           display "Value-8 of Group-2: " Value-8 of Group-2
           display "Value-9 of Group-2: " Value-9 of Group-2
 
           add corr Group-1 to Group-2 

           display "after:"
           display "Value-7 of Group-1: " Value-7 of Group-1
           display "Value-8 of Group-1: " Value-8 of Group-1
           display "Value-9 of Group-1: " Value-9 of Group-1
           display "Value-7 of Group-2: " Value-7 of Group-2
           display "Value-8 of Group-2: " Value-8 of Group-2
           display "Value-9 of Group-2: " Value-9 of Group-2
            
      *---- Add Example 6
           move 9 to Value-1
           move 16 to Value-2
           move -5 to Value-3
           display space
           display "ADD identifier-1 TO identifier-2"
           display "  GIVING identifier-3"
           display "before:"
           display "Value-1: " Value-1
           display "Value-2: " Value-2
           display "Value-3: " Value-3

           add Value-1 to Value-2 giving Value-3

           display "after:"
           display "Value-1: " Value-1
           display "Value-2: " Value-2
           display "Value-3: " Value-3

      *---- Add Example 7
           move 9 to Value-1
           move 16 to Value-2
           move -5 to Value-3
           move 84 to Value-4
           display space
           display "COMPUTE identifier-4 ="
           display "  identifier-1 + identifier-2 + identifier-3"      
           display "before:"
           display "Value-1: " Value-1
           display "Value-2: " Value-2
           display "Value-3: " Value-3
           display "Value-4: " Value-4

           compute Value-4 =
               Value-1 + Value-2 + Value-3
           end-compute
            
           display "after:"
           display "Value-1: " Value-1
           display "Value-2: " Value-2
           display "Value-3: " Value-3
           display "Value-4: " Value-4

      *---- Add Example 8
           move 9 to Value-1
           move 16 to Value-2
           move -5 to Value-3
           move 84 to Value-4
           display space
           display "COMPUTE identifier-4 ="
           display "  identifier-1 + identifier-2 + identifier-3"      
           display "before:"
           display "Value-1: " Value-1
           display "Value-2: " Value-2
           display "Value-3: " Value-3
           display "Value-4: " Value-4

           compute Value-4 =
               Value-1 + Value-2 + Value-3
           end-compute
            
           display "after:"
           move Value-1 to Value-1-Edited
           move Value-2 to Value-2-Edited
           move Value-3 to Value-3-Edited
           move Value-4 to Value-4-Edited
           display "Value-1: " Value-1-Edited
           display "Value-2: " Value-2-Edited
           display "Value-3: " Value-3-Edited
           display "Value-4: " Value-4-Edited

      *---- Subtraction Example 1
           move 6583.2076 to Value-6
           move 1000.99 to Value-5
           display space
           display "SUBTRACT identifier-1 FROM identifier-2"
           display "  ROUNDED"
           display "before:"
           display "Value-5: " Value-5
           display "Value-6: " Value-6
           move Value-5 to Value-5-Edited
           move Value-6 to Value-6-Edited
           display "Value-5-Edited: " Value-5-Edited
           display "Value-6-Edited: " Value-6-Edited

           subtract Value-5 from Value-6 rounded

           display "after:"
           display "Value-5: " Value-5
           display "Value-6: " Value-6
           move Value-5 to Value-5-Edited
           move Value-6 to Value-6-Edited
           display "Value-5-Edited: " Value-5-Edited
           display "Value-6-Edited: " Value-6-Edited

      *---- Subtraction Example 2
           move zero to Value-6
           move 500.00 to Value-5
           move 350 to Value-1
           display space
           display "SUBTRACT identifier-1 FROM identiier-2"
           display "  GIVING identifier-3"
           display "before:"
           display "Value-1: " Value-1
           display "Value-5: " Value-5
           display "Value-6: " Value-6
           move Value-1 to Value-1-Edited
           move Value-5 to Value-5-Edited
           move Value-6 to Value-6-Edited
           display "Value-1-Edited: " Value-1-Edited
           display "Value-5-Edited: " Value-5-Edited
           display "Value-6-Edited: " Value-6-Edited

           subtract Value-1 from Value-5 giving Value-6

           display "after:"
           display "Value-1: " Value-1
           display "Value-5: " Value-5
           display "Value-6: " Value-6
           move Value-1 to Value-1-Edited
           move Value-5 to Value-5-Edited
           move Value-6 to Value-6-Edited
           display "Value-1-Edited: " Value-1-Edited
           display "Value-5-Edited: " Value-5-Edited
           display "Value-6-Edited: " Value-6-Edited

      *---- Multiplication Example 1
           move 346.9876 to Value-6
           display space
           display "MULTIPLY identifier-1 BY literal-1"
           display "  ROUNDED"
           display "before:"
           display "Literal: " .25
           display "Value-6: " Value-6
           move .25 to Value-5-Edited
           move Value-6 to Value-6-Edited
           display "Literal edited: " Value-5-Edited
           display "Value-6-Edited: " Value-6-Edited

           multiply .25 by Value-6 rounded
           
           display "after:"
           display "Value-6: " Value-6
           move Value-6 to Value-6-Edited
           display "Value-6-Edited: " Value-6-Edited 

      *---- Multiplication Example 2
           move 29.1233 to Value-6
           move 500.00 to Value-5
           display space
           display "MULTIPLY"
           display "  identifier-1 BY identifier-2"
           display "  GIVING identifier-3"
           display "before:"
           display "Value-2: " Value-2
           display "Value-5: " Value-5
           display "Value-6: " Value-6
           move Value-2 to Value-2-Edited
           move Value-5 to Value-5-Edited
           move Value-6 to Value-6-Edited
           display "Value-2-Edited: " Value-2-Edited
           display "Value-5-Edited: " Value-5-Edited
           display "Value-6-Edited: " Value-6-Edited

           multiply Value-5 by Value-2 giving value-6

           display "after:"
           display "Value-2: " Value-2
           display "Value-5: " Value-5
           display "Value-6: " Value-6
           move Value-2 to Value-2-Edited
           move Value-5 to Value-5-Edited
           move Value-6 to Value-6-Edited
           display "Value-2-Edited: " Value-2-Edited
           display "Value-5-Edited: " Value-5-Edited
           display "Value-6-Edited: " Value-6-Edited

      *---- Division Example 1
           move 50 to Value-1
           move 25 to Value-2
           display space
           display "DIVIDE identifier-1 INTO identifier-2"
           display "  ROUNDED"
           display "before:"
           display "Value-1: " Value-1
           display "Value-2: " Value-2
           move Value-1 to Value-1-Edited
           move Value-2 to Value-2-Edited
           display "Value-1-Edited: " Value-1-Edited
           display "Value-2-Edited: " Value-2-Edited

      *---- Division Example 2
           move 50 to Value-1
           move 13 to Value-2
           move zero to Value-3 Value-4
           display space
           display "DIVIDE identifier-1 INTO identifier-2"
           display "  GIVING identifier-3"
           display "  REMAINDER identifier-4"
           display "END-DIVIDE"
           display "before:"
           display "Value-1: " Value-1
           display "Value-2: " Value-2
           display "Value-3: " Value-3
           display "Value-4: " Value-4
           move Value-1 to Value-1-Edited
           move Value-2 to Value-2-Edited
           move Value-3 to Value-3-Edited
           move Value-4 to Value-4-Edited
           display "Value-1-Edited: " Value-1-Edited
           display "Value-2-Edited: " Value-2-Edited
           display "Value-3-Edited: " Value-3-Edited
           display "Value-4-Edited: " Value-4-Edited
           
           divide Value-2 into Value-1
               giving Value-4
               remainder Value-3
           end-divide    

           display "after:"
           display "Value-1: " Value-1
           display "Value-2: " Value-2
           display "Value-3: " Value-3
           display "Value-4: " Value-4
           move Value-1 to Value-1-Edited
           move Value-2 to Value-2-Edited
           move Value-3 to Value-3-Edited
           move Value-4 to Value-4-Edited
           display "Value-1-Edited: " Value-1-Edited
           display "Value-2-Edited: " Value-2-Edited
           display "Value-3-Edited: " Value-3-Edited
           display "Value-4-Edited: " Value-4-Edited

      *---- Division Example 3
           move 29.1233 to Value-6
           move zero to Value-5
           display space
           display "DIVIDE by zero"
           display "before:"
           display "Value-5: " Value-5
           display "Value-6: " Value-6
           move Value-5 to Value-5-Edited
           move Value-6 to Value-6-Edited
           display "Value-5-Edited: " Value-5-Edited
           display "Value-6-Edited: " Value-6-Edited

      * Uncomment the following line to cause a S0CB abend.
      *    divide Value-5 into Value-6

           display "after:"
           display "Value-5: " Value-5
           display "Value-6: " Value-6
           move Value-5 to Value-5-Edited
           move Value-6 to Value-6-Edited
           display "Value-5-Edited: " Value-5-Edited
           display "Value-6-Edited: " Value-6-Edited

      *---- Compute Example 1
           move 5 to Value-1
           move 14 to Value-2
           move 1588 to Value-3
           move .23 to Value-6

           compute Value-5 =
               ((Value-3 / Value-1)
               - Value-2)
               * Value-6
           end-compute
            
           display space
           display "COMPUTE example"
           move Value-5 to Value-5-Edited
           display "Result: " Value-5-Edited 

      *---- Intrinsic Functions

           move 6 to Value-3
           compute Value-4 = 
               function factorial(Value-3)
           end-compute 
           display space
           display "function factorial(6)"
           display "Result: " Value-4

           move 456.4321 to Value-6
           compute Value-4 =
               function integer(Value-6)
           end-compute
           display space
           display "function integer(456.4321)"
           display "Result: " Value-4

           move 456.4321 to Value-6
           compute Value-4 =
               function integer-part(Value-6)
           end-compute
           display space
           display "function integer-part(456.4321)"
           display "Result: " Value-4

           move 15 to Value-1
           move -88 to Value-2
           move 3 to Value-3
           compute Value-4 = 
               function max(Value-1 Value-2 Value-3)
           end-compute
           display space
           display "function max(15 -88 3)"
           display "Result: " Value-4

           move 15 to Value-1
           move -88 to Value-2
           move 3 to Value-3
           compute Value-4 = 
               function min(Value-1 Value-2 Value-3)
           end-compute
           display space
           display "function min(15 -88 3)"
           display "Result: " Value-4

           move 15 to Value-1
           move -88 to Value-2
           move 3 to Value-3
           compute Value-6 = 
               function mean(Value-1 Value-2 Value-3)
           end-compute
           display space
           display "function mean(15 -88 3)"
           display "Result: " Value-6

           move 15 to Value-1
           move -88 to Value-2
           move 3 to Value-3
           compute Value-6 = 
               function median(Value-1 Value-2 Value-3)
           end-compute
           display space
           display "function median(15 -88 3)"
           display "Result: " Value-6

           move 15 to Value-1
           move -88 to Value-2
           move 3 to Value-3
           compute Value-6 = 
               function midrange(Value-1 Value-2 Value-3)
           end-compute
           display space
           display "function midrange(15 -88 3)"
           display "Result: " Value-6

           move 37 to Value-1
           move 5 to Value-2
           compute Value-4 =
               function mod(Value-1 Value-2)
           end-compute
           display space
           display "function mod(37 5)"
           display "Result: " Value-4

           move 37 to Value-1
           move 5 to Value-2
           compute Value-4 =
               function rem(Value-1 Value-2)
           end-compute
           display space
           display "function rem(37 5)"
           display "Result: " Value-4

           move 155 to Value-1
           move 89 to Value-2
           move 486 to Value-3
           compute Value-4 =
               function sum(Value-1 Value-2 Value-3)
           end-compute
           display space
           display "function sum(155 89 486)"
           display "Result: " Value-4

           goback
           .   
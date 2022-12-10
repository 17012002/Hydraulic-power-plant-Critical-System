-- This file was created by Anton Setzer
pragma SPARK_Mode (On);



-- This is a wrapper around spark.text_io and spark.text_IO.integer_Io;
-- We pretend here that after initizlisation we can always read and write
-- from standardP_input and _output.
-- This is obtained by having as implementation a file for which spark_io is off
-- so the spark ada conditions are not checked.


-- For using it one should first initialise stnadard input and/or standard output
-- by executing AS_Init_Standard_Input  and/or AS_Init_Standard_Output
-- functions named AS_Put* write output on the console
-- functions named AS_Get* get input from the console

with SPARK.Text_IO;
use SPARK.Text_IO;


package AS_Io_Wrapper 
is
   
   -- this procedure initialises standard input
   procedure AS_Init_Standard_Input 
     with Global => (Output => Standard_Input),
          Depends => (Standard_Input  => null);
--          Post => Is_Readable (Standard_Input);
--          Status (Standard_Input) = Success;
   
  -- this procedure initialises standard output
  procedure AS_Init_Standard_Output 
    with Global => (Output => Standard_Output),
         Depends => (Standard_Output  => null);     
  --       Post => Is_Writable (Standard_Output); 
  --    and Status (Standard_Output) = Success;
   
   --  -- as_get gets a character from console IO
   --  procedure AS_Get (Item : out Character_Result)
   --    with Global => (In_Out => (Standard_Input)),
   --    Depends=> (Standard_Input => Standard_Input,
   --  		Item => Standard_Input);
   
   -- as_put writes a character onto console IO   
   procedure AS_Put (Item : in  Character)
     with Global => (In_Out => Standard_Output),
          Depends=> (Standard_Output => (Item, Standard_Output));
   
   -- as_get gets a string from console IO
   -- the string it expects is the length of the string Item
   -- so if called with an Itm : string (1 .. 100)
   -- this procedure will wait until 100 characters are typed in.
   procedure AS_Get (Item : out String)
          with Global => (In_Out => (Standard_Input)),
     Depends=> (Standard_Input => Standard_Input,
		Item => Standard_Input);
   
   procedure AS_Clear_Buffer;   
   
   -- as_put writes a string to standard_output
   procedure AS_Put (Item : in  String)
       with Global => (In_Out => Standard_Output),
            Depends=> (Standard_Output => (Item, Standard_Output));
  
   
   -- as_get_line gets a string from standard_input until a 
   -- line break is entered
   -- and then writes it into the beginning of Item
   -- Anything else in Item will stay as it is.
   
   -- Last will contain the length of the string (delimited by carriage return)
   --  input
   -- so the true string obtained is the substring of Item of length Last
   -- which is Item(1 .. Last);
   --
   -- (In Ada if a : String    a (x .. y) is the substring starting at position
   -- x and ending at position y.
   procedure AS_Get_Line (Item : out String; Last : out Natural)
          with Global => (In_Out => (Standard_Input)),
     Depends=> (Standard_Input => Standard_Input,
		(Item,Last) => Standard_Input);
		
     
   -- as_put_line is as as_put, but adds a line break.
   procedure AS_Put_Line (Item : in  String)
            with Global => (In_Out => Standard_Output),
                 Depends=> (Standard_Output => (Item, Standard_Output));
   
   -- as_put_line() just adds a linebreak
   procedure AS_Put_Line 
            with Global => (In_Out => Standard_Output),
                 Depends=> (Standard_Output => (Standard_Output));
   

   
   -- as_get reads an integer from input.
   -- if the user didn't write an integer, it prints out the string of the parameter Prompt_Try_Again_When_Not_Integer
   -- and then waits for another attmpet to input by the user.
   -- it will continue until an integer has been entered.
   --
   --
   -- Prompt_Try_Again_When_Not_Integer has a default value as expressed by 
   --      := "Please type in an integer; please try again"
   -- therefore we use as well
   -- AS_Get (Item)
   -- which will execute the same as AS_Get(Item,"Please type in an integer; please try again") 
   -- 
   procedure AS_Get (Item  : out Integer; Prompt_Try_Again_When_Not_Integer : in String := "Please type in an integer; please try again")            with Global => (In_Out => (Standard_Input,Standard_Output)),
                            Depends=> (Standard_Input => Standard_Input,
	                               Standard_Output=> (Standard_Input,Standard_Output,Prompt_Try_Again_When_Not_Integer),
	                               Item => Standard_Input);     
   
   
   
   -- AS_Put(Item) writes an integer value to standard output
   procedure AS_Put (Item  : in Integer)
            with Global => (In_Out => Standard_Output),
                 Depends=> (Standard_Output => (Item, Standard_Output));
   
   -- AS_Put(Item) does the same as AS_Put(Item) but adds a line break;
   procedure AS_Put_Line (Item  : in Integer)
            with Global => (In_Out => Standard_Output),
                 Depends=> (Standard_Output => (Item, Standard_Output));   
   
   
end AS_Io_Wrapper;
   
   
   
   
   
   
   

-- This file was created by Anton Setzer
pragma SPARK_Mode (Off);

-- with SPARK.Text_IO;
-- use SPARK.Text_IO;
with SPARK.Text_IO.Integer_IO;


package body AS_IO_Wrapper is
   
   package Integer_IO is new SPARK.Text_IO.Integer_IO(Integer);
   use  Integer_IO; -- SPARK.Text_IO.Integer_IO (Integer)

   
   procedure AS_Init_Standard_Input  is
   begin
      SPARK.Text_IO.Init_Standard_Input;
   end AS_Init_Standard_Input;
   
   procedure AS_Init_Standard_Output is
   begin
      SPARK.Text_IO.Init_Standard_Output;
   end AS_Init_Standard_Output;

   
   

   --  procedure AS_Get (Item : out Character_Result) is
   --  begin
   --     --  loop
   --     --  	 exit when Status (Standard_Input) = Success;
   --     --  	 Put_Line (Standard_Error, "Error on Standard_Input");
   --     --  end loop;
   --     SPARK.Text_IO.Get(Item);
   --  end AS_Get;      

   
   procedure AS_Put (Item : in  Character) is
   begin
      SPARK.Text_IO.Put (Item);
      --  if Status (Standard_Output) = Success then
      --     SPARK.Text_IO.Put (Item);
      --  else
      --     SPARK.Text_IO.Put_Line (Standard_Error, "Error on Standard_Output");
      --  end if;
   end AS_Put;
      
   
   
   procedure AS_Get (Item : out String) is
   begin
      SPARK.Text_IO.Get (Item);
   end AS_Get;
   
   procedure AS_Clear_Buffer is
      -- sometimes whenn running AS_Get(x) where x : Integer;
      -- there is some strange error message, because something is still left in the buffer of user inputs.
      --  Running As_Clear_Buffer before AS_Get(x)  allows to clear what's left in the current buffer.      
      Item : String(1 .. 1);
   begin
      SPARK.Text_IO.Get (Item);
      -- work around since SPARK ada wants Item to be used,
      -- but we don't really need it.
      if Item = " " then return;
      else return;
      end if;
	 
   end AS_Clear_Buffer;
   
   
   
   procedure AS_Put (Item : in  String) is
   begin
      SPARK.Text_IO.Put (Item);
   end AS_Put;

   
   procedure AS_Get_Line (Item : out String; Last : out Natural) is
   begin
      SPARK.Text_IO.Get_Line (Item,Last);
   end AS_Get_Line;





   
   procedure AS_Put_Line (Item : in  String) is
   begin
      SPARK.Text_IO.Put_Line (Item);
   end AS_Put_Line;
   
   procedure AS_Put_Line is
   begin
      As_Put_Line("");
   end As_Put_Line;
   
   procedure AS_Get (Item  : out Integer; Prompt_Try_Again_When_Not_Integer : in String := "Please type in an integer; please try again") is
      -- sometimes whenn running AS_Get(x) where x : Integer;
      -- there is some strange error message, because something is still left in the buffer of user inputs.
      -- Running As_Clear_Buffer before AS_Get(x)  allows to clear what's left in the current buffer and avoid this problem
      
      Length_String : constant Integer := 512;
      Input_By_User : String(1 .. Length_String);
      Converted_Result  : Integer_Result;
      Length_Input : Natural;
      Length_Input_Used : Positive;
   begin
      loop
	 SPARK.Text_IO.Get_Line(Input_By_User,Length_Input);
	 Get (Input_By_User(1 .. Length_Input) ,Converted_Result,Length_Input_Used);
	 exit when Converted_Result.Status = Success and Length_Input_Used = Length_Input;
	 SPARK.Text_IO.Put_Line(Prompt_Try_Again_When_Not_Integer);
      end loop;
      Item := Converted_Result.Item;
   end AS_Get;      
   
  
   procedure AS_Put  (Item : in  Integer) is
   begin
      Put(Item);
   end AS_Put;
   
   
   procedure AS_Put_Line  (Item : in  Integer) is
   begin
      Integer_IO.Put(Item);
      AS_Put_Line;
   end AS_Put_Line;

end AS_IO_Wrapper;
   
   
   
   
   
   
   

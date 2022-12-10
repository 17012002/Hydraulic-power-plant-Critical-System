pragma SPARK_Mode (On);

with AS_IO_Wrapper;  use AS_IO_Wrapper; 


package body Hydroelectric_system is
   
   
   procedure Read_User is
      Energy_Input_User : Integer;
   begin
      AS_Put_Line;
      AS_Put_Line("***Welcome to the EL MEDIANO power plant!***");
      AS_Put_Line;
      AS_Put_Line("**The current status of the system is:**");
      AS_Put_Line;
      AS_Put_Line("Water filter state: ");
      AS_Put_Line;
      AS_Put(Water_Filter_To_String(Status_System.Filter_State));
      AS_Put_Line;
      AS_Put_Line("Current water level: ");
      AS_Put_Line;
      AS_Put(Status_System.Water_Level);
      AS_Put_Line("hm3");
      AS_Put_Line;
      AS_Put("Please type the desired Mega-Watts you want to generate in the next 12h (1-30):");
      loop
         pragma Loop_Invariant (Status_System.Energy in Energy_Output_Range);
         AS_Get(Energy_Input_User,"Please type the desired Mega-Watts you want to generate in the next 12h(1-30): ");
         exit when (Energy_Input_User in Energy_Output_Range'Range);
         AS_Put("(1-30)");
      end loop;
      Status_System.Energy := Energy_Output_Range(Energy_Input_User);
   end Read_User;
   
   function Water_Filter_To_String (Status_Water_Filter   : Water_Filter_Type) return String is
   begin
         if (Status_Water_Filter = Clear) then
         return "Clear";
      else
         return "Clogged";
      end if;
   end Water_Filter_To_String;
   
   procedure Monitor_Water_Filter  is
   begin
      if Status_System.Filter_State = Clear then
         AS_Put("The water filter is unclogged and you can proceed with your desired request.");
         AS_Put_Line;
      else
         AS_Put("*");
         AS_Put_Line;
         AS_Put("*");
         AS_Put_Line;
         AS_Put("*");
         AS_Put_Line;
         AS_Put("Cleaning complete.");
         Status_System.Filter_State := Clear;
         AS_Put_Line;
         AS_Put("The water filter has been unclogged and you can proceed with your request.");
         AS_Put_Line;
      end if;
   end Monitor_Water_Filter;
   
   procedure Monitor_Water_Level  is
   begin      
      if (Status_System.Water_Level-Status_System.Energy) in Water_Level_Range then
         Status_System.Water_Level := Water_Level_Range(Status_System.Water_Level-Status_System.Energy);
         if(Status_System.Counter /= Integer'Last) then
            Status_System.Counter := Status_System.Counter + 1;
         end if;
      else AS_Put("Unable to run because running this action will deplete the water levels below 15%, ");
         AS_Put(Status_System.Water_Level-Status_System.Energy);
         AS_Put("hm3 of water is less than 15% of the total water. Recomended minimum energy production to gain water.");
      end if;
   end Monitor_Water_Level;
   
   --30 = h_seconds * (Maximum_Turbine_Intake/10000)
   procedure Monitor_Energy is
   begin 
      Status_System.Aperture_Percentage := ((Status_System.Energy * 100)/30);
   end Monitor_Energy;
   
   procedure River_Flow is
   begin 
      if (Status_System.Counter /= 0) and  ((Status_System.Water_Level + water_flow) in Water_Level_Range) then
         Status_System.Water_Level := Status_System.Water_Level + water_flow;
      else Status_System.Water_Level := Maximum_Water_Level;
      end if;
   end River_Flow;
         
   procedure Print_Status is
   begin
      AS_Put_Line;
      AS_Put("***Remaining water level***");
      AS_Put_Line;
      AS_Put(Status_System.Water_Level);
      AS_Put("hm3 after the reservoir recollected 14hm3 of water after 12h ");
      AS_Put_Line;
      AS_Put("***Status of the water filter***");
      AS_Put_Line;
      AS_Put(Water_Filter_To_String(Status_System.Filter_State));
      AS_Put_Line;
      AS_Put("***Valve Aperture***");
      AS_Put_Line;
      AS_Put(Status_System.Aperture_Percentage);
      AS_Put("%");
      AS_Put_Line;
      AS_Put("***Energy Output***");
      AS_Put_Line;
      AS_Put(Status_System.Energy);
      AS_Put("MW per 12h");
      AS_Put_Line;
      AS_Put(Status_System.Counter);
      AS_Put(" interval/s of 12h");
   end Print_Status;
   
   procedure Init is
   begin
      AS_Init_Standard_Input; 
      AS_Init_Standard_Output;
      Status_System := (Clogged, 66, 0, 1, 0);
   end Init;      
     
end Hydroelectric_system;
	

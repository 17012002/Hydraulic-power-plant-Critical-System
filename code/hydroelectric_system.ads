-- This file was created by Anton Setzer
-- it is an ultra simple example of a critical system
-- namely the cooling system of a nuclear power station.
-- if the temperature goes above a critical value
-- the cooling system will be set to activated.

pragma SPARK_Mode (On);

with SPARK.Text_IO;use  SPARK.Text_IO;


package Hydroelectric_system is
   
   --Constant river flow of water in hm3
   water_flow : constant Integer := 14;
   
   --12h in seconds
   h_seconds : constant Integer := 43200;
   
   --Maximum Energy Output produced by the hydroelectric power plant during 12h
   --of constant work
   Maximum_Energy_Output : constant Integer := 30;
   
   --Maximum capacity of the water reservoir in hm3
   Maximum_Water_Level : constant Integer := 436;
   
   --Minimum capacity of the water reservoir in hm3
   Minimum_Water_Level : constant Integer := 65;
   
   --Maximum intake  of the water turbine in hm3 per second
   Maximum_Turbine_Intake : constant Integer := 7;
   
   --Range of water level of the reservoir, minimum water level suitable for
   --the environment always above 15% of the maximum water level ((15*Maximum_Water_Level)/100
   subtype Water_Level_Range is Integer range Minimum_Water_Level..Maximum_Water_Level;
                                                   
   --Range of energy output of the hydroelectric power plant during 12h
   --of constant work
   subtype Energy_Output_Range is Integer range 1..Maximum_Energy_Output;
   
   --Range of the aperture of the percentage of intake
   subtype Valve_Aperture_Range is Integer range 0..100;
                                                   
   --Statest in which the filter can be
   type Water_Filter_Type is (Clogged, Clear);
   
   -- status of the overall system consisting of the Filter State, Water level, Aperture of the valve and energy
   type Status_System_Type  is 
      record
         Filter_State   : Water_Filter_Type;
         Water_Level : Water_Level_Range;
         Aperture_Percentage : Valve_Aperture_Range;
         Energy : Energy_Output_Range;
         Counter : Integer;
      end record;
   
   function Is_Safe (Status : Status_System_Type) return Boolean is
      (Status.Filter_State in Water_Filter_Type'Range and
      Status.Water_Level in Water_Level_Range'Range and
      Status.Aperture_Percentage in Valve_Aperture_Range'Range and
      Status.Energy in Energy_Output_Range'Range);  
   
   --Status System is a global variable determining the status of the system
   Status_System : Status_System_Type;
   
   -- Read_Temperature gets the current temperature from console input output
   -- and updates Status_System
   -- it does NOT monitor the cooling system
   -- so after executing it the system might be unsafe.x
   procedure Read_User with
     Global => (In_Out => (Standard_Output, Standard_Input,Status_System)),
     Depends => (Standard_Output => (Standard_Input,Standard_Output,Status_System),
                 Standard_Input  => Standard_Input,
                 Status_System   => (Status_System, Standard_Input)),
     Post => (Status_System.Energy in Energy_Output_Range);
   
   -- This function converts a value into Status_Cooling_System_Type
   -- into a string which can be printed to console
   function Water_Filter_To_String (Status_Water_Filter  : Water_Filter_Type) return String;
   
   procedure Monitor_Water_Filter with
     Global => (In_Out => (Standard_Output, Status_System)),
     Depends => (Standard_Output => (Standard_Output,Status_System), Status_System => Status_System);
   procedure Monitor_Water_Level with
     Global => (In_Out => (Standard_Output, Status_System)),
     Depends => (Standard_Output => (Standard_Output,Status_System), Status_System => Status_System),
     Pre => (Status_System.Counter in Integer'Range);
   
   procedure Monitor_Energy with
     Global => (In_Out => (Status_System)),
     Depends => (Status_System => Status_System);
   
   procedure River_Flow with
     Global => (In_Out => (Status_System)),
     Depends => (Status_System => Status_System);
   
   procedure Print_Status with
     Global => (In_Out => Standard_Output, 
                Input  => Status_System),
     Depends => (Standard_Output => (Standard_Output,Status_System));
   
   -- Init initialises the system to some values.
   -- afterwards the system is safe.x
   procedure Init with
     Global => (Output => (Standard_Output,Standard_Input,Status_System)),
     Depends => ((Standard_Output,Standard_Input,Status_System) => null),
     Post    => Is_Safe(Status_System);
end  Hydroelectric_system;



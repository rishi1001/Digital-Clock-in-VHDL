library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity assign is
    port(
        clk: in std_logic;                       -- clock of 10 MHz
        button_push: in std_logic_vector(3 downto 0);
        display_number: out std_logic_vector(15 downto 0)        
                                                                    
    );
end assign;

architecture arch_assign of assign is
    signal H_1: std_logic_vector(3 downto 0):='0000';                        
    signal H_0: std_logic_vector(3 downto 0):='0000';
    signal M_1: std_logic_vector(3 downto 0):='0000';
    signal M_0: std_logic_vector(3 downto 0):='0000';
    signal S_1: std_logic_vector(3 downto 0):='0000';                       
    signal S_0: std_logic_vector(3 downto 0):='0000';
    
    type state_type is(AH,EH1,AH1,EH2,AH2,EH3,AH3,EH4,AH4,EH5,AS,ES1,AS1,ES2,AS2,ES3,AS3,ES4,AS4,ES5,FH1,FH2,FH3,FH4,FS1,FS2,FS3,FS4);
    signal state : state_type:=AH;
    signal counter: integer:=0;                            -- check this
    signal clk_5s:std_logic;                                -- 2Hz clock ie time similar to a button click   
    signal clk_0_1s:std_logic;                             -- 1Hz clock for normal functioning 
    begin
     instance_clk_part0_1s: entity clk_part5 port map(
        clk_10=>clk,
        clk_0_1s=>clk_0_1s
     );   
     instance_clk_part1: entity clk_part1 port map(
        clk_10=>clk,
        clk_1s=>clk_1s
     );   
     process(clk)                                            -- should I keep button here?
     begin
      if(rising_edge(clk)) then
       case state is
        when AH =>
            if (button_push(0)='1') then state<=AS;
            elsif (button_push(1)='1') then state<=EH1;
            end if;
        when AS =>
            if (button_push(0)='1') then state<=AH;
            elsif (button_push(1)='1') then state<=ES1;
            end if;    
        when EH1 =>
            if (button_push(1)='0') then state<=AH1;
            end if;
        when AH1=>
            if (button_push(1)='1') then state<=EH2;
            elsif (button_push(2)='1') then state<=FH1;
            end if;
        when FH1=>
            if (button_push(1)='1') then state<=EH2;
            end if;    
        when EH2=>
            if (button_push(1)='0') then state<=AH2;
            end if;
        when AH2=>
            if (button_push(1)='1') then state<=EH3;
            elsif (button_push(2)='1') then state<=FH2;
            end if;
        when FH2=>
            if (button_push(1)='1') then state<=EH3;
            end if;    
        when EH3=>
            if (button_push(1)='0') then state<=AH3;
            end if;
        when AH3=>
            if (button_push(1)='1') then state<=EH4;
            elsif (button_push(2)='1') then state<=FH3;
            end if;
        when FH3=>
            if (button_push(1)='1') then state<=EH4;
            end if;    
        when EH4=>
            if (button_push(1)='0') then state<=AH4;
            end if;
        when AH4=>
            if (button_push(1)='1') then state<=EH5;
            elsif (button_push(2)='1') then state<=FH4;
            end if;
        when FH4=>
            if (button_push(1)='1') then state<=EH5;
            end if;    
        when EH5=>
            if (button_push(1)='0') then state<=AH;
            end if;

        when ES1 =>
            if (button_push(1)='0') then state<=AS1;
            end if;
        when AS1=>
            if (button_push(1)='1') then state<=ES2;
            elsif (button_push(2)='1') then state<=FS1;
            end if;
        when FS1=>
            if (button_push(1)='1') then state<=ES2;
            end if;    
        when ES2=>
            if (button_push(1)='0') then state<=AS2;
            end if;
        when AS2=>
            if (button_push(1)='1') then state<=ES3;
            elsif (button_push(2)='1') then state<=FS2;
            end if;
        when FS2=>
            if (button_push(1)='1') then state<=ES3;
            end if;    
        when ES3=>
            if (button_push(1)='0') then state<=AS3;
            end if;
        when AS3=>
            if (button_push(1)='1') then state<=ES4;
            elsif (button_push(2)='1') then state<=FS3;
            end if;
        when FS3=>
            if (button_push(1)='1') then state<=ES4;
            end if;    
        when ES4=>
            if (button_push(1)='0') then state<=AS4;
            end if;
        when AS4=>
            if (button_push(1)='1') then state<=ES5;
            elsif (button_push(2)='1') then state<=FS4;
            end if;
        when FS4=>
            if (button_push(1)='1') then state<=ES5;
            end if;    
        when ES5=>
            if (button_push(1)='0') then state<=AS; 
            end if;   
       end case; 
      end if;
     end process;

     

     process(clk_0_1s)                                            -- 0.1s clock
     signal c1_h0,c1_m0,c1_s0,c1_h1,c1_m1,c1_s1,c2_h0,c2_m0,c2_s0,c2_h1,c2_m1,c2_s1 : integer:=0; 
     begin
      if(rising_edge(clk_0_1s)) then
       case state is
        
        when FH1 or FS3=>                                                          -- change unit digit of minute
            if (button_push(2)='1') then 
                if (c1_m0>=5) then                                           -- when the button is pressed more than 0.5sec then fast increament starts ie at every 0.2sec increment
                    c2_m0<=c2_m0+1;
                    if (c2_m0>=2) then 
                        c2_m0<=0;
                    end if;
                elsif (c1_m0=0) then 
                    M_0<=M_0+1;
                    if (M_0='1010') then                        -- if it gets 10
                        M_0<='0000';
                    end if;    
                    c1_m0<=c1_m0+1;
                else c1_m0<=c1_m0+1;    
                end if;   
            else c1_m0<=0;
            end if;          

            
        when FH2 or FS4=>                                                           -- change 10s digit of minute
            if (button_push(2)='1') then 
                if (c1_m1>=5) then                                           -- when the button is pressed more than 0.5sec then fast increament starts ie at every 0.2sec increment
                    c2_m1<=c2_m1+1;
                    if (c2_m1>=2) then 
                        c2_m1<=0;
                    end if;
                elsif (c1_m1=0) then 
                    M_1<=M_1+1;
                    if (M_1='0110') then                        -- if it gets 6
                        M_1<='0000';
                    end if;    
                    c1_m1<=c1_m1+1;
                else c1_m1<=c1_m1+1;    
                end if;   
            else c1_m1<=0;
            end if;
            
        when FH3=>                                                        -- change unit digit of hour
            if (button_push(2)='1') then 
                if (c1_h0>=5) then                                           -- when the button is pressed more than 0.5sec then fast increament starts ie at every 0.2sec increment
                    c2_h0<=c2_h0+1;
                    if (c2_h0>=2) then 
                        c2_h0<=0;
                    end if;
                elsif (c1_h0=0) then 
                    H_0<=H_0+1;
                    if (H_0='1010') then                        -- if it gets 10
                        H_0<='0000';
                    end if;    
                    c1_h0<=c1_h0+1;
                else c1_h0<=c1_h0+1;    
                end if;   
            else c1_h0<=0;
            end if;

        when FH4=>                                                          -- change 10s digit of hour
            if (button_push(2)='1') then 
                if (c1_h1>=5) then                                           -- when the button is pressed more than 0.5sec then fast increament starts ie at every 0.2sec increment
                    c2_h1<=c2_h1+1;
                    if (c2_h1>=2) then 
                        c2_h1<=0;
                    end if;
                elsif (c1_h1=0) then 
                    H_1<=H_1+1;
                    if (H_1='0011') then                        -- if it gets 3
                        H_1<='0000';
                    end if;    
                    c1_h1<=c1_h1+1;
                else c1_h1<=c1_h1+1;    
                end if;   
            else c1_h1<=0;
            end if;

        when FS1=>                                                          -- change unit digit of second
            if (button_push(2)='1') then 
                if (c1_s0>=5) then                                           -- when the button is pressed more than 0.5sec then fast increament starts ie at every 0.2sec increment
                    c2_s0<=c2_s0+1;
                    if (c2_s0>=2) then 
                        c2_s0<=0;
                    end if;
                elsif (c1_s0=0) then 
                    S_0<=S_0+1;
                    if (S_0='1010') then                        -- if it gets 10
                        S_0<='0000';
                    end if;    
                    c1_s0<=c1_s0+1;
                else c1_s0<=c1_s0+1;    
                end if;   
            else c1_s0<=0;
            end if;          
        
        when FS2=>                                                           -- change 10s digit of second
            if (button_push(2)='1') then 
                if (c1_s1>=5) then                                           -- when the button is pressed more than 0.5sec then fast increament starts ie at every 0.2sec increment
                    c2_s1<=c2_s1+1;
                    if (c2_s1>=2) then 
                        c2_s1<=0;
                    end if;
                elsif (c1_s1=0) then 
                    S_1<=S_1+1;
                    if (S_1='0110') then                        -- if it gets 6
                        S_1<='0000';
                    end if;    
                    c1_s1<=c1_s1+1;
                else c1_s1<=c1_s1+1;    
                end if;   
            else c1_s1<=0;
            end if;


       end case; 
      end if;
     end process;


     process(clk_1s)                                            -- should I keep button here?
     begin
      if(rising_edge(clk_1s)) then
       case state is

        when AH =>                                                        -- display hour and minutes
            if (S_0='1001') then 
                S_0<='0000';
                S_1<=S_1+1;
            else S_0<=S_0+1;    
            end if; 
            if (S_1='0110') then
                if (M_0='1001') then
                    M_0<='0000';
                    M_1<=M_1+1;
                else M_0<=M_0+1;
                S_1<='0000';
                end if;
            end if;   

            if (M_1='0110') then
                if (H_0='1001') then
                    H_0<='0000';
                    H_1<=H_1+1;
                else H_0<=H_0+1; 
                end if;
                M_1<='0000';
            end if;  
            
            if (H_1='010' and H_0='0101') then
                H_1='000';
                H_0='0000';
                M_0='0000';
                M_1='0000';
                S_0='0000';
                S_1='0000';      
            end if;              
            
        when AS =>                                                         -- display minutes and seconds

            if (S_0='1001') then 
                S_0<='0000';
                S_1<=S_1+1;
            else S_0<=S_0+1;    
            end if; 
            if (S_1='0110') then
                if (M_0='1001') then
                    M_0<='0000';
                    M_1<=M_1+1;
                else M_0<=M_0+1;
                end if;
                S_1<='0000';
            end if;   

            if (M_1='0110') then
                if (H_0='1001') then
                    H_0<='0000';
                    H_1<=H_1+1;
                else H_0<=H_0+1; 
                end if;
                M_1<='0000';
            end if;  
            
            if (H_1='010' and H_0='0101') then
                H_1='000';
                H_0='0000';
                M_0='0000';
                M_1='0000';
                S_0='0000';
                S_1='0000';      
            end if;              

       end case; 
      end if;
     end process;




     process(clk_1s)                                            -- should I keep button here?
     begin
      if(rising_edge(clk_1s)) then
       case state is
        when AH or EH1 or AH1 or EH2 or AH2 or EH3 or AH3 or EH4 or AH4 or EH5 or FH1 or FH2 or FH3 or FH4=>
            display_number<=H_1&H_0&M_1&M_0;
        when AS or ES1 or AS1 or ES2 or AS2 or ES3 or AS3 or ES4 or AS4 or ES5 or FS1 or FS2 or FS3 or FS4=>
            display_number<=M_1&M_0&S_1&S_0;

       end case; 
      end if;
     end process;


end arch_assign;

entity display is
    port (
       clk: in std_logic;
       button_push: in std_logic_vector(3 downto 0);
       anode_activate: out std_logic_vector(3 downto 0);       
       led: out std_logic_vector(6 downto 0)
      );
end display;

architecture arch_display of display is
    signal led_temp: std_logic_vector(3 downto 0);
    signal display_number: std_logic vector(15 downto 0);
    signal led_counter:std_logic_vector(1 downto 0):='00';
    signal clk_1ms:std_logic;
    begin
     instance_assign: entity assign port map(
        clk=>clk,
        button_push=>button_push,
        display_number=>display_number        
     );   

     instance_assign: entity clk_part1ms port map(
        clk=>clk,
        clk_1ms=>clk_1ms                
     ); 

     process(clk_1ms)
     begin
      if(rising_edge(clk_1ms)) then
        case led_counter is                                    -- do this based on refreshing rate
            when 2'b00:
                anode_activate<=4'b0111;
                led_temp<=display_number(15 downto 12);
                led_counter<='01';
            when 2'b01:
                anode_activate<=4'b1011;
                led_temp<=display_number(11 downto 8);
                led_counter<='10';
            when 2'b10:
                anode_activate<=4'b1101;
                led_temp<=display_number(7 downto 4);
                led_counter<='11';
            when 2'b11:
                anode_activate<=4'b1110;
                led_temp<=display_number(3 downto 0);
                led_counter<='00';
                
        end case;    
      end if;
     end process;
        
     process(clk_1ms)
     begin
      if(rising_edge(clk_1ms)) then
        case led_temp is
            when 4'b0000: led<=7'b0000001;
            when 4'b0001: led <= 7'b1001111;
            when 4'b0010: led <= 7'b0010010;
            when 4'b0011: led <= 7'b0000110;
            when 4'b0100: led <= 7'b1001100; 
            when 4'b0101: led <= 7'b0100100;
            when 4'b0110: led <= 7'b0100000;
            when 4'b0111: led <= 7'b0001111;
            when 4'b1000: led <= 7'b0000000;
            when 4'b1001: led <= 7'b0000100;
        end case;    
      end if;
     end process;
end arch_display;



entity clk_part1 is                                   -- 1 sec clock
    port (
       clk_10: in std_logic;
       clk_1s: out std_logic
      );
end clk_part1;

architecture arch_clk_part1 of clk_part1 is
    signal temporal: std_logic :='0';
    signal counter : integer range 0 to 4999999 := 0;
    begin
     process(clk_10)
     begin
      if(rising_edge(clk_10)) then
        if (counter = 4999999) then
            temporal <= NOT(temporal);
            counter <= 0;
        else
            counter <= counter + 1;
        end if;
      end if;  
     end process;
end arch_clk_part1;

entity clk_part0_1 is                                      -- 0.1 sec clock
    port (
       clk_10: in std_logic;
       clk_0_1s: out std_logic
      );
end clk_part0_1;

architecture arch_clk_part0_1 of clk_part0_1 is
    signal temporal: std_logic :='0';
    signal counter : integer range 0 to 499999 := 0;
    begin
     process(clk_10)
     begin
      if(rising_edge(clk_10)) then
        if (counter = 499999) then
            temporal <= NOT(temporal);
            counter <= 0;
        else
            counter <= counter + 1;
        end if;
      end if;  
     end process;
end arch_clk_part0_1;

entity clk_part1ms is
    port (
       clk_10: in std_logic;
       clk_1ms: out std_logic
      );
end clk_part1ms;

architecture arch_clk_part1ms of clk_part1ms is                       -- 1ms clock
    signal temporal: std_logic :='0';
    signal counter : integer range 0 to 4999 := 0;
    begin
     process(clk_10)
     begin
      if(rising_edge(clk_10)) then
        if (counter = 4999) then
            temporal <= NOT(temporal);
            counter <= 0;
        else
            counter <= counter + 1;
        end if;
      end if;  
     end process;
end arch_clk_part1ms;
    

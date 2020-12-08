----------------------------------------------------------------------------------
-- COPYRIGHT 2019 Jes?s Eduardo M?ndez Rosales
--This program is free software: you can redistribute it and/or modify
--it under the terms of the GNU General Public License as published by
--the Free Software Foundation, either version 3 of the License, or
--(at your option) any later version.
--
--This program is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--GNU General Public License for more details.
--
--You should have received a copy of the GNU General Public License
--along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
--
--							LIBRER?A LCD
--
-- Descripci?n: Con ?sta librer?a podr?s implementar c?digos para una LCD 16x2 de manera
-- f?cil y r?pida, con todas las ventajas de utilizar una FPGA.
--
-- Caracter?sticas:
-- 
--	Los comandos que puedes utilizar son los siguientes:
--
-- LCD_INI() -> Inicializa la lcd.
--		 			 NOTA: Dentro de los par?ntesis poner un vector de 2 bits para encender o apagar
--					 		 el cursor y activar o desactivar el parpadeo.
--
--		"1x" -- Cursor ON
--		"0x" -- Cursor OFF
--		"x1" -- Parpadeo ON
--		"x0" -- Parpadeo OFF
--
--   Por ejemplo: LCD_INI("10") -- Inicializar LCD con cursor encendido y sin parpadeo 
--	
--			
-- CHAR() -> Manda una letra may?scula o min?scula
--
--				 IMPORTANTE: 1) Debido a que VHDL no es sensible a may?sculas y min?sculas, si se quiere
--								    escribir una letra may?scula se debe escribir una "M" antes de la letra.
--								 2) Si se quiere escribir la letra "S" may?scula, se declara "MAS"
--											
-- 	Por ejemplo: CHAR(A)  -- Escribe en la LCD la letra "a"
--						 CHAR(MA) -- Escribe en la LCD la letra "A"	
--						 CHAR(S)	 -- Escribe en la LCD la letra "s"
--						 CHAR(MAS)	 -- Escribe en la LCD la letra "S"	
--	
--
-- POS() -> Escribir en la posici?n que se indique.
--				NOTA: Dentro de los par?ntesis se dene poner la posici?n de la LCD a la que se quiere ir, empezando
--						por el rengl?n seguido de la posici?n vertical, ambos n?meros separados por una coma.
--		
--		Por ejemplo: POS(1,2) -- Manda cursor al rengl?n 1, poscici?n 2
--						 POS(2,4) -- Manda cursor al rengl?n 2, poscici?n 4		
--
--
-- CHAR_ASCII() -> Escribe un caracter a partir de su c?digo en ASCII
--						 NOTA: Dentro de los parentesis escribir x"(n?mero hex.)"
--
--		Por ejemplo: CHAR_ASCII(x"40") -- Escribe en la LCD el caracter "@"
--
--
-- CODIGO_FIN() -> Finaliza el c?digo. 
--						 NOTA: Dentro de los par?ntesis poner cualquier n?mero: 1,2,3,4...,8,9.
--
--
-- BUCLE_INI() -> Indica el inicio de un bucle. 
--						NOTA: Dentro de los par?ntesis poner cualquier n?mero: 1,2,3,4...,8,9.
--
--
-- BUCLE_FIN() -> Indica el final del bucle.
--						NOTA: Dentro de los par?ntesis poner cualquier n?mero: 1,2,3,4...,8,9.
--
--
-- INT_NUM() -> Escribe en la LCD un n?mero entero.
--					 NOTA: Dentro de los par?ntesis poner s?lo un n?mero que vaya del 0 al 9,
--						    si se quiere escribir otro n?mero entero se tiene que volver
--							 a llamar la funci?n
--
--
-- CREAR_CHAR() -> Funci?n que crea el caracter dise?ado previamente en "CARACTERES_ESPECIALES.vhd"
--                 NOTA: Dentro de los par?ntesis poner el nombre del caracter dibujado (CHAR1,CHAR2,CHAR3,..,CHAR8)
--								 
--
-- CHAR_CREADO() -> Escribe en la LCD el caracter creado por medio de la funci?n "CREAR_CHAR()"
--						  NOTA: Dentro de los par?ntesis poner el nombre del caracter creado.
--
--     Por ejemplo: 
--
--				Dentro de CARACTERES_ESPECIALES.vhd se dibujan los caracteres personalizados utilizando los vectores 
--				"CHAR_1", "CHAR_2","CHAR_3",...,"CHAR_7","CHAR_8"
--
--								 '1' => [#] - Se activa el pixel de la matr?z.
--                       '0' => [ ] - Se desactiva el pixel de la matriz.
--
-- 			Si se quiere crear el				Entonces CHAR_1 queda de la siguiente
--				siguiente caracter:					manera:
--												
--				  1  2  3  4  5						CHAR_1 <=
--  		  1 [ ][ ][ ][ ][ ]							"00000"&			
-- 		  2 [ ][ ][ ][ ][ ]							"00000"&			  
-- 		  3 [ ][#][ ][#][ ]							"01010"&   		  
-- 		  4 [ ][ ][ ][ ][ ]		=====>			"00000"&			   
-- 		  5 [#][ ][ ][ ][#]							"10001"&          
-- 		  6 [ ][#][#][#][ ]							"01110"&			  
-- 		  7 [ ][ ][ ][ ][ ]							"00000"&			  
-- 		  8 [ ][ ][ ][ ][ ]							"00000";			
--
--		
--			Como el caracter se cre? en el vector "CHAR_1",entonces se escribe en las funci?nes como "CHAR1"
--			
--			CREAR_CHAR(CHAR1)  -- Crea el caracter personalizado (CHAR1)
--			CHAR_CREADO(CHAR1) -- Muestra en la LCD el caracter creado (CHAR1)		
--
-- 
--
-- LIMPIAR_PANTALLA() -> Manda a limpiar la LCD.
--								 NOTA: ?sta funci?n se activa poniendo dentro de los par?ntesis
--										 un '1' y se desactiva con un '0'. 
--
--		Por ejemplo: LIMPIAR_PANTALLA('1') -- Limpiar pantalla est? activado.
--						 LIMPIAR_PANTALLA('0') -- Limpiar pantalla est? desactivado.
--
--
--	Con los puertos de entrada "CORD" y "CORI" se hacen corrimientos a la derecha y a la
--	izquierda respectivamente. NOTA: La velocidad del corrimiento se puede cambiar 
-- modificando la variable "DELAY_COR".
--
-- Algunas funci?nes generan un vector ("BLCD") cuando se termin? de ejecutar dicha funci?n y
--	que puede ser utilizado como una bandera, el vector solo dura un ciclo de instruccion.
--	   
--		LCD_INI() ---------- BLCD <= x"01"
--		CHAR() ------------- BLCD <= x"02"
--		POS() -------------- BLCD <= x"03"
-- 	INT_NUM() ---------- BLCD <= x"04"
--	   CHAR_ASCII() ------- BLCD <= x"05"
--	   BUCLE_INI() -------- BLCD <= x"06"
--		BUCLE_FIN() -------- BLCD <= x"07"
--		LIMPIAR_PANTALLA() - BLCD <= x"08"
--	   CREAR_CHAR() ------- BLCD <= x"09"
--	 	CHAR_CREADO() ------ BLCD <= x"0A"
--
--
--		?IMPORTANTE!
--		
--		1) Se deber? especificar el n?mero de instrucciones en la constante "NUM_INSTRUCCIONES". El valor 
--			de la ?ltima instrucci?n es el que se colocar?
--		2) En caso de utilizar a la librer?a como TOP del dise?o, se deber? comentar el puerto gen?rico y 
--			descomentar la constante "FPGA_CLK" para especificar la frecuencia de reloj.
--		3) Cada funci?n se acompa?a con " INST(NUM) <= <FUNCI?N> " como lo muestra en el c?digo
-- 		demostrativo.
--
--
--                C?DIGO DEMOSTRATIVO
--
--		CONSTANT NUM_INSTRUCCIONES : INTEGER := 7;
--
-- 	INST(0) <= LCD_INI("11"); 		-- INICIALIZAMOS LCD, CURSOR A HOME, CURSOR ON, PARPADEO ON.
-- 	INST(1) <= POS(1,1);				-- EMPEZAMOS A ESCRIBIR EN LA LINEA 1, POSICI?N 1
-- 	INST(2) <= CHAR(MH);				-- ESCRIBIMOS EN LA LCD LA LETRA "h" MAYUSCULA
-- 	INST(3) <= CHAR(O);			
-- 	INST(4) <= CHAR(L);
-- 	INST(5) <= CHAR(A);
-- 	INST(6) <= CHAR_ASCII(x"21"); -- ESCRIBIMOS EL CARACTER "!"
-- 	INST(7) <= CODIGO_FIN(1);	   -- FINALIZAMOS EL CODIGO
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use IEEE.std_logic_unsigned.ALL;
USE WORK.COMANDOS_LCD_REVD.ALL;

entity LIB_LCD_INTESC_REVD is

GENERIC(
			FPGA_CLK : INTEGER := 100_000_000
);


PORT(CLK: IN STD_LOGIC;

-----------------------------------------------------
------------------PUERTOS DE LA LCD------------------
	  RS 		  : OUT STD_LOGIC;							--
	  RW		  : OUT STD_LOGIC;							--
	  ENA 	  : OUT STD_LOGIC;							--
	  DATA_LCD : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);   --
-----------------------------------------------------
-----------------------------------------------------
	  
	  
-----------------------------------------------------------
--------------ABAJO ESCRIBE TUS PUERTOS--------------------	
      OS, S1 : IN STD_LOGIC;
      SDA, SCL : INOUT STD_LOGIC;
      RDY_O,ERR_O: OUT STD_LOGIC;
      temp_o: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
     -- OL1, OL2, OL3, OL4, L5, L6, L7, L8, L9, L10, L11, L12, L13, L14, L15, L16 : OUT STD_LOGIC
-----------------------------------------------------------
-----------------------------------------------------------

	  );

end LIB_LCD_INTESC_REVD;

architecture Behavioral of LIB_LCD_INTESC_REVD is


CONSTANT NUM_INSTRUCCIONES : INTEGER := 38; 	--INDICAR EL N?MERO DE INSTRUCCIONES PARA LA LCD


--------------------------------------------------------------------------------
-------------------------SE?ALES DE LA LCD (NO BORRAR)--------------------------
																										--
component PROCESADOR_LCD_REVD is																--
																										--
GENERIC(																								--
			FPGA_CLK : INTEGER := 50_000_000;												--
			NUM_INST : INTEGER := 38																--
);																										--
																										--
PORT( CLK 				 : IN  STD_LOGIC;														--
	   VECTOR_MEM 		 : IN  STD_LOGIC_VECTOR(8  DOWNTO 0);							--
	   C1A,C2A,C3A,C4A : IN  STD_LOGIC_VECTOR(39 DOWNTO 0);							--
	   C5A,C6A,C7A,C8A : IN  STD_LOGIC_VECTOR(39 DOWNTO 0);							--
	   RS 				 : OUT STD_LOGIC;														--
	   RW 				 : OUT STD_LOGIC;														--
	   ENA 				 : OUT STD_LOGIC;														--
	   BD_LCD 			 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);			         	--
	   DATA 				 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);							--
	   DIR_MEM 			 : OUT INTEGER RANGE 0 TO NUM_INSTRUCCIONES					--
	);																									--
																										--
end component PROCESADOR_LCD_REVD;															--
																										--
COMPONENT CARACTERES_ESPECIALES_REVD is													--
																										--
PORT( C1,C2,C3,C4 : OUT STD_LOGIC_VECTOR(39 DOWNTO 0);								--
		C5,C6,C7,C8 : OUT STD_LOGIC_VECTOR(39 DOWNTO 0)									--
	 );																								--
																										--
end COMPONENT CARACTERES_ESPECIALES_REVD;													--
                                                                                                        --
                                                                                                        
component one_shot is
    Port ( Din : in STD_LOGIC;
           clk : in STD_LOGIC;
           Qout : out STD_LOGIC);
end component;

component binary_bcd is
    generic(N: positive := 16);
    port(
        clk, reset: in std_logic;
        binary_in: in std_logic_vector(N-1 downto 0);
        bcd0, bcd1, bcd2, bcd3, bcd4: out std_logic_vector(3 downto 0)
    );
end component;

component BCDtoASCII is
  Port (num: in std_logic_vector(3 downto 0);
  asciinum: out std_logic_vector(7 downto 0 ) );
end component;

component TempSensorCtl is
	Generic (CLOCKFREQ : natural := 100); -- input CLK frequency in MHz
	Port (
		TMP_SCL : inout STD_LOGIC;
		TMP_SDA : inout STD_LOGIC;
      -- The Interrupt and Critical Temperature Signals
      -- from the ADT7420 Temperature Sensor are not used in this design
--		TMP_INT : in STD_LOGIC;
--		TMP_CT : in STD_LOGIC;		
		TEMP_O : out STD_LOGIC_VECTOR(12 downto 0); --12-bit two's complement temperature with sign bit
		RDY_O : out STD_LOGIC;	--'1' when there is a valid temperature reading on TEMP_O
		ERR_O : out STD_LOGIC; --'1' if communication error
		CLK_I : in STD_LOGIC;
		SRST_I : in STD_LOGIC
	);
end component;
                                                                                                        
CONSTANT CHAR1 : INTEGER := 1;																--
CONSTANT CHAR2 : INTEGER := 2;																--
CONSTANT CHAR3 : INTEGER := 3;																--
CONSTANT CHAR4 : INTEGER := 4;																--
CONSTANT CHAR5 : INTEGER := 5;																--
CONSTANT CHAR6 : INTEGER := 6;																--
CONSTANT CHAR7 : INTEGER := 7;																--
CONSTANT CHAR8 : INTEGER := 8;																--
																										--
type ram is array (0 to  NUM_INSTRUCCIONES) of std_logic_vector(8 downto 0); 	--
signal INST : ram := (others => (others => '0'));										--
																										--
signal blcd 			  : std_logic_vector(7 downto 0):= (others => '0');		--																										
signal vector_mem 	  : STD_LOGIC_VECTOR(8  DOWNTO 0) := (others => '0');		--
signal c1s,c2s,c3s,c4s : std_logic_vector(39 downto 0) := (others => '0');		--
signal c5s,c6s,c7s,c8s : std_logic_vector(39 downto 0) := (others => '0'); 	--
signal dir_mem 		  : integer range 0 to NUM_INSTRUCCIONES := 0;				--
																										--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
---------------------------AGREGA TUS SE?ALES AQU?------------------------------

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
TYPE CONTROL IS(lectura, fail, exito, PR1, R1, PR2, R2, PR3, R3, PR4, R4);
SIGNAL state : CONTROL := lectura;
SIGNAL P1, P2, P3, P4, B1 : STD_LOGIC;
SIGNAL CH1, CH2, CH3, CH4, CH5, CH6, CH7, CH8, CH9, CH10, CH11, CH12, CH13, CH14, CH15,
       CH16, CH17, CH18, CH19, CH20, CH21, CH22, CH23, CH24, CH25, CH26, CH27, CH28,
       CH29, CH30, CH31, CH32 : std_logic_vector(7 downto 0);
--signal auxSCL, auxSDA, auxRDY, auxERR : std_logic;
--signal   temp_menor : STD_LOGIC;
--signal auxtemp : unsigned(11 downto 0);
signal temp : std_logic_vector(12 downto 0);
signal reset: std_logic;
signal temp_aux: std_logic_vector(12 downto 0);--salida del tempsensor
signal tautemp: integer:=625;-- constante para conseguir la temp_aux en celsius
signal punto: integer:=100;-- dividimos 
signal temp_unsigned: unsigned(23 downto 0);-- conserva la temp real en celsius pero unsigned
signal temp_celsiusb: std_logic_vector(15 downto 0);-- temp real 
signal bcd0, bcd1, bcd2, bcd3, bcd4:  std_logic_vector(3 downto 0);--temp en bcd
--signal temp_o: std_logic_vector(15 downto 0);
signal temp0ch,temp1ch,temp2ch,temp3ch: std_logic_vector(7 downto 0);
signal temp_registrada: std_logic_vector(15 downto 0):="0000000000000000";
signal bcd0flag, bcd1flag, bcd2flag, bcd3flag, bcd4flag:  std_logic_vector(3 downto 0);--temp en bcd

begin


---------------------------------------------------------------
-------------------COMPONENTES PARA LCD------------------------
																				 --
u1: PROCESADOR_LCD_REVD													 --
GENERIC map( FPGA_CLK => FPGA_CLK,									 --
				 NUM_INST => NUM_INSTRUCCIONES )						 --
																				 --
PORT map( CLK,VECTOR_MEM,C1S,C2S,C3S,C4S,C5S,C6S,C7S,C8S,RS, --
			 RW,ENA,BLCD,DATA_LCD, DIR_MEM );						 --
																				 --
U2 : CARACTERES_ESPECIALES_REVD 										 --
PORT MAP( C1S,C2S,C3S,C4S,C5S,C6S,C7S,C8S );				 		 --
																				 --
VECTOR_MEM <= INST(DIR_MEM);											 --
																				 --
---------------------------------------------------------------
---------------------------------------------------------------
OS1 : one_shot port map (Din => OS, clk => clk, Qout => B1);
TC1: TempSensorCtl port map (TMP_SCL => SCL, TMP_SDA => SDA, TEMP_O => temp, RDY_O => RDY_O,
                             ERR_O => ERR_O, CLK_I => clk, SRST_I => '0');
                             
                             
               temp_unsigned<=(to_unsigned(natural(tautemp),12)*unsigned(temp(11 downto 0)))/(to_unsigned(natural(punto),12));
                             
                             temp_celsiusb<= std_logic_vector(temp_unsigned(15 downto 0));
                             bcdtemp: binary_bcd
                             generic map (N => 16)
                             port map (
                             clk =>clk,
                             reset=>reset,
                             binary_in=>temp_celsiusb,
                             bcd0=>bcd0,
                             bcd1=>bcd1,
                             bcd2=>bcd2,
                             bcd3=> bcd3,
                             bcd4=> bcd4);
                             
                             
                             temp_o<=bcd3&bcd2&bcd1&bcd0;
                             
                             temp0ascii: BCDtoASCII port map(bcd0, temp0ch);
                             temp1ascii: BCDtoASCII port map(bcd1, temp1ch);
                             temp2ascii: BCDtoASCII port map(bcd2, temp2ch);
                             temp3ascii: BCDtoASCII port map(bcd3, temp3ch);
--                OL4 <= temp(0);
--                L5 <= temp(1);
--                L6 <= temp(2);
--                L7 <= temp(3);
--                L8 <= temp(4);
--                L9 <= temp(5);
--                L10 <= temp(6);
--                L11 <= temp(7);
--                L12 <= temp(8);
--                                L13 <= temp(9);
--                                L14 <= temp(10);
--                                L15 <= temp(11);
--                                L16 <= temp(12);
                

                INST(0) <= LCD_INI("10");
                INST(1) <= BUCLE_INI(1);
                INST(2) <= POS(1,1);
                INST(3) <= CHAR_ASCII(CH1);
                INST(4) <= CHAR_ASCII(CH2);
                INST(5) <= CHAR_ASCII(CH3);
                INST(6) <= CHAR_ASCII(CH4);
                INST(7) <= CHAR_ASCII(CH5);
                INST(8) <= CHAR_ASCII(CH6);
                INST(9) <= CHAR_ASCII(CH7);
                INST(10) <= CHAR_ASCII(CH8);
                INST(11) <= CHAR_ASCII(CH9);
                INST(12) <= CHAR_ASCII(CH10);
                INST(13) <= CHAR_ASCII(CH11);
                INST(14) <= CHAR_ASCII(CH12);
                INST(15) <= CHAR_ASCII(CH13);
                INST(16) <= CHAR_ASCII(CH14);
                INST(18) <= CHAR_ASCII(CH15);
                INST(19) <= CHAR_ASCII(CH16);
                INST(17) <= POS(2,1);
                INST(20) <= CHAR_ASCII(CH17);
                INST(21) <= CHAR_ASCII(CH18);
                INST(22) <= CHAR_ASCII(CH19);
                INST(23) <= CHAR_ASCII(CH20);
                INST(24) <= CHAR_ASCII(CH21);
                INST(25) <= CHAR_ASCII(CH22);
                INST(26) <= CHAR_ASCII(CH23);
                INST(27) <= CHAR_ASCII(CH24);
                INST(28) <= CHAR_ASCII(CH25);
                INST(29) <= CHAR_ASCII(CH26);
                INST(30) <= CHAR_ASCII(CH27);
                INST(31) <= CHAR_ASCII(CH28);
                INST(32) <= CHAR_ASCII(CH29);
                INST(33) <= CHAR_ASCII(CH30);
                INST(34) <= CHAR_ASCII(CH31);
                INST(35) <= CHAR_ASCII(CH32);
                INST(36) <= BUCLE_FIN(1);
                INST(37) <= CODIGO_FIN(1);

        process(clk)
            begin
            if (clk'event and clk = '1') then
                
               case state is

                   when lectura => 
                         CH1 <= "00100000";--spacio
                                           CH2 <= "00100000";--spacio
                                           CH3 <= "00100000";--spacio
                                           CH4 <= "00100000";--spacio
                                           CH5 <= "00100000";--spacio
                                           CH6 <= "00100000";--spacio
                                           CH7 <= temp3ch;--temp3ch;--temp en bcd 3
                                           CH8 <= temp2ch;--temp2ch;--temp en bcd 2
                                           CH9 <= "00101110";--punto decimal
                                           CH10 <= temp1ch;--temp1ch;--temp en bcd 1
                                           CH11 <= temp0ch;--temp0ch;--temp en bcd 0
                                           CH12 <= "11011111";--spacio
                                           CH13 <= "01000011";--spacio
                                           CH14 <= "00100000";--spacio
                                           CH15 <= "00100000";--spacio
                                           CH16 <= "00100000";--spacio
                                           CH17 <= "01010000";--P
                                           CH18 <= "01101111";--o
                                           CH19 <= "01101110";--n
                                           CH20 <= "00100000";--spacio
                                           CH21 <= "01110100";--t
                                           CH22 <= "01110101";--u
                                           CH23 <= "00100000";--spacio
                                           CH24 <= "01100100";--d
                                           CH25 <= "01100101";--e
                                           CH26 <= "01100100";--d
                                           CH27 <= "01101111";--o
                                           CH28 <= "00100000";--spacio
                                           CH29 <= "00111010";--:
                                           CH30 <= "00101001";--)
                                           CH31 <= "00100000";--spacio
                                           CH32 <= "00100000";--spacio
                                           
                                           if( B1= '1') then 
--                                            bcd3flag<=bcd3;
--                                            bcd2flag<=bcd2;
--                                            state<= PR1;
                                                if(bcd3 <= "0010" AND bcd2 <= "0101") then
                                                    state <= PR1;
                                                else
                                                    state <= fail;
                                                end if;
                                           end if;
                                          
                        
                   when PR1 =>
                  
 --                      if ((bcd3<"0010") and bcd2<"0101") then -- temperatura limite es igual a 28C, (28,000)
                                           CH1 <= "01001000";--H
                                           CH2 <= "01100001";--a
                                           CH3 <= "01110011";--s
                                           CH4 <= "00100000";--spacio
                                           CH5 <= "01110000";--p
                                           CH6 <= "01110010";--r
                                           CH7 <= "01100101";--e
                                           CH8 <= "01110011";--s
                                           CH9 <= "01100101";--e
                                           CH10 <= "01101110";--n
                                           CH11 <= "01110100";--t
                                           CH12 <= "01100001";--a
                                           CH13 <= "01100100";--d
                                           CH14 <= "01101111";--o
                                           CH15 <= "00100000";--spacio
                                           CH16 <= "01110100";--t
                                           CH17 <= "01101111";--o
                                           CH18 <= "01110011";--s
                                           CH19 <= "00111111";--?
                                           CH20 <= "00100000";--spacio
                                           CH21 <= "00100000";--spacio
                                           CH22 <= "00100000";--spacio
                                           CH23 <= "00100000";--spacio
                                           CH24 <= "00100000";--spacio
                                           CH25 <= "00100000";--spacio
                                           CH26 <= "00100000";--spacio
                                           CH27 <= "00100000";--spacio
                                           CH28 <= "00100000";--spacio
                                           CH29 <= "00100000";--spacio
                                           CH30 <= "00100000";--spacio
                                           CH31 <= "00100000";--spacio
                                           CH32 <= "00100000";--spacio
                        state <= R1;
--                    else 
--                        state <= fail;
--                    end if;

                    when R1 =>

                        if B1 = '1' then
                            --1 es si, 0 es no

                            P1 <= S1;
                            state <= PR2;
                        end if;

                    when PR2 =>

                        IF (P1 = '0') THEN
                                                   CH1 <= "01010100"; --T
                                                   CH2 <= "01101001"; --i
                                                   CH3 <= "01100101"; --e
                                                   CH4 <= "01101110"; --n
                                                   CH5 <= "01100101"; --e
                                                   CH6 <= "00100000"; -- espacio
                                                   CH7 <= "01100100"; --d
                                                   CH8 <= "01101111"; --o
                                                   CH9 <= "01101100"; --l
                                                   CH10 <= "01101111";--o
                                                   CH11 <= "01110010"; --r
                                                   CH12 <= "00100000";--spacio
                                                   CH13 <= "01100100"; --d
                                                   CH14 <= "01100101";--e
                                                   CH15 <= "00100000"; --spacio
                                                   CH16 <= "01100011"; --c
                                                   CH17 <= "01100001"; --a
                                                   CH18 <= "01100010"; --b
                                                   CH19 <= "01100101"; --e
                                                   CH20 <= "01111010"; --z
                                                   CH21 <= "01100001"; --a
                                                   CH22 <= "00111111";--?
                                                   CH23 <= "00100000"; --spacio
                                                   CH24 <= "00100000";--spacio
                                                   CH25 <= "00100000"; --spacio
                                                   CH26 <= "00100000";--spacio
                                                   CH27 <= "00100000";--spacio
                                                   CH28 <= "00100000";--spacio
                                                   CH29 <= "00100000";--spacio
                                                   CH30 <= "00100000";--spacio
                                                   CH31 <= "00100000";--spacio
                                                   CH32 <= "00100000";--spacio

                            state <= R2;
                        ELSE 
                            state <= fail;
                        end if;
                        
                    when R2 =>

                        if B1 = '1' then
                            --1 es si, 0 es no
                            P2 <= S1;
                            state <= PR3;
                        end if;

                    when PR3 =>

                        IF (P2 = '0') THEN 
                            CH1 <= "01001000";--H
                                                   CH2 <= "01100001";--a
                                                   CH3 <= "01110011";--s
                                                   CH4 <= "00100000";--spacio
                                                   CH5 <= "01100101";--e
                                                   CH6 <= "01110011";--s
                                                   CH7 <= "01110100";--t
                                                   CH8 <= "01100001";--a
                                                   CH9 <= "01100100";--d
                                                   CH10 <= "01101111"; --o
                                                   CH11 <= "00100000";--spacio
                                                   CH12 <= "01100011"; --c
                                                   CH13 <= "01101111"; --o
                                                   CH14 <= "01101110";--n
                                                   CH15 <= "00100000";--spacio
                                                   CH16 <= "01100001"; --a
                                                   CH17 <= "01101100";--l
                                                   CH18 <= "01100111";--g
                                                   CH19 <= "01110101";--u
                                                   CH20 <= "01101110"; --n
                                                   CH21 <= "00100000"; --spacio
                                                   CH22 <= "01100011"; --c
                                                   CH23 <= "01101111";--o
                                                   CH24 <= "01101110"; --n
                                                   CH25 <= "01110100"; --t
                                                   CH26 <= "01100001";--a
                                                   CH27 <= "01100111";--g
                                                   CH28 <= "01101001";--i
                                                   CH29 <= "01100001";--a
                                                   CH30 <= "01100100"; --d
                                                   CH31 <= "01101111";--o
                                                   CH32 <= "00111111";--?

                            state <= R3;
                        ELSE 
                            state <= fail;
                        end if;
                        
                    when R3 =>

                        if B1 = '1' then
                            --1 es si, 0 es no
                            P3 <= S1;
                            state <= PR4;
                        end if;

                    when PR4 =>
                        IF (P3 = '0') THEN
                            CH1 <= "01010100";--T
                                                   CH2 <= "01100101";--e
                                                   CH3 <= "00100000";--spacio
                                                   CH4 <= "01101000"; --h
                                                   CH5 <= "01100001"; --a
                                                   CH6 <= "01110011"; --s
                                                   CH7 <= "00100000";--spacio
                                                   CH8 <= "01110011";--s
                                                   CH9 <= "01100101";--e
                                                   CH10 <= "01101110";--n
                                                   CH11 <= "01110100";--t
                                                   CH12 <= "01101001"; --i
                                                   CH13 <= "01100100";--d
                                                   CH14 <= "01101111"; --o
                                                   CH15 <= "00100000"; --spacio
                                                   CH16 <= "01100110"; --f
                                                   CH17 <= "01100001";--a
                                                   CH18 <= "01110100";--t
                                                   CH19 <= "01101001";--i
                                                   CH20 <= "01100111"; --g
                                                   CH21 <= "01100001"; --a
                                                   CH22 <= "01100100";--d
                                                   CH23 <= "01000000";--@
                                                   CH24 <= "00111111";--?
                                                   CH25 <= "00100000";--spacio
                                                   CH26 <= "00100000";--spacio
                                                   CH27 <= "00100000";--spacio
                                                   CH28 <= "00100000";--spacio
                                                   CH29 <= "00100000";--spacio
                                                   CH30 <= "00100000";--spacio
                                                   CH31 <= "00100000";--spacio
                                                   CH32 <= "00100000";--spacio

                            state <= R4;
                        ELSE 
                            state <= fail;
                        end if;
                when R4 =>

                    if B1 = '1' then
                        --1 es si, 0 es no
                        P2 <= S1;
                        if S1 =  '1' then 
                        state <= fail;
                        else 
                        state<= EXITO;
                        end if;
                    end if;

                when EXITO =>
                                    CH1 <= "00100000";--spacio
                                    CH2 <= "00100000";--spacio
                                    CH3 <= "01010000"; --P
                                    CH4 <= "01110101"; --u
                                    CH5 <= "01100101";--e
                                    CH6 <= "01100100"; --d
                                    CH7 <= "01110101";--e
                                    CH8 <= "00100000"; --spacio
                                    CH9 <= "00100000";--spacio
                                    CH10 <= "01110000";--p
                                    CH11 <= "01100001";--a
                                    CH12 <= "01110011";--s
                                    CH13 <= "01100001";--a
                                    CH14 <= "01110010";--r
                                    CH15 <= "00100000";--spacio
                                    CH16 <= "00100000";--spacio
                                    CH17 <= "01110011";--s
                                    CH18 <= "01110101";--u
                                    CH19 <= "01110011";--s
                                    CH20 <= "01100001";--a
                                    CH21 <= "01101110";--n
                                    CH22 <= "01100001";--a
                                    CH23 <= "00100000";--spacio
                                    CH24 <= "01100100";--d
                                    CH25 <= "01101001";--i
                                    CH26 <= "01110011";--s
                                    CH27 <= "01110100";--t
                                    CH28 <= "01100001";--a
                                    CH29 <= "01101110";--n
                                    CH30 <= "00100000";--c
                                    CH31 <= "01101001";--i
                                    CH32 <= "01100001";--a

                    
                    if B1 = '1' then
                        state <= lectura;
                    end if;

                when FAIL =>
                                   CH1 <= "01001110"; --N
                                   CH2 <= "01101111";--o
                                   CH3 <= "00100000";--spacio
                                   CH4 <= "01110101";--p
                                   CH5 <= "01100001";--a
                                   CH6 <= "01110011";--s
                                   CH7 <= "01100001";--a
                                   CH8 <= "01110010"; --r
                                   CH9 <= "00101100";--,
                                   CH10 <= "00100000";--spacio
                                   CH11 <= "01100001"; --a
                                   CH12 <= "01100011";--c
                                   CH13 <= "01110101";--u
                                   CH14 <= "01100100";--d
                                   CH15 <= "01100001";--a
                                   CH16 <= "00100000";--spacio
                                   CH17 <= "01100011"; --c
                                   CH18 <= "01101111"; --o
                                   CH19 <= "01101110";--n
                                   CH20 <= "00100000";--spacio
                                   CH21 <= "01110101";--u
                                   CH22 <= "01101110";--n
                                   CH23 <= "00100000";--spacio
                                   CH24 <= "01100100";--d
                                   CH25 <= "01101111";--o
                                   CH26 <= "01100011";--c
                                   CH27 <= "01110100";--t
                                   CH28 <= "01101111";--o
                                   CH29 <= "01110010";--r
                                   CH30 <= "00100000";--spacio
                                   CH31 <= "00100000";--spacio
                                   CH32 <= "00100000";--spacio

                    if B1 = '1' then
                        state <= lectura;
                    end if;
                        
                when others => null;
				end case;
            end if;
        end process;
end Behavioral;
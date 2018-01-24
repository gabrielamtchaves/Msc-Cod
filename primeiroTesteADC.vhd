----------------------------------------
-- Universidade Federal do Rio de Janeiro
-- Programa de engenharia eletrica - COPPE
----------------------------------------
-- primeiroTesteADC.vhd
-- Author: Gabriela M T Chaves
-- Jan 2018
--
-- Primeira leitura do AD.
--
----------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity primeiroTesteADC is
	port(
			led1			: buffer std_logic; -- Buffer pois led <= not led
			led2			: buffer std_logic; -- Buffer pois led <= not led
			clk_in_adc	: out 	std_logic; -- SCLK do ADC
			config_ad	: out 	std_logic; -- SDI do ADC - Configuracao do chip de AD
			dados_in		: in 		std_logic; -- Leitura dos dados digitalizados em SERIE
			convst		: out 	std_logic; -- Chip select - pulso de inicializacao da conversao
			clk_50mhz	: in 		std_logic  -- Clock do sistema, 50 MHz
			);
end primeiroTesteADC;


architecture behavioral of primeiroTesteADC is -- EH BEHAVIORAL MESMO?
	-----------------
	constant tWHconv	: time := 20 ns; 	-- min 20ns
	constant tconv		: time := 1.6 us; -- 1.3 a 1.6 us
	constant tHconvst	: time := 20 ns; 	-- min 20ns
	-----------------
	signal contador1	: natural range 0 to 50000000;
	signal contador2	: natural range 0 to 50000000;
	signal clk_25mhz	: std_logic;
	signal aux_clk		: std_logic;
	-----------------
	COMPONENT FF_DQ is
		port (clk, D: in std_logic; Q, nQ: out std_logic);
	end COMPONENT;
	-----------------
begin
	-----------------
	FF1: FF_DQ port map (clk_50mhz, aux_clk, clk_25mhz, aux_clk); -- Flipflop divisor de clock
	-----------------
	process(clk_50mhz)
	begin
	if rising_edge(clk_50mhz) then
		contador1 <= contador1 + 1;
		if contador1 = 10000000 then
			led1 <= not led1;
		elsif contador1 = 50000000 then 
			contador1 <= 0;
			led1 <= not led1;
		end if;
	end if;
	end process;
	-----------------
		process(clk_25mhz)
	begin
	if rising_edge(clk_25mhz) then
		contador2 <= contador2 + 1;
		if contador2 = 10000000 then
			led2 <= not led2;
		elsif contador2 = 50000000 then 
			contador2 <= 0;
			led2 <= not led2;
		end if;
	end if;
	end process;
	-----------------
end behavioral;


----------------------------------------
-- FIM DO CODIGO
----------------------------------------
----------------------------------------
-- Universidade Federal do Rio de Janeiro
-- Programa de engenharia eletrica - COPPE
----------------------------------------
-- primeiroTesteADC.vhd
-- Author: Gabriela M T Chaves
-- Jan 2018
--
-- Primeira leitura do AD. Para gerar as entradas de controle do AD, usa-se uma
-- 	maquina de estados.
--
----------------------------------------


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


ENTITY primeiroTesteADC IS
	port(
			-----------------
			led1			: buffer std_logic; -- Buffer pois led <= not led
			led2			: buffer std_logic; -- Buffer pois led <= not led
			led3			: buffer std_logic; -- Buffer pois led <= not led
			led4			: buffer std_logic; -- Buffer pois led <= not led
			led5			: buffer std_logic; -- Buffer pois led <= not led
			led6			: buffer std_logic; -- Buffer pois led <= not led
			-----------------
			clk_in_adc	: out 	std_logic; -- SCLK do ADC
			config_ad	: out 	std_logic; -- SDI do ADC - Configuracao do chip de AD
			dados_in		: in 		std_logic; -- Leitura dos dados digitalizados em SERIE
			convst		: out 	std_logic; -- Chip select - pulso de inicializacao da conversao
			clk_50mhz	: in 		std_logic; -- Clock do sistema, 50 MHz
			-----------------
			reset			: in		std_logic; -- Reset manual (botao 2)
			input			: in		std_logic  -- Selecao manual (chave 9)
			);
END primeiroTesteADC;


ARCHITECTURE behavioral OF primeiroTesteADC IS -- EH BEHAVIORAL MESMO?
	-----------------
	constant tWHconv	: time := 20 ns; 	-- min 20ns
	constant tconv		: time := 1.6 us; -- 1.3 a 1.6 us
	constant tHconvst	: time := 20 ns; 	-- min 20ns
	constant tACQ		: time := 240 ns;	-- min 240ns
	-----------------
	signal contador1	: natural range 0 to 50000000;
	signal contador2	: natural range 0 to 50000000;
	signal clk_25mhz	: std_logic;
	signal aux_clk		: std_logic;
	-----------------
	type tiposEstados	is (S0, S1, S2, S3, S4);
	signal estado		: tiposEstados;
	-----------------
	COMPONENT FF_DQ is
		port (clk, D: in std_logic; Q, nQ: out std_logic);
	end COMPONENT;
	-----------------
BEGIN
	-----------------
	-- Flipflop divisor de clock
	FF1: FF_DQ port map (clk_50mhz, aux_clk, clk_25mhz, aux_clk);
	-----------------
	
	process(clk_25mhz)
	begin
		if rising_edge(clk_25mhz) then
		contador1 <= contador1 + 1;
			if contador1 = 50000000 then
				contador1 <= 0;
				led1 <= not led1;
			end if;
		end if;
	end process;
	-----------------
	process(clk_25mhz)
	begin
	if reset = '1' then
		estado <= S0;
	elsif (contador1 = 50000000) then
		case estado is
			when S0 =>
				if input = '1' then
					estado <= S1;
					led2 <= '0';
            else
					estado <= S0;
					led2 <= '1';
            end if;
			when S1 =>
				if input = '1' then
					estado <= S2;
					led3 <= '0';
            else
					estado <= S1;
					led3 <= '1';
            end if;
			when S2 =>
				if input = '1' then
					estado <= S3;
					led4 <= '0';
            else
					estado <= S2;
					led4 <= '1';
            end if;
			when S3 =>
				if input = '1' then
					estado <= S4;
					led5 <= '0';
            else
					estado <= S3;
					led5 <= '1';
            end if;
			when S4 =>
				if input = '1' then
					estado <= S1;
					led6 <= '0';
            else
					estado <= S4;
					led6 <= '1';
            end if;
		end case;
	end if; -- IF RESET
	end process;
--	-----------------
--	process (estado)
--   begin
--      case estado is
--         when S0 =>
--            led1 <= '0';
--				led2 <= '0';
--         when S1 =>
--            led1 <= '0';
--				led2 <= '1';
--         when S2 =>
--            led1 <= '1';
--				led2 <= '0';
--			when S3 =>
--            led1 <= '1';
--				led2 <= '1';
--			when S4 =>
--            led1 <= '0';
--				led2 <= '0';
--      end case;
--   end process;
	----------------
END behavioral;


----------------------------------------
-- FIM DO CODIGO
----------------------------------------
----------------------------------------
-- Universidade Federal do Rio de Janeiro
-- Programa de engenharia eletrica - COPPE
----------------------------------------
-- FF_DQ.vhd
-- Author: Gabriela M T Chaves
-- Jan 2018
--
-- Componente flip flop tipo DQ com duas entrada e duas saidas
--
----------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity FF_DQ is
	port(
			clk, D		: in 	std_logic;
			Q, nQ			: out std_logic
			);
end FF_DQ;


architecture behavioral of FF_DQ is
begin
	process(clk)
	begin
	if rising_edge(clk) then
		Q <= D;
		nQ <= not D;
	end if;
	end process;
end behavioral;


----------------------------------------
-- FIM DO CODIGO
----------------------------------------
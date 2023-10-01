--------------------------------------------------------------------------------
-- Module Types
--
-- We have to do this here, or we can't use the types in the port list
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package counter_pkg is

    generic (
        WIDTH: integer := 10
    );

    subtype count_vector_t is std_logic_vector(WIDTH-1 downto 0);
    subtype count_t is unsigned(WIDTH-1 downto 0);

end package counter_pkg;

--------------------------------------------------------------------------------
-- Module Logic
--------------------------------------------------------------------------------

package counter_pkg_inst is new work.counter_pkg
    generic map(WIDTH => 10);

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.counter_pkg_inst.all;

entity counter is

    generic (
        WIDTH: integer := count_vector_t'length
    );

    port (
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_en : in std_logic;
        i_clear : in std_logic;
        o_count : out count_vector_t
    );

end counter;

architecture only of counter is

    signal count : count_t := (others => '0');
    signal next_count : count_t := (others => '0');

begin

    -- Convert unsigned to bits
    o_count <= std_logic_vector(count);

    -- Compute next value
    process(all) begin
        if i_clear = '1' then
            next_count <= (others => '0');
        else
            -- I think, technically, we have to be explicit about wrapping
            if count = to_unsigned(2**WIDTH-1, WIDTH) then
                next_count <= (others => '0');
            else
                next_count <= count + 1;
            end if;
        end if;
    end process;

    -- Update count register
    process(i_clk) begin
        if rising_edge(i_clk) then
            if i_rst = '1' then
                count <= (others => '0');
            elsif i_en = '1' then
                count <= next_count;
            end if;
        end if;
    end process;

end only;

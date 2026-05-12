/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 29/10/2025
DROP TRIGGER IF EXISTS gw_trg_fk_array_id_table ON arc;
DROP TRIGGER IF EXISTS gw_trg_fk_array_id_table_update ON arc;
CREATE TRIGGER gw_trg_fk_array_id_table BEFORE DELETE ON arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('arc_id', '{"man_source":"inlet_arc", "man_tank":"inlet_arc", "man_wtp":"inlet_arc", "man_waterwell":"inlet_arc", "man_valve":"to_arc", "man_pump":"to_arc", "man_meter":"to_arc", "man_frelem":"to_arc"}');

CREATE TRIGGER gw_trg_fk_array_id_table_update AFTER UPDATE ON arc
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_id_table('arc_id', '{"man_source":"inlet_arc", "man_tank":"inlet_arc", "man_wtp":"inlet_arc", "man_waterwell":"inlet_arc", "man_valve":"to_arc", "man_pump":"to_arc", "man_meter":"to_arc", "man_frelem":"to_arc"}');

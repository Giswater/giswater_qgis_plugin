/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE arc_type DROP CONSTRAINT IF EXISTS arc_type_epa_table_check;
ALTER TABLE arc_type DROP CONSTRAINT IF EXISTS arc_type_man_table_check;

ALTER TABLE node_type DROP CONSTRAINT IF EXISTS node_type_epa_table_check;
ALTER TABLE node_type DROP CONSTRAINT IF EXISTS node_type_man_table_check;

ALTER TABLE connec_type DROP CONSTRAINT IF EXISTS connec_type_man_table_check;

ALTER TABLE gully_type DROP CONSTRAINT IF EXISTS gully_type_man_table_check;


ALTER TABLE arc_type ADD CONSTRAINT arc_type_epa_table_check CHECK (epa_table IN ('inp_conduit', 'inp_orifice', 'inp_outlet','inp_virtual','inp_pump', 'inp_weir'));

ALTER TABLE arc_type ADD CONSTRAINT arc_type_man_table_check CHECK (man_table IN ('man_conduit', 'man_waccel', 'man_varc', 'man_siphon'));

ALTER TABLE node_type ADD CONSTRAINT node_type_epa_table_check CHECK (epa_table IN ('inp_junction', 'inp_divider', 'inp_storage', 'inp_outfall'));

ALTER TABLE node_type ADD CONSTRAINT node_type_man_table_check CHECK (man_table IN ('man_chamber', 'man_junction', 'man_manhole', 'man_netelement', 'man_netgully',
'man_netinit', 'man_outfall', 'man_storage', 'man_valve', 'man_wjump', 'man_wwtp'));

ALTER TABLE connec_type ADD CONSTRAINT connec_type_man_table_check CHECK (man_table IN ('man_connec'));

ALTER TABLE gully_type ADD CONSTRAINT gully_type_man_table_check CHECK (man_table IN ('man_gully'));
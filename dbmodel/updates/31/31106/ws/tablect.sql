/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--DROP
ALTER TABLE  arc_type  DROP CONSTRAINT IF EXISTS arc_type_epa_table_check;
ALTER TABLE  node_type  DROP CONSTRAINT IF EXISTS node_type_epa_table_check;
ALTER TABLE  arc_type  DROP CONSTRAINT IF EXISTS arc_type_man_table_check;
ALTER TABLE  node_type  DROP CONSTRAINT IF EXISTS node_type_man_table_check;
ALTER TABLE  connec_type  DROP CONSTRAINT IF EXISTS connec_type_man_table_check;

--ADD
ALTER TABLE arc_type ADD CONSTRAINT arc_type_epa_table_check CHECK (epa_table IN ('inp_pipe'));

ALTER TABLE node_type ADD CONSTRAINT node_type_epa_table_check CHECK (epa_table IN ('inp_junction', 'inp_pump', 'inp_reservoir', 'inp_tank', 'inp_valve', 'inp_shortpipe'));

ALTER TABLE arc_type ADD CONSTRAINT arc_type_man_table_check CHECK (man_table IN ('man_pipe', 'man_varc'));

ALTER TABLE node_type ADD CONSTRAINT node_type_man_table_check CHECK (man_table IN ('man_expansiontank', 'man_tank', 'man_filter', 'man_flexunion', 'man_hydrant',
'man_junction', 'man_manhole', 'man_meter', 'man_netelement', 'man_netsamplepoint', 'man_netwjoin', 'man_pump', 'man_reduction', 'man_register', 'man_source', 'man_tank',
'man_valve', 'man_waterwell', 'man_wtp'));

ALTER TABLE connec_type ADD CONSTRAINT connec_type_man_table_check CHECK (man_table IN ('man_fountain', 'man_greentap', 'man_tap', 'man_wjoin'));
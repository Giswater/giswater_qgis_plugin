/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2020/12/14
ALTER TABLE sys_feature_cat ADD COLUMN man_table character varying(30);

UPDATE sys_feature_cat SET man_table = f.man_table FROM cat_feature_gully f WHERE sys_feature_cat.id=f.type;

ALTER TABLE cat_feature_gully DROP COLUMN man_table;

ALTER TABLE inp_arc_type ADD COLUMN epa_table character varying(30);
ALTER TABLE inp_node_type ADD COLUMN epa_table character varying(30);

UPDATE inp_arc_type SET epa_table = f.epa_table FROM cat_feature_arc f WHERE inp_arc_type.id=f.epa_default;
UPDATE inp_arc_type SET epa_table = 'inp_outlet' where id = 'OUTLET';
UPDATE inp_arc_type SET epa_table = 'inp_orifice' where id = 'ORIFICE';
UPDATE inp_arc_type SET epa_table = 'inp_pump' where id = 'PUMP';
UPDATE inp_arc_type SET epa_table = 'inp_virtual' where id = 'VIRTUAL';
UPDATE inp_arc_type SET epa_table = 'inp_weir' where id = 'WEIR';

UPDATE inp_node_type SET epa_table = f.epa_table FROM cat_feature_node f WHERE inp_node_type.id=f.epa_default;
UPDATE inp_node_type SET epa_table = 'inp_divider' where id = 'DIVIDER';

ALTER TABLE cat_feature_node DROP COLUMN epa_table;
ALTER TABLE cat_feature_arc DROP COLUMN epa_table;

INSERT INTO sys_feature_epa_type SELECT id, 'NODE', epa_table FROM inp_node_type;
INSERT INTO sys_feature_epa_type SELECT id, 'ARC', epa_table FROM inp_arc_type;

ALTER TABLE cat_feature_arc ADD CONSTRAINT cat_feature_arc_inp_check CHECK (epa_default = ANY(ARRAY['CONDUIT', 'WEIR', 'ORIFICE', 'VIRTUAL', 'PUMP', 'OUTLET', 'NOT DEFINED']));
ALTER TABLE cat_feature_node ADD CONSTRAINT cat_feature_node_inp_check CHECK (epa_default = ANY(ARRAY['JUNCTION', 'STORAGE', 'DIVIDER', 'OUTFALL', 'NOT DEFINED']));

ALTER TABLE cat_feature_node DROP CONSTRAINT cat_feature_node_epa_default_fkey;
ALTER TABLE cat_feature_arc DROP CONSTRAINT cat_feature_arc_epa_default_fkey;

ALTER TABLE arc ADD CONSTRAINT cat_feature_arc_inp_check CHECK (epa_type = ANY(ARRAY['CONDUIT', 'WEIR', 'ORIFICE', 'VIRTUAL', 'PUMP', 'OUTLET', 'NOT DEFINED']));
ALTER TABLE node ADD CONSTRAINT cat_feature_node_inp_check CHECK (epa_type = ANY(ARRAY['JUNCTION', 'STORAGE', 'DIVIDER', 'OUTFALL', 'NOT DEFINED']));

ALTER TABLE node DROP CONSTRAINT node_epa_type_fkey ;
ALTER TABLE arc DROP CONSTRAINT arc_epa_type_fkey ;

DROP TABLE IF EXISTS inp_node_type;
DROP TABLE IF EXISTS inp_arc_type;
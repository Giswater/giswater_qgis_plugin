/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/02/27
UPDATE sys_feature_epa_type SET active = true;
UPDATE sys_feature_epa_type SET active = false WHERE id IN ('DIVIDER');

UPDATE config_form_fields SET dv_querytext = 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active 
AND feature_type = ''NODE'''  WHERE columnname = 'epa_type' AND formname like '%_arc%';
UPDATE config_form_fields SET dv_querytext = 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active 
AND feature_type = ''ARC'''  WHERE columnname = 'epa_type' AND formname like '%_node%';

UPDATE sys_feature_cat SET man_table = f.man_table FROM cat_feature_gully f WHERE sys_feature_cat.id=f.type;

UPDATE inp_arc_type SET epa_table = f.epa_table FROM cat_feature_arc f WHERE inp_arc_type.id=f.epa_default;
UPDATE inp_arc_type SET epa_table = 'inp_outlet' where id = 'OUTLET';
UPDATE inp_arc_type SET epa_table = 'inp_orifice' where id = 'ORIFICE';
UPDATE inp_arc_type SET epa_table = 'inp_pump' where id = 'PUMP';
UPDATE inp_arc_type SET epa_table = 'inp_virtual' where id = 'VIRTUAL';
UPDATE inp_arc_type SET epa_table = 'inp_weir' where id = 'WEIR';

UPDATE inp_node_type SET epa_table = f.epa_table FROM cat_feature_node f WHERE inp_node_type.id=f.epa_default;
UPDATE inp_node_type SET epa_table = 'inp_divider' where id = 'DIVIDER';

INSERT INTO sys_feature_epa_type SELECT id, 'NODE', epa_table FROM inp_node_type;
INSERT INTO sys_feature_epa_type SELECT id, 'ARC', epa_table FROM inp_arc_type;

UPDATE cat_feature_node SET epa_default  ='UNDEFINED' WHERE epa_default  ='NOT DEFINED';
UPDATE cat_feature_arc SET epa_default  ='UNDEFINED' WHERE epa_default  ='NOT DEFINED';
UPDATE sys_feature_epa_type SET id  ='UNDEFINED' WHERE id  ='NOT DEFINED';
UPDATE arc SET epa_type ='UNDEFINED' WHERE epa_type  ='NOT DEFINED';
UPDATE node SET epa_type ='UNDEFINED' WHERE epa_type  ='NOT DEFINED';



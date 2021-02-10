/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/02/10
UPDATE config_fprocess SET fid = 141 WHERE target  ='[DEMANDS]';
INSERT INTO inp_typevalue values ('inp_value_patternmethod','24','PJOINT ESTIMATED (PJOINT)',NULL, '{"DemandType":2}');

ALTER TABLE inp_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;
DELETE FROM inp_typevalue WHERE typevalue  ='inp_options_dscenario_priority' and id = '2';
UPDATE inp_typevalue SET id='2' WHERE id='3' and typevalue  ='inp_options_dscenario_priority';
UPDATE inp_typevalue SET idval = 'JOIN DEMANDS & PATTERNS' WHERE id='2' and typevalue  ='inp_options_dscenario_priority'; 
UPDATE inp_typevalue SET typevalue = concat('_',typevalue) WHERE typevalue = 'inp_value_demandtype' AND id::integer IN (4,5);
ALTER TABLE inp_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;

INSERT INTO sys_table VALUES ('temp_demand','Table with temporal demands when go2epa inp file is created',
	'role_epa',0, 'role_epa',null,null,'temp_demand_id_seq', 'id');
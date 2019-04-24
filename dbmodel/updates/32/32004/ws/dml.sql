
/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;


INSERT INTO audit_cat_param_user VALUES ('epaversion', 'epaoptions', 'Version of EPANET. Hard coded variable. Only enabled version is EPANET-EN 2.0.12', 'role_epa', NULL, NULL, 'EPANET version:', NULL, NULL, false, NULL, NULL, 'ws', false, NULL, NULL, NULL, false, 'string', 'combo', true, null, '2.0.12', NULL, NULL, NULL, NULL, NULL, NULL, NULL, false);


UPDATE audit_cat_param_user SET epaversion='{"from":"2.0.12", "to":null, "language":"english"}' where formname='epaoptions';


-- reactived again (disabled on 3.2.003 because code was not solved)
UPDATE sys_csv2pg_config SET reverse_pg2csvcat_id=12 WHERE tablename='vi_energy';
UPDATE sys_csv2pg_config SET reverse_pg2csvcat_id=12 WHERE tablename='vi_quality';
UPDATE sys_csv2pg_config SET reverse_pg2csvcat_id=12 WHERE tablename='vi_reactions';
UPDATE sys_csv2pg_config SET reverse_pg2csvcat_id=12 WHERE tablename='vi_mixing';

UPDATE sys_csv2pg_config SET fields=null;
UPDATE sys_csv2pg_config SET csvversion='{"from":"2.0.12", "to":null,"language":"english"}';



-- forgetted on 3.2.0000
UPDATE audit_cat_table SET isdeprecated = true WHERE id='inp_report';
UPDATE audit_cat_table SET isdeprecated = true WHERE id='inp_times';
UPDATE audit_cat_table SET isdeprecated = true WHERE id='vi_title';
UPDATE audit_cat_table SET isdeprecated = true WHERE id='inp_controls_x_node';


-- new udpates
UPDATE audit_cat_table SET isdeprecated = true WHERE id='inp_energy_gl';
UPDATE audit_cat_table SET isdeprecated = true WHERE id='inp_energy_el';
UPDATE audit_cat_table SET isdeprecated = true WHERE id='inp_reactions_gl';
UPDATE audit_cat_table SET isdeprecated = true WHERE id='inp_reactions_el';

INSERT INTO audit_cat_table VALUES ('inp_energy') ;
INSERT INTO audit_cat_table VALUES ('inp_reactions') ;


--modify inp_typevalue for inp_reactions
INSERT INTO inp_typevalue(typevalue, id, idval) VALUES ('inp_value_reactions', 'BULK', 'BULK');
INSERT INTO inp_typevalue(typevalue, id, idval) VALUES ('inp_value_reactions', 'WALL', 'WALL');
INSERT INTO inp_typevalue(typevalue, id, idval) VALUES ('inp_value_reactions', 'TANK', 'TANK');


--To delete
DELETE FROM inp_typevalue WHERE typevalue='inp_typevalue_pump';
DELETE FROM inp_typevalue WHERE typevalue='inp_typevalue_reactions_gl';
DELETE FROM inp_typevalue WHERE typevalue='inp_value_reactions_el';
DELETE FROM inp_typevalue WHERE typevalue='inp_value_reactions_gl';


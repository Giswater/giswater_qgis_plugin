
/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- reactived again (disabled on 3.2.003 because code was not solved)
UPDATE sys_csv2pg_config SET reverse_pg2csvcat_id=12 WHERE tablename='vi_energy';
UPDATE sys_csv2pg_config SET reverse_pg2csvcat_id=12 WHERE tablename='vi_quality';
UPDATE sys_csv2pg_config SET reverse_pg2csvcat_id=12 WHERE tablename='vi_reactions';
UPDATE sys_csv2pg_config SET reverse_pg2csvcat_id=12 WHERE tablename='vi_mixing';


-- forgetted on 3.2.0000
UPDATE audit_cat_table SET isdeprecated = true WHERE id='inp_report';
UPDATE audit_cat_table SET isdeprecated = true WHERE id='inp_times';

-- new udpates
UPDATE audit_cat_table SET isdeprecated = true WHERE id='inp_energy_gl';
UPDATE audit_cat_table SET isdeprecated = true WHERE id='inp_energy_el';
UPDATE audit_cat_table SET isdeprecated = true WHERE id='inp_reactions_gl';
UPDATE audit_cat_table SET isdeprecated = true WHERE id='inp_reactions_el';

INSERT INTO audit_cat_table VALUES ('inp_energy') ;
INSERT INTO audit_cat_table VALUES ('inp_reactions') ;

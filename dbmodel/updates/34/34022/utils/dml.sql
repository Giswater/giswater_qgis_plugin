/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/10/16
INSERT INTO sys_fprocess VALUES (292, 'EPANET pumps with more than two acs', 'ws')
ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess VALUES (293, 'EPANET valves with more than two acs', 'ws')
ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess VALUES (294, 'Check for inp_node tables and epa_type consistency', 'utils')
ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess VALUES (295, 'Check for inp_arc tables and epa_type consistency', 'utils')
ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess VALUES (296, 'Repair vnodes', 'utils')
ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess VALUES (297, 'EPA TYPE not defined', 'utils')
ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess VALUES (298, 'Create vnodes on orphan links', 'utils')
ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess VALUES (299, 'Delete orphan nodes', 'utils')
ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess VALUES (300, 'Remove duplicated vnodes', 'utils')
ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess VALUES (301, 'Reconnect link to node', 'utils')
ON CONFLICT (fid) DO NOTHING;


-- delete references to visit_cat_status typevalue. Only use visit_status
UPDATE config_form_fields SET dv_querytext=replace(dv_querytext, 'visit_cat_status', 'visit_status') where dv_querytext like '%visit_cat_status%';

ALTER TABLE om_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;
DELETE FROM om_typevalue WHERE typevalue='visit_cat_status';
UPDATE sys_typevalue SET typevalue_name='visit_status' WHERE typevalue_name='visit_cat_status';
ALTER TABLE om_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;
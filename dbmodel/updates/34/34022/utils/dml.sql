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

INSERT INTO sys_fprocess VALUES (298, 'Check duplicated vnodes', 'utils')
ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess VALUES (299, 'Check vnodes over nodes', 'utils')
ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_function VALUES (2998, 'gw_fct_setvnodefusion', 'utils', 'function', 'json', 'json', 'Function used to fusion vnodes', 'role_edit')
ON CONFLICT (id) DO NOTHING;


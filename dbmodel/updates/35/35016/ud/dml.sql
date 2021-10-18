/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/10/14
INSERT INTO config_csv(fid, alias, descript, functionname, active, orderby, addparam)
VALUES (408, 'Import istram nodes', null, 'gw_fct_import_istram', false, 10, NULL) ON CONFLICT (fid) DO NOTHING;

INSERT INTO config_csv(fid, alias, descript, functionname, active, orderby, addparam)
VALUES (409, 'Import istram arcs', null, 'gw_fct_import_istram', false, 11, NULL) ON CONFLICT (fid) DO NOTHING;
/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = audit, public, pg_catalog;

INSERT INTO config_fprocess
(fid, tablename, target, querytext, orderby, addparam, active)
VALUES(9000, 'audit_fid_log', 'DATA', 'SELECT sum(gis_length) FROM ve_arc WHERE state=1', NULL, NULL, true);

INSERT INTO sys_fprocess
(fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam)
VALUES(9000, 'Calculate current network length', 'utils', NULL, 'core', true, NULL, NULL);

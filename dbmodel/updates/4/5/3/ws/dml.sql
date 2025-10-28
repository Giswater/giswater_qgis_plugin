/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO config_fprocess (fid,tablename,"target",orderby) VALUES (140,'rpt_arc_stats','{Arc Stats}',33);
INSERT INTO config_fprocess (fid,tablename,"target",orderby) VALUES (140,'rpt_node_stats','{Node Stats}',34);

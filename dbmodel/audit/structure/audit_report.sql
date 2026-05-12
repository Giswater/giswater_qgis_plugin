/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = PARENT_SCHEMA, public, pg_catalog;

CREATE OR REPLACE VIEW audit.v_log AS
SELECT insert_by,  count (*) , action, date FROM
(SELECT insert_by, substring(query,0,30)  as action, (substring(date_trunc('day',(tstamp))::text,0,12))::date AS date, schema from audit.log)a
group by insert_by, date, action, schema
ORDER BY date desc;

GRANT ALL ON TABLE audit.v_log TO role_plan;

INSERT INTO audit.sys_version (id, giswater, project_type, postgres, postgis, "date", "language", epsg) VALUES(2, '4.0.001', 'AUDIT', 'PostgreSQL 16.1, compiled by Visual C++ build 1937, 64-bit', '3.4 USE_GEOS=1 USE_PROJ=1 USE_STATS=1', '2025-04-16 10:48:31.383', 'en_US', 25831) ON CONFLICT (id) DO NOTHING;

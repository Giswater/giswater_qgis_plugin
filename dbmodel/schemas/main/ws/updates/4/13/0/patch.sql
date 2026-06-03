/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- ingnore TCV valves
UPDATE sys_fprocess
SET query_text='SELECT * FROM t_inp_valve WHERE to_arc IS NULL AND valve_type <> ''TCV'''
WHERE fid=368;

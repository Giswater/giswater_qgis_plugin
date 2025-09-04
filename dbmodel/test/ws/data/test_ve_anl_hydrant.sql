/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT plan(3);

INSERT INTO ve_anl_hydrant (nodecat_id, expl_id, the_geom)
VALUES('-901', 0, null);
SELECT is((SELECT count(*)::integer FROM ve_anl_hydrant WHERE nodecat_id = 'PROPOSED HYDRANT'), 1, 'INSERT: ve_anl_hydrant -901 was inserted');

UPDATE ve_anl_hydrant SET expl_id = 1 WHERE nodecat_id = 'PROPOSED HYDRANT';
SELECT is((SELECT expl_id FROM ve_anl_hydrant WHERE nodecat_id = 'PROPOSED HYDRANT'), 1, 'UPDATE: ve_anl_hydrant -901 was updated');

DELETE FROM ve_anl_hydrant WHERE nodecat_id = 'PROPOSED HYDRANT';
SELECT is((SELECT count(*)::integer FROM ve_anl_hydrant WHERE nodecat_id = 'PROPOSED HYDRANT'), 0, 'DELETE: ve_anl_hydrant -901 was deleted');


SELECT * FROM finish();

ROLLBACK;

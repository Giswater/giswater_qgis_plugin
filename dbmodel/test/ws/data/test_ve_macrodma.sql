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

SELECT plan(6);

INSERT INTO ve_macrodma (macrodma_id, code, "name", descript, the_geom, expl_id)
VALUES(-901, '-901', 'Undefined', NULL, NULL, '{0}');
SELECT is((SELECT count(*)::integer FROM ve_macrodma WHERE code = '-901'), 1, 'INSERT: ve_macrodma -901 was inserted');
SELECT is((SELECT count(*)::integer FROM macrodma WHERE code = '-901'), 1, 'INSERT: macrodma -901 was inserted');


UPDATE ve_macrodma SET descript = 'updated descript' WHERE code = '-901';
SELECT is((SELECT descript FROM ve_macrodma WHERE code = '-901'), 'updated descript', 'UPDATE: ve_macrodma -901 was updated');
SELECT is((SELECT descript FROM macrodma WHERE code = '-901'), 'updated descript', 'UPDATE: macrodma -901 was updated');


DELETE FROM ve_macrodma WHERE code = '-901';
SELECT is((SELECT count(*)::integer FROM ve_macrodma WHERE code = '-901'), 0, 'DELETE: ve_macrodma -901 was deleted');
SELECT is((SELECT count(*)::integer FROM macrodma WHERE code = '-901'), 0, 'DELETE: macrodma -901 was deleted');


SELECT * FROM finish();

ROLLBACK;
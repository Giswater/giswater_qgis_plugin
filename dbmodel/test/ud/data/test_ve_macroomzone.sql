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


INSERT INTO ve_macroomzone (macroomzone_id, code, "name", descript, the_geom, expl_id)
VALUES(-901, '-901', 'Undefined', NULL, NULL, '{1}');

SELECT is((SELECT count(*)::integer FROM ve_macroomzone WHERE code = '-901'), 1, 'INSERT: ve_macroomzone -901 was inserted');
SELECT is((SELECT count(*)::integer FROM macroomzone WHERE code = '-901'), 1, 'INSERT: macroomzone -901 was inserted');

UPDATE ve_macroomzone SET descript = 'updated descript' WHERE code = '-901';
SELECT is((SELECT descript FROM ve_macroomzone WHERE code = '-901'), 'updated descript', 'UPDATE: ve_macroomzone -901 was updated');
SELECT is((SELECT descript FROM macroomzone WHERE code = '-901'), 'updated descript', 'UPDATE: macroomzone -901 was updated');

DELETE FROM ve_macroomzone WHERE code = '-901';
SELECT is((SELECT count(*)::integer FROM ve_macroomzone WHERE code = '-901'), 0, 'DELETE: ve_macroomzone -901 was deleted');
SELECT is((SELECT count(*)::integer FROM macroomzone WHERE code = '-901'), 0, 'DELETE: macroomzone -901 was deleted');


SELECT * FROM finish();


ROLLBACK;
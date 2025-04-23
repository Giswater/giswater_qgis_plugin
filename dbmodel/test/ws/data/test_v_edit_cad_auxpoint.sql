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

INSERT INTO v_edit_cad_auxpoint (geom_point)
VALUES (ST_GeomFromText('POINT(-901 0)', 25831));
SELECT is((SELECT count(*)::integer FROM v_edit_cad_auxpoint WHERE geom_point = ST_GeomFromText('POINT(-901 0)', 25831)), 1, 'INSERT: v_edit_cad_auxpoint -901 was inserted');

UPDATE v_edit_cad_auxpoint SET geom_point = ST_GeomFromText('POINT(-902 0)', 25831) WHERE geom_point = ST_GeomFromText('POINT(-901 0)', 25831);
SELECT is((SELECT geom_point FROM v_edit_cad_auxpoint WHERE geom_point = ST_GeomFromText('POINT(-902 0)', 25831)), ST_GeomFromText('POINT(-902 0)', 25831), 'UPDATE: v_edit_cad_auxpoint -901 was updated');

DELETE FROM v_edit_cad_auxpoint WHERE geom_point = ST_GeomFromText('POINT(-902 0)', 25831);
SELECT is((SELECT count(*)::integer FROM v_edit_cad_auxpoint WHERE geom_point = ST_GeomFromText('POINT(-902 0)', 25831)), 0, 'DELETE: v_edit_cad_auxpoint -902 was deleted');


SELECT * FROM finish();


ROLLBACK;
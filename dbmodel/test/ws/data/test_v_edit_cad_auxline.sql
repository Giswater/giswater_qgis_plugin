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

INSERT INTO v_edit_cad_auxline(geom_line)
VALUES (ST_GeomFromText('LINESTRING(-901 10, 20 20, 30 10, 40 40)', 25831));
SELECT is((SELECT count(*)::integer FROM v_edit_cad_auxline WHERE geom_line = ST_GeomFromText('LINESTRING(-901 10, 20 20, 30 10, 40 40)', 25831)), 1, 'INSERT: v_edit_cad_auxline -901 was inserted');

UPDATE v_edit_cad_auxline SET geom_line = ST_GeomFromText('LINESTRING(-902 10, 20 20, 30 10, 40 40)', 25831) WHERE geom_line = ST_GeomFromText('LINESTRING(-901 10, 20 20, 30 10, 40 40)', 25831);
SELECT is((SELECT geom_line FROM v_edit_cad_auxline WHERE geom_line = ST_GeomFromText('LINESTRING(-902 10, 20 20, 30 10, 40 40)', 25831)), ST_GeomFromText('LINESTRING(-902 10, 20 20, 30 10, 40 40)', 25831), 'UPDATE: v_edit_cad_auxline -901 was updated');

DELETE FROM v_edit_cad_auxline WHERE geom_line = ST_GeomFromText('LINESTRING(-902 10, 20 20, 30 10, 40 40)', 25831);
SELECT is((SELECT count(*)::integer FROM v_edit_cad_auxline WHERE geom_line = ST_GeomFromText('LINESTRING(-901 10, 20 20, 30 10, 40 40)', 25831)), 0, 'DELETE: v_edit_cad_auxline -902 was deleted');


SELECT * FROM finish();


ROLLBACK;
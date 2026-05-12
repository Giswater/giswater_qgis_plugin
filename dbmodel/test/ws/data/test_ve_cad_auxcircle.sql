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

INSERT INTO ve_cad_auxcircle(geom_multicurve)
VALUES(ST_GeomFromText('MULTICURVE((-901 10, 20 20, 30 40), CIRCULARSTRING(10 10, 15 15, 20 10))', 25831) );
SELECT is((SELECT count(*)::integer FROM ve_cad_auxcircle WHERE geom_multicurve = ST_GeomFromText('MULTICURVE((-901 10, 20 20, 30 40), CIRCULARSTRING(10 10, 15 15, 20 10))', 25831)), 1, 'INSERT: ve_cad_auxcircle -901 was inserted');

UPDATE ve_cad_auxcircle SET geom_multicurve =  ST_GeomFromText('MULTICURVE((-902 10, 20 20, 30 40), CIRCULARSTRING(10 10, 15 15, 20 10))', 25831) WHERE geom_multicurve = ST_GeomFromText('MULTICURVE((-901 10, 20 20, 30 40), CIRCULARSTRING(10 10, 15 15, 20 10))', 25831);
SELECT is((SELECT geom_multicurve FROM ve_cad_auxcircle WHERE geom_multicurve = ST_GeomFromText('MULTICURVE((-902 10, 20 20, 30 40), CIRCULARSTRING(10 10, 15 15, 20 10))', 25831)),  ST_GeomFromText('MULTICURVE((-902 10, 20 20, 30 40), CIRCULARSTRING(10 10, 15 15, 20 10))', 25831), 'UPDATE: ve_cad_auxcircle -901 was updated');

DELETE FROM ve_cad_auxcircle WHERE geom_multicurve = ST_GeomFromText('MULTICURVE((-902 10, 20 20, 30 40), CIRCULARSTRING(10 10, 15 15, 20 10))', 25831);
SELECT is((SELECT count(*)::integer FROM ve_cad_auxcircle WHERE geom_multicurve = ST_GeomFromText('MULTICURVE((-902 10, 20 20, 30 40), CIRCULARSTRING(10 10, 15 15, 20 10))', 25831)), 0, 'DELETE: ve_cad_auxcircle -902 was deleted');


SELECT * FROM finish();


ROLLBACK;
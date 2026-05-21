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



INSERT INTO ve_raingage (rg_id, form_type, intvl, scf, rgage_type, timser_id, fname, sta, units, the_geom, expl_id, muni_id)
VALUES('-901', 'VOLUME', '0:05', 1.0000, 'TIMESERIES', 'T5-5m', NULL, NULL, NULL, 'SRID=25831;POINT (419104.15832005773 4576995.253196637)'::public.geometry, 1, 1);



SELECT is((SELECT count(*)::integer FROM ve_raingage WHERE rg_id = '-901'), 1, 'INSERT: ve_raingage -901 was inserted');
SELECT is((SELECT count(*)::integer FROM raingage WHERE rg_id = '-901'), 1, 'INSERT: raingage -901 was inserted');

UPDATE ve_raingage SET fname = 'updated fname' WHERE rg_id = '-901';
SELECT is((SELECT fname FROM ve_raingage WHERE rg_id = '-901'), 'updated fname', 'UPDATE: ve_raingage -901 was updated');
SELECT is((SELECT fname FROM raingage WHERE rg_id = '-901'), 'updated fname', 'UPDATE: raingage -901 was updated');

DELETE FROM ve_raingage WHERE rg_id = '-901';
SELECT is((SELECT count(*)::integer FROM ve_raingage WHERE rg_id = '-901'), 0, 'DELETE: ve_raingage -901 was deleted');
SELECT is((SELECT count(*)::integer FROM raingage WHERE rg_id = '-901'), 0, 'DELETE: raingage -901 was deleted');


SELECT * FROM finish();


ROLLBACK;
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

SELECT plan(9);

-- Subtest 1: Testing macroexploitation operations
INSERT INTO macroexploitation (macroexpl_id, "name", descript, lock_level, active) VALUES(-999, 'Test', 'Test macroexploitation', NULL, true);
SELECT is((SELECT count(*)::integer FROM macroexploitation WHERE macroexpl_id = -999), 1, 'INSERT: macroexploitation "2" was inserted');

UPDATE macroexploitation SET descript = 'updated test' WHERE macroexpl_id = -999;
SELECT is((SELECT descript FROM macroexploitation WHERE macroexpl_id = -999), 'updated test', 'UPDATE: descript was updated to "updated test"');

DELETE FROM macroexploitation WHERE macroexpl_id = -999;
SELECT is((SELECT count(*)::integer FROM macroexploitation WHERE macroexpl_id = -999), 0, 'DELETE: macroexploitation 2 was deleted');


-- Subtest 2: Testing macrosecto operations
INSERT INTO macrosector (macrosector_id, "name", descript, the_geom, active)
VALUES(-999, 'macrosector_03', 'macrosector_project_ud', 'SRID=25831;MULTIPOLYGON (((418661.46939954103 4578015.45745487, 418647.37730746274 4578106.685208859, 
418536.61840831034 4578081.220551241, 418457.5049089153 4578046.113935886, 418401.13654059684 4578007.051645559, 418347.73492850515 4577966.505977117, 
418307.6837194355 4577934.366117985, 418280.9829133909 4577912.609905655, 418294.82777578407 4577893.820449547, 418303.72804446577 4577879.481127782, 
418316.08952874615 4577811.740193926, 418323.50641931436 4577792.456278448, 418334.38452548115 4577771.688984857, 418348.7238472465 4577744.49371944, 
418362.5687096406 4577720.26521025, 418377.8969501484 4577697.025619804, 418396.68640625506 4577668.346976273, 418430.4332583408 4577617.417661038, 
418459.9772057712 4577581.32212694, 418485.1946337044 4577554.126861522, 418514.36773660715 4577536.326324159, 418533.6516520847 4577559.565914604, 
418633.53244507004 4577577.366451968, 418697.31770395674 4577586.761180022, 418734.4021567978 4577592.200233106, 418728.9631037145 4577622.36225475, 
418722.04067251686 4577665.380220048, 418709.67918823694 4577732.132235162, 418695.8343258427 4577809.267897072, 418688.91189464426 4577848.330187399, 
418676.05595099396 4577926.45476805, 418661.46939954103 4578015.45745487)))'::public.geometry, true);
SELECT is((SELECT count(*)::integer FROM macrosector WHERE macrosector_id = -999), 1, 'INSERT: macrosector "3" was inserted');

UPDATE macrosector SET descript = 'updated test' WHERE macrosector_id = -999;
SELECT is((SELECT descript FROM macrosector WHERE macrosector_id = -999), 'updated test', 'UPDATE: descript was updated to "updated test"');

DELETE FROM macrosector WHERE macrosector_id = -999;
SELECT is((SELECT count(*)::integer FROM macrosector WHERE macrosector_id = -999), 0, 'DELETE: macrosector 3 was deleted');


-- Subtest 3: Testing macroomzone operations
INSERT INTO macroomzone (macroomzone_id, "name", expl_id, descript, the_geom, active) VALUES(-999, 'macroomzone_03', '{0}', NULL, NULL, true);
SELECT is((SELECT count(*)::integer FROM macroomzone WHERE macroomzone_id = -999), 1, 'INSERT: macroomzone "3" was inserted');

UPDATE macroomzone SET descript = 'updated test' WHERE macroomzone_id = -999;
SELECT is((SELECT descript FROM macroomzone WHERE macroomzone_id = -999), 'updated test', 'UPDATE: descript was updated to "updated test"');

DELETE FROM macroomzone WHERE macroomzone_id = -999;
SELECT is((SELECT count(*)::integer FROM macroomzone WHERE macroomzone_id = -999), 0, 'DELETE: macroomzone 3 was deleted');


SELECT * FROM finish();

ROLLBACK;

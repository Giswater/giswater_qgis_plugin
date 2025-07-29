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

INSERT INTO ve_inp_pattern_value (pattern_id,  factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18)
VALUES('PTN-JUNCTION', -901, 0.2000, 0.4000, 0.3000, 0.5000, 0.5000, 0.8000, 1.1000, 1.5000, 1.1000, 1.1000, 1.3000, NULL, NULL, NULL, NULL, NULL, NULL);
SELECT is((SELECT count(*)::integer FROM ve_inp_pattern_value WHERE factor_1 = -901), 1, 'INSERT: ve_inp_pattern_value -901 was inserted');
SELECT is((SELECT count(*)::integer FROM inp_pattern_value WHERE factor_1 = -901), 1, 'INSERT: inp_pattern_value -901 was inserted');

UPDATE ve_inp_pattern_value SET factor_2 = -902 WHERE factor_1 = -901;
SELECT is((SELECT factor_2::integer FROM ve_inp_pattern_value WHERE factor_1 = -901), -902, 'UPDATE: ve_inp_pattern_value -901 was updated');
SELECT is((SELECT factor_2::integer FROM inp_pattern_value WHERE factor_1 = -901), -902, 'UPDATE: inp_pattern_value -901 was updated');

DELETE FROM ve_inp_pattern_value WHERE factor_1 = -901;
SELECT is((SELECT count(*)::integer FROM ve_inp_pattern_value WHERE factor_1 = -901), 0, 'DELETE: ve_inp_pattern_value -901 was deleted');
SELECT is((SELECT count(*)::integer FROM inp_pattern_value WHERE factor_1 = -901), 0, 'DELETE: inp_pattern_value -901 was deleted');


SELECT * FROM finish();


ROLLBACK;
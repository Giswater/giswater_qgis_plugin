/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT plan(6);

INSERT INTO v_edit_samplepoint (sample_id, code, lab_code, feature_id, featurecat_id, dma_id, macrodma_id, presszone_id, state, builtdate, enddate, workcat_id, workcat_id_end, rotation, muni_id, streetaxis_id, postnumber, postcode, district_id, streetaxis2_id, postnumber2, postcomplement, postcomplement2, place_name, cabinet, observations, verified, the_geom, expl_id, link, sector_id)
VALUES('-901', '', '', '', 'JUNCTION', 0, 0, 0, 1, null, null, 'work1', 'work1', 0, 1, '1-10240C', 0, '', 0, '1-10240C', 0, '', '', '', '', '', '', null, 0, '', 0);
SELECT is((SELECT count(*)::integer FROM v_edit_samplepoint WHERE sample_id = '-901'), 1, 'INSERT: v_edit_samplepoint -901 was inserted');
SELECT is((SELECT count(*)::integer FROM samplepoint WHERE sample_id = '-901'), 1, 'INSERT: samplepoint -901 was inserted');


UPDATE v_edit_samplepoint SET code = 'updated code' WHERE sample_id = '-901';
SELECT is((SELECT code FROM v_edit_samplepoint WHERE sample_id = '-901'), 'updated code', 'UPDATE: v_edit_samplepoint -901 was updated');
SELECT is((SELECT code FROM samplepoint WHERE sample_id = '-901'), 'updated code', 'UPDATE: samplepoint -901 was updated');


DELETE FROM v_edit_samplepoint WHERE sample_id = '-901';
SELECT is((SELECT count(*)::integer FROM v_edit_samplepoint WHERE sample_id = '-901'), 0, 'DELETE: v_edit_samplepoint -901 was deleted');
SELECT is((SELECT count(*)::integer FROM samplepoint WHERE sample_id = '-901'), 0, 'DELETE: samplepoint -901 was deleted');


SELECT * FROM finish();

ROLLBACK;
/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT plan(3);

INSERT INTO v_edit_presszone
(presszone_id, "name", expl_id, presszone_type, descript, head, graphconfig, stylesheet, link, avg_press, active, tstamp, insert_user, lastupdate, lastupdate_user, the_geom)
VALUES(-901, 'pzone1-1s', 1, NULL, NULL, 103.85, '{"use":[{"nodeParent":"1105", "toArc":[113881]}], "ignore":[], "forceClosed":[]}', '{"color":[251,181,174], "featureColor":"251,181,174"}', NULL, NULL, true, '2024-02-21 12:08:16.880', 'postgres', '2024-09-20 11:43:42.716', 'postgres', 'SRID=25831;MULTIPOLYGON (((419236.42319 4576873.35927, 419236.45781 4576874.92716, 419236.79765 4576876.45817, 419237.42965 4576877.89347, 419238.32951 4576879.17788, 419239.46267 4576880.26207, 419240.78556 4576881.10435, 419242.24735 4576881.67237, 419257.22297 4576885.85642, 419259.23364 4576886.41818, 419260.77816 4576886.6901, 419262.34605 4576886.65548, 419263.87706 4576886.31564, 419265.31235 4576885.68364, 419266.59677 4576884.78378, 419267.68095 4576883.65063, 419268.52324 4576882.32773, 419269.09125 4576880.86594, 419269.36317 4576879.32142, 419269.32855 4576877.75353, 419268.98871 4576876.22252, 419268.35671 4576874.78723, 419267.45685 4576873.50281, 419266.3237 4576872.41862, 419265.00081 4576871.57634, 419263.53901 4576871.00832, 419261.52835 4576870.44656, 419246.55273 4576866.26251, 419245.00821 4576865.99059, 419243.44031 4576866.02521, 419241.9093 4576866.36505, 419240.47401 4576866.99705, 419239.18959 4576867.89691, 419238.10541 4576869.03007, 419237.26313 4576870.35296, 419236.69511 4576871.81475, 419236.42319 4576873.35927)))'::public.geometry);
SELECT is((SELECT count(*)::integer FROM v_edit_presszone WHERE presszone_id = -901), 1, 'INSERT: v_edit_presszone -901 was inserted');

UPDATE v_edit_presszone SET descript = 'updated descript' WHERE presszone_id = -901;
SELECT is((SELECT descript FROM v_edit_dma WHERE presszone_id = -901), 'updated descript', 'UPDATE: v_edit_presszone -901 was updated');

DELETE FROM v_edit_presszone WHERE presszone_id = -901;
SELECT is((SELECT count(*)::integer FROM v_edit_presszone WHERE presszone_id = -901), 0, 'DELETE: v_edit_presszone -901 was deleted');


SELECT * FROM finish();


ROLLBACK;
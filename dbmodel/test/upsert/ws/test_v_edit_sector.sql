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

INSERT INTO v_edit_sector
(sector_id, "name", muni_id, expl_id, macrosector_id, macrosector_name, idval, descript, parent_id, pattern_id, graphconfig, stylesheet, link, avg_press, active, undelete, tstamp, insert_user, lastupdate, lastupdate_user, the_geom)
VALUES(-901, 'sector1-1s', NULL::int4[], '{1}', 1, 'macrosector_01', 'SOURCE', NULL, NULL, 'PTN-SECT-01-DEF', '{"use":[{"nodeParent":"1097", "toArc":[2207]}], "ignore":[], "forceClosed":[]}', '{"color":[251,181,174], "featureColor":"251,181,174"}', NULL, NULL, true, NULL, '2024-02-21 12:08:16.880', 'postgres', NULL, NULL, 'SRID=25831;MULTIPOLYGON (((419235.0724363852 4576868.250503188, 419234.4932468037 4576868.148748435, 419233.90533463104 4576868.161934724, 419233.33128971315 4576868.289555386, 419232.79316906276 4576868.526706744, 419232.3116493441 4576868.864276531, 419231.905232396 4576869.289294019, 419231.58953432005 4576869.785428402, 419231.3766854501 4576870.333616289, 419231.27486425795 4576870.912794194, 419231.2879831054 4576871.500707876, 419231.41553791583 4576872.07476743, 419231.65262754296 4576872.612915281, 419231.99014209193 4576873.0944737205, 419232.41511295614 4576873.50093942, 419232.91121112107 4576873.816694408, 419233.45937458816 4576874.02960616, 419260.5794625765 4576881.6027119355, 419261.15864610387 4576881.704600884, 419261.7465784416 4576881.691543992, 419262.32066764176 4576881.564042986, 419262.8588536942 4576881.326997234, 419263.3404562071 4576880.989515477, 419263.7469690731 4576880.564565826, 419264.0627715874 4576880.068477439, 419264.2757286906 4576879.520313058, 419264.3776572712 4576878.941136504, 419264.36464061134 4576878.353203274, 419264.23717889044 4576877.77910535, 419264.00016996555 4576877.240903079, 419263.6627211658 4576876.759277473, 419263.23779933306 4576876.352735529, 419262.74173255695 4576876.036899068, 419262.1935827498 4576875.823904456, 419245.2072961848 4576871.078089832, 419235.0724363852 4576868.250503188)))'::public.geometry);
SELECT is((SELECT count(*)::integer FROM v_edit_sector WHERE sector_id = -901), 1, 'INSERT: v_edit_sector -901 was inserted');
SELECT is((SELECT count(*)::integer FROM sector WHERE sector_id = -901), 1, 'INSERT: sector -901 was inserted');

UPDATE v_edit_sector SET descript = 'updated descript' WHERE sector_id = -901;
SELECT is((SELECT descript FROM v_edit_sector WHERE sector_id = -901), 'updated descript', 'UPDATE: v_edit_sector -901 was updated');
SELECT is((SELECT descript FROM sector WHERE sector_id = -901), 'updated descript', 'UPDATE: sector -901 was updated');

DELETE FROM v_edit_sector WHERE sector_id = -901;
SELECT is((SELECT count(*)::integer FROM v_edit_sector WHERE sector_id = -901), 0, 'DELETE: v_edit_sector -901 was deleted');
SELECT is((SELECT count(*)::integer FROM sector WHERE sector_id = -901), 0, 'DELETE: sector -901 was deleted');


SELECT * FROM finish();


ROLLBACK;
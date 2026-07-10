/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/
BEGIN;

SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- Requires schema >= 4.15.0: config_code_parts, cat_feature.abrevation,
-- edit_sys_code_autofill modes (uuid|code|none), and updated edit triggers.

SELECT plan(20);

CREATE SEQUENCE IF NOT EXISTS seq_feature_code START 1 INCREMENT 1 MAXVALUE 99999999;
ALTER SEQUENCE seq_feature_code RESTART WITH 1;

INSERT INTO config_param_system ("parameter", value, isenabled, project_type, "datatype", widgettype)
VALUES ('edit_sys_code_autofill', '{"node":"none","arc":"none","connec":"none","gully":"none"}', true, 'utils', 'json', 'linetext')
ON CONFLICT ("parameter") DO UPDATE SET value = EXCLUDED.value;

INSERT INTO config_code_parts (context, entity, part, source_expr, concat_order, descript, active) VALUES
('feature', NULL, 'separator', $$'_'::text$$, 2, 'Underscore separator', true),
('feature', NULL, 'sequence', $$lpad(nextval('seq_feature_code')::text, 8, '0')$$, 3, 'Global feature sequence suffix', true),
('feature', 'NODE', 'abrevation', '(SELECT abrevation FROM cat_feature WHERE id = ($1::json->>''node_type''))', 1, 'Catalog abrevation for nodes', true),
('feature', 'ARC', 'abrevation', '(SELECT abrevation FROM cat_feature WHERE id = ($1::json->>''arc_type''))', 1, 'Catalog abrevation for arcs', true),
('feature', 'CONNEC', 'abrevation', '(SELECT abrevation FROM cat_feature WHERE id = ($1::json->>''connec_type''))', 1, 'Catalog abrevation for connecs', true),
('feature', 'GULLY', 'abrevation', '(SELECT abrevation FROM cat_feature WHERE id = ($1::json->>''gully_type''))', 1, 'Catalog abrevation for gullies', true)
ON CONFLICT (context, entity, part) DO UPDATE SET
  source_expr = EXCLUDED.source_expr,
  concat_order = EXCLUDED.concat_order,
  active = EXCLUDED.active;

UPDATE cat_feature SET abrevation = 'TST', code_autofill = true
WHERE id IN ('CHAMBER', 'CONDUIT', 'CJOIN', 'GINLET');

CREATE OR REPLACE FUNCTION pg_temp.test_ud_insert_node(p_node_id text, p_code text, p_sys_code text)
RETURNS void LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO ve_node_chamber (
        node_id, code, sys_code, top_elev, node_type, sys_type, nodecat_id, epa_type, state, state_type,
        expl_id, sector_id, macrosector_id, omzone_id, soilcat_id, fluid_type, workcat_id, ownercat_id, muni_id,
        verified, the_geom, publish, inventory, uncertain, unconnected, inp_type, length, width, is_operative
    ) VALUES (
        p_node_id::integer, p_code, p_sys_code, 33.220, 'CHAMBER', 'CHAMBER', 'CHAMBER-01', 'STORAGE', 1, 2,
        2, 2, 2, 3, 'soil1', 0, 'work1', 'owner1', 2,
        '1', 'SRID=25831;POINT (418456.7137334756 4577989.971585366)'::geometry, true, true, false, false, 'STORAGE', 0, 0, true
    );
END;
$$;

CREATE OR REPLACE FUNCTION pg_temp.test_ud_insert_arc_nodes(p_node_1 text, p_node_2 text)
RETURNS void LANGUAGE plpgsql AS $$
BEGIN
    PERFORM pg_temp.test_ud_insert_node(p_node_1, p_node_1, p_node_1);
    PERFORM pg_temp.test_ud_insert_node(p_node_2, p_node_2, p_node_2);
END;
$$;

CREATE OR REPLACE FUNCTION pg_temp.test_ud_insert_arc(p_arc_id text, p_code text, p_sys_code text, p_node_1 text, p_node_2 text)
RETURNS void LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO ve_arc_conduit (
        arc_id, code, sys_code, node_1, nodetype_1, node_2, nodetype_2, arc_type, sys_type, arccat_id,
        cat_shape, cat_geom1, cat_geom2, cat_width, cat_area, epa_type, state, state_type, expl_id, sector_id,
        macrosector_id, gis_length, omzone_id, soilcat_id, fluid_type, workcat_id, ownercat_id, muni_id, link,
        verified, publish, inventory, uncertain, is_operative, the_geom, inp_type
    ) VALUES (
        p_arc_id::integer, p_code, p_sys_code, p_node_1::integer, 'CHAMBER', p_node_2::integer, 'CHAMBER', 'CONDUIT', 'CONDUIT', 'CC100',
        'CIRCULAR', 1.0000, 0.0000, 1.30, 0.7854, 'CONDUIT', 1, 2, 2, 2,
        2, 3.47, 3, 'soil1', 0, 'work1', 'owner1', 2, '',
        '1', true, true, false, true, 'SRID=25831;LINESTRING (418456.38290275045 4577986.547739702, 418459.7520876639 4577987.378497627)'::geometry, 'CONDUIT'
    );
END;
$$;

CREATE OR REPLACE FUNCTION pg_temp.test_ud_insert_connec(p_connec_id text, p_code text, p_sys_code text)
RETURNS void LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO ve_connec (
        connec_id, code, sys_code, top_elev, y1, y2, conneccat_id, connec_type, sys_type, matcat_id, state, state_type,
        expl_id, sector_id, connec_depth, connec_length, arc_id, omzone_id, soilcat_id, function_type, category_type,
        fluid_type, location_type, ownercat_id, muni_id, rotation, link, verified, publish, inventory, pjoint_id,
        pjoint_type, the_geom, is_operative
    ) VALUES (
        p_connec_id::integer, p_code, p_sys_code, 55.2583, 2.1380, 1.7380, 'DIRECT-CONNECTION', 'CJOIN', 'CONNEC', 'PVC', 1, 2,
        1, 1, 1.938, 17.979, '171', 1, 'soil1', 'St. Function', 'St. Category',
        0, 'St. Location', 'owner1', 1, -56.687, 'https://www.giswater.org', '0', true, true, '171',
        'ARC', 'SRID=25831;POINT (418802.5740642579 4576477.885736115)'::geometry, true
    );
END;
$$;

CREATE OR REPLACE FUNCTION pg_temp.test_ud_insert_gully(p_gully_id text, p_code text, p_sys_code text)
RETURNS void LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO ve_gully (
        gully_id, code, sys_code, top_elev, width, length, ymax, sandbox, matcat_id, gully_type, sys_type, gullycat_id,
        units, groove, siphon, connec_arccat_id, connec_length, connec_depth, arc_id, epa_type, state, state_type,
        expl_id, sector_id, macrosector_id, muni_id, omzone_id, soilcat_id, function_type, category_type, location_type,
        fluid_type, ownercat_id, link, verified, inventory, publish, is_operative, the_geom, pjoint_id, pjoint_type
    ) VALUES (
        p_gully_id::integer, p_code, p_sys_code, 36.7800, 34.5000, 77.6000, 0.8000, 0.0000, 'Concrete', 'GINLET', 'GULLY', 'SGRT4',
        1.00, false, false, 'DIRECT-CONNECTION', 4.672, 1.200, '18893', 'GULLY', 1, 2,
        2, 2, 2, 2, 3, 'soil1', 'St. Function', 'St. Category', 'St. Location',
        0, 'owner1', 'https://www.giswater.org', '0', true, true, true, 'SRID=25831;POINT (429089.6348767015 4576325.2010902)'::geometry, '18893', 'ARC'
    );
END;
$$;

CREATE OR REPLACE FUNCTION pg_temp.test_set_sys_code_mode(p_feature text, p_mode text)
RETURNS void LANGUAGE plpgsql AS $$
BEGIN
    UPDATE config_param_system
    SET value = (('{"node":"none","arc":"none","connec":"none","gully":"none"}'::jsonb
        || jsonb_build_object(p_feature, p_mode))::text)
    WHERE parameter = 'edit_sys_code_autofill';
END;
$$;

-- NODE: code autofill on
ALTER SEQUENCE seq_feature_code RESTART WITH 1;
UPDATE cat_feature SET code_autofill = true WHERE id = 'CHAMBER';
UPDATE config_code_parts SET active = true WHERE context = 'feature';
SELECT pg_temp.test_ud_insert_node('-991', NULL, NULL);
SELECT ok((SELECT code FROM node WHERE node_id = '-991') ~ '^TST_', 'UD node: code autofill generates code');
DELETE FROM node WHERE node_id = '-991';

-- NODE: code autofill off
UPDATE cat_feature SET code_autofill = false WHERE id = 'CHAMBER';
SELECT pg_temp.test_ud_insert_node('-992', NULL, NULL);
SELECT is((SELECT code FROM node WHERE node_id = '-992'), NULL::text, 'UD node: code autofill disabled keeps code NULL');
DELETE FROM node WHERE node_id = '-992';
UPDATE cat_feature SET code_autofill = true WHERE id = 'CHAMBER';

-- NODE: sys_code uuid
SELECT pg_temp.test_set_sys_code_mode('node', 'uuid');
SELECT pg_temp.test_ud_insert_node('-993', NULL, NULL);
SELECT ok((SELECT sys_code FROM node WHERE node_id = '-993') ~ '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$', 'UD node: sys_code uuid mode');
DELETE FROM node WHERE node_id = '-993';

-- NODE: sys_code code
SELECT pg_temp.test_set_sys_code_mode('node', 'code');
SELECT pg_temp.test_ud_insert_node('-994', 'USR-NODE', NULL);
SELECT is((SELECT sys_code FROM node WHERE node_id = '-994'), 'USR-NODE', 'UD node: sys_code code mode copies code');
DELETE FROM node WHERE node_id = '-994';

-- NODE: sys_code none
SELECT pg_temp.test_set_sys_code_mode('node', 'none');
SELECT pg_temp.test_ud_insert_node('-995', 'USR-NODE2', NULL);
SELECT is((SELECT sys_code FROM node WHERE node_id = '-995'), NULL::text, 'UD node: sys_code none keeps sys_code NULL');
DELETE FROM node WHERE node_id = '-995';

-- ARC: code autofill on
ALTER SEQUENCE seq_feature_code RESTART WITH 1;
UPDATE cat_feature SET code_autofill = true WHERE id = 'CONDUIT';
UPDATE config_code_parts SET active = true WHERE context = 'feature';
SELECT pg_temp.test_ud_insert_arc_nodes('-801', '-802');
SELECT pg_temp.test_ud_insert_arc('-791', NULL, NULL, '-801', '-802');
SELECT ok((SELECT code FROM arc WHERE arc_id = '-791') ~ '^TST_', 'UD arc: code autofill generates code');
DELETE FROM arc WHERE arc_id = '-791';
DELETE FROM node WHERE node_id IN ('-801', '-802');

-- ARC: code autofill off
UPDATE cat_feature SET code_autofill = false WHERE id = 'CONDUIT';
SELECT pg_temp.test_ud_insert_arc_nodes('-803', '-804');
SELECT pg_temp.test_ud_insert_arc('-792', NULL, NULL, '-803', '-804');
SELECT is((SELECT code FROM arc WHERE arc_id = '-792'), NULL::text, 'UD arc: code autofill disabled keeps code NULL');
DELETE FROM arc WHERE arc_id = '-792';
DELETE FROM node WHERE node_id IN ('-803', '-804');
UPDATE cat_feature SET code_autofill = true WHERE id = 'CONDUIT';

-- ARC: sys_code uuid
SELECT pg_temp.test_set_sys_code_mode('arc', 'uuid');
SELECT pg_temp.test_ud_insert_arc_nodes('-805', '-806');
SELECT pg_temp.test_ud_insert_arc('-793', NULL, NULL, '-805', '-806');
SELECT ok((SELECT sys_code FROM arc WHERE arc_id = '-793') ~ '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$', 'UD arc: sys_code uuid mode');
DELETE FROM arc WHERE arc_id = '-793';
DELETE FROM node WHERE node_id IN ('-805', '-806');

-- ARC: sys_code code
SELECT pg_temp.test_set_sys_code_mode('arc', 'code');
SELECT pg_temp.test_ud_insert_arc_nodes('-807', '-808');
SELECT pg_temp.test_ud_insert_arc('-794', 'USR-ARC', NULL, '-807', '-808');
SELECT is((SELECT sys_code FROM arc WHERE arc_id = '-794'), 'USR-ARC', 'UD arc: sys_code code mode copies code');
DELETE FROM arc WHERE arc_id = '-794';
DELETE FROM node WHERE node_id IN ('-807', '-808');

-- ARC: sys_code none
SELECT pg_temp.test_set_sys_code_mode('arc', 'none');
SELECT pg_temp.test_ud_insert_arc_nodes('-809', '-810');
SELECT pg_temp.test_ud_insert_arc('-795', 'USR-ARC2', NULL, '-809', '-810');
SELECT is((SELECT sys_code FROM arc WHERE arc_id = '-795'), NULL::text, 'UD arc: sys_code none keeps sys_code NULL');
DELETE FROM arc WHERE arc_id = '-795';
DELETE FROM node WHERE node_id IN ('-809', '-810');

-- CONNEC: code autofill on
ALTER SEQUENCE seq_feature_code RESTART WITH 1;
UPDATE cat_feature SET code_autofill = true WHERE id = 'CJOIN';
SELECT pg_temp.test_ud_insert_connec('-781', NULL, NULL);
SELECT ok((SELECT code FROM connec WHERE connec_id = '-781') ~ '^TST_', 'UD connec: code autofill generates code');
DELETE FROM connec WHERE connec_id = '-781';

-- CONNEC: code autofill off
UPDATE cat_feature SET code_autofill = false WHERE id = 'CJOIN';
SELECT pg_temp.test_ud_insert_connec('-782', NULL, NULL);
SELECT is((SELECT code FROM connec WHERE connec_id = '-782'), NULL::text, 'UD connec: code autofill disabled keeps code NULL');
DELETE FROM connec WHERE connec_id = '-782';
UPDATE cat_feature SET code_autofill = true WHERE id = 'CJOIN';

-- CONNEC: sys_code uuid
SELECT pg_temp.test_set_sys_code_mode('connec', 'uuid');
SELECT pg_temp.test_ud_insert_connec('-783', NULL, NULL);
SELECT ok((SELECT sys_code FROM connec WHERE connec_id = '-783') ~ '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$', 'UD connec: sys_code uuid mode');
DELETE FROM connec WHERE connec_id = '-783';

-- CONNEC: sys_code code
SELECT pg_temp.test_set_sys_code_mode('connec', 'code');
SELECT pg_temp.test_ud_insert_connec('-784', 'USR-CONNEC', NULL);
SELECT is((SELECT sys_code FROM connec WHERE connec_id = '-784'), 'USR-CONNEC', 'UD connec: sys_code code mode copies code');
DELETE FROM connec WHERE connec_id = '-784';

-- CONNEC: sys_code none
SELECT pg_temp.test_set_sys_code_mode('connec', 'none');
SELECT pg_temp.test_ud_insert_connec('-785', 'USR-CONNEC2', NULL);
SELECT is((SELECT sys_code FROM connec WHERE connec_id = '-785'), NULL::text, 'UD connec: sys_code none keeps sys_code NULL');
DELETE FROM connec WHERE connec_id = '-785';

-- GULLY: code autofill on
ALTER SEQUENCE seq_feature_code RESTART WITH 1;
UPDATE cat_feature SET code_autofill = true WHERE id = 'GINLET';
SELECT pg_temp.test_ud_insert_gully('-771', NULL, NULL);
SELECT ok((SELECT code FROM gully WHERE gully_id = '-771') ~ '^TST_', 'UD gully: code autofill generates code');
DELETE FROM gully WHERE gully_id = '-771';

-- GULLY: code autofill off
UPDATE cat_feature SET code_autofill = false WHERE id = 'GINLET';
SELECT pg_temp.test_ud_insert_gully('-772', NULL, NULL);
SELECT is((SELECT code FROM gully WHERE gully_id = '-772'), NULL::text, 'UD gully: code autofill disabled keeps code NULL');
DELETE FROM gully WHERE gully_id = '-772';
UPDATE cat_feature SET code_autofill = true WHERE id = 'GINLET';

-- GULLY: sys_code uuid
SELECT pg_temp.test_set_sys_code_mode('gully', 'uuid');
SELECT pg_temp.test_ud_insert_gully('-773', NULL, NULL);
SELECT ok((SELECT sys_code FROM gully WHERE gully_id = '-773') ~ '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$', 'UD gully: sys_code uuid mode');
DELETE FROM gully WHERE gully_id = '-773';

-- GULLY: sys_code code
SELECT pg_temp.test_set_sys_code_mode('gully', 'code');
SELECT pg_temp.test_ud_insert_gully('-774', 'USR-GULLY', NULL);
SELECT is((SELECT sys_code FROM gully WHERE gully_id = '-774'), 'USR-GULLY', 'UD gully: sys_code code mode copies code');
DELETE FROM gully WHERE gully_id = '-774';

-- GULLY: sys_code none
SELECT pg_temp.test_set_sys_code_mode('gully', 'none');
SELECT pg_temp.test_ud_insert_gully('-775', 'USR-GULLY2', NULL);
SELECT is((SELECT sys_code FROM gully WHERE gully_id = '-775'), NULL::text, 'UD gully: sys_code none keeps sys_code NULL');
DELETE FROM gully WHERE gully_id = '-775';

SELECT finish();

ROLLBACK;

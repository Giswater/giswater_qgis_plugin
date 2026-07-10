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

SELECT plan(15);

CREATE SEQUENCE IF NOT EXISTS seq_feature_code START 1 INCREMENT 1 MAXVALUE 99999999;
ALTER SEQUENCE seq_feature_code RESTART WITH 1;

INSERT INTO config_param_system ("parameter", value, isenabled, project_type, "datatype", widgettype)
VALUES ('edit_sys_code_autofill', '{"node":"none","arc":"none","connec":"none"}', true, 'utils', 'json', 'linetext')
ON CONFLICT ("parameter") DO UPDATE SET value = EXCLUDED.value;

INSERT INTO config_code_parts (context, entity, part, source_expr, concat_order, descript, active) VALUES
('feature', NULL, 'separator', $$'_'::text$$, 2, 'Underscore separator', true),
('feature', NULL, 'sequence', $$lpad(nextval('seq_feature_code')::text, 8, '0')$$, 3, 'Global feature sequence suffix', true),
('feature', 'NODE', 'abrevation', '(SELECT abrevation FROM cat_feature WHERE id = ($1::json->>''node_type''))', 1, 'Catalog abrevation for nodes', true),
('feature', 'ARC', 'abrevation', '(SELECT abrevation FROM cat_feature WHERE id = ($1::json->>''arc_type''))', 1, 'Catalog abrevation for arcs', true),
('feature', 'CONNEC', 'abrevation', '(SELECT abrevation FROM cat_feature WHERE id = ($1::json->>''connec_type''))', 1, 'Catalog abrevation for connecs', true)
ON CONFLICT (context, entity, part) DO UPDATE SET
  source_expr = EXCLUDED.source_expr,
  concat_order = EXCLUDED.concat_order,
  active = EXCLUDED.active;

UPDATE cat_feature SET abrevation = 'TST', code_autofill = true
WHERE id IN ('JUNCTION', 'PIPE', 'WJOIN');

CREATE OR REPLACE FUNCTION pg_temp.test_ws_insert_node(p_node_id text, p_code text, p_sys_code text)
RETURNS void LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO ve_node_junction (
        node_id, code, sys_code, top_elev, node_type, sys_type, nodecat_id, epa_type, state, state_type,
        expl_id, sector_id, presszone_id, dma_id, staticpressure, soilcat_id, workcat_id, ownercat_id, muni_id,
        verified, the_geom, publish, inventory, inp_type
    ) VALUES (
        p_node_id::integer, p_code, p_sys_code, 33.1500, 'JUNCTION', 'JUNCTION', 'JUNCTION DN63', 'JUNCTION', 1, 2,
        2, 5, 3, 3, 38.600, 'soil1', 'work1', 'owner1', 2,
        '1', format('SRID=25831;POINT(%s %s)', 433000 + abs(p_node_id::integer), 4588000 + abs(p_node_id::integer))::geometry, true, true, 'JUNCTION'
    );
END;
$$;

CREATE OR REPLACE FUNCTION pg_temp.test_ws_insert_arc(p_arc_id text, p_code text, p_sys_code text)
RETURNS void LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO ve_arc (
        arc_id, code, sys_code, node_1, nodetype_1, elevation1, depth1, staticpressure1, node_2, nodetype_2,
        staticpressure2, elevation2, depth2, depth, arccat_id, arc_type, sys_type, cat_matcat_id, cat_pnom,
        cat_dnom, cat_dint, epa_type, state, state_type, expl_id, sector_id, presszone_id, dma_id, soilcat_id,
        function_type, category_type, fluid_type, location_type, workcat_id, ownercat_id, muni_id, link, verified,
        publish, inventory, the_geom, inp_type
    ) VALUES (
        p_arc_id::integer, p_code, p_sys_code, '1059', 'T', 39.4360, 0.0000, 32.314, '1058', 'T',
        34.309, 37.4409, 0.0000, 0.00, 'FD150', 'PIPE', 'PIPE', 'FD', '16',
        '150', 153.00000, 'PIPE', 1, 2, 1, 3, '3', 2, 'soil1',
        'St. Function', 'St. Category', 'St. Fluid', 'St. Location', 'work1', 'owner1', 1, '', '0',
        true, true, 'SRID=25831;LINESTRING (419226.5872581192 4576722.169890118, 419241.7624485789 4576716.732824818)'::geometry, 'PIPE'
    );
END;
$$;

CREATE OR REPLACE FUNCTION pg_temp.test_ws_insert_connec(p_connec_id text, p_code text, p_sys_code text)
RETURNS void LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO ve_connec (
        connec_id, code, sys_code, top_elev, depth, connec_type, sys_type, conneccat_id, cat_matcat_id, cat_pnom,
        cat_dnom, cat_dint, epa_type, inp_type, state, state_type, expl_id, sector_id, presszone_id, dma_id,
        customer_code, connec_length, arc_id, staticpressure, soilcat_id, function_type, category_type, fluid_type,
        location_type, workcat_id, ownercat_id, muni_id, rotation, link, verified, publish, inventory, pjoint_id,
        pjoint_type, the_geom, is_operative
    ) VALUES (
        p_connec_id::integer, p_code, p_sys_code, 38.0963, NULL, 'WJOIN', 'WJOIN', 'FACADE-CABINET', 'PVC', '16',
        '25', 25.00000, 'JUNCTION', 'JUNCTION', 1, 2, 1, 3, '3', 2,
        'cc3279', NULL, '2031', 33.654, 'soil1', 'St. Function', 'St. Category', 'St. Fluid',
        'St. Location', 'work2', 'owner1', 1, 2.564, 'https://www.giswater.org', '0', true, true, '2031',
        'ARC', format('SRID=25831;POINT(%s %s)', 434000 + abs(p_connec_id::integer), 4589000 + abs(p_connec_id::integer))::geometry, true
    );
END;
$$;

CREATE OR REPLACE FUNCTION pg_temp.test_set_sys_code_mode(p_feature text, p_mode text)
RETURNS void LANGUAGE plpgsql AS $$
BEGIN
    UPDATE config_param_system
    SET value = (('{"node":"none","arc":"none","connec":"none"}'::jsonb
        || jsonb_build_object(p_feature, p_mode))::text)
    WHERE parameter = 'edit_sys_code_autofill';
END;
$$;

-- NODE: code autofill on
ALTER SEQUENCE seq_feature_code RESTART WITH 1;
UPDATE cat_feature SET code_autofill = true WHERE id = 'JUNCTION';
UPDATE config_code_parts SET active = true WHERE context = 'feature';
SELECT pg_temp.test_ws_insert_node('-991', NULL, NULL);
SELECT ok((SELECT code FROM node WHERE node_id = '-991') ~ '^TST_', 'WS node: code autofill generates code');
DELETE FROM node WHERE node_id = '-991';

-- NODE: code autofill off
UPDATE cat_feature SET code_autofill = false WHERE id = 'JUNCTION';
SELECT pg_temp.test_ws_insert_node('-992', NULL, NULL);
SELECT is((SELECT code FROM node WHERE node_id = '-992'), NULL::text, 'WS node: code autofill disabled keeps code NULL');
DELETE FROM node WHERE node_id = '-992';
UPDATE cat_feature SET code_autofill = true WHERE id = 'JUNCTION';

-- NODE: sys_code uuid
SELECT pg_temp.test_set_sys_code_mode('node', 'uuid');
SELECT pg_temp.test_ws_insert_node('-993', NULL, NULL);
SELECT ok((SELECT sys_code FROM node WHERE node_id = '-993') ~ '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$', 'WS node: sys_code uuid mode');
DELETE FROM node WHERE node_id = '-993';

-- NODE: sys_code code
SELECT pg_temp.test_set_sys_code_mode('node', 'code');
SELECT pg_temp.test_ws_insert_node('-994', 'USR-NODE', NULL);
SELECT is((SELECT sys_code FROM node WHERE node_id = '-994'), 'USR-NODE', 'WS node: sys_code code mode copies code');
DELETE FROM node WHERE node_id = '-994';

-- NODE: sys_code none
SELECT pg_temp.test_set_sys_code_mode('node', 'none');
SELECT pg_temp.test_ws_insert_node('-995', 'USR-NODE2', NULL);
SELECT is((SELECT sys_code FROM node WHERE node_id = '-995'), NULL::text, 'WS node: sys_code none keeps sys_code NULL');
DELETE FROM node WHERE node_id = '-995';

-- ARC: code autofill on
ALTER SEQUENCE seq_feature_code RESTART WITH 1;
UPDATE cat_feature SET code_autofill = true WHERE id = 'PIPE';
SELECT pg_temp.test_ws_insert_arc('-791', NULL, NULL);
SELECT ok((SELECT code FROM arc WHERE arc_id = '-791') ~ '^TST_', 'WS arc: code autofill generates code');
DELETE FROM arc WHERE arc_id = '-791';

-- ARC: code autofill off
UPDATE cat_feature SET code_autofill = false WHERE id = 'PIPE';
SELECT pg_temp.test_ws_insert_arc('-792', NULL, NULL);
SELECT is((SELECT code FROM arc WHERE arc_id = '-792'), NULL::text, 'WS arc: code autofill disabled keeps code NULL');
DELETE FROM arc WHERE arc_id = '-792';
UPDATE cat_feature SET code_autofill = true WHERE id = 'PIPE';

-- ARC: sys_code uuid
SELECT pg_temp.test_set_sys_code_mode('arc', 'uuid');
SELECT pg_temp.test_ws_insert_arc('-793', NULL, NULL);
SELECT ok((SELECT sys_code FROM arc WHERE arc_id = '-793') ~ '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$', 'WS arc: sys_code uuid mode');
DELETE FROM arc WHERE arc_id = '-793';

-- ARC: sys_code code
SELECT pg_temp.test_set_sys_code_mode('arc', 'code');
SELECT pg_temp.test_ws_insert_arc('-794', 'USR-ARC', NULL);
SELECT is((SELECT sys_code FROM arc WHERE arc_id = '-794'), 'USR-ARC', 'WS arc: sys_code code mode copies code');
DELETE FROM arc WHERE arc_id = '-794';

-- ARC: sys_code none
SELECT pg_temp.test_set_sys_code_mode('arc', 'none');
SELECT pg_temp.test_ws_insert_arc('-795', 'USR-ARC2', NULL);
SELECT is((SELECT sys_code FROM arc WHERE arc_id = '-795'), NULL::text, 'WS arc: sys_code none keeps sys_code NULL');
DELETE FROM arc WHERE arc_id = '-795';

-- CONNEC: code autofill on
ALTER SEQUENCE seq_feature_code RESTART WITH 1;
UPDATE cat_feature SET code_autofill = true WHERE id = 'WJOIN';
SELECT pg_temp.test_ws_insert_connec('-781', NULL, NULL);
SELECT ok((SELECT code FROM connec WHERE connec_id = '-781') ~ '^TST_', 'WS connec: code autofill generates code');
DELETE FROM connec WHERE connec_id = '-781';

-- CONNEC: code autofill off
UPDATE cat_feature SET code_autofill = false WHERE id = 'WJOIN';
SELECT pg_temp.test_ws_insert_connec('-782', NULL, NULL);
SELECT is((SELECT code FROM connec WHERE connec_id = '-782'), NULL::text, 'WS connec: code autofill disabled keeps code NULL');
DELETE FROM connec WHERE connec_id = '-782';
UPDATE cat_feature SET code_autofill = true WHERE id = 'WJOIN';

-- CONNEC: sys_code uuid
SELECT pg_temp.test_set_sys_code_mode('connec', 'uuid');
SELECT pg_temp.test_ws_insert_connec('-783', NULL, NULL);
SELECT ok((SELECT sys_code FROM connec WHERE connec_id = '-783') ~ '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$', 'WS connec: sys_code uuid mode');
DELETE FROM connec WHERE connec_id = '-783';

-- CONNEC: sys_code code
SELECT pg_temp.test_set_sys_code_mode('connec', 'code');
SELECT pg_temp.test_ws_insert_connec('-784', 'USR-CONNEC', NULL);
SELECT is((SELECT sys_code FROM connec WHERE connec_id = '-784'), 'USR-CONNEC', 'WS connec: sys_code code mode copies code');
DELETE FROM connec WHERE connec_id = '-784';

-- CONNEC: sys_code none
SELECT pg_temp.test_set_sys_code_mode('connec', 'none');
SELECT pg_temp.test_ws_insert_connec('-785', 'USR-CONNEC2', NULL);
SELECT is((SELECT sys_code FROM connec WHERE connec_id = '-785'), NULL::text, 'WS connec: sys_code none keeps sys_code NULL');
DELETE FROM connec WHERE connec_id = '-785';

SELECT finish();

ROLLBACK;

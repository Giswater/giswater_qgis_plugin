/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DO $patch$
BEGIN
    IF (SELECT value::boolean FROM config_param_system WHERE parameter = 'admin_cibs_schema') IS NOT TRUE THEN
        PERFORM gw_fct_admin_manage_view_dependencies(
            json_build_object(
                'data', json_build_object(
                    'action', 'SAVE-DROP',
                    'rootViews', json_build_array('v_hydrometer'),
                    'batchId', 1
                )
            )
        );
        ALTER TABLE ext_hydrometer ALTER COLUMN wmeter_number TYPE text USING wmeter_number::text;
        CREATE OR REPLACE VIEW v_hydrometer AS SELECT * FROM ext_hydrometer;
        PERFORM gw_fct_admin_manage_view_dependencies(
            json_build_object(
                'data', json_build_object(
                    'action', 'RESTORE',
                    'rootViews', json_build_array('v_hydrometer'),
                    'batchId', 1
                )
            )
        );
    END IF;
END $patch$;

CREATE UNIQUE INDEX link_feature_id_state1_unique
ON link (feature_id, feature_type)
WHERE state = 1 AND feature_id IS NOT NULL;

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4370, 'Invalid or missing QGIS project CRS (EPSG). Please configure a valid projected coordinate system.', NULL, 0, true, 'utils', 'core', 'UI')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4371, 'QGIS project CRS is geographic (lat/long). INP export requires a projected CRS (e.g. EPSG:8908 CRTM05 for Costa Rica). Change the project CRS in QGIS and retry.', NULL, 0, true, 'utils', 'core', 'UI')
ON CONFLICT (id) DO NOTHING;

CREATE SEQUENCE seq_feature_code
    START 1
    INCREMENT 1
    MAXVALUE 99999999;  -- maximum 8 digits

CREATE SEQUENCE seq_mapzone_code
    START 1
    INCREMENT 1
    MAXVALUE 99999;  -- maximum 5 digits

CREATE TABLE IF NOT EXISTS config_mapzones (
    id varchar(30) PRIMARY KEY, -- name
    abrevation varchar(30),
    descript text,
    fid integer,
    code_autofill bool,
    active bool,
    is_dynamic bool
);

INSERT INTO config_mapzones (id, abrevation, descript, fid, code_autofill, active, is_dynamic) VALUES
('MACROSECTOR', 'MAC', 'Macrosector', NULL, true, true, true),
('MACRODMA', 'MAC', 'Macrodma', NULL, true, true, true),
('MACROOMZONE', 'MAC', 'Macroomzone', NULL, true, true, true),
('SECTOR', 'SEC', 'Sector', 130, true, true, true),
('DMA', 'DMA', 'Distribution Management Area', 145, true, true, true),
('OMZONE', 'OM', 'Omzone', NULL, true, true, true)
ON CONFLICT (id) DO NOTHING;

ALTER TABLE cat_feature ADD COLUMN abrevation varchar(30);

UPDATE cat_feature
SET abrevation = addparam::jsonb->>'code_prefix'
WHERE addparam::jsonb ? 'code_prefix';

UPDATE cat_feature
SET addparam = addparam::jsonb - 'code_prefix'
WHERE addparam::jsonb ? 'code_prefix';

CREATE TABLE config_code_parts (
    id serial PRIMARY KEY,
    context varchar(10) NOT NULL CHECK (context IN ('feature', 'mapzone')),
    entity varchar(30),
    part varchar(30) NOT NULL,
    source_expr text NOT NULL,
    concat_order int NOT NULL,
    descript text,
    active bool DEFAULT true
);

CREATE UNIQUE INDEX config_code_parts_context_entity_part_uidx
ON config_code_parts (context, entity, part) NULLS NOT DISTINCT;

CREATE UNIQUE INDEX config_code_parts_context_entity_order_uidx
ON config_code_parts (context, entity, concat_order) NULLS NOT DISTINCT;

INSERT INTO config_code_parts (context, entity, part, source_expr, concat_order, descript, active) VALUES
('feature', NULL, 'separator', $$'_'::text$$, 2, 'Underscore separator', true),
('feature', NULL, 'sequence', $$lpad(nextval('seq_feature_code')::text, 8, '0')$$, 3, 'Global feature sequence suffix', true),
('feature', 'NODE', 'abrevation', '(SELECT abrevation FROM cat_feature WHERE id = ($1::json->>''node_type''))', 1, 'Catalog abrevation for nodes', true),
('feature', 'ARC', 'abrevation', '(SELECT abrevation FROM cat_feature WHERE id = ($1::json->>''arc_type''))', 1, 'Catalog abrevation for arcs', true),
('feature', 'CONNEC', 'abrevation', '(SELECT abrevation FROM cat_feature WHERE id = ($1::json->>''connec_type''))', 1, 'Catalog abrevation for connecs', true),
('feature', 'GULLY', 'abrevation', '(SELECT abrevation FROM cat_feature WHERE id = ($1::json->>''gully_type''))', 1, 'Catalog abrevation for gullies', true),
('feature', 'ELEMENT', 'abrevation', '(SELECT abrevation FROM cat_feature WHERE id = ($1::json->>''elementcat_id''))', 1, 'Catalog abrevation for elements', true),
('feature', 'LINK', 'abrevation', '(SELECT abrevation FROM cat_feature WHERE id = ($1::json->>''feature_type''))', 1, 'Catalog abrevation for links', true),
('mapzone', NULL, 'abrevation', '(SELECT abrevation FROM config_mapzones WHERE id = $2)', 1, 'Mapzone abrevation prefix', true),
('mapzone', NULL, 'separator', $$'_'::text$$, 2, 'Underscore separator', true),
('mapzone', NULL, 'sequence', $$lpad(nextval('seq_mapzone_code')::text, 5, '0')$$, 3, 'Global mapzone sequence suffix', true)
ON CONFLICT (context, entity, part) DO UPDATE SET
  source_expr = EXCLUDED.source_expr,
  concat_order = EXCLUDED.concat_order,
  descript = EXCLUDED.descript,
  active = EXCLUDED.active;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias)
VALUES(3542, 'gw_fct_generate_code', 'utils', 'function', 'text, text, json', 'text',
'Generate autofill code for features or mapzones using configurable SQL templates',
'role_basic', NULL, 'core', NULL)
ON CONFLICT (id) DO UPDATE SET
  input_params = EXCLUDED.input_params,
  descript = EXCLUDED.descript;

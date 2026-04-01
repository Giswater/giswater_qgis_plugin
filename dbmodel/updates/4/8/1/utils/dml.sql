/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- Mapzones analysis
UPDATE sys_function
SET function_alias = 'MAPZONES DYNAMIC SECTORITZATION'
WHERE function_name = 'gw_fct_graphanalytics_mapzones_v1';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4592, 'Mapzone constructor method: %updateMapZone%', NULL, 0, true, 'utils', 'core', 'AUDIT') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4594, 'Update feature mapzone attributes: %commitChanges%', NULL, 0, true, 'utils', 'core', 'AUDIT') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4596, 'From zero: %fromZero%', NULL, 0, true, 'utils', 'core', 'AUDIT') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4598, 'There is a conflict against %graphClass%''s (%mapzones_ids%) with %arcs_count% arc(s) and %connecs_count% connec(s) affected.', NULL, 0, true, 'utils', 'core', 'AUDIT') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4600, '%arcs_count% arc''s have been disconnected', NULL, 0, true, 'utils', 'core', 'AUDIT') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4602, '0 arc''s have been disconnected', NULL, 0, true, 'utils', 'core', 'AUDIT') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4604, '%connecs_count% connec''s have been disconnected', NULL, 0, true, 'utils', 'core', 'AUDIT') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4606, '0 connec''s have been disconnected', NULL, 0, true, 'utils', 'core', 'AUDIT') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4608, '%graphClass% values for features and geometry of the mapzone has been modified by this process', NULL, 0, true, 'utils', 'core', 'AUDIT') ON CONFLICT (id) DO NOTHING;

-- 24/03/2026
UPDATE config_param_system
SET value = (
  COALESCE(value::jsonb, '{}'::jsonb)
  || jsonb_build_object(
    'SECTOR', true,
    'DMA', true,
    'DQA', true,
    'PRESSZONE', true,
    'DWFZONE', true,
    'SUPPLYZONE', true,
    'MACROSECTOR', false,
    'MACRODMA', true,
    'MACRODQA', true,
    'MACROOMZONE', true,
    'OMZONE', false,
    'DRAINZONE', false
  )
)::json
WHERE parameter = 'utils_graphanalytics_status';

-- 2026/04/01
UPDATE config_param_system SET value = value::jsonb || '{"plan_statetype_obsolete_planned": 24}' WHERE parameter = 'plan_statetype_vdefault';
DELETE FROM config_param_system WHERE parameter = ‘plan_psector_status_action’;
DELETE FROM config_param_system WHERE parameter = ‘plan_statetype_planned’;
DELETE FROM config_param_system WHERE parameter = ‘plan_statetype_ficticius’;
DELETE FROM config_param_system WHERE parameter = ‘plan_statetype_reconstruct’;
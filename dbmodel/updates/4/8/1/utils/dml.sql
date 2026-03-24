/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- Mapzones analysis (Info log) - dedicated ids (avoid collisions with existing ones)
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4588, 'MAPZONES DYNAMIC SECTORITZATION - %graphClass%', NULL, 0, true, 'utils', 'core', 'AUDIT') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4590, '------------------------------------------------------------------', NULL, 0, true, 'utils', 'core', 'AUDIT') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4592, 'Mapzone constructor method: %updateMapZone%', NULL, 0, true, 'utils', 'core', 'AUDIT') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4594, 'Update feature mapzone attributes: %commitChanges%', NULL, 0, true, 'utils', 'core', 'AUDIT') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4596, 'From zero: %fromZero%', NULL, 0, true, 'utils', 'core', 'AUDIT') ON CONFLICT (id) DO NOTHING;

-- Section headers/separators (sys_message only)
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4598, 'ERRORS', NULL, 0, true, 'utils', 'core', 'AUDIT') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4600, '-----------', NULL, 0, true, 'utils', 'core', 'AUDIT') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4602, 'WARNINGS', NULL, 0, true, 'utils', 'core', 'AUDIT') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4604, '--------------', NULL, 0, true, 'utils', 'core', 'AUDIT') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4606, 'INFO', NULL, 0, true, 'utils', 'core', 'AUDIT') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4608, '-------', NULL, 0, true, 'utils', 'core', 'AUDIT') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4610, 'DETAILS', NULL, 0, true, 'utils', 'core', 'AUDIT') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4612, '----------', NULL, 0, true, 'utils', 'core', 'AUDIT') ON CONFLICT (id) DO NOTHING;

-- Generic empty spacer line (used with any criticity)
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4614, '', NULL, 0, true, 'utils', 'core', 'AUDIT') ON CONFLICT (id) DO NOTHING;

-- Remaining v1 audit messages
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4616, 'There is a conflict against %graphClass%''s (%mapzones_ids%) with %arcs_count% arc(s) and %connecs_count% connec(s) affected.', NULL, 0, true, 'utils', 'core', 'AUDIT') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4618, '%arcs_count% arc''s have been disconnected', NULL, 0, true, 'utils', 'core', 'AUDIT') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4620, '0 arc''s have been disconnected', NULL, 0, true, 'utils', 'core', 'AUDIT') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4622, '%connecs_count% connec''s have been disconnected', NULL, 0, true, 'utils', 'core', 'AUDIT') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4624, '0 connec''s have been disconnected', NULL, 0, true, 'utils', 'core', 'AUDIT') ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4626, '%graphClass% values for features and geometry of the mapzone has been modified by this process', NULL, 0, true, 'utils', 'core', 'AUDIT') ON CONFLICT (id) DO NOTHING;

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
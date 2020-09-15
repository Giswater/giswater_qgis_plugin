/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/09/15

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (251, 'Conduits with negative slope and inverted slope','ud') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (252, 'Features state=2 are involved in psector','utils') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (253, 'State not according with state_type','utils') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (254, 'Features with code null','utils') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (255, 'Orphan polygons', 'utils') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (256, 'Orphan rows on addfields values', 'utils') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (257, 'Connec or gully without or with wrong arc_id', 'utils') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (258, 'Vnode inconsistency - link without vnode', 'utils') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (259, 'Vnode inconsistency - vnode without link', 'utils') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (260, 'Link without feature_id', 'utils') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (261, 'Link without exit_id', 'utils') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (262, 'Features state=1 and end date', 'utils') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (263, 'Features state=0 without end date', 'utils') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (264, 'Features state=1 and end date before start date', 'utils') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (265, 'Automatic links with more than 100m', 'utils') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (266, 'Duplicated ID between arc, node, connec, gully', 'utils') ON CONFLICT (fid) DO NOTHING;
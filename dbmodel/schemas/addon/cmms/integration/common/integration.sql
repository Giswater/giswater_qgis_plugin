/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- 'node'::regclass is stored as an OID, so a schema rename still resolves
-- asset_feature_map.schema_name to this parent.
DROP VIEW IF EXISTS v_ui_cmms_attachment;
DROP VIEW IF EXISTS v_ui_cmms_visit;

CREATE VIEW v_ui_cmms_visit AS
SELECT
	m.feature_id,
	m.feature_type,
	v.id AS visit_id,
	v.ext_visit_id,
	v.type,
	v.status,
	v.title,
	v.description,
	v.start_date,
	v.end_date,
	EXISTS (
		SELECT 1 FROM cmms.attachment_x_visit ax
		WHERE ax.visit_id = v.id
	) AS has_attachment
FROM cmms.asset_feature_map m
JOIN cmms.visit_x_feature vx ON vx.asset_feature_map_id = m.id
JOIN cmms.visit v ON v.id = vx.visit_id
WHERE m.feature_deleted_at IS NULL
	AND m.schema_name = (
		SELECT relnamespace::regnamespace::text
		FROM pg_class
		WHERE oid = 'node'::regclass
	);

CREATE VIEW v_ui_cmms_attachment AS
SELECT
	m.feature_id,
	m.feature_type,
	NULL::uuid AS visit_id,
	a.id AS attachment_id,
	a.name,
	a.attachment_type,
	a.content_type,
	a.description,
	a.uploaded_at,
	a.uploaded_by,
	a.path,
	a.thumbnail_path
FROM cmms.asset_feature_map m
JOIN cmms.attachment_x_feature axf ON axf.asset_feature_map_id = m.id
JOIN cmms.attachment a ON a.id = axf.attachment_id
WHERE m.feature_deleted_at IS NULL
	AND m.schema_name = (
		SELECT relnamespace::regnamespace::text
		FROM pg_class
		WHERE oid = 'node'::regclass
	)
UNION ALL
SELECT
	m.feature_id,
	m.feature_type,
	vx.visit_id,
	a.id AS attachment_id,
	a.name,
	a.attachment_type,
	a.content_type,
	a.description,
	a.uploaded_at,
	a.uploaded_by,
	a.path,
	a.thumbnail_path
FROM cmms.asset_feature_map m
JOIN cmms.visit_x_feature vx ON vx.asset_feature_map_id = m.id
JOIN cmms.attachment_x_visit axv ON axv.visit_id = vx.visit_id
JOIN cmms.attachment a ON a.id = axv.attachment_id
WHERE m.feature_deleted_at IS NULL
	AND m.schema_name = (
		SELECT relnamespace::regnamespace::text
		FROM pg_class
		WHERE oid = 'node'::regclass
	);

INSERT INTO sys_table (id, descript, sys_role, source)
VALUES
	('v_ui_cmms_visit', 'CMMS visits linked to a feature', 'role_basic', 'core'),
	('v_ui_cmms_attachment', 'CMMS attachments linked to a feature', 'role_basic', 'core')
ON CONFLICT (id) DO NOTHING;

DO $cmms_grant_views$
BEGIN
	IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'role_basic') THEN
		GRANT SELECT ON v_ui_cmms_visit, v_ui_cmms_attachment TO role_basic;
	END IF;
END
$cmms_grant_views$;

DELETE FROM config_typevalue
WHERE typevalue = 'layout_name_typevalue'
	AND id IN ('lyt_cmms_1', 'lyt_cmms_2', 'lyt_cmms_3');

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam)
VALUES
	('tabname_typevalue', 'tab_cmms', 'tab_cmms', 'tabCmms', NULL),
	('formtype_typevalue', 'cmms_visit', 'cmms_visit', 'cmmsVisit', NULL),
	('formtype_typevalue', 'cmms_attachment', 'cmms_attachment', 'cmmsAttachment', NULL),
	('layout_name_typevalue', 'lyt_cmms_main', 'lyt_cmms_main', 'layoutCmmsMain', NULL),
	('layout_name_typevalue', 'lyt_cmms_v_1', 'lyt_cmms_v_1', 'layoutCmmsV1', '{"lytOrientation":"horizontal"}'::json),
	('layout_name_typevalue', 'lyt_cmms_v_2', 'lyt_cmms_v_2', 'layoutCmmsV2', '{"lytOrientation":"horizontal"}'::json),
	('layout_name_typevalue', 'lyt_cmms_v_3', 'lyt_cmms_v_3', 'layoutCmmsV3', NULL),
	('layout_name_typevalue', 'lyt_cmms_a_1', 'lyt_cmms_a_1', 'layoutCmmsA1', '{"lytOrientation":"horizontal"}'::json),
	('layout_name_typevalue', 'lyt_cmms_a_2', 'lyt_cmms_a_2', 'layoutCmmsA2', '{"lytOrientation":"horizontal"}'::json),
	('layout_name_typevalue', 'lyt_cmms_a_3', 'lyt_cmms_a_3', 'layoutCmmsA3', NULL)
ON CONFLICT (typevalue, id) DO NOTHING;

DELETE FROM config_form_fields WHERE tabname = 'tab_cmms';

INSERT INTO config_form_fields (
	formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype,
	ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject, hidden
)
SELECT f.formname, 'form_feature', 'tab_cmms', 'tbl_visit', 'lyt_cmms_v_3', 1, 'tableview',
	false, false, false, false, false, '{"saveValue": false}'::json,
	'{"functionName": "open_cmms_visit"}'::json, 'v_ui_cmms_visit', false
FROM unnest(ARRAY['node', 'arc', 'connec', 'link', 'gully']) AS f(formname)
WHERE f.formname <> 'gully' OR to_regclass('gully') IS NOT NULL;

INSERT INTO config_form_fields (
	formname, formtype, tabname, columnname, layoutname, layoutorder, widgettype,
	ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction, linkedobject, hidden
)
SELECT f.formname, 'form_feature', 'tab_cmms', 'tbl_attachment', 'lyt_cmms_a_3', 1, 'tableview',
	false, false, false, false, false, '{"saveValue": false}'::json,
	'{"functionName": "open_cmms_attachment"}'::json, 'v_ui_cmms_attachment', false
FROM unnest(ARRAY['node', 'arc', 'connec', 'link', 'gully']) AS f(formname)
WHERE f.formname <> 'gully' OR to_regclass('gully') IS NOT NULL;

DELETE FROM config_form_fields WHERE formtype IN ('cmms_visit', 'cmms_attachment');

INSERT INTO config_form_fields (
	formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype,
	label, tooltip, ismandatory, isparent, iseditable, isautoupdate, isfilter, widgetcontrols, widgetfunction,
	linkedobject, hidden
)
VALUES
	('generic', 'cmms_visit', 'tab_none', 'visit_id', 'lyt_cmms_main', 1, 'string', 'text',
		'Visit id', 'Visit id', false, false, false, false, false, NULL, NULL, NULL, false),
	('generic', 'cmms_visit', 'tab_none', 'ext_visit_id', 'lyt_cmms_main', 2, 'string', 'text',
		'External id', 'External id', false, false, false, false, false, NULL, NULL, NULL, false),
	('generic', 'cmms_visit', 'tab_none', 'type', 'lyt_cmms_main', 3, 'string', 'text',
		'Type', 'Type', false, false, false, false, false, NULL, NULL, NULL, false),
	('generic', 'cmms_visit', 'tab_none', 'status', 'lyt_cmms_main', 4, 'string', 'text',
		'Status', 'Status', false, false, false, false, false, NULL, NULL, NULL, false),
	('generic', 'cmms_visit', 'tab_none', 'title', 'lyt_cmms_main', 5, 'string', 'text',
		'Title', 'Title', false, false, false, false, false, NULL, NULL, NULL, false),
	('generic', 'cmms_visit', 'tab_none', 'start_date', 'lyt_cmms_main', 6, 'string', 'text',
		'Start date', 'Start date', false, false, false, false, false, NULL, NULL, NULL, false),
	('generic', 'cmms_visit', 'tab_none', 'end_date', 'lyt_cmms_main', 7, 'string', 'text',
		'End date', 'End date', false, false, false, false, false, NULL, NULL, NULL, false),
	('generic', 'cmms_visit', 'tab_none', 'description', 'lyt_cmms_main', 8, 'string', 'textarea',
		'Description', 'Description', false, false, false, false, false, NULL, NULL, NULL, false),
	('generic', 'cmms_visit', 'tab_none', 'tbl_attachment', 'lyt_cmms_main', 9, NULL, 'tableview',
		'Attachments', 'Attachments', false, false, false, false, false, '{"saveValue": false}'::json,
		'{"functionName": "open_cmms_attachment"}'::json, 'v_ui_cmms_attachment', false),
	('generic', 'cmms_attachment', 'tab_none', 'name', 'lyt_cmms_main', 1, 'string', 'text',
		'Name', 'Name', false, false, false, false, false, NULL, NULL, NULL, false),
	('generic', 'cmms_attachment', 'tab_none', 'attachment_type', 'lyt_cmms_main', 2, 'string', 'text',
		'Type', 'Type', false, false, false, false, false, NULL, NULL, NULL, false),
	('generic', 'cmms_attachment', 'tab_none', 'content_type', 'lyt_cmms_main', 3, 'string', 'text',
		'Content type', 'Content type', false, false, false, false, false, NULL, NULL, NULL, false),
	('generic', 'cmms_attachment', 'tab_none', 'uploaded_at', 'lyt_cmms_main', 4, 'string', 'text',
		'Uploaded at', 'Uploaded at', false, false, false, false, false, NULL, NULL, NULL, false),
	('generic', 'cmms_attachment', 'tab_none', 'uploaded_by', 'lyt_cmms_main', 5, 'string', 'text',
		'Uploaded by', 'Uploaded by', false, false, false, false, false, NULL, NULL, NULL, false),
	('generic', 'cmms_attachment', 'tab_none', 'path', 'lyt_cmms_main', 6, 'string', 'text',
		'Path', 'Path', false, false, false, false, false, NULL, NULL, NULL, false),
	('generic', 'cmms_attachment', 'tab_none', 'description', 'lyt_cmms_main', 7, 'string', 'textarea',
		'Description', 'Description', false, false, false, false, false, NULL, NULL, NULL, false),
	('generic', 'cmms_attachment', 'tab_none', 'btn_open', 'lyt_cmms_main', 8, NULL, 'button',
		NULL, 'Open', false, false, true, false, false, '{"text": "Open"}'::json,
		'{"functionName": "open_cmms_attachment_file"}'::json, NULL, false),
	('generic', 'cmms_attachment', 'tab_none', 'thumbnail_path', 'lyt_cmms_main', 9, 'string', 'text',
		'Thumbnail path', 'Thumbnail path', false, false, false, false, false, NULL, NULL, NULL, true);

DELETE FROM config_form_tableview
WHERE objectname IN ('v_ui_cmms_visit', 'v_ui_cmms_attachment');

INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, alias)
VALUES
	('info form', 'utils', 'v_ui_cmms_visit', 'feature_id', 0, false, 'Feature id'),
	('info form', 'utils', 'v_ui_cmms_visit', 'feature_type', 1, false, 'Feature type'),
	('info form', 'utils', 'v_ui_cmms_visit', 'visit_id', 2, true, 'Visit id'),
	('info form', 'utils', 'v_ui_cmms_visit', 'ext_visit_id', 3, false, 'External id'),
	('info form', 'utils', 'v_ui_cmms_visit', 'type', 4, true, 'Type'),
	('info form', 'utils', 'v_ui_cmms_visit', 'status', 5, true, 'Status'),
	('info form', 'utils', 'v_ui_cmms_visit', 'title', 6, true, 'Title'),
	('info form', 'utils', 'v_ui_cmms_visit', 'description', 7, true, 'Description'),
	('info form', 'utils', 'v_ui_cmms_visit', 'start_date', 8, true, 'Start date'),
	('info form', 'utils', 'v_ui_cmms_visit', 'end_date', 9, true, 'End date'),
	('info form', 'utils', 'v_ui_cmms_visit', 'has_attachment', 10, true, 'Has attachment'),
	('info form', 'utils', 'v_ui_cmms_attachment', 'feature_id', 0, false, 'Feature id'),
	('info form', 'utils', 'v_ui_cmms_attachment', 'feature_type', 1, false, 'Feature type'),
	('info form', 'utils', 'v_ui_cmms_attachment', 'visit_id', 2, true, 'Visit id'),
	('info form', 'utils', 'v_ui_cmms_attachment', 'attachment_id', 3, false, 'Attachment id'),
	('info form', 'utils', 'v_ui_cmms_attachment', 'name', 4, true, 'Name'),
	('info form', 'utils', 'v_ui_cmms_attachment', 'attachment_type', 5, true, 'Type'),
	('info form', 'utils', 'v_ui_cmms_attachment', 'content_type', 6, true, 'Content type'),
	('info form', 'utils', 'v_ui_cmms_attachment', 'description', 7, true, 'Description'),
	('info form', 'utils', 'v_ui_cmms_attachment', 'uploaded_at', 8, true, 'Uploaded at'),
	('info form', 'utils', 'v_ui_cmms_attachment', 'uploaded_by', 9, true, 'Uploaded by'),
	('info form', 'utils', 'v_ui_cmms_attachment', 'path', 10, true, 'Path'),
	('info form', 'utils', 'v_ui_cmms_attachment', 'thumbnail_path', 11, false, 'Thumbnail path');

INSERT INTO config_form_tabs (formname, tabname, label, tooltip, sys_role, tabactions, device, orderby)
SELECT f.formname, 'tab_cmms', 'Visits', 'CMMS visits and attachments', 'role_basic',
	e.tabactions, COALESCE(e.device, '{4,5}'::integer[]), COALESCE(e.orderby, 6)
FROM unnest(ARRAY['ve_node', 've_arc', 've_connec', 've_link', 've_gully']) AS f(formname)
LEFT JOIN LATERAL (
	SELECT tabactions, device, orderby
	FROM config_form_tabs
	WHERE formname = f.formname AND tabname = 'tab_event'
	LIMIT 1
) e ON true
WHERE to_regclass(f.formname) IS NOT NULL
ON CONFLICT DO NOTHING;

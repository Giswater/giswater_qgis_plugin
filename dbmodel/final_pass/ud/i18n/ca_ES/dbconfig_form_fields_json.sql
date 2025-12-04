/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE config_param_system SET value = FALSE WHERE parameter = 'admin_config_control_trigger';

UPDATE config_form_fields AS t
SET widgetcontrols = v.text::json
FROM (
	VALUES
	('btn_accept', 'generic', 'form_visit', 'tab_data', '{"text": "Acceptar", "setMultiline": false}'),
    ('btn_apply', 'generic', 'form_visit', 'tab_file', '{"text": "Aplicar", "setMultiline": false}'),
    ('btn_cancel', 'generic', 'form_visit', 'tab_file', '{"text": "Cancel·la", "setMultiline": false}'),
    ('btn_accept', 'generic', 'link_to_gully', 'tab_none', '{"text": "Acceptar"}'),
    ('btn_close', 'generic', 'link_to_gully', 'tab_none', '{"text": "Tancar"}'),
    ('btn_accept', 'gully', 'form_feature', 'tab_none', '{"text": "Acceptar"}'),
    ('btn_apply', 'gully', 'form_feature', 'tab_none', '{"text": "Aplicar"}'),
    ('btn_cancel', 'gully', 'form_feature', 'tab_none', '{"text": "Cancel·la"}'),
    ('btn_accept', 'arc', 'form_feature', 'tab_none', '{"text": "Acceptar"}'),
    ('btn_apply', 'arc', 'form_feature', 'tab_none', '{"text": "Aplicar"}'),
    ('btn_cancel', 'arc', 'form_feature', 'tab_none', '{"text": "Cancel·la"}'),
    ('btn_accept', 'connec', 'form_feature', 'tab_none', '{"text": "Acceptar"}'),
    ('btn_apply', 'connec', 'form_feature', 'tab_none', '{"text": "Aplicar"}'),
    ('btn_cancel', 'connec', 'form_feature', 'tab_none', '{"text": "Cancel·la"}'),
    ('cancel', 'element_manager', 'form_element', 'tab_none', '{"text": "Tancar", "saveValue": false}'),
    ('create', 'element_manager', 'form_element', 'tab_none', '{"text": "Crear", "saveValue": false}'),
    ('delete', 'element_manager', 'form_element', 'tab_none', '{"text": "Suprimeix", "saveValue": false, "onContextMenu": "Delete"}'),
    ('btn_close', 'generic', 'audit', 'tab_none', '{"text": "Tancar"}'),
    ('btn_close', 'generic', 'audit_manager', 'tab_none', '{"text": "Tancar"}'),
    ('btn_open', 'generic', 'audit_manager', 'tab_none', '{"text": "Obert"}'),
    ('btn_open_date', 'generic', 'audit_manager', 'tab_none', '{"text": "Data oberta"}'),
    ('Info:', 'generic', 'check_project', 'tab_data', '{"vdefault_value": "Aquesta funció verifica tant el projecte com la base de dades.Per a la verificació de la base de dades es revisen tots els objectes seleccionats per l''usuari mitjançant el seu selector de sector i explotació."}'),
    ('btn_accept', 'generic', 'create_organization', 'tab_none', '{"text": "Acceptar"}'),
    ('btn_close', 'generic', 'create_organization', 'tab_none', '{"text": "Tancar"}'),
    ('btn_close', 'generic', 'dscenario', 'tab_none', '{"text": "Tancar"}'),
    ('btn_close', 'generic', 'dscenario_manager', 'tab_none', '{"text": "Tancar"}'),
    ('btn_close', 'generic', 'epa_manager', 'tab_none', '{"text": "Tancar"}'),
    ('btn_accept', 'generic', 'epa_selector', 'tab_none', '{"text": "Acceptar"}'),
    ('btn_cancel', 'generic', 'epa_selector', 'tab_none', '{"text": "Cancel·la"}'),
    ('btn_accept', 'generic', 'form_featuretype_change', 'tab_none', '{"text": "Acceptar"}'),
    ('btn_cancel', 'generic', 'form_featuretype_change', 'tab_none', '{"text": "Cancel·la"}'),
    ('btn_accept', 'generic', 'link_to_connec', 'tab_none', '{"text": "Acceptar"}'),
    ('btn_close', 'generic', 'link_to_connec', 'tab_none', '{"text": "Tancar"}'),
    ('btn_cancel', 'generic', 'nvo_manager', 'tab_none', '{"text": "Tancar"}'),
    ('btn_accept', 'generic', 'psector', 'tab_none', '{"text": "Acceptar"}'),
    ('btn_close', 'generic', 'psector', 'tab_none', '{"text": "Cancel·la"}'),
    ('btn_close', 'generic', 'psector_manager', 'tab_none', '{"text": "Tancar"}'),
    ('btn_close', 'generic', 'snapshot_view', 'tab_none', '{"text": "Tancar"}'),
    ('btn_run', 'generic', 'snapshot_view', 'tab_none', '{"text": "Corre"}'),
    ('btn_close', 'generic', 'workspace_manager', 'tab_none', '{"text": "Tancar"}'),
    ('btn_accept', 'generic', 'workspace_open', 'tab_none', '{"text": "Desa"}'),
    ('btn_close', 'generic', 'workspace_open', 'tab_none', '{"text": "Tancar"}'),
    ('btn_accept', 'node', 'form_feature', 'tab_none', '{"text": "Acceptar"}'),
    ('btn_apply', 'node', 'form_feature', 'tab_none', '{"text": "Aplicar"}'),
    ('btn_cancel', 'node', 'form_feature', 'tab_none', '{"text": "Cancel·la"}')
) AS v(columnname, formname, formtype, tabname, text)
WHERE t.columnname = v.columnname AND t.formname = v.formname AND t.formtype = v.formtype AND t.tabname = v.tabname;

UPDATE config_param_system SET value = TRUE WHERE parameter = 'admin_config_control_trigger';

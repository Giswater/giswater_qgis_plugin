/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE config_param_system SET value = FALSE WHERE parameter = 'admin_config_control_trigger';

UPDATE config_form_fields AS t SET widgetcontrols = v.text::json FROM (
	VALUES
	('btn_accept', 'generic', 'form_visit', 'tab_data', '{"text": "Akceptuj", "setMultiline": false}'),
    ('btn_apply', 'generic', 'form_visit', 'tab_file', '{"text": "Zastosuj", "setMultiline": false}'),
    ('btn_cancel', 'generic', 'form_visit', 'tab_file', '{"text": "Anuluj", "setMultiline": false}'),
    ('btn_accept', 'generic', 'link_to_gully', 'tab_none', '{"text": "Akceptuj"}'),
    ('btn_close', 'generic', 'link_to_gully', 'tab_none', '{"text": "Zamknij"}'),
    ('btn_accept', 'gully', 'form_feature', 'tab_none', '{"text": "Akceptuj"}'),
    ('btn_apply', 'gully', 'form_feature', 'tab_none', '{"text": "Zastosuj"}'),
    ('btn_cancel', 'gully', 'form_feature', 'tab_none', '{"text": "Anuluj"}'),
    ('btn_accept', 'arc', 'form_feature', 'tab_none', '{"text": "Akceptuj"}'),
    ('btn_apply', 'arc', 'form_feature', 'tab_none', '{"text": "Zastosuj"}'),
    ('btn_cancel', 'arc', 'form_feature', 'tab_none', '{"text": "Anuluj"}'),
    ('btn_accept', 'connec', 'form_feature', 'tab_none', '{"text": "Akceptuj"}'),
    ('btn_apply', 'connec', 'form_feature', 'tab_none', '{"text": "Zastosuj"}'),
    ('btn_cancel', 'connec', 'form_feature', 'tab_none', '{"text": "Anuluj"}'),
    ('cancel', 'element_manager', 'form_element', 'tab_none', '{"text": "Close", "saveValue": false}'),
    ('create', 'element_manager', 'form_element', 'tab_none', '{"text": "Utwórz", "saveValue": false}'),
    ('delete', 'element_manager', 'form_element', 'tab_none', '{"text": "Delete", "saveValue": false, "onContextMenu": "Delete"}'),
    ('btn_close', 'generic', 'audit', 'tab_none', '{"text": "Zamknij"}'),
    ('btn_close', 'generic', 'audit_manager', 'tab_none', '{"text": "Zamknij"}'),
    ('btn_open', 'generic', 'audit_manager', 'tab_none', '{"text": "Otwarty"}'),
    ('btn_open_date', 'generic', 'audit_manager', 'tab_none', '{"text": "Data otwarcia"}'),
    ('Info:', 'generic', 'check_project', 'tab_data', '{"vdefault_value": "Ta funkcja weryfikuje zarówno projekt, jak i bazę danych. W przypadku weryfikacji bazy danych sprawdzane są wszystkie obiekty wybrane przez użytkownika za pomocą selektora sektora i eksploatacji."}'),
    ('btn_accept', 'generic', 'create_organization', 'tab_none', '{"text": "Akceptuj"}'),
    ('btn_close', 'generic', 'create_organization', 'tab_none', '{"text": "Zamknij"}'),
    ('btn_close', 'generic', 'dscenario', 'tab_none', '{"text": "Zamknij"}'),
    ('btn_close', 'generic', 'dscenario_manager', 'tab_none', '{"text": "Zamknij"}'),
    ('btn_close', 'generic', 'epa_manager', 'tab_none', '{"text": "Zamknij"}'),
    ('btn_accept', 'generic', 'epa_selector', 'tab_none', '{"text": "Akceptuj"}'),
    ('btn_cancel', 'generic', 'epa_selector', 'tab_none', '{"text": "Anuluj"}'),
    ('btn_accept', 'generic', 'form_featuretype_change', 'tab_none', '{"text": "Accept"}'),
    ('btn_cancel', 'generic', 'form_featuretype_change', 'tab_none', '{"text": "Anuluj"}'),
    ('btn_accept', 'generic', 'link_to_connec', 'tab_none', '{"text": "Akceptuj"}'),
    ('btn_close', 'generic', 'link_to_connec', 'tab_none', '{"text": "Zamknij"}'),
    ('btn_cancel', 'generic', 'nvo_manager', 'tab_none', '{"text": "Zamknij"}'),
    ('btn_accept', 'generic', 'psector', 'tab_none', '{"text": "Akceptuj"}'),
    ('btn_close', 'generic', 'psector', 'tab_none', '{"text": "Anuluj"}'),
    ('btn_close', 'generic', 'psector_manager', 'tab_none', '{"text": "Zamknij"}'),
    ('btn_close', 'generic', 'snapshot_view', 'tab_none', '{"text": "Zamknij"}'),
    ('btn_run', 'generic', 'snapshot_view', 'tab_none', '{"text": "Bieg"}'),
    ('btn_close', 'generic', 'workspace_manager', 'tab_none', '{"text": "Zamknij"}'),
    ('btn_accept', 'generic', 'workspace_open', 'tab_none', '{"text": "Zapisz"}'),
    ('btn_close', 'generic', 'workspace_open', 'tab_none', '{"text": "Zamknij"}'),
    ('btn_accept', 'node', 'form_feature', 'tab_none', '{"text": "Akceptuj"}'),
    ('btn_apply', 'node', 'form_feature', 'tab_none', '{"text": "Zastosuj"}'),
    ('btn_cancel', 'node', 'form_feature', 'tab_none', '{"text": "Anuluj"}')
) AS v(columnname, formname, formtype, tabname, text)
WHERE t.columnname = v.columnname AND t.formname = v.formname AND t.formtype = v.formtype AND t.tabname = v.tabname;

UPDATE config_param_system SET value = TRUE WHERE parameter = 'admin_config_control_trigger';

/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE config_param_system SET value = FALSE WHERE parameter = 'admin_config_control_trigger';

UPDATE config_form_fields AS t SET widgetcontrols = v.text::json FROM (
	VALUES
	('btn_accept', 'arc', 'form_feature', 'tab_none', '{"text": "Acceptați"}'),
    ('btn_apply', 'arc', 'form_feature', 'tab_none', '{"text": "Aplicați"}'),
    ('btn_cancel', 'arc', 'form_feature', 'tab_none', '{"text": "Anulează"}'),
    ('btn_accept', 'connec', 'form_feature', 'tab_none', '{"text": "Acceptați"}'),
    ('btn_apply', 'connec', 'form_feature', 'tab_none', '{"text": "Aplicați"}'),
    ('btn_cancel', 'connec', 'form_feature', 'tab_none', '{"text": "Anulează"}'),
    ('cancel', 'element_manager', 'form_element', 'tab_none', '{"text": "Închidere", "saveValue": false}'),
    ('create', 'element_manager', 'form_element', 'tab_none', '{"text": "Creați", "saveValue": false}'),
    ('delete', 'element_manager', 'form_element', 'tab_none', '{"text": "Ștergeți", "saveValue": false, "onContextMenu": "Delete"}'),
    ('btn_close', 'generic', 'audit', 'tab_none', '{"text": "Închidere"}'),
    ('btn_close', 'generic', 'audit_manager', 'tab_none', '{"text": "Închidere"}'),
    ('btn_open', 'generic', 'audit_manager', 'tab_none', '{"text": "Deschis"}'),
    ('btn_open_date', 'generic', 'audit_manager', 'tab_none', '{"text": "Data deschiderii"}'),
    ('Info:', 'generic', 'check_project', 'tab_data', '{"vdefault_value": "Această funcție verifică atât proiectul, cât și baza de date. Pentru verificarea bazei de date, sunt verificate toate obiectele selectate de utilizator prin intermediul selectorului de sector și de exploatare."}'),
    ('btn_accept', 'generic', 'create_organization', 'tab_none', '{"text": "Acceptați"}'),
    ('btn_close', 'generic', 'create_organization', 'tab_none', '{"text": "Închidere"}'),
    ('btn_close', 'generic', 'dscenario', 'tab_none', '{"text": "Închidere"}'),
    ('btn_close', 'generic', 'dscenario_manager', 'tab_none', '{"text": "Închidere"}'),
    ('btn_close', 'generic', 'epa_manager', 'tab_none', '{"text": "Închidere"}'),
    ('btn_accept', 'generic', 'epa_selector', 'tab_none', '{"text": "Acceptați"}'),
    ('btn_cancel', 'generic', 'epa_selector', 'tab_none', '{"text": "Anulează"}'),
    ('btn_accept', 'generic', 'form_featuretype_change', 'tab_none', '{"text": "Acceptați"}'),
    ('btn_cancel', 'generic', 'form_featuretype_change', 'tab_none', '{"text": "Anulează"}'),
    ('btn_accept', 'generic', 'link_to_connec', 'tab_none', '{"text": "Acceptați"}'),
    ('btn_close', 'generic', 'link_to_connec', 'tab_none', '{"text": "Închidere"}'),
    ('btn_cancel', 'generic', 'nvo_manager', 'tab_none', '{"text": "Închidere"}'),
    ('btn_accept', 'generic', 'psector', 'tab_none', '{"text": "Acceptați"}'),
    ('btn_close', 'generic', 'psector', 'tab_none', '{"text": "Anulează"}'),
    ('btn_close', 'generic', 'psector_manager', 'tab_none', '{"text": "Închidere"}'),
    ('btn_close', 'generic', 'snapshot_view', 'tab_none', '{"text": "Închidere"}'),
    ('btn_run', 'generic', 'snapshot_view', 'tab_none', '{"text": "Aleargă"}'),
    ('btn_close', 'generic', 'workspace_manager', 'tab_none', '{"text": "Închidere"}'),
    ('btn_accept', 'generic', 'workspace_open', 'tab_none', '{"text": "Salvați"}'),
    ('btn_close', 'generic', 'workspace_open', 'tab_none', '{"text": "Închidere"}'),
    ('btn_accept', 'node', 'form_feature', 'tab_none', '{"text": "Acceptați"}'),
    ('btn_apply', 'node', 'form_feature', 'tab_none', '{"text": "Aplicați"}'),
    ('btn_cancel', 'node', 'form_feature', 'tab_none', '{"text": "Anulează"}'),
    ('btn_accept', 'mincut', 'form_mincut', 'tab_mincut', '{"text": "Acceptați"}'),
    ('btn_apply', 'mincut', 'form_mincut', 'tab_mincut', '{"text": "Aplicați"}'),
    ('btn_cancel', 'mincut', 'form_mincut', 'tab_mincut', '{"text": "Anulează"}'),
    ('btn_end', 'mincut', 'form_mincut', 'tab_mincut', '{"text": "Fin"}'),
    ('btn_start', 'mincut', 'form_mincut', 'tab_mincut', '{"text": "Acasă"}'),
    ('cancel', 'mincut_manager', 'form_mincut', 'tab_none', '{"text": "Închidere", "saveValue": false}'),
    ('cancel_mincut', 'mincut_manager', 'form_mincut', 'tab_none', '{"text": "Anulează mincut", "saveValue": false, "onContextMenu": "Cancel mincut"}'),
    ('delete', 'mincut_manager', 'form_mincut', 'tab_none', '{"text": "Ștergeți mincut", "saveValue": false, "onContextMenu": "Delete mincut"}')
) AS v(columnname, formname, formtype, tabname, text)
WHERE t.columnname = v.columnname AND t.formname = v.formname AND t.formtype = v.formtype AND t.tabname = v.tabname;

UPDATE config_param_system SET value = TRUE WHERE parameter = 'admin_config_control_trigger';

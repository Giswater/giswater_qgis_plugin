/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE config_param_system SET value = FALSE WHERE parameter = 'admin_config_control_trigger';

UPDATE config_form_fields AS t SET widgetcontrols = v.text::json FROM (
	VALUES
	('btn_accept', 'generic', 'form_visit', 'tab_data', '{"text": "Прийняти", "setMultiline": false}'),
    ('btn_apply', 'generic', 'form_visit', 'tab_file', '{"text": "Застосувати", "setMultiline": false}'),
    ('btn_cancel', 'generic', 'form_visit', 'tab_file', '{"text": "Скасувати", "setMultiline": false}'),
    ('btn_accept', 'generic', 'link_to_gully', 'tab_none', '{"text": "Прийняти"}'),
    ('btn_close', 'generic', 'link_to_gully', 'tab_none', '{"text": "Закрити"}'),
    ('btn_accept', 'gully', 'form_feature', 'tab_none', '{"text": "Прийняти"}'),
    ('btn_apply', 'gully', 'form_feature', 'tab_none', '{"text": "Застосувати"}'),
    ('btn_cancel', 'gully', 'form_feature', 'tab_none', '{"text": "Скасувати"}'),
    ('btn_accept', 'arc', 'form_feature', 'tab_none', '{"text": "Прийняти"}'),
    ('btn_apply', 'arc', 'form_feature', 'tab_none', '{"text": "Застосувати"}'),
    ('btn_cancel', 'arc', 'form_feature', 'tab_none', '{"text": "Скасувати"}'),
    ('btn_accept', 'connec', 'form_feature', 'tab_none', '{"text": "Прийняти"}'),
    ('btn_apply', 'connec', 'form_feature', 'tab_none', '{"text": "Застосувати"}'),
    ('btn_cancel', 'connec', 'form_feature', 'tab_none', '{"text": "Скасувати"}'),
    ('cancel', 'element_manager', 'form_element', 'tab_none', '{"text": "Закрити", "saveValue": false}'),
    ('create', 'element_manager', 'form_element', 'tab_none', '{"text": "Створити", "saveValue": false}'),
    ('delete', 'element_manager', 'form_element', 'tab_none', '{"text": "Видалити", "saveValue": false, "onContextMenu": "Delete"}'),
    ('btn_close', 'generic', 'audit', 'tab_none', '{"text": "Закрити"}'),
    ('btn_close', 'generic', 'audit_manager', 'tab_none', '{"text": "Закрити"}'),
    ('btn_open', 'generic', 'audit_manager', 'tab_none', '{"text": "Відкрити"}'),
    ('btn_open_date', 'generic', 'audit_manager', 'tab_none', '{"text": "Відкрити дату"}'),
    ('Info:', 'generic', 'check_project', 'tab_data', '{"vdefault_value": "Ця функція перевіряє як проєкт, так і базу даних. Для перевірки бази даних перевіряються всі об''єкти, обрані користувачем за допомогою селектора сектора та експлуатації."}'),
    ('btn_accept', 'generic', 'create_organization', 'tab_none', '{"text": "Прийняти"}'),
    ('btn_close', 'generic', 'create_organization', 'tab_none', '{"text": "Закрити"}'),
    ('btn_close', 'generic', 'dscenario', 'tab_none', '{"text": "Закрити"}'),
    ('btn_close', 'generic', 'dscenario_manager', 'tab_none', '{"text": "Закрити"}'),
    ('btn_close', 'generic', 'epa_manager', 'tab_none', '{"text": "Закрити"}'),
    ('btn_accept', 'generic', 'epa_selector', 'tab_none', '{"text": "Прийняти"}'),
    ('btn_cancel', 'generic', 'epa_selector', 'tab_none', '{"text": "Скасувати"}'),
    ('btn_accept', 'generic', 'form_featuretype_change', 'tab_none', '{"text": "Прийняти"}'),
    ('btn_cancel', 'generic', 'form_featuretype_change', 'tab_none', '{"text": "Скасувати"}'),
    ('btn_options', 'generic', 'go2epa', 'tab_data', '{"text": "Параметри"}'),
    ('btn_selector', 'generic', 'go2epa', 'tab_data', '{"text": "Селектор"}'),
    ('btn_download_inp', 'generic', 'go2epa', 'tab_log', '{"text": "INP Файл"}'),
    ('btn_download_rpt', 'generic', 'go2epa', 'tab_log', '{"text": "RPT Файл"}'),
    ('btn_close', 'generic', 'go2epa', 'tab_none', '{"text": "Закрити"}'),
    ('btn_execute_epa', 'generic', 'go2epa', 'tab_none', '{"text": "Виконати"}'),
    ('btn_accept', 'generic', 'link_to_connec', 'tab_none', '{"text": "Прийняти"}'),
    ('btn_close', 'generic', 'link_to_connec', 'tab_none', '{"text": "Закрити"}'),
    ('btn_cancel', 'generic', 'nvo_manager', 'tab_none', '{"text": "Закрити"}'),
    ('btn_accept', 'generic', 'psector', 'tab_none', '{"text": "Прийняти"}'),
    ('btn_close', 'generic', 'psector', 'tab_none', '{"text": "Скасувати"}'),
    ('btn_close', 'generic', 'psector_manager', 'tab_none', '{"text": "Закрити"}'),
    ('btn_close', 'generic', 'snapshot_view', 'tab_none', '{"text": "Закрити"}'),
    ('btn_run', 'generic', 'snapshot_view', 'tab_none', '{"text": "Запустити"}'),
    ('btn_close', 'generic', 'workspace_manager', 'tab_none', '{"text": "Закрити"}'),
    ('btn_accept', 'generic', 'workspace_open', 'tab_none', '{"text": "Зберегти"}'),
    ('btn_close', 'generic', 'workspace_open', 'tab_none', '{"text": "Закрити"}'),
    ('btn_accept', 'node', 'form_feature', 'tab_none', '{"text": "Прийняти"}'),
    ('btn_apply', 'node', 'form_feature', 'tab_none', '{"text": "Застосувати"}'),
    ('btn_cancel', 'node', 'form_feature', 'tab_none', '{"text": "Скасувати"}')
) AS v(columnname, formname, formtype, tabname, text)
WHERE t.columnname = v.columnname AND t.formname = v.formname AND t.formtype = v.formtype AND t.tabname = v.tabname;

UPDATE config_param_system SET value = TRUE WHERE parameter = 'admin_config_control_trigger';

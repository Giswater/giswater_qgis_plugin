/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = cm, public, public;
UPDATE config_form_fields AS t SET widgetcontrols = v.text::json FROM (
	VALUES
	('active', 'campaign_inventory', 'form_feature', 'tab_data', '{"vdefault_value": "Adevărat"}'),
    ('active', 'campaign_review', 'form_feature', 'tab_data', '{"vdefault_value": "Adevărat"}'),
    ('active', 'campaign_visit', 'form_feature', 'tab_data', '{"vdefault_value": "Adevărat"}'),
    ('txt_info', 'generic', 'check_project_cm', 'tab_data', '{"vdefault_value": "Această funcție urmărește să treacă controlul de calitate al unei campanii, putând alege un anumit lot într-un mod concret.<br><br> Sunt analizate diferite aspecte, cel mai important fiind faptul că este configurat astfel încât datele să fie operaționale în întreaga campanie pentru ca modelul hidraulic să funcționeze."}'),
    ('active', 'lot', 'form_feature', 'tab_data', '{"vdefault_value": "Adevărat"}')
) AS v(columnname, formname, formtype, tabname, text)
WHERE t.columnname = v.columnname AND t.formname = v.formname AND t.formtype = v.formtype AND t.tabname = v.tabname;

UPDATE config_param_system SET value = TRUE WHERE parameter = 'admin_config_control_trigger';

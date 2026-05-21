/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = cm, public, public;
UPDATE config_form_fields AS t SET widgetcontrols = v.text::json FROM (
	VALUES
	('active', 'campaign_inventory', 'form_feature', 'tab_data', '{"vdefault_value": "És cert"}'),
    ('active', 'campaign_review', 'form_feature', 'tab_data', '{"vdefault_value": "És cert"}'),
    ('active', 'campaign_visit', 'form_feature', 'tab_data', '{"vdefault_value": "És cert"}'),
    ('txt_info', 'generic', 'check_project_cm', 'tab_data', '{"vdefault_value": "Aquesta funció pretén passar el control de qualitat d''una campanya, podent escollir específicament un lot concret.<br><br>S''analitzen diferents aspectes, el més destacat és que està configurat perquè les dades estiguin operatives al llarg d''una campanya perquè funcioni el model hidràulic."}'),
    ('active', 'lot', 'form_feature', 'tab_data', '{"vdefault_value": "És cert"}')
) AS v(columnname, formname, formtype, tabname, text)
WHERE t.columnname = v.columnname AND t.formname = v.formname AND t.formtype = v.formtype AND t.tabname = v.tabname;

UPDATE config_param_system SET value = TRUE WHERE parameter = 'admin_config_control_trigger';

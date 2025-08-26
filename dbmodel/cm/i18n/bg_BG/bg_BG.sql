/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = cm, public, public;
UPDATE config_form_fields AS t
SET label = v.label, tooltip = v.tooltip
FROM (
    VALUES
    ('real_enddate', 'lot', 'form_feature', 'Real end:', 'Real end'),
    ('real_startdate', 'campaign_review', 'form_feature', 'Real start:', 'Real start'),
    ('reviewclass_id', 'campaign_review', 'form_feature', 'Reviewclass:', 'Reviewclass'),
    ('name', 'campaign_review', 'form_feature', 'Name:', 'Name'),
    ('startdate', 'campaign_review', 'form_feature', 'Planified start:', 'Planified start'),
    ('enddate', 'campaign_review', 'form_feature', 'Planified end:', 'Planified end'),
    ('real_enddate', 'campaign_review', 'form_feature', 'Real end:', 'Real end'),
    ('serie', 'workorder', 'form_feature', 'Serie:', 'Serie'),
    ('exercise', 'workorder', 'form_feature', 'Exercise:', 'Exercise'),
    ('enddate', 'campaign_visit', 'form_feature', 'Planified end:', 'Planified end'),
    ('real_startdate', 'campaign_visit', 'form_feature', 'Real start:', 'Real start'),
    ('real_enddate', 'campaign_visit', 'form_feature', 'Real end:', 'Real end'),
    ('startdate', 'lot', 'form_feature', 'Planified start:', 'Planified start'),
    ('enddate', 'lot', 'form_feature', 'Planified end:', 'Planified end'),
    ('real_startdate', 'lot', 'form_feature', 'Real start:', 'Real start'),
    ('workorder_id', 'lot', 'form_feature', 'Workorder id:', 'Workorder id'),
    ('campaign_id', 'lot', 'form_feature', 'Campaign id:', 'Campaign id'),
    ('team_id', 'lot', 'form_feature', 'Team:', 'Team'),
    ('txt_infolog', 'generic', 'check_project_cm', NULL, NULL),
    ('txt_info', 'generic', 'check_project_cm', NULL, NULL),
    ('workorder_id', 'workorder', 'form_feature', 'Workorder Id:', 'Workorder Id'),
    ('workorder_class', 'workorder', 'form_feature', 'Workorder class:', 'Workorder class'),
    ('verified_exceptions', 'generic', 'check_project_cm', 'Ignore verified exception:', 'Ignore verified exception:'),
    ('campaign_id', 'campaign_review', 'form_feature', 'Campaign Id:', 'Id'),
    ('graph_check', 'generic', 'check_project_cm', 'Check graph data:', 'Check graph data:'),
    ('plan_check', 'generic', 'check_project_cm', 'Check plan data:', 'Check plan data:'),
    ('admin_check', 'generic', 'check_project_cm', 'Check admin data:', 'Check admin data:'),
    ('om_check', 'generic', 'check_project_cm', 'Check om data:', 'Check om data:'),
    ('Info:', 'generic', 'check_project_cm', NULL, NULL),
    ('epa_check', 'generic', 'check_project_cm', 'Check EPA data:', 'Check EPA data:'),
    ('organization_id', 'campaign_review', 'form_feature', 'Organization:', 'Organization'),
    ('duration', 'campaign_review', 'form_feature', 'Duration:', 'Duration'),
    ('status', 'campaign_review', 'form_feature', 'Status:', 'Status'),
    ('startdate', 'campaign_visit', 'form_feature', 'Planified start:', 'Planified start'),
    ('visitclass_id', 'campaign_visit', 'form_feature', 'Visitclass:', 'Visitclass'),
    ('lot_id', 'lot', 'form_feature', 'Lot Id:', 'Id'),
    ('spacer_1', 'generic', 'create_organization', NULL, NULL),
    ('duration', 'campaign_visit', 'form_feature', 'Duration:', 'Duration'),
    ('btn_accept', 'generic', 'create_team', NULL, 'Accept'),
    ('btn_close', 'generic', 'create_team', NULL, 'Close'),
    ('status', 'campaign_visit', 'form_feature', 'Status:', 'Status'),
    ('btn_close', 'generic', 'create_user', NULL, 'Close'),
    ('organization_id', 'campaign_visit', 'form_feature', 'Organization:', 'Organization'),
    ('btn_close', 'generic', 'create_organization', NULL, 'Close'),
    ('code', 'generic', 'create_team', 'Code:', 'Code'),
    ('username', 'generic', 'create_user', 'User name:', 'User name'),
    ('btn_accept', 'generic', 'create_organization', NULL, 'Accept'),
    ('org_id', 'generic', 'create_team', 'Organization:', 'Organization'),
    ('role_id', 'generic', 'create_team', 'Role:', 'Role'),
    ('spacer_1', 'generic', 'create_team', NULL, NULL),
    ('fullname', 'generic', 'create_user', 'Full name:', 'Full name'),
    ('spacer_1', 'generic', 'create_user', NULL, NULL),
    ('name', 'lot', 'form_feature', 'Nombre:', 'Name'),
    ('observ', 'workorder', 'form_feature', 'Observ:', 'Observ'),
    ('code', 'generic', 'create_organization', 'Code:', 'Code'),
    ('campaign_id', 'campaign_visit', 'form_feature', 'Lot Id:', 'Id'),
    ('loginname', 'generic', 'create_user', 'Login name:', 'Login name'),
    ('password', 'generic', 'create_user', 'Password:', 'Password:'),
    ('btn_accept', 'generic', 'create_user', NULL, 'Accept'),
    ('name', 'generic', 'create_team', 'Name:', 'Name'),
    ('name', 'campaign_visit', 'form_feature', 'Name:', 'Name'),
    ('code', 'generic', 'create_user', 'Code:', 'Code'),
    ('name', 'generic', 'create_organization', 'Name:', 'Name'),
    ('team_id', 'generic', 'create_user', 'Team:', 'Team'),
    ('startdate', 'workorder', 'form_feature', 'Startdate:', 'Startdate'),
    ('status', 'lot', 'form_feature', 'Status:', 'Status'),
    ('address', 'workorder', 'form_feature', 'Address:', 'Address'),
    ('cost', 'workorder', 'form_feature', 'Cost:', 'Cost'),
    ('workorder_name', 'workorder', 'form_feature', 'Workorder name:', 'Workorder name'),
    ('workorder_type', 'workorder', 'form_feature', 'Workorder type:', 'Workorder type'),
    ('active', 'lot', 'form_feature', 'Active:', 'Active'),
    ('active', 'campaign_review', 'form_feature', 'Active:', 'Active'),
    ('active', 'campaign_visit', 'form_feature', 'Active:', 'Active'),
    ('active', 'generic', 'create_team', 'Active:', 'Active'),
    ('descript', 'campaign_visit', 'form_feature', 'Description:', 'Description'),
    ('descript', 'generic', 'create_team', 'Description:', 'Description'),
    ('descript', 'generic', 'create_user', 'Description:', 'Description'),
    ('descript', 'lot', 'form_feature', 'Description:', 'Description'),
    ('active', 'generic', 'create_organization', 'Active:', 'Active'),
    ('descript', 'generic', 'create_organization', 'Description:', 'Description'),
    ('active', 'generic', 'create_user', 'Active:', 'Active'),
    ('descript', 'campaign_review', 'form_feature', 'Description:', 'Description'),
    ('versions_check', 'generic', 'check_project_cm', 'Versions:', 'Versions'),
    ('qgisproj_check', 'generic', 'check_project_cm', 'Qgis Project:', 'Qgis Project')
) AS v(columnname, formname, formtype, label, tooltip)
WHERE t.columnname = v.columnname AND t.formname = v.formname AND t.formtype = v.formtype;

UPDATE config_form_tabs AS t
SET label = v.label, tooltip = v.tooltip
FROM (
    VALUES
    ('selector_campaign', 'tab_campaign', 'Campaign', 'Campaign'),
    ('selector_campaign', 'tab_lot', 'Lot', 'Lot')
) AS v(formname, tabname, label, tooltip)
WHERE t.formname = v.formname AND t.tabname = v.tabname;

UPDATE config_form_fields AS t
SET widgetcontrols = v.text::json
FROM (
	VALUES
	('btn_accept', 'generic', 'create_team', '{"text": "Accept"}'),
    ('btn_close', 'generic', 'create_team', '{"text": "Close"}'),
    ('btn_close', 'generic', 'create_user', '{"text": "Close"}'),
    ('btn_accept', 'generic', 'create_user', '{"text": "Accept"}')
) AS v(columnname, formname, formtype, text)
WHERE t.columnname = v.columnname AND t.formname = v.formname AND t.formtype = v.formtype;

UPDATE config_param_system SET value = TRUE WHERE parameter = 'admin_config_control_trigger';

/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = cm, public, public;
UPDATE config_form_fields AS t
SET label = v.label, tooltip = v.tooltip
FROM (
    VALUES
    ('real_enddate', 'lot', 'form_feature', 'Fin real:', 'Real end'),
    ('real_startdate', 'campaign_review', 'form_feature', 'Comienzo real:', 'Inicio real'),
    ('reviewclass_id', 'campaign_review', 'form_feature', 'Clase de revisión:', 'Reviewclass'),
    ('name', 'campaign_review', 'form_feature', 'Nombre:', 'Nombre'),
    ('startdate', 'campaign_review', 'form_feature', 'Inicio planificado:', 'Inicio planificado'),
    ('enddate', 'campaign_review', 'form_feature', 'Fin planificado:', 'Final planificado'),
    ('real_enddate', 'campaign_review', 'form_feature', 'Fin real:', 'Real end'),
    ('serie', 'workorder', 'form_feature', 'Series:', 'Serie'),
    ('exercise', 'workorder', 'form_feature', 'Ejercicio:', 'Ejercicio'),
    ('enddate', 'campaign_visit', 'form_feature', 'Fin planificado:', 'Final planificado'),
    ('real_startdate', 'campaign_visit', 'form_feature', 'Comienzo real:', 'Inicio real'),
    ('real_enddate', 'campaign_visit', 'form_feature', 'Fin real:', 'Real end'),
    ('startdate', 'lot', 'form_feature', 'Inicio planificado:', 'Inicio planificado'),
    ('enddate', 'lot', 'form_feature', 'Fin planificado:', 'Final planificado'),
    ('real_startdate', 'lot', 'form_feature', 'Comienzo real:', 'Inicio real'),
    ('workorder_id', 'lot', 'form_feature', 'Id. de orden de trabajo:', 'Id de orden de trabajo'),
    ('campaign_id', 'lot', 'form_feature', 'Id de campaña:', 'Id de campaña'),
    ('team_id', 'lot', 'form_feature', 'Equipo:', 'Equipo'),
    ('txt_infolog', 'generic', 'check_project_cm', NULL, NULL),
    ('txt_info', 'generic', 'check_project_cm', NULL, NULL),
    ('workorder_id', 'workorder', 'form_feature', 'Id. de orden de trabajo:', 'Id de orden de trabajo'),
    ('workorder_class', 'workorder', 'form_feature', 'Clase de orden de trabajo:', 'Clase de orden de trabajo'),
    ('verified_exceptions', 'generic', 'check_project_cm', 'Ignorar excepción verificada:', 'Ignorar excepción verificada:'),
    ('campaign_id', 'campaign_review', 'form_feature', 'Id de campaña:', 'Id'),
    ('graph_check', 'generic', 'check_project_cm', 'Comprobar datos del grafo:', 'Comprueba los datos del gráfico:'),
    ('plan_check', 'generic', 'check_project_cm', 'Comprobar datos de planificación:', 'Compruebe los datos del plan:'),
    ('admin_check', 'generic', 'check_project_cm', 'Comprobar datos de administración:', 'Comprueba los datos del administrador:'),
    ('om_check', 'generic', 'check_project_cm', 'Comprobar datos om:', 'Comprueba las fechas:'),
    ('Info:', 'generic', 'check_project_cm', NULL, NULL),
    ('epa_check', 'generic', 'check_project_cm', 'Comprobar datos epa:', 'Comprueba los datos de la EPA:'),
    ('organization_id', 'campaign_review', 'form_feature', 'Organización:', 'Organización'),
    ('duration', 'campaign_review', 'form_feature', 'Duración:', 'Duración'),
    ('status', 'campaign_review', 'form_feature', 'Estado:', 'Estado'),
    ('startdate', 'campaign_visit', 'form_feature', 'Inicio planificado:', 'Inicio planificado'),
    ('visitclass_id', 'campaign_visit', 'form_feature', 'Visitclass:', 'Visitclass'),
    ('lot_id', 'lot', 'form_feature', 'Lote ID:', 'Id'),
    ('spacer_1', 'generic', 'create_organization', NULL, NULL),
    ('duration', 'campaign_visit', 'form_feature', 'Duración:', 'Duración'),
    ('btn_accept', 'generic', 'create_team', NULL, 'Acepte'),
    ('btn_close', 'generic', 'create_team', NULL, 'Cerrar'),
    ('status', 'campaign_visit', 'form_feature', 'Estado:', 'Estado'),
    ('btn_close', 'generic', 'create_user', NULL, 'Cerrar'),
    ('organization_id', 'campaign_visit', 'form_feature', 'Organización:', 'Organización'),
    ('btn_close', 'generic', 'create_organization', NULL, 'Cerrar'),
    ('code', 'generic', 'create_team', 'Código:', 'Código'),
    ('username', 'generic', 'create_user', 'Nombre de usuario:', 'Nombre de usuario'),
    ('btn_accept', 'generic', 'create_organization', NULL, 'Acepte'),
    ('org_id', 'generic', 'create_team', 'Organización:', 'Organización'),
    ('role_id', 'generic', 'create_team', 'Papel:', 'Papel'),
    ('spacer_1', 'generic', 'create_team', NULL, NULL),
    ('fullname', 'generic', 'create_user', 'Nombre completo:', 'Nombre y apellidos'),
    ('spacer_1', 'generic', 'create_user', NULL, NULL),
    ('name', 'lot', 'form_feature', 'Nombre:', 'Nombre'),
    ('observ', 'workorder', 'form_feature', 'Observar:', 'Observar'),
    ('code', 'generic', 'create_organization', 'Código:', 'Código'),
    ('campaign_id', 'campaign_visit', 'form_feature', 'Lote Id:', 'Id'),
    ('loginname', 'generic', 'create_user', 'Nombre de usuario:', 'Nombre de usuario'),
    ('password', 'generic', 'create_user', 'Contraseña:', 'Contraseña:'),
    ('btn_accept', 'generic', 'create_user', NULL, 'Acepte'),
    ('name', 'generic', 'create_team', 'Nombre:', 'Nombre'),
    ('name', 'campaign_visit', 'form_feature', 'Nombre:', 'Nombre'),
    ('code', 'generic', 'create_user', 'Código:', 'Código'),
    ('name', 'generic', 'create_organization', 'Nombre:', 'Nombre'),
    ('team_id', 'generic', 'create_user', 'Equipo:', 'Equipo'),
    ('startdate', 'workorder', 'form_feature', 'Fecha de inicio:', 'Fecha de inicio'),
    ('status', 'lot', 'form_feature', 'Estado:', 'Estado'),
    ('address', 'workorder', 'form_feature', 'Dirección:', 'Dirección'),
    ('cost', 'workorder', 'form_feature', 'Coste:', 'Coste'),
    ('workorder_name', 'workorder', 'form_feature', 'Nombre de la orden de trabajo:', 'Nombre de la orden de trabajo'),
    ('workorder_type', 'workorder', 'form_feature', 'Tipo de orden de trabajo:', 'Tipo de orden de trabajo'),
    ('active', 'lot', 'form_feature', 'Activo:', 'Activo'),
    ('active', 'campaign_review', 'form_feature', 'Activo:', 'Activo'),
    ('active', 'campaign_visit', 'form_feature', 'Activo:', 'Activo'),
    ('active', 'generic', 'create_team', 'Activo:', 'Activo'),
    ('descript', 'campaign_visit', 'form_feature', 'Descripción:', 'Descripción'),
    ('descript', 'generic', 'create_team', 'Descripción:', 'Descripción'),
    ('descript', 'generic', 'create_user', 'Descripción:', 'Descripción'),
    ('descript', 'lot', 'form_feature', 'Descripción:', 'Descripción'),
    ('active', 'generic', 'create_organization', 'Activo:', 'Activo'),
    ('descript', 'generic', 'create_organization', 'Descripción:', 'Descripción'),
    ('active', 'generic', 'create_user', 'Activo:', 'Activo'),
    ('descript', 'campaign_review', 'form_feature', 'Descripción:', 'Descripción'),
    ('versions_check', 'generic', 'check_project_cm', 'Versiones:', 'Versiones'),
    ('qgisproj_check', 'generic', 'check_project_cm', 'Proyecto Qgis:', 'Proyecto Qgis')
) AS v(columnname, formname, formtype, label, tooltip)
WHERE t.columnname = v.columnname AND t.formname = v.formname AND t.formtype = v.formtype;

UPDATE config_form_tabs AS t
SET label = v.label, tooltip = v.tooltip
FROM (
    VALUES
    ('selector_campaign', 'tab_campaign', 'Campaña', 'Campaña'),
    ('selector_campaign', 'tab_lot', 'Lote', 'Lote')
) AS v(formname, tabname, label, tooltip)
WHERE t.formname = v.formname AND t.tabname = v.tabname;

UPDATE config_form_fields AS t
SET widgetcontrols = v.text::json
FROM (
	VALUES
	('btn_accept', 'generic', 'create_team', '{"text": "Aceptar"}'),
    ('btn_close', 'generic', 'create_team', '{"text": "Cerrar"}'),
    ('btn_close', 'generic', 'create_user', '{"text": "Cerrar"}'),
    ('btn_accept', 'generic', 'create_user', '{"text": "Aceptar"}')
) AS v(columnname, formname, formtype, text)
WHERE t.columnname = v.columnname AND t.formname = v.formname AND t.formtype = v.formtype;

UPDATE config_param_system SET value = TRUE WHERE parameter = 'admin_config_control_trigger';

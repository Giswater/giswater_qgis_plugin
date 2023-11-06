/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('netscenario manager', 'ws', 'plan_netscenario_arc', 'netscenari_id', 0, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('netscenario manager', 'ws', 'plan_netscenario_node', 'netscenari_id', 0, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('netscenario manager', 'ws', 'plan_netscenario_connec', 'netscenari_id', 0, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('netscenario manager', 'ws', 'plan_netscenario_dma', 'netscenari_id', 0, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('netscenario manager', 'ws', 'plan_netscenario_valve', 'netscenari_id', 0, false, NULL, NULL, NULL, NULL);

-- 27/10/23
UPDATE cat_feature_node SET epa_default='UNDEFINED', isarcdivide=false WHERE id='AIR_VALVE';
UPDATE config_form_fields SET hidden=false, iseditable=true, label = 'Exit elevation' where formname = 'v_edit_link' and columnname = 'exit_topelev';

-- 30/10/23
INSERT INTO config_form_fields values ('ve_epa_pump', 'form_feature', 'tab_epa', 'effic_curve_id', 'lyt_epa_data_1', 11, 'string', 'combo', 'Eff. curve', 'Eff. curve', null, false, false, true, false, false, 'SELECT id as id, id as idval FROM v_edit_inp_curve WHERE curve_type = ''EFFICIENCY''', true, true, null, null, null, null, null, null, false);

UPDATE config_form_fields set widgettype = 'combo', dv_querytext = 'SELECT pattern_id as id, pattern_id as idval FROM v_edit_inp_pattern WHERE pattern_id is not null' 
where formname like 've_epa_pump' and columnname ='energy_pattern_id';

UPDATE config_form_fields set iseditable = false  where formname = 've_epa_pump' and columnname = 'avg_effic';

-- 31/10/23
UPDATE sys_param_user SET "label"='Hydraulic timestep' WHERE id='inp_times_hydraulic_timestep';


UPDATE config_report SET query_text = '
SELECT w.exploitation as "Exploitation", w.dma as "Dma", period as "Period", 
total_in::numeric(20,2) as "Total inlet",
total_out::numeric(20,2) as "Total outlet",
total::numeric(20,2) as "Total injected",
auth as "Authorized Vol.", 
loss as "Losses Vol.", 
(case when total > 0 then 100*(1-auth/total)::numeric(20,2) else 0.00 end) as "NRW"
FROM v_om_waterbalance w'
WHERE id = 102;

UPDATE config_report SET query_text = 
'SELECT n.exploitation as "Exploitation",
(sum(n.total))::numeric(20,2) as "Total injected", 
sum(auth) as "Authorized Vol.", 
sum(loss) as "Losses Vol.", 
(case when sum(n.total) > 0 THEN 100*(1-sum(auth)/sum(total))::numeric(20,2) else 0.00 end) as "NRW"
FROM v_om_waterbalance n  WHERE n.dma IS NOT NULL '
WHERE id = 103;


UPDATE config_report SET query_text = 
'SELECT n.exploitation as "Exploitation", n.dma as "Dma", 
(sum(n.total))::numeric(20,2) as "Total injected", 
sum(auth) as "Authorized Vol.", 
sum(loss) as "Losses Vol.", 
(case when sum(n.total) > 0 THEN 100*(1-sum(auth)/sum(total))::numeric(20,2) else 0.00 end) as "NRW"
FROM v_om_waterbalance n  WHERE n.dma IS NOT NULL '
WHERE id = 104;

UPDATE config_toolbox SET alias ='Mapzones Netscenario analysis'
where id = 3256;



--06/07/2023. Manage null values on shortpipe status

UPDATE config_form_fields set dv_querytext = 'SELECT DISTINCT (id) AS id, idval AS idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_value_status_shortpipe''' WHERE formname in ('ve_epa_shortpipe', 'v_edit_inp_shortpipe', 'v_edit_inp_dscenario_shortpipe') and columnname ='status';
UPDATE config_form_fields set dv_isnullvalue =True  WHERE formname in ('ve_epa_shortpipe', 'v_edit_inp_shortpipe', 'v_edit_inp_dscenario_shortpipe') and columnname ='status';

INSERT INTO inp_typevalue (typevalue, id, idval, descript, addparam) VALUES('inp_value_status_shortpipe', 'CV', 'CV', NULL, NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript, addparam) VALUES('inp_value_status_shortpipe', ' ', ' ', NULL, NULL);

ALTER TABLE inp_shortpipe DROP CONSTRAINT inp_shortpipe_status_check;
ALTER TABLE inp_shortpipe ADD CONSTRAINT inp_shortpipe_status_check CHECK (((status)::text = ANY ((ARRAY[''::character varying, 'CV'::character varying, 'OPEN'::character varying, 'CLOSED'::character varying])::text[])));
/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2018/11/11
INSERT INTO audit_cat_param_user VALUES ('om_mincut_analysis_dminsector', 'om', 'Use mincut to analyze minsector in spite of standard mincut workflow', 'role_edit');
INSERT INTO audit_cat_param_user VALUES ('om_mincut_analysis_pipehazard', 'om', 'Use mincut to analyze pipehazard in spite of standard mincut workflow', 'role_plan');
INSERT INTO audit_cat_param_user VALUES ('om_mincut_analysis_dinletsector', 'om', 'Use mincut to analyze dynamic inlet sector in spite of standard mincut workflow', 'role_om');


--2018/11/12
INSERT INTO config_param_system (parameter, value, data_type, context, descript) VALUES ('om_mincut_valvestat_using_valveunaccess', 'FALSE', 'Boolean', 'Mincut', 'Variable to enable/disable the possibility to use valve unaccess button to open valves with closed status');
UPDATE audit_cat_table SET sys_role_id='role_om' WHERE id='man_valve';

--2018/11/20
INSERT INTO config_param_system (parameter, value, data_type, context, descript) VALUES ('om_mincut_debug', 'FALSE', 'Boolean', 'Mincut', 'Variable to enable/disable the debug messages of mincut');

--2019/01/21
UPDATE audit_cat_param_user SET description = 'Default value for builtdate parameter' 
WHERE id='builtdate_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for cat_arc parameter' 
WHERE id='arccat_vdefault';
UPDATE audit_cat_param_user SET description = 'Selected layer will be the only one which allow snapping with CAD tools' 
WHERE id='cad_tools_base_layer_vdefault';
UPDATE audit_cat_param_user SET description = 'If true, when you finish element insertion, QGIS edition will keep opened. If false, QGIS edition will be closed automatically' 
WHERE id='cf_keep_opened_edition';
UPDATE audit_cat_param_user SET description = 'Default value for cat_connec parameter' 
WHERE id='connecat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for dma parameter' 
WHERE id='dma_vdefault';
UPDATE audit_cat_param_user SET description = 'If true, tooltip appears when you''re selecting depth from another node with dimensioning tool' 
WHERE id='dim_tooltip';
UPDATE audit_cat_param_user SET description = 'If true, arcs won''t be divided when new node where situated over him' 
WHERE id='edit_arc_division_dsbl';
UPDATE audit_cat_param_user SET description = 'If true, when inserting new connec, link will be automatically generated' 
WHERE id='edit_connect_force_automatic_connect2network';
UPDATE audit_cat_param_user SET description = 'Default value for cat_element parameter' 
WHERE id='elementcat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for enddate parameter' 
WHERE id='enddate_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for exploitation parameter' 
WHERE id='exploitation_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for expansiontank element parameter' 
WHERE id='expansiontankcat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for filter element parameter' 
WHERE id='filtercat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for flexunion element parameter' 
WHERE id='flexunioncat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for fountain element parameter' 
WHERE id='fountaincat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for greentap element parameter' 
WHERE id='greentapcat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for hydrant element parameter' 
WHERE id='hydrantcat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for junction element parameter' 
WHERE id='junctioncat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for meter element parameter' 
WHERE id='metercat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for municipality parameter' 
WHERE id='municipality_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for netelement element parameter' 
WHERE id='netelementcat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for netsamplepoint element parameter' 
WHERE id='netsamplepointcat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for netwjoin element parameter' 
WHERE id='netwjoincat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for cat_node parameter' 
WHERE id='nodecat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for parameter type of OM' 
WHERE id='om_param_type_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for cat_pavement parameter' 
WHERE id='pavementcat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for pipe element parameter' 
WHERE id='pipecat_vdefault';
UPDATE audit_cat_param_user SET description = 'If false, when you insert a planified node over an arc, this will be divided with two planified new arcs. This parameter is related to edit_arc_division_dsbl' 
WHERE id='plan_arc_vdivision_dsbl';
UPDATE audit_cat_param_user SET description = 'Default value for presszone parameter' 
WHERE id='presszone_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for psector general expenses parameter' 
WHERE id='psector_gexpenses_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for psector measurement parameter' 
WHERE id='psector_measurement_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for psector other parameter' 
WHERE id='psector_other_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for psector rotation parameter' 
WHERE id='psector_rotation_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for psector scale parameter' 
WHERE id='psector_scale_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for psector vat parameter' 
WHERE id='psector_vat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for psector parameter' 
WHERE id='psector_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for pump element parameter' 
WHERE id='pumpcat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for register element parameter' 
WHERE id='registercat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for sector parameter' 
WHERE id='sector_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for soilcat parameter' 
WHERE id='soilcat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for source element parameter' 
WHERE id='sourcecat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for state parameter' 
WHERE id='state_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for state type parameter' 
WHERE id='statetype_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for state type end parameter' 
WHERE id='statetype_end_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for tank element parameter' 
WHERE id='tankcat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for tap element parameter' 
WHERE id='tapcat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for valve element parameter' 
WHERE id='valvecat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for verified parameter' 
WHERE id='verified_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for visit parameter' 
WHERE id='visitcat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for wjoin element parameter' 
WHERE id='wjoincat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for workcat parameter' 
WHERE id='workcat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for wtp element parameter' 
WHERE id='wtpcat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for psector state type parameter' 
WHERE id='statetype_plan_vdefault';
UPDATE audit_cat_param_user SET description = 'If true, allows to force arcs downgrade although they have other connected elements' 
WHERE id='edit_arc_downgrade_force';
UPDATE audit_cat_param_user SET description = 'If true, when a connec is downgraded, associated link and vnode are also downgraded' 
WHERE id='edit_connect_force_downgrade_linkvnode';
UPDATE audit_cat_param_user SET description = 'If true, the automatic rotation calculation on the nodes is disabled. Used for an absolute manual update of rotation field' 
WHERE id='edit_noderotation_update_dissbl';

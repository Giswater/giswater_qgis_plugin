/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2018/11/20
SELECT setval('SCHEMA_NAME.config_param_system_id_seq', (SELECT max(id) FROM config_param_system), true);
INSERT INTO config_param_system (parameter, value, data_type, context, descript) VALUES ('code_vd', 'No code', 'Text', 'OM', 'UD');

--2019/01/21
UPDATE audit_cat_param_user SET description = 'Default value for cat_arc parameter' WHERE id='arccat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for builtdate parameter' WHERE id='builtdate_vdefault';
UPDATE audit_cat_param_user SET description = 'If true, when you finish element insertion, QGIS edition will keep opened. If false, QGIS edition will be closed automatically' WHERE id='cf_keep_opened_edition';
UPDATE audit_cat_param_user SET description = 'Default value for cat_connec parameter' WHERE id='connecat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for dma parameter' WHERE id='dma_vdefault';
UPDATE audit_cat_param_user SET description = 'If true, arcs won''t be divided when new node where situated over him' WHERE id='edit_arc_division_dsbl';
UPDATE audit_cat_param_user SET description = 'If true, when inserting new connec, link will be automatically generated' WHERE id='edit_connect_force_automatic_connect2network';
UPDATE audit_cat_param_user SET description = 'Default value for cat_element parameter' WHERE id='elementcat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for enddate parameter' WHERE id='enddate_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for EPA conduit q0 parameter' WHERE id='epa_conduit_q0_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for EPA junction y0 parameter' WHERE id='epa_junction_y0_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for EPA outfall type parameter' WHERE id='epa_outfall_type_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for EPA raingage scf parameter' WHERE id='epa_rgage_scf_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for exploitation parameter' WHERE id='exploitation_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for cat_gully parameter' WHERE id='gullycat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for cat_grate parameter' WHERE id='gratecat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for municipality parameter' WHERE id='municipality_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for cat_node parameter' WHERE id='nodecat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for parameter type of OM' WHERE id='om_param_type_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for owner parameter' WHERE id='ownercat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for pavement parameter' WHERE id='pavement_vdefault';
UPDATE audit_cat_param_user SET description = 'If false, when you insert a planified node over an arc, this will be divided with two planified new arcs. This parameter is related to edit_arc_division_dsbl' WHERE id='plan_arc_vdivision_dsbl';
UPDATE audit_cat_param_user SET description = 'Default value for psector general expenses parameter' WHERE id='psector_gexpenses_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for psector other parameter' WHERE id='psector_other_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for psector rotation parameter' WHERE id='psector_rotation_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for psector scale parameter' WHERE id='psector_scale_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for psector type parameter' WHERE id='psector_type_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for psector vat parameter' WHERE id='psector_vat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for psector parameter' WHERE id='psector_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for sector parameter' WHERE id='sector_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for soilcat parameter' WHERE id='soilcat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for state parameter' WHERE id='state_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for state type end parameter' WHERE id='statetype_end_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for psector state type parameter' WHERE id='statetype_plan_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for state type parameter' WHERE id='statetype_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for verified parameter' WHERE id='verified_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for visit parameter' WHERE id='visitcat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for workcat parameter' WHERE id='workcat_vdefault';
UPDATE audit_cat_param_user SET description = 'If true, allows to force arcs downgrade although they have other connected elements' WHERE id='edit_arc_downgrade_force';
UPDATE audit_cat_param_user SET description = 'If true, when a connec is downgraded, associated link and vnode are also downgraded' WHERE id='edit_connect_force_downgrade_linkvnode';
UPDATE audit_cat_param_user SET description = 'If true, the automatic rotation calculation on the nodes is disabled. Used for an absolute manual update of rotation field ' WHERE id='edit_noderotation_update_dissbl';
UPDATE audit_cat_param_user SET description = 'Deprecated' WHERE id='qgis_template_folder_path';
UPDATE audit_cat_param_user SET description = 'Deprecated' WHERE id='virtual_line_vdefault';
UPDATE audit_cat_param_user SET description = 'Deprecated' WHERE id='virtual_point_vdefault';
UPDATE audit_cat_param_user SET description = 'Deprecated' WHERE id='virtual_polygon_vdefault';

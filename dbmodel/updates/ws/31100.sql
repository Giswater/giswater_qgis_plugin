/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;




INSERT INTO audit_cat_error VALUES (3006, 'There are one or more arc(s) with null nodes. Mincut is broken (arc_id=)','Please review your data',2, true, NULL);



----------------------
--01/06/2018
-----------------------
INSERT INTO audit_cat_table VALUES ('anl_mincut_result_cat', 'Mincut', 'Catalog of mincut results', 'role_om', 0, NULL, NULL, 0, NULL, 'anl_mincut_result_cat_seq', 'id');


----------------------
--05/06/2018
-----------------------
INSERT INTO audit_cat_table VALUES ('v_anl_mincut_result_conflict_arc', 'Mincut', 'Catalog of mincut results', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL);
INSERT INTO audit_cat_table VALUES ('v_anl_mincut_result_conflict_valve', 'Mincut', 'Catalog of mincut results', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL);
INSERT INTO audit_cat_table VALUES ('v_anl_mincut_planified_arc', 'Mincut', 'Catalog of mincut results', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL);
INSERT INTO audit_cat_table VALUES ('v_anl_mincut_planified_valve', 'Mincut', 'Catalog of mincut results', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL);
 

--------------------
--20/09/2018
--------------------

UPDATE audit_cat_param_user SET description = 'Default value for builtdate parameter' WHERE id='builtdate_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for cat_arc parameter' WHERE id='arccat_vdefault';
UPDATE audit_cat_param_user SET description = 'Selected layer will be the only one which allow snapping with CAD tools' WHERE id='cad_tools_base_layer_vdefault';
UPDATE audit_cat_param_user SET description = 'If true, when you finish element insertion, QGIS edition will keep opened. If false, QGIS edition will be closed automatically' WHERE id='cf_keep_opened_edition';
UPDATE audit_cat_param_user SET description = 'Default value for cat_connec parameter' WHERE id='connecat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for dma parameter' WHERE id='dma_vdefault';
UPDATE audit_cat_param_user SET description = 'If true, tooltip appears when you''re selecting depth from another node with dimensioning tool' WHERE id='dim_tooltip';
UPDATE audit_cat_param_user SET description = 'If true, arcs won''t be divided when new node where situated over him' WHERE id='edit_arc_division_dsbl';
UPDATE audit_cat_param_user SET description = 'If true, when inserting new connec, link will be automatically generated' WHERE id='edit_connect_force_automatic_connect2network';
UPDATE audit_cat_param_user SET description = 'Default value for cat_element parameter' WHERE id='elementcat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for enddate parameter' WHERE id='enddate_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for exploitation parameter' WHERE id='exploitation_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for expansiontank element parameter' WHERE id='expansiontankcat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for filter element parameter' WHERE id='filtercat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for flexunion element parameter' WHERE id='flexunioncat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for fountain element parameter' WHERE id='fountaincat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for greentap element parameter' WHERE id='greentapcat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for hydrant element parameter' WHERE id='hydrantcat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for junction element parameter' WHERE id='junctioncat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for meter element parameter' WHERE id='metercat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for municipality parameter' WHERE id='municipality_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for netelement element parameter' WHERE id='netelementcat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for netsamplepoint element parameter' WHERE id='netsamplepointcat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for netwjoin element parameter' WHERE id='netwjoincat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for cat_node parameter' WHERE id='nodecat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for parameter type of OM' WHERE id='om_param_type_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for cat_pavement parameter' WHERE id='pavementcat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for pipe element parameter' WHERE id='pipecat_vdefault';
UPDATE audit_cat_param_user SET description = 'If false, when you insert a planified node over an arc, this will be divided with two planified new arcs. This parameter is related to edit_arc_division_dsbl' WHERE id='plan_arc_vdivision_dsbl';
UPDATE audit_cat_param_user SET description = 'Default value for presszone parameter' WHERE id='presszone_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for psector general expenses parameter' WHERE id='psector_gexpenses_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for psector measurement parameter' WHERE id='psector_measurement_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for psector other parameter' WHERE id='psector_other_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for psector rotation parameter' WHERE id='psector_rotation_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for psector scale parameter' WHERE id='psector_scale_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for psector vat parameter' WHERE id='psector_vat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for psector parameter' WHERE id='psector_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for pump element parameter' WHERE id='pumpcat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for register element parameter' WHERE id='registercat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for sector parameter' WHERE id='sector_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for soilcat parameter' WHERE id='soilcat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for source element parameter' WHERE id='sourcecat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for state parameter' WHERE id='state_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for state type parameter' WHERE id='statetype_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for state type end parameter' WHERE id='statetype_end_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for tank element parameter' WHERE id='tankcat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for tap element parameter' WHERE id='tapcat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for valve element parameter' WHERE id='valvecat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for verified parameter' WHERE id='verified_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for visit parameter' WHERE id='visitcat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for wjoin element parameter' WHERE id='wjoincat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for workcat parameter' WHERE id='workcat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for wtp element parameter' WHERE id='wtpcat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for psector state type parameter' WHERE id='statetype_plan_vdefault';














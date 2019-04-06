/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = ud_sample, public, pg_catalog;

UPDATE audit_cat_param_user SET layout_id=3, layout_name='grl_hyd_3' WHERE layout_id=11;
UPDATE audit_cat_param_user SET layout_id=4, layout_name='grl_hyd_4' WHERE layout_id=12;
UPDATE audit_cat_param_user SET layout_id=3, layout_order=4,layout_name='grl_hyd_3' WHERE id='inp_options_routing_step';
UPDATE audit_cat_param_user SET layout_id=4, layout_order=4,layout_name='grl_hyd_4' WHERE id='inp_options_dry_days';
UPDATE audit_cat_param_user SET layout_id=3, layout_order=5,layout_name='grl_hyd_3' WHERE id='inp_options_wet_step';
UPDATE audit_cat_param_user SET layout_id=4, layout_order=5,layout_name='grl_hyd_4' WHERE id='inp_options_dry_step';
UPDATE audit_cat_param_user SET layout_id=3, layout_order=6,layout_name='grl_hyd_3' WHERE id='inp_options_sweep_start';
UPDATE audit_cat_param_user SET layout_id=4, layout_order=6,layout_name='grl_hyd_4' WHERE id='inp_options_sweep_end';


UPDATE audit_cat_param_user SET layout_id=13,layout_name='grl_date_13', widgettype='linetext', vdefault='00:00:00', placeholder='00:00:00'  WHERE id='inp_options_start_time';



UPDATE audit_cat_param_user SET layout_id=13,layout_order = 1, layout_name='grl_date_13', widgettype='linetext', vdefault='01/01/2017', placeholder='01/01/2017'  WHERE id='inp_options_start_date';
UPDATE audit_cat_param_user SET layout_id=14,layout_order = 1, layout_name='grl_date_14', widgettype='linetext', vdefault='00:00:00', placeholder='00:00:00'  WHERE id='inp_options_start_time';

UPDATE audit_cat_param_user SET layout_id=13,layout_order = 2, layout_name='grl_date_13', widgettype='linetext', vdefault='01/01/2017', placeholder='01/01/2017' WHERE id='inp_options_end_date';
UPDATE audit_cat_param_user SET layout_id=14,layout_order = 2, layout_name='grl_date_14', widgettype='linetext', vdefault='00:03:00', placeholder='00:03:00'  WHERE id='inp_options_end_time';

UPDATE audit_cat_param_user SET layout_id=13,layout_order = 3, layout_name='grl_date_13', widgettype='linetext', vdefault='01/01/2017', placeholder='01/01/2017' WHERE id='inp_options_report_start_date';
UPDATE audit_cat_param_user SET layout_id=14,layout_order = 3, layout_name='grl_date_14', widgettype='linetext', vdefault='00:00:00', placeholder='00:00:00' WHERE id='inp_options_report_start_time';
UPDATE audit_cat_param_user SET layout_id=13,layout_order = 4, layout_name='grl_date_13' WHERE id='inp_options_report_step';


UPDATE audit_cat_param_user SET layout_id=2,layout_order=90, layout_name='grl_general_2', isenabled=true, ismandatory=true WHERE id='inp_options_tempdir';

UPDATE audit_cat_param_user SET label = 'Timestep detailed nodes:', placeholder='ALL / node1 node2 node3 node4' WHERE id='inp_report_nodes';
UPDATE audit_cat_param_user SET label = 'Timestep detailed links:', placeholder='ALL / link1 link2 link3 link4' WHERE id='inp_report_links';
UPDATE audit_cat_param_user SET label = 'Timestep detailed subcatchments:',placeholder='ALL / subc1 subc2 subc3 subc4' WHERE id='inp_report_subcatchments';


INSERT INTO audit_cat_param_user VALUES ('epaversion', null, 'Version of SWMM. Hard coded variable. Only enabled version is SWMM-EN 5.0.022', 'role_epa', NULL, NULL, 'SWMM version:', NULL, NULL, false, NULL, NULL, 'ud', false, NULL, NULL, NULL, false, 'string', 'combo', true, null, '5.0.022', NULL, NULL, NULL, NULL, NULL, NULL, NULL, false);

UPDATE audit_cat_param_user SET epaversion='{"from":"5.0.022", "to":null,"language":"english"}' where formname='epaoptions';


UPDATE audit_cat_param_user SET isenabled=FALSE ismandatory=FALSE WHERE id='inp_options_rtc_period_id';
UPDATE audit_cat_param_user SET epaversion='{"from":"5.1.000", "to":null,"language":"english"}' where id ='inp_options_max_trials';
UPDATE audit_cat_param_user SET epaversion='{"from":"5.1.000", "to":null,"language":"english"}' where id ='inp_options_lat_flow_tol';
UPDATE audit_cat_param_user SET epaversion='{"from":"5.1.000", "to":null,"language":"english"}' where id ='inp_options_head_tolerance';
UPDATE audit_cat_param_user SET epaversion='{"from":"5.1.000", "to":null,"language":"english"}' where id ='inp_options_sys_flow_tol';

UPDATE audit_cat_param_user SET project_type='ud' where id ='epa_conduit_q0_vdefault';
UPDATE audit_cat_param_user SET project_type='ud' where id ='epa_outfall_type_vdefault';
UPDATE audit_cat_param_user SET project_type='ud' where id ='epa_junction_y0_vdefault';
UPDATE audit_cat_param_user SET project_type='ud' where id ='epa_rgage_scf_vdefault';


UPDATE sys_csv2pg_config SET csvversion='{"from":"5.0.022", "to":null,"language":"english"}';
 
UPDATE sys_csv2pg_config SET csvversion='{"from":"5.1", "to":null,"language":"english"}' where tablename='vi_gwf';
UPDATE sys_csv2pg_config SET csvversion='{"from":"5.1", "to":null,"language":"english"}' where tablename='vi_adjustments';



UPDATE inp_typevalue SET descript='TRIANGULAR' WHERE id='V-NOTCH';




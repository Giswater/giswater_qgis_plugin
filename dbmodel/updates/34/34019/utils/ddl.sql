/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


set search_path = 'SCHEMA_NAME';


/*
2020/09/08
DELETE ALL REFERENCES TO LOT PLUGIN
*/
DROP VIEW IF EXISTS v_ui_om_vehicle_x_parameters;
DROP VIEW IF EXISTS v_visit_lot_user;
DROP VIEW IF EXISTS v_om_user_x_team;
DROP VIEW IF EXISTS v_om_team_x_visitclass;
DROP VIEW IF EXISTS v_edit_cat_team;
DROP VIEW IF EXISTS v_ext_cat_vehicle;
DROP VIEW IF EXISTS v_om_lot_x_user;
DROP VIEW IF EXISTS v_ui_om_visit_lot;
DROP VIEW IF EXISTS v_res_lot_x_user;
DROP VIEW IF EXISTS ve_lot_x_node;
DROP VIEW IF EXISTS ve_lot_x_connec;
DROP VIEW IF EXISTS ve_lot_x_arc;
DROP VIEW IF EXISTS ve_lot_x_gully;

ALTER TABLE IF EXISTS om_team_x_visitclass RENAME TO _om_team_x_visitclass_;
ALTER TABLE IF EXISTS om_vehicle_x_parameters RENAME TO _om_vehicle_x_parameters_;
ALTER TABLE IF EXISTS om_team_x_vehicle RENAME TO _om_team_x_vehicle_;
ALTER TABLE IF EXISTS ext_cat_vehicle RENAME TO _ext_cat_vehicle_;
ALTER TABLE IF EXISTS om_visit_team_x_user RENAME TO _om_visit_team_x_user_;
ALTER TABLE IF EXISTS om_visit_lot_x_user RENAME TO _om_visit_lot_x_user_;
ALTER TABLE IF EXISTS config_visit_class_x_workorder RENAME TO _config_visit_class_x_workorder_;
ALTER TABLE IF EXISTS ext_workorder RENAME TO _ext_workorder_;
ALTER TABLE IF EXISTS ext_workorder_class RENAME TO _ext_workorder_class_;
ALTER TABLE IF EXISTS ext_workorder_type RENAME TO _ext_workorder_type_;
ALTER TABLE IF EXISTS om_visit_lot_x_node RENAME TO _om_visit_lot_x_node_;
ALTER TABLE IF EXISTS om_visit_lot_x_connec RENAME TO _om_visit_lot_x_connec_;
ALTER TABLE IF EXISTS om_visit_lot_x_arc RENAME TO _om_visit_lot_x_arc_;
ALTER TABLE IF EXISTS om_visit_lot_x_gully RENAME TO _om_visit_lot_x_gully_;
ALTER TABLE IF EXISTS selector_lot RENAME TO _selector_lot_;
ALTER TABLE IF EXISTS om_visit_lot RENAME TO _om_visit_lot_;
ALTER TABLE IF EXISTS cat_team RENAME TO _cat_team_;

DROP FUNCTION IF EXISTS gw_fct_getlot(json);
DROP FUNCTION IF EXISTS gw_fct_getvisitmanager(json);
DROP FUNCTION IF EXISTS gw_fct_setlot(json);
DROP FUNCTION IF EXISTS gw_setvisitmanager(json);
DROP FUNCTION IF EXISTS gw_setvisitmanagerstart(json);
DROP FUNCTION IF EXISTS gw_setvisitmanagerend(json);
DROP FUNCTION IF EXISTS gw_fct_setvehicleload(json);

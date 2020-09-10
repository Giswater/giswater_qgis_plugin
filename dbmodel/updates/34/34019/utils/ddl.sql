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

DROP TABLE IF EXISTS om_team_x_visitclass;
DROP TABLE IF EXISTS om_vehicle_x_parameters;
DROP TABLE IF EXISTS om_team_x_vehicle;
DROP TABLE IF EXISTS ext_cat_vehicle;
DROP TABLE IF EXISTS om_visit_team_x_user;
DROP TABLE IF EXISTS om_visit_lot_x_user;
DROP TABLE IF EXISTS config_visit_class_x_workorder;
DROP TABLE IF EXISTS ext_workorder;
DROP TABLE IF EXISTS ext_workorder_class;
DROP TABLE IF EXISTS om_visit_class_x_wo;
DROP TABLE IF EXISTS ext_workorder_type;
DROP TABLE IF EXISTS om_visit_lot_x_node;
DROP TABLE IF EXISTS om_visit_lot_x_connec;
DROP TABLE IF EXISTS om_visit_lot_x_arc;
DROP TABLE IF EXISTS om_visit_lot_x_gully;
DROP TABLE IF EXISTS selector_lot;
DROP TABLE IF EXISTS om_visit_lot;
DROP TABLE IF EXISTS cat_team;

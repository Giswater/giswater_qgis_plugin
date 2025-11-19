/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = am, public;

UPDATE config_form_tableview SET alias = 'Result Id' WHERE objectname = 'cat_result' AND columnname = 'result_id';
UPDATE config_form_tableview SET alias = 'Result Name' WHERE objectname = 'cat_result' AND columnname = 'result_name';
UPDATE config_form_tableview SET alias = 'Type' WHERE objectname = 'cat_result' AND columnname = 'result_type';
UPDATE config_form_tableview SET alias = 'Descript' WHERE objectname = 'cat_result' AND columnname = 'descript';
UPDATE config_form_tableview SET alias = 'Report' WHERE objectname = 'cat_result' AND columnname = 'report';
UPDATE config_form_tableview SET alias = 'Expl Id' WHERE objectname = 'cat_result' AND columnname = 'expl_id';
UPDATE config_form_tableview SET alias = 'Budget' WHERE objectname = 'cat_result' AND columnname = 'budget';
UPDATE config_form_tableview SET alias = 'Horizon Year' WHERE objectname = 'cat_result' AND columnname = 'target_year';
UPDATE config_form_tableview SET alias = 'Timestamp' WHERE objectname = 'cat_result' AND columnname = 'tstamp';
UPDATE config_form_tableview SET alias = 'Current User' WHERE objectname = 'cat_result' AND columnname = 'cur_user';
UPDATE config_form_tableview SET alias = 'Status' WHERE objectname = 'cat_result' AND columnname = 'status';
UPDATE config_form_tableview SET alias = 'Corporate' WHERE objectname = 'cat_result' AND columnname = 'iscorporate';
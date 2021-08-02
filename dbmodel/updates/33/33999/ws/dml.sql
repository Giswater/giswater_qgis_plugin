/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2020/06/26
UPDATE config_param_user SET value ='1' WHERE value ='EPA TABLES' AND parameter = 'inp_options_valve_mode';
UPDATE config_param_user SET value ='2' WHERE value ='INVENTORY VALUES' AND parameter = 'inp_options_valve_mode';
UPDATE config_param_user SET value ='3' WHERE value ='MINCUT RESULTS' AND parameter = 'inp_options_valve_mode';
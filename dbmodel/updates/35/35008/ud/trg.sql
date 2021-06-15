/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/01/07
CREATE TRIGGER gw_trg_edit_inp_lid INSTEAD OF INSERT OR UPDATE OR DELETE 
ON v_edit_inp_lid FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_lid();

-- 2020/06/14
DROP TRIGGER if exists gw_trg_scenario_management ON cat_hydrology;
CREATE TRIGGER gw_trg_scenario_management AFTER INSERT ON cat_hydrology  
FOR EACH ROW EXECUTE PROCEDURE gw_trg_scenario_management('cat_hydrology');


-- 2020/06/14
DROP TRIGGER if exists gw_trg_scenario_management ON cat_dwf_scenario;
CREATE TRIGGER gw_trg_scenario_management AFTER INSERT ON cat_dwf_scenario  
FOR EACH ROW EXECUTE PROCEDURE gw_trg_scenario_management('cat_dwf_scenario');




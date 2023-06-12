/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

do $$ 
declare
    v_utils boolean; 
begin
     SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';
	 
	 if v_utils is true then
	 
		ALTER TABLE utils.municipality DROP CONSTRAINT IF EXISTS municipality_region_id_fkey;
     	ALTER TABLE utils.municipality ADD CONSTRAINT municipality_region_id_fkey
		FOREIGN KEY (region_id) REFERENCES utils.region(region_id) ON DELETE RESTRICT ON UPDATE CASCADE;
	
		ALTER TABLE utils.municipality DROP CONSTRAINT IF EXISTS municipality_province_id_fkey;
		ALTER TABLE utils.municipality ADD CONSTRAINT municipality_province_id_fkey
		FOREIGN KEY (province_id) REFERENCES utils.province(province_id) ON DELETE RESTRICT ON UPDATE CASCADE;

		ALTER TABLE utils.region DROP CONSTRAINT IF EXISTS ext_region_province_id_fkey;
		ALTER TABLE utils.region ADD CONSTRAINT ext_region_province_id_fkey
		FOREIGN KEY (province_id) REFERENCES utils.province(province_id) ON DELETE RESTRICT ON UPDATE CASCADE;
	
     else
     	ALTER TABLE ext_municipality ADD CONSTRAINT ext_municipality_region_id_fkey
		FOREIGN KEY (region_id) REFERENCES ext_region(region_id) ON DELETE RESTRICT ON UPDATE CASCADE;
	
		ALTER TABLE ext_municipality ADD CONSTRAINT ext_municipality_province_id_fkey
		FOREIGN KEY (province_id) REFERENCES ext_province(province_id) ON DELETE RESTRICT ON UPDATE CASCADE;

		ALTER TABLE ext_region ADD CONSTRAINT ext_region_province_id_fkey
		FOREIGN KEY (province_id) REFERENCES ext_province(province_id) ON DELETE RESTRICT ON UPDATE CASCADE;
	
	 end if;
end; $$
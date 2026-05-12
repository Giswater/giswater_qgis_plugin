/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- UPDATE om_mincut SET expl_id=999 WHERE expl_id IN (84, 85, 86, 87, 88, 89); // this om_mincut expl_id are not in exploitation table
ALTER TABLE om_mincut ADD CONSTRAINT om_mincut_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;

DO $$
DECLARE
    v_utils boolean;
BEGIN
     SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	 IF v_utils IS true THEN
        ALTER TABLE om_mincut ADD CONSTRAINT om_mincut_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;
     ELSE
        ALTER TABLE om_mincut ADD CONSTRAINT om_mincut_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;
	 END IF;
END; $$;

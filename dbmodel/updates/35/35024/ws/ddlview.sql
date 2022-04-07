/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/04/06
CREATE OR REPLACE VIEW v_edit_inp_dscenario_rules AS 
SELECT id,
d.dscenario_id,
i.sector_id,
i.text,
i.active
FROM selector_inp_dscenario, inp_dscenario_rules i 
JOIN cat_dscenario d USING (dscenario_id)
WHERE i.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;

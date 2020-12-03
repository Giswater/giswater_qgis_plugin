/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--22/11/2019
ALTER TABLE man_addfields_parameter ALTER COLUMN _form_label_ DROP NOT NULL;
ALTER TABLE man_addfields_parameter ALTER COLUMN _widgettype_id_ DROP NOT NULL;

--24/11/2019
ALTER TABLE selector_audit ALTER COLUMN cur_user SET DEFAULT current_user;
ALTER TABLE selector_date ALTER COLUMN cur_user SET DEFAULT current_user;
ALTER TABLE selector_expl ALTER COLUMN cur_user SET DEFAULT current_user;
ALTER TABLE selector_hydrometer ALTER COLUMN cur_user SET DEFAULT current_user;
ALTER TABLE selector_lot ALTER COLUMN cur_user SET DEFAULT current_user;
ALTER TABLE selector_psector ALTER COLUMN cur_user SET DEFAULT current_user;
ALTER TABLE selector_state ALTER COLUMN cur_user SET DEFAULT current_user;
ALTER TABLE selector_workcat ALTER COLUMN cur_user SET DEFAULT current_user;

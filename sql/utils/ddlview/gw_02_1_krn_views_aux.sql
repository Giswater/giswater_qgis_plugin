/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


--------------
-- STATE VIEWS
--------------

DROP VIEW IF EXISTS v_state_dimensions CASCADE;
CREATE VIEW v_state_dimensions AS
SELECT 
	dimensions.id
	FROM selector_state,dimensions
	WHERE dimensions.state=selector_state.state_id
	AND selector_state.cur_user=current_user	




 
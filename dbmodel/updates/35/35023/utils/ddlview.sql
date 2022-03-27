/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/03/24
DROP VIEW IF EXISTS v_ui_workspace;
CREATE VIEW v_ui_workspace
AS SELECT id, name, descript, config, private 
		FROM cat_workspace 
		WHERE private IS FALSE OR (private IS TRUE AND cur_user = current_user);

CREATE OR REPLACE VIEW v_polygon AS
SELECT 
pol_id,
state,
feature_id,
sys_type,
featurecat_id,
the_geom
FROM selector_state s, polygon p
WHERE s.state_id = p.state and s.cur_user = current_user;
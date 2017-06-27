/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

DROP VIEW IF EXISTS v_edit_plan_psector CASCADE;
CREATE VIEW v_edit_plan_psector AS SELECT
	psector_id,
	plan_psector.descript,
	priority,
	text1,
	text2,
	observ,
	rotation,
	scale,
	sector_id,
	atlas_id,
	gexpenses,
	vat,
	other,
	plan_psector.the_geom,
	plan_psector.expl_id
FROM expl_selector,plan_psector
WHERE ((plan_psector.expl_id)::text=(expl_selector.expl_id)::text
AND expl_selector.cur_user="current_user"()::text);
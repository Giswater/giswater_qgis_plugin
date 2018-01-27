/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

  
DROP VIEW IF EXISTS v_edit_om_visit CASCADE;
CREATE VIEW v_edit_om_visit AS SELECT
	om_visit.id,
	visitcat_id
	startdate,
	enddate,
	user_name,
	om_visit.the_geom,
	webclient_id,
	om_visit.expl_id
FROM selector_expl,om_visit
WHERE ((om_visit.expl_id)=(selector_expl.expl_id)
AND selector_expl.cur_user="current_user"());




DROP VIEW IF EXISTS v_edit_om_psector CASCADE;
CREATE OR REPLACE VIEW v_edit_om_psector AS 
SELECT om_psector.psector_id,
    om_psector.name,
    om_psector.result_id,
    om_psector.descript,
    om_psector.priority,
    om_psector.text1,
    om_psector.text2,
    om_psector.observ,
    om_psector.rotation,
    om_psector.scale,
    om_psector.sector_id,
    om_psector.atlas_id,
    om_psector.gexpenses,
    om_psector.vat,
    om_psector.other,
    om_psector.the_geom,
    om_psector.expl_id,
    om_psector.psector_type,
    om_psector.active
FROM selector_expl, om_psector
WHERE om_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;





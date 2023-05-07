/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP VIEW v_edit_plan_psector_x_connec;
CREATE OR REPLACE VIEW v_edit_plan_psector_x_connec AS 
 SELECT 
    id,
    plan_psector_x_connec.connec_id,
    plan_psector_x_connec.arc_id,
    plan_psector_x_connec.psector_id,
    plan_psector_x_connec.state,
    plan_psector_x_connec.doable,
    plan_psector_x_connec.descript,
    plan_psector_x_connec.link_id,
    plan_psector_x_connec.active,
    plan_psector_x_connec.insert_tstamp,
    plan_psector_x_connec.insert_user
   FROM plan_psector_x_connec;
   
   
CREATE OR REPLACE VIEW v_expl_connec AS 
 SELECT connec.connec_id
 FROM selector_expl, connec
 WHERE selector_expl.cur_user = "current_user"()::text AND (connec.expl_id = selector_expl.expl_id);
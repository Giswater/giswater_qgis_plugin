/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/09/07
CREATE OR REPLACE VIEW v_edit_plan_psector
AS SELECT plan_psector.psector_id,
    plan_psector.name,
    plan_psector.descript,
    plan_psector.priority,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.rotation,
    plan_psector.scale,
    plan_psector.atlas_id,
    plan_psector.gexpenses,
    plan_psector.vat,
    plan_psector.other,
    plan_psector.the_geom,
    plan_psector.expl_id,
    plan_psector.psector_type,
    plan_psector.active,
    plan_psector.ext_code,
    plan_psector.status,
    plan_psector.text3,
    plan_psector.text4,
    plan_psector.text5,
    plan_psector.text6,
    plan_psector.num_value,
    plan_psector.workcat_id,
    plan_psector.parent_id
   FROM selector_expl,
    plan_psector
  WHERE plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;

--2021/09/15
CREATE OR REPLACE VIEW v_ui_workspace AS
SELECT id, name, descript, config
FROM cat_workspace
WHERE isautomatic IS FALSE;

--2021/09/20
CREATE OR REPLACE VIEW ve_pol_node AS
SELECT 
pol_id,
feature_id,
polygon.feature_type,
polygon.the_geom
FROM node
JOIN v_state_node USING(node_id)
JOIN polygon ON polygon.feature_id::text = node.node_id::text;


CREATE OR REPLACE VIEW ve_pol_connec AS
SELECT 
pol_id,
feature_id,
polygon.feature_type,
polygon.the_geom
FROM connec
JOIN v_state_connec USING(connec_id)
JOIN polygon ON polygon.feature_id::text = connec.connec_id::text;


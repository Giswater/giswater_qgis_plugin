/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME ,public;


CREATE OR REPLACE VIEW vu_link AS
 SELECT l.link_id,
    l.feature_type,
    l.feature_id,
    l.exit_type,
    l.exit_id,
    l.state,
    l.expl_id,
    l.sector_id,
    l.dma_id,
    l.exit_topelev,
    l.exit_elev,
    l.fluid_type,
    st_length2d(l.the_geom)::numeric(12,3) AS gis_length,
    l.the_geom,
    s.name AS sector_name,
    s.macrosector_id,
    d.macrodma_id,
    l.expl_id2,
    l.epa_type,
    l.is_operative,
    l.drainzone_id,
    r.name as drainzone_name,
    l.connecat_id,
    l.workcat_id,
    l.workcat_id_end,
    l.builtdate,
    l.enddate,
    date_trunc('second'::text, l.lastupdate) AS lastupdate,
    l.lastupdate_user
   FROM link l
     LEFT JOIN sector s USING (sector_id)
     LEFT JOIN dma d USING (dma_id)
     LEFT JOIN drainzone r USING (drainzone_id);

create or replace view v_link_connec as 
select distinct on (link_id) * from vu_link_connec
JOIN v_state_link_connec USING (link_id);

create or replace view v_link_gully as 
select distinct on (link_id) * from vu_link_gully
JOIN v_state_link_gully USING (link_id);

create or replace view v_link as 
select distinct on (link_id) * from vu_link
JOIN v_state_link USING (link_id);

CREATE OR REPLACE VIEW v_edit_link AS SELECT *
FROM v_link l;

drop view if exists v_ui_arc_x_relations;
CREATE OR REPLACE VIEW v_ui_arc_x_relations as
  WITH links_node AS (
         SELECT n.node_id,
            l.feature_id,
            l.exit_type AS proceed_from,
            l.exit_id AS proceed_from_id,
            l.state AS l_state,
            n.state AS n_state
           FROM node n
             JOIN link l ON n.node_id::text = l.exit_id::text
             where l.state = 1
        )
 SELECT row_number() OVER () + 1000000 AS rid,  
    v_connec.arc_id,
    v_connec.connec_type AS featurecat_id,
    v_connec.connecat_id AS catalog,
    v_connec.connec_id AS feature_id,
    v_connec.code AS feature_code,
    v_connec.sys_type,
    a.state as arc_state,
    v_connec.state AS feature_state,
    st_x(v_connec.the_geom) AS x,
    st_y(v_connec.the_geom) AS y,
    l.exit_type AS proceed_from,
    l.exit_id AS proceed_from_id,
    'v_edit_connec'::text AS sys_table_id
   FROM v_connec
     JOIN link l ON v_connec.connec_id::text = l.feature_id::text
     JOIN arc a ON a.arc_id = v_connec.arc_id
  WHERE v_connec.arc_id IS NOT NULL AND l.exit_type::text <> 'NODE'::text AND l.state = 1 AND l.state = 1 and a.state = 1
UNION
 SELECT DISTINCT ON (c.connec_id) row_number() OVER () + 2000000 AS rid,
    a.arc_id,
    c.connec_type AS featurecat_id,
    c.connecat_id AS catalog,
    c.connec_id AS feature_id,
    c.code AS feature_code,
    c.sys_type,
    a.state as arc_state,
    c.state AS feature_state,
    st_x(c.the_geom) AS x,
    st_y(c.the_geom) AS y,
    n.proceed_from,
    n.proceed_from_id,
    'v_edit_connec'::text AS sys_table_id
   FROM arc a
     JOIN links_node n ON a.node_1::text = n.node_id::text
     JOIN v_connec c ON c.connec_id::text = n.feature_id::text
UNION
 SELECT row_number() OVER () + 3000000 AS rid, 
    v_gully.arc_id,
    v_gully.gully_type AS featurecat_id,
    v_gully.gratecat_id AS catalog,
    v_gully.gully_id AS feature_id,
    v_gully.code AS feature_code,
    v_gully.sys_type,
    a.state as arc_state,
    v_gully.state AS feature_state,
    st_x(v_gully.the_geom) AS x,
    st_y(v_gully.the_geom) AS y,
    l.exit_type AS proceed_from,
    l.exit_id AS proceed_from_id,
    'v_edit_gully'::text AS sys_table_id
   FROM v_gully
     JOIN link l ON v_gully.gully_id::text = l.feature_id::text
     JOIN arc a ON a.arc_id = v_gully.arc_id
  WHERE v_gully.arc_id IS NOT NULL AND l.exit_type::text <> 'NODE'::text AND l.state = 1 and a.state =  1
UNION
 SELECT DISTINCT ON (g.gully_id) row_number() OVER () + 4000000 AS rid, 
    a.arc_id,
    g.gully_type AS featurecat_id,
    g.gratecat_id AS catalog,
    g.gully_id AS feature_id,
    g.code AS feature_code,
    g.sys_type,
    a.state as arc_state,
    g.state AS feature_state,
    st_x(g.the_geom) AS x,
    st_y(g.the_geom) AS y,
    n.proceed_from,
    n.proceed_from_id,
    'v_edit_gully'::text AS sys_table_id
   FROM arc a
     JOIN links_node n ON a.node_1::text = n.node_id::text
     JOIN v_gully g ON g.gully_id::text = n.feature_id::text;


CREATE OR REPLACE VIEW v_edit_plan_psector_x_connec AS 
SELECT plan_psector_x_connec.id,
    plan_psector_x_connec.connec_id,
    plan_psector_x_connec.arc_id,
    plan_psector_x_connec.psector_id,
    plan_psector_x_connec.state,
    plan_psector_x_connec.doable,
    plan_psector_x_connec.descript,
    plan_psector_x_connec.link_id,
    plan_psector_x_connec.active,
    plan_psector_x_connec.insert_tstamp,
    plan_psector_x_connec.insert_user,
    exit_type
   FROM plan_psector_x_connec
   LEFT JOIN link USING (link_id);


CREATE OR REPLACE VIEW v_edit_plan_psector_x_gully AS 
SELECT plan_psector_x_gully.id,
    plan_psector_x_gully.gully_id,
    plan_psector_x_gully.arc_id,
    plan_psector_x_gully.psector_id,
    plan_psector_x_gully.state,
    plan_psector_x_gully.doable,
    plan_psector_x_gully.descript,
    plan_psector_x_gully.link_id,
    plan_psector_x_gully.active,
    plan_psector_x_gully.insert_tstamp,
    plan_psector_x_gully.insert_user,
    exit_type
   FROM plan_psector_x_gully
   LEFT JOIN link USING (link_id);



CREATE OR REPLACE VIEW v_connec AS 
 SELECT vu_connec.connec_id,
    vu_connec.code,
    vu_connec.customer_code,
    vu_connec.top_elev,
    vu_connec.y1,
    vu_connec.y2,
    vu_connec.connecat_id,
    vu_connec.connec_type,
    vu_connec.sys_type,
    vu_connec.private_connecat_id,
    vu_connec.matcat_id,
    vu_connec.expl_id,
    vu_connec.macroexpl_id,
        CASE
            WHEN a.sector_id IS NULL THEN vu_connec.sector_id
            ELSE a.sector_id
        END AS sector_id,
        CASE
            WHEN a.macrosector_id IS NULL THEN vu_connec.macrosector_id
            ELSE a.macrosector_id
        END AS macrosector_id,
    vu_connec.demand,
    vu_connec.state,
    vu_connec.state_type,
    vu_connec.connec_depth,
    vu_connec.connec_length,
    v_state_connec.arc_id,
    vu_connec.annotation,
    vu_connec.observ,
    vu_connec.comment,
        CASE
            WHEN a.dma_id IS NULL THEN vu_connec.dma_id
            ELSE a.dma_id
        END AS dma_id,
        CASE
            WHEN a.macrodma_id IS NULL THEN vu_connec.macrodma_id
            ELSE a.macrodma_id
        END AS macrodma_id,
    vu_connec.soilcat_id,
    vu_connec.function_type,
    vu_connec.category_type,
    vu_connec.fluid_type,
    vu_connec.location_type,
    vu_connec.workcat_id,
    vu_connec.workcat_id_end,
    vu_connec.buildercat_id,
    vu_connec.builtdate,
    vu_connec.enddate,
    vu_connec.ownercat_id,
    vu_connec.muni_id,
    vu_connec.postcode,
    vu_connec.district_id,
    vu_connec.streetname,
    vu_connec.postnumber,
    vu_connec.postcomplement,
    vu_connec.streetname2,
    vu_connec.postnumber2,
    vu_connec.postcomplement2,
    vu_connec.descript,
    vu_connec.svg,
    vu_connec.rotation,
    vu_connec.link,
    vu_connec.verified,
    vu_connec.undelete,
    vu_connec.label,
    vu_connec.label_x,
    vu_connec.label_y,
    vu_connec.label_rotation,
    vu_connec.accessibility,
    vu_connec.diagonal,
    vu_connec.publish,
    vu_connec.inventory,
    vu_connec.uncertain,
    vu_connec.num_value,
        CASE
            WHEN a.exit_id IS NULL THEN vu_connec.pjoint_id
            ELSE a.exit_id
        END AS pjoint_id,
        CASE
            WHEN a.exit_type IS NULL THEN vu_connec.pjoint_type
            ELSE a.exit_type
        END AS pjoint_type,
    vu_connec.tstamp,
    vu_connec.insert_user,
    vu_connec.lastupdate,
    vu_connec.lastupdate_user,
    vu_connec.the_geom,
    vu_connec.workcat_id_plan,
    vu_connec.asset_id,
    vu_connec.drainzone_id,
    vu_connec.expl_id2,
    vu_connec.is_operative,
    vu_connec.region_id,
    vu_connec.province_id,
    vu_connec.adate,
    vu_connec.adescript
   FROM vu_connec
	 JOIN v_state_connec USING (connec_id)
     LEFT JOIN ( SELECT DISTINCT ON (vu_link.feature_id) vu_link.link_id,
            vu_link.feature_type,
            vu_link.feature_id,
            vu_link.exit_type,
            vu_link.exit_id,
            vu_link.state,
            vu_link.expl_id,
            vu_link.sector_id,
            vu_link.dma_id,
            vu_link.exit_topelev,
            vu_link.exit_elev,
            vu_link.fluid_type,
            vu_link.gis_length,
            vu_link.the_geom,
            vu_link.sector_name,
            vu_link.macrosector_id,
            vu_link.macrodma_id
           FROM vu_link
           JOIN selector_expl USING (expl_id) WHERE cur_user =current_user AND vu_link.state = 2) 
           a ON a.feature_id::text = vu_connec.connec_id::text;


CREATE OR REPLACE VIEW v_gully AS 
 SELECT vu_gully.gully_id,
    vu_gully.code,
    vu_gully.top_elev,
    vu_gully.ymax,
    vu_gully.sandbox,
    vu_gully.matcat_id,
    vu_gully.gully_type,
    vu_gully.sys_type,
    vu_gully.gratecat_id,
    vu_gully.cat_grate_matcat,
    vu_gully.units,
    vu_gully.groove,
    vu_gully.siphon,
    vu_gully.connec_arccat_id,
    vu_gully.connec_length,
    vu_gully.connec_depth,
    v_state_gully.arc_id,
    vu_gully.expl_id,
    vu_gully.macroexpl_id,
         CASE
            WHEN a.sector_id IS NULL THEN vu_gully.sector_id
            ELSE a.sector_id
        END AS sector_id,
        CASE
            WHEN a.macrosector_id IS NULL THEN vu_gully.macrosector_id
            ELSE a.macrosector_id
        END AS macrosector_id,
    vu_gully.state,
    vu_gully.state_type,
    vu_gully.annotation,
    vu_gully.observ,
    vu_gully.comment,
	CASE
            WHEN a.dma_id IS NULL THEN vu_gully.dma_id
            ELSE a.dma_id
        END AS dma_id,
        CASE
            WHEN a.macrodma_id IS NULL THEN vu_gully.macrodma_id
            ELSE a.macrodma_id
        END AS macrodma_id,
    vu_gully.soilcat_id,
    vu_gully.function_type,
    vu_gully.category_type,
    vu_gully.fluid_type,
    vu_gully.location_type,
    vu_gully.workcat_id,
    vu_gully.workcat_id_end,
    vu_gully.buildercat_id,
    vu_gully.builtdate,
    vu_gully.enddate,
    vu_gully.ownercat_id,
    vu_gully.muni_id,
    vu_gully.postcode,
    vu_gully.district_id,
    vu_gully.streetname,
    vu_gully.postnumber,
    vu_gully.postcomplement,
    vu_gully.streetname2,
    vu_gully.postnumber2,
    vu_gully.postcomplement2,
    vu_gully.descript,
    vu_gully.svg,
    vu_gully.rotation,
    vu_gully.link,
    vu_gully.verified,
    vu_gully.undelete,
    vu_gully.label,
    vu_gully.label_x,
    vu_gully.label_y,
    vu_gully.label_rotation,
    vu_gully.publish,
    vu_gully.inventory,
    vu_gully.uncertain,
    vu_gully.num_value,
	CASE
            WHEN a.exit_id IS NULL THEN vu_gully.pjoint_id
            ELSE a.exit_id
        END AS pjoint_id,
        CASE
            WHEN a.exit_type IS NULL THEN vu_gully.pjoint_type
            ELSE a.exit_type
        END AS pjoint_type,
    vu_gully.tstamp,
    vu_gully.insert_user,
    vu_gully.lastupdate,
    vu_gully.lastupdate_user,
    vu_gully.the_geom,
    vu_gully.workcat_id_plan,
    vu_gully.asset_id,
    vu_gully.connec_matcat_id,
    vu_gully.gratecat2_id,
    vu_gully.connec_y1,
    vu_gully.connec_y2,
    vu_gully.epa_type,
    vu_gully.groove_height,
    vu_gully.groove_length,
    vu_gully.grate_width,
    vu_gully.grate_length,
    vu_gully.units_placement,
    vu_gully.drainzone_id,
    vu_gully.expl_id2,
    vu_gully.is_operative,
    vu_gully.region_id,
    vu_gully.province_id,
    vu_gully.adate,
    vu_gully.adescript,
    vu_gully.siphon_type,
    vu_gully.odorflap
   FROM vu_gully
   	 JOIN v_state_gully USING (gully_id)
     LEFT JOIN ( SELECT DISTINCT ON (vu_link.feature_id) vu_link.link_id,
            vu_link.feature_type,
            vu_link.feature_id,
            vu_link.exit_type,
            vu_link.exit_id,
            vu_link.state,
            vu_link.expl_id,
            vu_link.sector_id,
            vu_link.dma_id,
            vu_link.exit_topelev,
            vu_link.exit_elev,
            vu_link.fluid_type,
            vu_link.gis_length,
            vu_link.the_geom,
            vu_link.sector_name,
            vu_link.macrosector_id,
            vu_link.macrodma_id
           FROM vu_link
           JOIN selector_expl USING (expl_id) WHERE cur_user =current_user AND vu_link.state = 2) 
           a ON a.feature_id::text = vu_gully.gully_id::text;

CREATE OR REPLACE VIEW ve_pol_connec AS 
 SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom,
    polygon.trace_featuregeom
   FROM v_connec
     JOIN polygon ON polygon.feature_id::text = v_connec.connec_id::text;

CREATE OR REPLACE VIEW ve_pol_gully AS 
 SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom,
    fluid_type,
    polygon.trace_featuregeom
   FROM v_gully
     JOIN polygon ON polygon.feature_id::text = v_gully.gully_id::text;

CREATE OR REPLACE VIEW ve_pol_node AS 
 SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom,
    polygon.trace_featuregeom
   FROM v_node
     JOIN polygon ON polygon.feature_id::text = v_node.node_id::text;


CREATE OR REPLACE VIEW v_anl_flow_gully AS 
 SELECT gully_id,
        CASE
            WHEN anl_arc.fid = 220 THEN 'Flow trace'::text
            WHEN anl_arc.fid = 221 THEN 'Flow exit'::text
            ELSE NULL::text
        END AS context,
    anl_arc.expl_id,
    gully.the_geom
   FROM anl_arc
     JOIN gully ON anl_arc.arc_id::text = gully.arc_id::text
     JOIN selector_expl ON anl_arc.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text AND anl_arc.cur_user::name = "current_user"() AND (anl_arc.fid = 220 OR anl_arc.fid = 221);


CREATE OR REPLACE VIEW v_rpt_comp_storagevol_sum
AS SELECT rpt_storagevol_sum.id,
    rpt_storagevol_sum.result_id,
    rpt_storagevol_sum.node_id,
    node.node_type,
    node.nodecat_id,
    rpt_storagevol_sum.aver_vol,
    rpt_storagevol_sum.avg_full,
    rpt_storagevol_sum.ei_loss,
    rpt_storagevol_sum.max_vol,
    rpt_storagevol_sum.max_full,
    rpt_storagevol_sum.time_days,
    rpt_storagevol_sum.time_hour,
    rpt_storagevol_sum.max_out,
    node.sector_id,
    node.the_geom
   FROM selector_rpt_compare, rpt_inp_node node
     JOIN rpt_storagevol_sum ON rpt_storagevol_sum.node_id::text = node.node_id::text
  WHERE rpt_storagevol_sum.result_id::text = selector_rpt_compare.result_id::text AND selector_rpt_compare.cur_user = "current_user"()::text
  AND node.result_id::text = selector_rpt_compare.result_id::text;

UPDATE config_form_tabs SET tabactions='[{"actionName":"actionEdit", "disabled":false},
{"actionName":"actionZoom", "disabled":false},
{"actionName":"actionCentered", "disabled":false},
{"actionName":"actionZoomOut", "disabled":false},
{"actionName":"actionCatalog", "disabled":false},
{"actionName":"actionWorkcat", "disabled":false},
{"actionName":"actionCopyPaste","disabled":false},
{"actionName":"actionSection", "disabled":false},
{"actionName":"actionGetParentId", "disabled":false},
{"actionName":"actionLink",  "disabled":false},
{"actionName": "actionHelp", "disabled": false}]'::json WHERE formname='v_edit_arc' AND tabname='tab_data';

UPDATE sys_param_user SET layoutorder=26 WHERE id='edit_node_ymax_vdefault';


UPDATE inp_curve SET active = true where active is null;
UPDATE inp_typevalue SET descript = 'RECT_OPEN' WHERE typevalue = 'inp_value_weirs' AND id = 'ROADWAY';


UPDATE inp_timeseries SET active = true where active is null;
INSERT INTO inp_typevalue VALUES ('inp_typevalue_dscenario', 'CONTROLS', 'CONTROLS');


INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source") 
VALUES(3290, 'gw_fct_create_hydrology_scenario_empty', 'ud', 'function', NULL, NULL, 'Function to create empty hydrology scenario', 'role_epa', NULL, 'core');
INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active, device) 
VALUES(3290, 'Create empty Hydrology scenario', '{"featureType":[]}'::json, '[
{"widgetname":"name", "label":"Name: (*)","widgettype":"linetext","datatype":"text", "isMandatory":true, "tooltip":"Name for hydrology scenario (mandatory)", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":1, "value":""},
{"widgetname":"infiltration", "label":"Infiltration:","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Infiltration", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":2, "value":""},
{"widgetname":"text", "label":"Text:","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Text of hydrology scenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":3, "value":""},
{"widgetname":"expl", "label":"Exploitation:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"hydrology scenario type", "dvQueryText":"SELECT expl_id AS id, name as idval FROM v_edit_exploitation", "layoutname":"grl_option_parameters","layoutorder":4, "value":""},
{"widgetname":"active", "label":"Active:", "widgettype":"check", "datatype":"boolean", "tooltip":"If true, active" , "layoutname":"grl_option_parameters","layoutorder":5, "value":"true"}
]'::json, NULL, true, '{4}');
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam) 
VALUES(523, 'Create hydrology scenario with empty values', 'ud', NULL, 'core', NULL, 'Function process', NULL);

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source") 
VALUES(3292, 'gw_fct_create_dwf_scenario_empty', 'ud', 'function', NULL, NULL, 'Function to create empty dwf scenario', 'role_epa', NULL, 'core');
INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active, device) 
VALUES(3292, 'Create empty DWF scenario', '{"featureType":[]}'::json, '[
{"widgetname":"idval", "label":"Name: (*)","widgettype":"linetext","datatype":"text", "isMandatory":true, "tooltip":"Name for dwf scenario (mandatory)", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":1, "value":""},
{"widgetname":"startdate", "label":"Start date:","widgettype":"datetime","datatype":"date", "isMandatory":false, "tooltip":"Start date for dwf scenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":2, "value":""},
{"widgetname":"enddate", "label":"Parent:","widgettype":"datetime","datatype":"date", "isMandatory":false, "tooltip":"", "placeholder":"End date for dwf scenario", "layoutname":"grl_option_parameters","layoutorder":3, "value":""},
{"widgetname":"observ", "label":"Observ:","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Observations of dwf scenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":4, "value":""},
{"widgetname":"expl", "label":"Exploitation:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"dwf scenario type", "dvQueryText":"SELECT expl_id AS id, name as idval FROM v_edit_exploitation", "layoutname":"grl_option_parameters","layoutorder":5, "value":""},
{"widgetname":"active", "label":"Active:", "widgettype":"check", "datatype":"boolean", "tooltip":"If true, active" , "layoutname":"grl_option_parameters","layoutorder":6, "value":"true"}
]'::json, NULL, true, '{4}');
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam) 
VALUES(524, 'Create dwf scenario with empty values', 'ud', NULL, 'core', NULL, 'Function process', NULL);

UPDATE config_toolbox SET inputparams='[
  {"widgetname":"target", "label":"Target Scenario:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT id, idval FROM cat_dwf_scenario c WHERE active IS TRUE", "layoutname":"grl_option_parameters","layoutorder":1, "selectedId":"$userDwf"},
  {"widgetname":"sector", "label":"Sector:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT sector_id AS id, name as idval FROM sector JOIN selector_sector USING (sector_id) WHERE cur_user = current_user UNION SELECT -999,''ALL VISIBLE SECTORS'' ORDER BY 1 DESC", "layoutname":"grl_option_parameters","layoutorder":2, "selectedId":"$userSector"},
  {"widgetname":"action", "label":"Action:", "widgettype":"combo", "datatype":"text", "comboIds":["INSERT-ONLY", "DELETE-COPY", "KEEP-COPY", "DELETE-ONLY"], "comboNames":["INSERT ONLY", "DELETE & COPY", "KEEP & COPY", "DELETE ONLY"], "layoutname":"grl_option_parameters","layoutorder":3, "selectedId":"INSERT-ONLY"},
  {"widgetname":"copyFrom", "label":"Copy from:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT id, idval FROM cat_dwf_scenario c WHERE active IS TRUE", "layoutname":"grl_option_parameters","layoutorder":4, "selectedId":""}
  ]'::json WHERE id=3102;
  
  
insert into config_toolbox (id,alias,functionparams, inputparams, observ, active, device)
values (3242, 'Set optimum outlet for subcatchments', '{"featureType":[]}', 
'[{"widgetname":"sector", "label":"Sector:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT sector_id AS id, name as idval FROM sector JOIN selector_sector USING (sector_id) WHERE cur_user = current_user UNION SELECT -999,''ALL VISIBLE SECTORS'' ORDER BY 1 DESC ", "layoutname":"grl_option_parameters","layoutorder":1, "selectedId":"$userSector"}]',
null, true, '{4}');

update sys_function set descript = 'Function to set optimum outlet for subcatchments according the closest node of network with less elevation that minimum elevation (minelev) of subcatchment' WHERE id = 3242;

-- gully
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('gully', 'form_feature', 'tab_visit', 'date_visit_from', 'lyt_visit_1', 1, 'date', 'datetime', 'From:', NULL, NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"labelPosition": "top", "filterSign":">="}'::json, '{"functionName": "filter_table", "parameters":{}}'::json, 'tbl_doc_x_gully', false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('gully', 'form_feature', 'tab_visit', 'date_visit_to', 'lyt_visit_1', 2, 'date', 'datetime', 'To:', NULL, NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"labelPosition": "top", "filterSign":"<="}'::json, '{"functionName": "filter_table", "parameters":{}}'::json, 'tbl_doc_x_gully', false, 2);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('gully', 'form_feature', 'tab_visit', 'visit_class', 'lyt_visit_1', 3, 'string', 'combo', 'Visit class:', NULL, NULL, false, false, true, false, true, 'SELECT id, idval FROM config_visit_class WHERE feature_type IN (''GULLY'',''ALL'') ', NULL, true, NULL, NULL, NULL, '{"labelPosition": "top"}'::json, '{"functionName": "filter_table", "parameters":{}}'::json, 'tbl_visit_x_gully', false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('gully', 'form_feature', 'tab_visit', 'hspacer_lyt_document_1', 'lyt_visit_2', 1, NULL, 'hspacer', NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('gully', 'form_feature', 'tab_visit', 'open_gallery', 'lyt_visit_2', 2, NULL, 'button', NULL, 'Open gallery', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, '{"icon":"136b", "size":"24x24"}'::json, '{"saveValue":false, "filterSign":"="}'::json, '{"functionName": "open_visit_files", "module": "info", "parameters":{"targetwidget":"tab_visit_tbl_visits"}}'::json, 'tbl_visit_x_gully', false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('gully', 'form_feature', 'tab_visit', 'tbl_visits', 'lyt_visit_3', 1, NULL, 'tableview', NULL, NULL, NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"saveValue": false}'::json, '{"functionName": "open_selected_path", "parameters":{"columnfind":"path"}}'::json, 'tbl_visit_x_gully', false, 4);

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3294, 'gw_fct_duplicate_hydrology_scenario', 'ud', 'function', NULL, NULL, 'Function to duplicate hydrology scenario', 'role_epa', NULL, 'core');
INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active, device)
VALUES(3294, 'Duplicate Hydrology scenario', '{"featureType":[]}'::json, '[
{"widgetname":"copyFrom", "label":"Copy from:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT hydrology_id as id, name as idval FROM cat_hydrology WHERE active IS TRUE", "layoutname":"grl_option_parameters","layoutorder":1, "selectedId":"$userDscenario"},
{"widgetname":"name", "label":"Name: (*)","widgettype":"linetext","datatype":"text", "isMandatory":true, "tooltip":"Name for hydrology scenario (mandatory)", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":2, "value":""},
{"widgetname":"infiltration", "label":"Infiltration:","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Infiltration", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":3, "value":""},
{"widgetname":"text", "label":"Text:","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Text of hydrology scenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":4, "value":""},
{"widgetname":"expl", "label":"Exploitation:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"hydrology scenario type", "dvQueryText":"SELECT expl_id AS id, name as idval FROM v_edit_exploitation", "layoutname":"grl_option_parameters","layoutorder":5, "value":""},
{"widgetname":"active", "label":"Active:", "widgettype":"check", "datatype":"boolean", "tooltip":"If true, active" , "layoutname":"grl_option_parameters","layoutorder":6, "value":"true"}
]'::json, NULL, true, '{4}');
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam)
VALUES(525, 'Duplicate hydrology scenario', 'ud', NULL, 'core', NULL, 'Function process', NULL);

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3296, 'gw_fct_duplicate_dwf_scenario', 'ud', 'function', NULL, NULL, 'Function to duplicate dwf scenario', 'role_epa', NULL, 'core');
INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active, device)
VALUES(3296, 'Duplicate DWF scenario', '{"featureType":[]}'::json, '[
{"widgetname":"copyFrom", "label":"Copy from:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT id, idval FROM cat_dwf_scenario WHERE active IS TRUE", "layoutname":"grl_option_parameters","layoutorder":1, "selectedId":"$userDscenario"},
{"widgetname":"idval", "label":"Name: (*)","widgettype":"linetext","datatype":"text", "isMandatory":true, "tooltip":"Name for dwf scenario (mandatory)", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":2, "value":""},
{"widgetname":"startdate", "label":"Start date:","widgettype":"datetime","datatype":"date", "isMandatory":false, "tooltip":"Start date for dwf scenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":3, "value":""},
{"widgetname":"enddate", "label":"Parent:","widgettype":"datetime","datatype":"date", "isMandatory":false, "tooltip":"", "placeholder":"End date for dwf scenario", "layoutname":"grl_option_parameters","layoutorder":4, "value":""},
{"widgetname":"observ", "label":"Observ:","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Observations of dwf scenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":5, "value":""},
{"widgetname":"expl", "label":"Exploitation:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"dwf scenario type", "dvQueryText":"SELECT expl_id AS id, name as idval FROM v_edit_exploitation", "layoutname":"grl_option_parameters","layoutorder":6, "value":""},
{"widgetname":"active", "label":"Active:", "widgettype":"check", "datatype":"boolean", "tooltip":"If true, active" , "layoutname":"grl_option_parameters","layoutorder":7, "value":"true"}
]'::json, NULL, true, '{4}');
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam)
VALUES(526, 'Duplicate dwf scenario', 'ud', NULL, 'core', NULL, 'Function process', NULL);

ALTER TABLE inp_coverage DROP CONSTRAINT inp_coverage_land_x_subc_subc_id_fkey;
ALTER TABLE inp_coverage ADD CONSTRAINT inp_coverage_land_x_subc_subc_id_fkey FOREIGN KEY (subc_id, hydrology_id)
REFERENCES inp_subcatchment (subc_id, hydrology_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE inp_divider DROP CONSTRAINT inp_divider_arc_id_fkey;
ALTER TABLE inp_divider ADD CONSTRAINT inp_divider_arc_id_fkey FOREIGN KEY (arc_id)
REFERENCES arc (arc_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_divider DROP CONSTRAINT inp_divider_curve_id_fkey;
ALTER TABLE inp_divider ADD CONSTRAINT inp_divider_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_conduit DROP CONSTRAINT inp_dscenario_conduit_arccat_id_fkey;
ALTER TABLE inp_dscenario_conduit ADD CONSTRAINT inp_dscenario_conduit_arccat_id_fkey FOREIGN KEY (arccat_id)
REFERENCES cat_arc (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_conduit DROP CONSTRAINT inp_dscenario_conduit_matcat_id_fkey;
ALTER TABLE inp_dscenario_conduit ADD CONSTRAINT inp_dscenario_conduit_matcat_id_fkey FOREIGN KEY (matcat_id)
REFERENCES cat_mat_arc (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_flwreg_outlet DROP CONSTRAINT inp_dscenario_flwreg_outlet_curve_id_fkey;
ALTER TABLE inp_dscenario_flwreg_outlet ADD CONSTRAINT inp_dscenario_flwreg_outlet_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_flwreg_pump DROP CONSTRAINT inp_dscenario_flwreg_pump_curve_id_fkey;
ALTER TABLE inp_dscenario_flwreg_pump ADD CONSTRAINT inp_dscenario_flwreg_pump_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_inflows_poll DROP CONSTRAINT inp_dscenario_inflows_pol_poll_id_fkey;
ALTER TABLE inp_dscenario_inflows_poll ADD CONSTRAINT inp_dscenario_inflows_pol_poll_id_fkey FOREIGN KEY (poll_id)
REFERENCES inp_pollutant (poll_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_inflows_poll DROP CONSTRAINT inp_dscenario_inflows_pol_timser_id_fkey;
ALTER TABLE inp_dscenario_inflows_poll ADD CONSTRAINT inp_dscenario_inflows_pol_timser_id_fkey FOREIGN KEY (timser_id)
REFERENCES inp_timeseries (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_inflows ADD CONSTRAINT inp_dscenario_inflows_timser_id_fkey FOREIGN KEY (timser_id)
REFERENCES inp_timeseries (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_lid_usage DROP CONSTRAINT inp_dscenario_lid_usage_lidco_id_fkey;
ALTER TABLE inp_dscenario_lid_usage ADD CONSTRAINT inp_dscenario_lid_usage_lidco_id_fkey FOREIGN KEY (lidco_id)
REFERENCES inp_lid (lidco_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_outfall DROP CONSTRAINT inp_dscenario_outfall_timser_id_fkey;
ALTER TABLE inp_dscenario_outfall ADD CONSTRAINT inp_dscenario_outfall_timser_id_fkey FOREIGN KEY (timser_id)
REFERENCES inp_timeseries (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_outfall DROP CONSTRAINT inp_dscenario_outfall_curve_id_fkey;
ALTER TABLE inp_dscenario_outfall ADD CONSTRAINT inp_dscenario_outfall_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_raingage ADD CONSTRAINT inp_dscenario_raingage_timser_id_fkey FOREIGN KEY (timser_id)
REFERENCES inp_timeseries (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_storage DROP CONSTRAINT inp_dscenario_storage_curve_id_fkey;
ALTER TABLE inp_dscenario_storage ADD CONSTRAINT inp_dscenario_storage_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dscenario_treatment DROP CONSTRAINT inp_treatment_poll_id_fkey;
ALTER TABLE inp_dscenario_treatment ADD CONSTRAINT inp_treatment_poll_id_fkey FOREIGN KEY (poll_id)
REFERENCES inp_pollutant (poll_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_dwf_pol_x_node DROP CONSTRAINT inp_dwf_pol_x_node_poll_id_fkey;
ALTER TABLE inp_dwf_pol_x_node ADD CONSTRAINT inp_dwf_pol_x_node_poll_id_fkey FOREIGN KEY (poll_id)
REFERENCES inp_pollutant (poll_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_flwreg_outlet DROP CONSTRAINT inp_flwreg_outlet_curve_id_fkey;
ALTER TABLE inp_flwreg_outlet ADD CONSTRAINT inp_flwreg_outlet_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_flwreg_pump DROP CONSTRAINT inp_flwreg_pump_to_arc_fkey;
ALTER TABLE inp_flwreg_pump ADD CONSTRAINT inp_flwreg_pump_to_arc_fkey FOREIGN KEY (to_arc)
REFERENCES arc (arc_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_flwreg_pump DROP CONSTRAINT inp_flwreg_pump_curve_id_fkey;
ALTER TABLE inp_flwreg_pump ADD CONSTRAINT inp_flwreg_pump_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_flwreg_weir DROP CONSTRAINT inp_flwreg_weir_to_arc_fkey;
ALTER TABLE inp_flwreg_weir ADD CONSTRAINT inp_flwreg_weir_to_arc_fkey FOREIGN KEY (to_arc)
REFERENCES arc (arc_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_inflows ADD CONSTRAINT inp_inflows_timser_id_fkey FOREIGN KEY (timser_id)
REFERENCES inp_timeseries (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_inflows_poll DROP CONSTRAINT inp_inflows_pol_x_node_poll_id_fkey;
ALTER TABLE inp_inflows_poll ADD CONSTRAINT inp_inflows_pol_x_node_poll_id_fkey FOREIGN KEY (poll_id)
REFERENCES inp_pollutant (poll_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
	
ALTER TABLE inp_inflows_poll DROP CONSTRAINT inp_inflows_pol_x_node_timser_id_fkey;
ALTER TABLE inp_inflows_poll ADD CONSTRAINT inp_inflows_pol_x_node_timser_id_fkey FOREIGN KEY (timser_id)
REFERENCES inp_timeseries (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;	

ALTER TABLE inp_loadings DROP CONSTRAINT inp_loadings_pol_x_subc_subc_id_fkey;
ALTER TABLE inp_loadings ADD CONSTRAINT inp_loadings_pol_x_subc_subc_id_fkey FOREIGN KEY (subc_id, hydrology_id)
REFERENCES inp_subcatchment (subc_id, hydrology_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_pattern_value DROP CONSTRAINT inp_pattern_pattern_id_fkey;
ALTER TABLE inp_pattern_value ADD CONSTRAINT inp_pattern_pattern_id_fkey FOREIGN KEY (pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE inp_outfall DROP CONSTRAINT inp_outfall_curve_id_fkey;
ALTER TABLE inp_outfall ADD CONSTRAINT inp_outfall_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_outfall DROP CONSTRAINT inp_outfall_timser_id_fkey;
ALTER TABLE inp_outfall ADD CONSTRAINT inp_outfall_timser_id_fkey FOREIGN KEY (timser_id)
REFERENCES inp_timeseries (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_outlet DROP CONSTRAINT inp_outlet_curve_id_fkey;
ALTER TABLE inp_outlet ADD CONSTRAINT inp_outlet_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_pump DROP CONSTRAINT inp_pump_curve_id_fkey;
ALTER TABLE inp_pump ADD CONSTRAINT inp_pump_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_storage DROP CONSTRAINT inp_storage_curve_id_fkey;
ALTER TABLE inp_storage ADD CONSTRAINT inp_storage_curve_id_fkey FOREIGN KEY (curve_id)
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_treatment DROP CONSTRAINT inp_treatment_node_x_pol_poll_id_fkey;
ALTER TABLE inp_treatment ADD CONSTRAINT inp_treatment_node_x_pol_poll_id_fkey FOREIGN KEY (poll_id)
REFERENCES inp_pollutant (poll_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_washoff DROP CONSTRAINT inp_washoff_land_x_pol_landus_id_fkey;
ALTER TABLE inp_washoff ADD CONSTRAINT inp_washoff_land_x_pol_landus_id_fkey FOREIGN KEY (landus_id)
REFERENCES inp_landuses (landus_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_washoff DROP CONSTRAINT inp_washoff_land_x_pol_poll_id_fkey;
ALTER TABLE inp_washoff ADD CONSTRAINT inp_washoff_land_x_pol_poll_id_fkey FOREIGN KEY (poll_id)
REFERENCES inp_pollutant (poll_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_coverage DROP CONSTRAINT inp_coverage_land_x_subc_subc_id_fkey;
ALTER TABLE inp_coverage ADD CONSTRAINT inp_coverage_land_x_subc_subc_id_fkey FOREIGN KEY (subc_id, hydrology_id)
REFERENCES inp_subcatchment (subc_id, hydrology_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

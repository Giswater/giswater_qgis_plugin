/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


DROP VIEW v_om_visit;
CREATE OR REPLACE VIEW v_om_visit AS 
 SELECT DISTINCT ON (a.visit_id) a.visit_id,
    a.code,
    a.visitcat_id,
    a.name,
    a.visit_start,
    a.visit_end,
    a.user_name,
    a.is_done,
    a.feature_id,
    a.feature_type,
    a.the_geom::geometry(POINT, SRID_VALUE)
   FROM ( SELECT om_visit.id AS visit_id,
            om_visit.ext_code AS code,
            om_visit.visitcat_id,
            om_visit_cat.name,
            om_visit.startdate AS visit_start,
            om_visit.enddate AS visit_end,
            om_visit.user_name,
            om_visit.is_done,
            om_visit_x_node.node_id AS feature_id,
            'NODE'::text AS feature_type,
                CASE
                    WHEN om_visit.the_geom IS NULL THEN node.the_geom
                    ELSE om_visit.the_geom
                END AS the_geom
           FROM selector_state, om_visit
             JOIN om_visit_x_node ON om_visit_x_node.visit_id = om_visit.id
             JOIN node ON node.node_id::text = om_visit_x_node.node_id::text
             JOIN om_visit_cat ON om_visit.visitcat_id = om_visit_cat.id
          WHERE selector_state.state_id = node.state AND selector_state.cur_user = "current_user"()::text
        UNION
         SELECT om_visit.id AS visit_id,
            om_visit.ext_code AS code,
            om_visit.visitcat_id,
            om_visit_cat.name,
            om_visit.startdate AS visit_start,
            om_visit.enddate AS visit_end,
            om_visit.user_name,
            om_visit.is_done,
            om_visit_x_arc.arc_id AS feature_id,
            'ARC'::text AS feature_type,
                CASE
                    WHEN om_visit.the_geom IS NULL THEN st_lineinterpolatepoint(arc.the_geom, 0.5::double precision)
                    ELSE om_visit.the_geom
                END AS the_geom
           FROM selector_state, om_visit
             JOIN om_visit_x_arc ON om_visit_x_arc.visit_id = om_visit.id
             JOIN arc ON arc.arc_id::text = om_visit_x_arc.arc_id::text
             JOIN om_visit_cat ON om_visit.visitcat_id = om_visit_cat.id
          WHERE selector_state.state_id = arc.state AND selector_state.cur_user = "current_user"()::text
        UNION
         SELECT om_visit.id AS visit_id,
            om_visit.ext_code AS code,
            om_visit.visitcat_id,
            om_visit_cat.name,
            om_visit.startdate AS visit_start,
            om_visit.enddate AS visit_end,
            om_visit.user_name,
            om_visit.is_done,
            om_visit_x_connec.connec_id AS feature_id,
            'CONNEC'::text AS feature_type,
                CASE
                    WHEN om_visit.the_geom IS NULL THEN connec.the_geom
                    ELSE om_visit.the_geom
                END AS the_geom
           FROM selector_state, om_visit
             JOIN om_visit_x_connec ON om_visit_x_connec.visit_id = om_visit.id
             JOIN connec ON connec.connec_id::text = om_visit_x_connec.connec_id::text
             JOIN om_visit_cat ON om_visit.visitcat_id = om_visit_cat.id
          WHERE selector_state.state_id = connec.state AND selector_state.cur_user = "current_user"()::text
        UNION
         SELECT om_visit.id AS visit_id,
            om_visit.ext_code AS code,
            om_visit.visitcat_id,
            om_visit_cat.name,
            om_visit.startdate AS visit_start,
            om_visit.enddate AS visit_end,
            om_visit.user_name,
            om_visit.is_done,
            om_visit_x_gully.gully_id AS feature_id,
            'GULLY'::text AS feature_type,
                CASE
                    WHEN om_visit.the_geom IS NULL THEN gully.the_geom
                    ELSE om_visit.the_geom
                END AS the_geom
           FROM selector_state, om_visit
             JOIN om_visit_x_gully ON om_visit_x_gully.visit_id = om_visit.id
             JOIN gully ON gully.gully_id::text = om_visit_x_gully.gully_id::text
             JOIN om_visit_cat ON om_visit.visitcat_id = om_visit_cat.id
          WHERE selector_state.state_id = gully.state AND selector_state.cur_user = "current_user"()::text) a;

INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) VALUES('edit_mapzones_set_lastupdate', 'false', 'If true, value of lastupdate is updated on node, arc, connec features and set to the date of executing the algorithm.', 'Set lastupdate on mapzone process', NULL, NULL, false, NULL, 'ws', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


update config_form_fields set hidden=true where columnname in ('geom3', 'geom4') and formname like '%orifice%';


UPDATE config_form_fields SET widgetcontrols = (replace(widgetcontrols::text,'"nullValue":false', '"nullValue":true'))::json 
where formname = 'cat_node' and columnname = 'node_type';
UPDATE config_form_fields SET widgetcontrols = (replace(widgetcontrols::text,'"nullValue":false', '"nullValue":true'))::json 
where formname = 'cat_arc' and columnname = 'arc_type';
UPDATE config_form_fields SET widgetcontrols = (replace(widgetcontrols::text,'"nullValue":false', '"nullValue":true'))::json 
where formname = 'cat_connec' and columnname = 'connec_type';
UPDATE config_form_fields SET widgetcontrols = (replace(widgetcontrols::text,'"nullValue":false', '"nullValue":true'))::json 
where formname = 'cat_grate' and columnname = 'gully_type';

UPDATE config_form_fields SET widgetcontrols = (replace(widgetcontrols::text,'"filterExpression": null', '"filterExpression":"active=true"'))::json 
where formname = 'cat_node' and columnname = 'node_type';
UPDATE config_form_fields SET widgetcontrols = (replace(widgetcontrols::text,'"filterExpression": null', '"filterExpression":"active=true"'))::json 
where formname = 'cat_arc' and columnname = 'arc_type';
UPDATE config_form_fields SET widgetcontrols = (replace(widgetcontrols::text,'"filterExpression": null', '"filterExpression":"active=true"'))::json 
where formname = 'cat_connec' and columnname = 'connec_type';
UPDATE config_form_fields SET widgetcontrols = (replace(widgetcontrols::text,'"filterExpression": null', '"filterExpression":"active=true"'))::json 
where formname = 'cat_grate' and columnname = 'gully_type';


UPDATE config_toolbox set inputparams = 
'[
{"widgetname":"idval", "label":"Name: (*)","widgettype":"linetext","datatype":"text", "isMandatory":true, "tooltip":"Name for dwf scenario (mandatory)", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":1, "value":""},
{"widgetname":"startdate", "label":"Startdate:","widgettype":"datetime","datatype":"date", "isMandatory":false, "tooltip":"Start date for dwf scenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":2, "value":""},
{"widgetname":"enddate", "label":"Enddate:","widgettype":"datetime","datatype":"date", "isMandatory":false, "tooltip":"End date", "placeholder":"End date for dwf scenario", "layoutname":"grl_option_parameters","layoutorder":3, "value":""},
{"widgetname":"observ", "label":"Observ:","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Observations of dwf scenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":4, "value":""},
{"widgetname":"expl", "label":"Exploitation:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"dwf scenario type", "dvQueryText":"SELECT expl_id AS id, name as idval FROM v_edit_exploitation", "layoutname":"grl_option_parameters","layoutorder":5, "value":""},
{"widgetname":"active", "label":"Active:", "widgettype":"check", "datatype":"boolean", "tooltip":"If true, active" , "layoutname":"grl_option_parameters","layoutorder":6, "value":"true"}
]'
where id = 3292;

DROP TRIGGER gw_trg_link_data ON connec;
CREATE TRIGGER gw_trg_link_data
AFTER UPDATE OF state_type, expl_id2, connecat_id
ON connec FOR EACH ROW  EXECUTE PROCEDURE gw_trg_link_data('connec');

DROP TRIGGER gw_trg_link_data ON gully;
CREATE TRIGGER gw_trg_link_data
AFTER UPDATE OF epa_type, state_type, expl_id2, connec_arccat_id
ON gully  FOR EACH ROW  EXECUTE PROCEDURE gw_trg_link_data('gully');

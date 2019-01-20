/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

/* Instructions to fill this file for developers
- Use CREATE OR REPLACE
- DROP CASCADE IS FORBIDDEN
- Only use DROP when view:
	- is not customizable view (ie ve_node_* or ve_arc_*)
	- has not other views over
	- has not trigger
*/

DROP VIEW IF EXISTS v_om_visit;
CREATE OR REPLACE VIEW v_om_visit AS 
 SELECT om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit_cat.name,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    om_visit_x_node.node_id AS feature_id,
    'NODE'::text as feature_type,
    om_visit.the_geom
   FROM selector_state,
    om_visit
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
    'ARC'::text as feature_type,
    om_visit.the_geom
   FROM selector_state,
    om_visit
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
    'CONNEC'::text as feature_type,
    om_visit.the_geom
   FROM selector_state,
    om_visit
     JOIN om_visit_x_connec ON om_visit_x_connec.visit_id = om_visit.id
     JOIN connec ON connec.connec_id::text = om_visit_x_connec.connec_id::text
     JOIN om_visit_cat ON om_visit.visitcat_id = om_visit_cat.id
  WHERE selector_state.state_id = connec.state AND selector_state.cur_user = "current_user"()::text;




CREATE OR REPLACE VIEW SCHEMA_NAME.v_arc_dattrib AS 
 SELECT arc_id,
	dattrib1 AS dminsector,
	dattrib2 AS dpipehazard,
	dattrib3 AS dinlet
	FROM SCHEMA_NAME.v_edit_arc
     LEFT JOIN ( SELECT rpt.feature_id,
            rpt.dattrib1,
            rpt.dattrib2,
            rpt.dattrib3
            FROM crosstab('SELECT feature_id, dattrib_type, idval FROM SCHEMA_NAME.dattrib ORDER BY 1,2'::text, 'VALUES (''1''), (''2''), (''3'')'::text) 
		rpt(feature_id character varying, dattrib1 text, dattrib2 text, dattrib3 text)) a ON arc_id = feature_id;
		
CREATE OR REPLACE VIEW SCHEMA_NAME.v_node_dattrib AS 
 SELECT node_id,
	dattrib4 AS dstaticpress
	FROM SCHEMA_NAME.v_edit_node
     LEFT JOIN ( SELECT rpt.feature_id,
            rpt.dattrib4
            FROM crosstab('SELECT feature_id, dattrib_type, idval FROM SCHEMA_NAME.dattrib ORDER BY 1,2'::text, 'VALUES (''4'')'::text) 
		rpt(feature_id character varying, dattrib4 text)) a ON node_id = feature_id;


CREATE OR REPLACE VIEW SCHEMA_NAME.v_connec_dattrib AS 
 SELECT connec_id,
	dattrib4 AS dstaticpress
	FROM SCHEMA_NAME.v_edit_connec
     LEFT JOIN ( SELECT rpt.feature_id,
            rpt.dattrib4
            FROM crosstab('SELECT feature_id, dattrib_type, idval FROM SCHEMA_NAME.dattrib ORDER BY 1,2'::text, 'VALUES (''4'')'::text) 
		rpt(feature_id character varying, dattrib4 text)) a ON connec_id = feature_id;


DROP VIEW IF EXISTS "v_inp_pattern";
CREATE VIEW "v_inp_pattern" AS
SELECT id,
pattern_id,
factor_1,
factor_2,
factor_3,
factor_4,
factor_5,
factor_6,
factor_7,
factor_8,
factor_9,
factor_10,
factor_11,
factor_12,
factor_13,
factor_14,
factor_15,
factor_16,
factor_17,
factor_18
FROM inp_pattern_value;



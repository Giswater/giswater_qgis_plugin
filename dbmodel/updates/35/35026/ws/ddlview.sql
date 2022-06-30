/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/06/07
DROP VIEW IF EXISTS v_om_mincut_node;
CREATE OR REPLACE VIEW v_om_mincut_node AS 
 SELECT om_mincut_node.id,
    om_mincut_node.result_id,
    om_mincut.work_order,
    om_mincut_node.node_id,
    node_type,
    om_mincut_node.the_geom
   FROM selector_mincut_result,om_mincut_node
     JOIN om_mincut ON om_mincut_node.result_id = om_mincut.id
  WHERE selector_mincut_result.result_id::text = om_mincut_node.result_id::text AND selector_mincut_result.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_om_mincut_arc AS 
 SELECT om_mincut_arc.id,
    om_mincut_arc.result_id,
    om_mincut.work_order,
    om_mincut_arc.arc_id,
    om_mincut_arc.the_geom
   FROM selector_mincut_result,
    om_mincut_arc
     JOIN om_mincut ON om_mincut_arc.result_id = om_mincut.id
  WHERE selector_mincut_result.result_id::text = om_mincut_arc.result_id::text AND selector_mincut_result.cur_user = "current_user"()::text
  ORDER BY om_mincut_arc.arc_id;
  
CREATE OR REPLACE VIEW v_om_mincut_connec AS 
SELECT om_mincut_connec.id,
    om_mincut_connec.result_id,
    om_mincut.work_order,
    om_mincut_connec.connec_id,
    om_mincut_connec.customer_code,
    om_mincut_connec.the_geom
   FROM selector_mincut_result,
    om_mincut_connec     
     JOIN om_mincut ON om_mincut_connec.result_id = om_mincut.id
  WHERE selector_mincut_result.result_id::text = om_mincut_connec.result_id::text AND selector_mincut_result.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW vi_rules AS 
 SELECT c.text
           FROM ( SELECT inp_rules.id,
                    inp_rules.text
                   FROM selector_sector,
                    inp_rules
                  WHERE selector_sector.sector_id = inp_rules.sector_id AND selector_sector.cur_user = "current_user"()::text AND inp_rules.active IS NOT FALSE
                  UNION
                  SELECT id,
                    text
                   FROM selector_sector s,
                    v_edit_inp_dscenario_rules d
                  WHERE s.sector_id = d.sector_id AND s.cur_user = "current_user"()::text AND d.active IS NOT FALSE
                  ORDER BY 1)c
  ORDER BY c.id;


DROP VIEW v_edit_inp_dscenario_demand;
CREATE OR REPLACE VIEW v_edit_inp_dscenario_demand AS 
 SELECT 
 inp_dscenario_demand.id,
 inp_dscenario_demand.dscenario_id,
    inp_dscenario_demand.feature_id,
    inp_dscenario_demand.feature_type,
    inp_dscenario_demand.demand,
    inp_dscenario_demand.pattern_id,
    inp_dscenario_demand.demand_type,
    inp_dscenario_demand.source,
    v_node.the_geom
   FROM selector_sector,
    selector_inp_dscenario,
    inp_dscenario_demand
     JOIN v_node ON v_node.node_id::text = inp_dscenario_demand.feature_id::text
  WHERE v_node.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND inp_dscenario_demand.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text
UNION
 SELECT 
 inp_dscenario_demand.id,
 inp_dscenario_demand.dscenario_id,
    inp_dscenario_demand.feature_id,
    inp_dscenario_demand.feature_type,
    inp_dscenario_demand.demand,
    inp_dscenario_demand.pattern_id,
    inp_dscenario_demand.demand_type,
    inp_dscenario_demand.source,
    v_connec.the_geom
   FROM selector_sector,
    selector_inp_dscenario,
    inp_dscenario_demand
     JOIN v_connec ON v_connec.connec_id::text = inp_dscenario_demand.feature_id::text
  WHERE v_connec.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text AND inp_dscenario_demand.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW v_edit_inp_dscenario_pump_additional AS 
 SELECT d.dscenario_id,
    p.node_id,
    p.order_id,
    p.power,
    p.curve_id,
    p.speed,
    p.pattern,
    p.status,
    the_geom
   FROM selector_inp_dscenario,
    v_edit_inp_pump
     JOIN inp_dscenario_pump_additional p USING (node_id)
     JOIN cat_dscenario d USING (dscenario_id)
  WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;
  
  
CREATE OR REPLACE VIEW vi_curves AS 
SELECT
        CASE
            WHEN a.x_value IS NULL THEN a.curve_type::character varying(16)
            ELSE a.curve_id
        END AS curve_id,
    a.x_value::numeric(12,4) AS x_value,
    a.y_value::numeric(12,4) AS y_value,
    NULL::text AS other
   FROM ( SELECT row_number() over (order by id)  as rid, * 
          FROM (SELECT DISTINCT ON (inp_curve_value.curve_id) ( SELECT min(sub.id) AS min
                   FROM inp_curve_value sub
                  WHERE sub.curve_id::text = inp_curve_value.curve_id::text) AS id,
            inp_curve_value.curve_id,
            concat(';', inp_curve.curve_type, ':', inp_curve.descript) AS curve_type,
            NULL::numeric AS x_value,
            NULL::numeric AS y_value
           FROM inp_curve
             JOIN inp_curve_value ON inp_curve_value.curve_id::text = inp_curve.id::text
        UNION
         SELECT inp_curve_value.id,
            inp_curve_value.curve_id,
            inp_curve.curve_type,
            inp_curve_value.x_value,
            inp_curve_value.y_value
           FROM inp_curve_value
             JOIN inp_curve ON inp_curve_value.curve_id::text = inp_curve.id::text
  ORDER BY 1, 4 DESC)a) a
  WHERE (a.curve_id::text IN ( SELECT temp_node.addparam::json ->> 'curve_id'::text
           FROM temp_node
        UNION
         SELECT temp_arc.addparam::json ->> 'curve_id'::text
           FROM temp_arc))
  ORDER BY a.rid, NULL::text;



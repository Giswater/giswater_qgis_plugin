/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--16/11/2019

CREATE OR REPLACE VIEW v_edit_inp_pump AS 
 SELECT DISTINCT ON (node_id) v_node.node_id,
    v_node.elevation,
    v_node.depth,
    v_node.nodecat_id,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.annotation,
    v_node.the_geom,
    inp_pump.power,
    inp_pump.curve_id,
    inp_pump.speed,
    inp_pump.pattern,
    inp_pump.to_arc,
    inp_pump.status,
    inp_pump.pump_type
   FROM inp_selector_sector, v_node
     JOIN inp_pump USING (node_id)
     JOIN vi_parent_arc a ON (a.node_1=v_node.node_id OR a.node_2=v_node.node_id)
     WHERE a.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW vi_pipes AS 
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.length,
    rpt_inp_arc.diameter,
    rpt_inp_arc.roughness,
        CASE
            WHEN rpt_inp_arc.minorloss IS NULL THEN 0::numeric(12,6)
            ELSE rpt_inp_arc.minorloss
        END AS minorloss,
    inp_typevalue.idval AS status
   FROM inp_selector_result,
    rpt_inp_arc
     LEFT JOIN inp_typevalue ON inp_typevalue.id::text = rpt_inp_arc.status::text
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text AND inp_typevalue.typevalue::text = 'inp_value_status_pipe'::text 
  AND (rpt_inp_arc.epa_type::text = 'SHORTPIPE'::text OR rpt_inp_arc.epa_type::text = 'PIPE'::text)
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.length,
    rpt_inp_arc.diameter,
    rpt_inp_arc.roughness,
        CASE
            WHEN inp_shortpipe.minorloss IS NULL THEN 0::numeric(12,6)
            ELSE inp_shortpipe.minorloss
        END AS minorloss,
    inp_typevalue.idval AS status
   FROM inp_selector_result,
    rpt_inp_arc
     JOIN inp_shortpipe ON rpt_inp_arc.arc_id::text = concat(inp_shortpipe.node_id, '_n2a')
     LEFT JOIN inp_typevalue ON inp_typevalue.id::text = inp_shortpipe.status::text
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text AND inp_typevalue.typevalue::text = 'inp_value_status_pipe'::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.length,
    rpt_inp_arc.diameter,
    rpt_inp_arc.roughness,
    rpt_inp_arc.minorloss,
    rpt_inp_arc.status::varchar(30)
   FROM inp_selector_result, rpt_inp_arc
  WHERE rpt_inp_arc.arc_type='NODE2NODE' AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;

  
  
CREATE OR REPLACE VIEW vi_tanks AS 
 SELECT inp_tank.node_id,
    rpt_inp_node.elevation,
    inp_tank.initlevel,
    inp_tank.minlevel,
    inp_tank.maxlevel,
    inp_tank.diameter,
    inp_tank.minvol,
    inp_tank.curve_id
   FROM inp_selector_result,
    inp_tank
     JOIN rpt_inp_node ON inp_tank.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND rpt_inp_node.epa_type='TANK' AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT inp_inlet.node_id,
    rpt_inp_node.elevation,
    inp_inlet.initlevel,
    inp_inlet.minlevel,
    inp_inlet.maxlevel,
    inp_inlet.diameter,
    inp_inlet.minvol,
    inp_inlet.curve_id
   FROM inp_selector_result,
    inp_inlet
     LEFT JOIN ( SELECT a.node_id,
            count(*) AS ct
           FROM ( SELECT rpt_inp_arc.node_1 AS node_id
                   FROM rpt_inp_arc,
                    inp_selector_result inp_selector_result_1
                  WHERE rpt_inp_arc.result_id::text = inp_selector_result_1.result_id::text AND inp_selector_result_1.cur_user = "current_user"()::text
                UNION ALL
                 SELECT rpt_inp_arc.node_2
                   FROM rpt_inp_arc,
                    inp_selector_result inp_selector_result_1
                  WHERE rpt_inp_arc.result_id::text = inp_selector_result_1.result_id::text AND inp_selector_result_1.cur_user = "current_user"()::text) a
          GROUP BY a.node_id) b USING (node_id)
     JOIN rpt_inp_node ON inp_inlet.node_id::text = rpt_inp_node.node_id::text
  WHERE b.ct > 1;


CREATE OR REPLACE VIEW vi_reservoirs AS 
 SELECT inp_reservoir.node_id,
    rpt_inp_node.elevation AS head,
    inp_reservoir.pattern_id
   FROM inp_selector_result,
    inp_reservoir
     JOIN rpt_inp_node ON inp_reservoir.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT inp_inlet.node_id,
    rpt_inp_node.elevation AS head,
    inp_inlet.pattern_id
   FROM inp_selector_result,
    inp_inlet
     LEFT JOIN ( SELECT a.node_id,
            count(*) AS ct
           FROM ( SELECT rpt_inp_arc.node_1 AS node_id
                   FROM rpt_inp_arc,
                    inp_selector_result inp_selector_result_1
                  WHERE rpt_inp_arc.result_id::text = inp_selector_result_1.result_id::text AND inp_selector_result_1.cur_user = "current_user"()::text
                UNION ALL
                 SELECT rpt_inp_arc.node_2
                   FROM rpt_inp_arc,
                    inp_selector_result inp_selector_result_1
                  WHERE rpt_inp_arc.result_id::text = inp_selector_result_1.result_id::text AND inp_selector_result_1.cur_user = "current_user"()::text) a
          GROUP BY a.node_id) b USING (node_id)
     JOIN rpt_inp_node ON inp_inlet.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text AND b.ct = 1
UNION
SELECT node_id,
     elevation,
    pattern_id
   FROM inp_selector_result, rpt_inp_node
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
  AND node_type='VIRT-RESERVOIR';



CREATE OR REPLACE VIEW vi_status AS 
 SELECT rpt_inp_arc.arc_id,
    inp_typevalue.idval
   FROM inp_selector_result, rpt_inp_arc
     JOIN inp_valve ON rpt_inp_arc.arc_id::text = concat(inp_valve.node_id, '_n2a')
     JOIN inp_typevalue ON inp_typevalue.id::text = rpt_inp_arc.status::text
  WHERE rpt_inp_arc.status::text = 'CLOSED'::text OR rpt_inp_arc.status::text = 'OPEN'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    inp_typevalue.idval
   FROM inp_selector_result, rpt_inp_arc
     JOIN inp_pump ON rpt_inp_arc.arc_id::text = concat(inp_pump.node_id, '_n2a')
     JOIN inp_typevalue ON inp_typevalue.id::text = rpt_inp_arc.status::text
  WHERE rpt_inp_arc.status::text = 'CLOSED'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    inp_typevalue.idval
   FROM inp_selector_result, rpt_inp_arc
     JOIN inp_pump_additional ON rpt_inp_arc.arc_id::text = concat(inp_pump_additional.node_id, '_n2a', inp_pump_additional.order_id)
     LEFT JOIN inp_typevalue ON inp_typevalue.id::text = rpt_inp_arc.status::text
  WHERE inp_pump_additional.status::text = 'CLOSED'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;
  
  
 
CREATE OR REPLACE VIEW vi_tanks AS 
 SELECT inp_tank.node_id,
    rpt_inp_node.elevation,
    inp_tank.initlevel,
    inp_tank.minlevel,
    inp_tank.maxlevel,
    inp_tank.diameter,
    inp_tank.minvol,
    inp_tank.curve_id
   FROM inp_selector_result,
    inp_tank
     JOIN rpt_inp_node ON inp_tank.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND rpt_inp_node.epa_type::text = 'TANK'::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT inp_inlet.node_id,
    rpt_inp_node.elevation,
    inp_inlet.initlevel,
    inp_inlet.minlevel,
    inp_inlet.maxlevel,
    inp_inlet.diameter,
    inp_inlet.minvol,
    inp_inlet.curve_id
   FROM inp_selector_result,
    inp_inlet
     LEFT JOIN ( SELECT a.node_id,
            count(*) AS ct
           FROM ( SELECT rpt_inp_arc.node_1 AS node_id
                   FROM rpt_inp_arc,
                    inp_selector_result inp_selector_result_1
                  WHERE rpt_inp_arc.result_id::text = inp_selector_result_1.result_id::text AND inp_selector_result_1.cur_user = "current_user"()::text
                UNION ALL
                 SELECT rpt_inp_arc.node_2
                   FROM rpt_inp_arc,
                    inp_selector_result inp_selector_result_1
                  WHERE rpt_inp_arc.result_id::text = inp_selector_result_1.result_id::text AND inp_selector_result_1.cur_user = "current_user"()::text) a
          GROUP BY a.node_id) b USING (node_id)
     JOIN rpt_inp_node ON inp_inlet.node_id::text = rpt_inp_node.node_id::text
  WHERE b.ct > 1 AND rpt_inp_node.epa_type::text = 'TANK'::text;

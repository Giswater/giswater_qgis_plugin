
/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;


CREATE OR REPLACE VIEW vi_controls AS 
 SELECT c.text
   FROM ( SELECT a.id,
            a.text
           FROM ( SELECT inp_controls_x_arc.id,
                    inp_controls_x_arc.text
                   FROM inp_selector_result,
                    inp_controls_x_arc
                     JOIN rpt_inp_arc ON inp_controls_x_arc.arc_id::text = rpt_inp_arc.arc_id::text
                  WHERE inp_selector_result.result_id::text = rpt_inp_arc.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
                  ORDER BY inp_controls_x_arc.id) a) c
  ORDER BY c.id;


CREATE OR REPLACE VIEW vi_rules AS 
 SELECT c.text
   FROM ( SELECT a.id,
            a.text
           FROM ( SELECT inp_rules_x_arc.id,
                    inp_rules_x_arc.text
                   FROM inp_selector_result,
                    inp_rules_x_arc
                     JOIN rpt_inp_arc ON inp_rules_x_arc.arc_id::text = rpt_inp_arc.arc_id::text
                  WHERE inp_selector_result.result_id::text = rpt_inp_arc.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
                  ORDER BY inp_rules_x_arc.id) a
        UNION
         SELECT b.id,
            b.text
           FROM ( SELECT inp_rules_x_node.id + 1000000 AS id,
                    inp_rules_x_node.text
                   FROM inp_selector_result,
                    inp_rules_x_node
                     JOIN rpt_inp_node ON inp_rules_x_node.node_id::text = rpt_inp_node.node_id::text
                  WHERE inp_selector_result.result_id::text = rpt_inp_node.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
                  ORDER BY inp_rules_x_node.id) b
         UNION
         SELECT d.id,
            d.text
           FROM ( SELECT inp_rules_x_sector.id + 2000000 AS id,
                    inp_rules_x_sector.text
                   FROM inp_selector_sector,
                    inp_rules_x_sector
                    WHERE inp_selector_sector.sector_id = inp_rules_x_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text
                  ORDER BY inp_rules_x_sector.id) d) c
  ORDER BY c.id;


DROP VIEW vi_energy;
CREATE OR REPLACE VIEW vi_energy AS 
 SELECT concat ('PUMP ',arc_id) as pump_id,
	inp_typevalue.idval,
	inp_pump.energyvalue
	FROM inp_selector_result, inp_pump
	JOIN rpt_inp_arc ON concat(inp_pump.node_id,'_n2a') = rpt_inp_arc.arc_id::text
	LEFT JOIN inp_typevalue ON inp_pump.energyparam::text = inp_typevalue.id::text AND inp_typevalue.typevalue::text = 'inp_value_param_energy'::text
	WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
	SELECT concat ('PUMP ',arc_id) as pump_id,
	inp_pump.energyparam,
	inp_pump.energyvalue
	FROM inp_selector_result, inp_pump
	JOIN rpt_inp_arc ON concat(inp_pump.node_id,'_n2a') = rpt_inp_arc.arc_id::text
	WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT descript, null as value,  null as value2  FROM inp_energy;


DROP VIEW vi_reactions;
CREATE OR REPLACE VIEW vi_reactions AS 
 SELECT inp_typevalue.idval,
	inp_pipe.arc_id,
	inp_pipe.reactionvalue
	FROM inp_selector_result, inp_pipe
	JOIN rpt_inp_arc ON inp_pipe.arc_id::text = rpt_inp_arc.arc_id::text
	LEFT JOIN inp_typevalue ON inp_pipe.reactionparam::text = inp_typevalue.id::text AND inp_typevalue.typevalue::text = 'inp_value_reactions'::text
	WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT descript, null as value, null as value2
   FROM inp_reactions;
   
   
   DROP VIEW vi_patterns;
CREATE OR REPLACE VIEW vi_patterns AS 
 SELECT inp_pattern_value.pattern_id,
    inp_pattern_value.factor_1,
    inp_pattern_value.factor_2,
    inp_pattern_value.factor_3,
    inp_pattern_value.factor_4,
    inp_pattern_value.factor_5,
    inp_pattern_value.factor_6,
    inp_pattern_value.factor_7,
    inp_pattern_value.factor_8,
    inp_pattern_value.factor_9,
    inp_pattern_value.factor_10,
    inp_pattern_value.factor_11,
    inp_pattern_value.factor_12,
    inp_pattern_value.factor_13,
    inp_pattern_value.factor_14,
    inp_pattern_value.factor_15,
    inp_pattern_value.factor_16,
    inp_pattern_value.factor_17,
    inp_pattern_value.factor_18
   FROM inp_pattern_value
  ORDER BY inp_pattern_value.id;
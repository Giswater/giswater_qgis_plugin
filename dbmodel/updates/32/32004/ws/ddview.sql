
/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- not used view
DROP VIEW  vi_title;

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
 SELECT inp_pipe.reactiontype,
	inp_typevalue.idval,
	inp_pipe.reactionvalue
	FROM inp_selector_result, inp_pipe
	JOIN rpt_inp_arc ON inp_pipe.arc_id::text = rpt_inp_arc.arc_id::text
	LEFT JOIN inp_typevalue ON inp_pipe.reactionparam::text = inp_typevalue.id::text AND inp_typevalue.typevalue::text = 'inp_value_reactions_el'::text
	WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT descript, null as value, null as value2
   FROM inp_reactions;
/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


DROP VIEW IF EXISTS v_anl_mincut_flowtrace;

CREATE OR REPLACE VIEW v_anl_graf AS 
 SELECT anl_graf.arc_id,
    anl_graf.node_1,
    anl_graf.node_2,
    anl_graf.flag,
    a.flag AS flagi,
    a.value
   FROM temp_anlgraf anl_graf
     JOIN ( SELECT anl_graf_1.arc_id,
            anl_graf_1.node_1,
            anl_graf_1.node_2,
            anl_graf_1.water,
            anl_graf_1.flag,
            anl_graf_1.checkf,
            anl_graf_1.value
           FROM temp_anlgraf anl_graf_1
          WHERE anl_graf_1.water = 1) a ON anl_graf.node_1 = a.node_2
  WHERE anl_graf.flag < 2 AND anl_graf.water = 0 AND a.flag < 2;
  
  
CREATE OR REPLACE VIEW vi_patterns AS 
SELECT a.pattern_id,a.factor_1,a.factor_2,a.factor_3,a.factor_4,a.factor_5,a.factor_6,a.factor_7, a.factor_8, a.factor_9, 
a.factor_10, a.factor_11, a.factor_12, a.factor_13, a.factor_14, a.factor_15, a.factor_16, a.factor_17, a.factor_18
FROM 
	(SELECT distinct on (a.id) a.id AS idrow, a.pattern_id,a.factor_1,a.factor_2,a.factor_3,a.factor_4,a.factor_5,
	a.factor_6,a.factor_7, a.factor_8, a.factor_9, a.factor_10, a.factor_11, a.factor_12, a.factor_13, a.factor_14, 
	a.factor_15, a.factor_16, a.factor_17, a.factor_18
	FROM inp_pattern_value a, rpt_inp_node n
	WHERE a.pattern_id = n.pattern_id 
	AND n.result_id = (SELECT result_id FROM inp_selector_result WHERE cur_user = current_user)
	UNION
	SELECT distinct on (a.id) a.id, a.pattern_id, a.factor_1,a.factor_2,a.factor_3,a.factor_4,a.factor_5,a.factor_6,
	a.factor_7, a.factor_8, a.factor_9, a.factor_10, a.factor_11, a.factor_12, a.factor_13, a.factor_14, a.factor_15, 
	a.factor_16, a.factor_17, a.factor_18
	FROM rpt_inp_pattern_value a, rpt_inp_node n
	WHERE a.pattern_id = n.pattern_id 
	AND n.result_id = (SELECT result_id FROM inp_selector_result WHERE cur_user = current_user))a
	ORDER BY idrow;

 

  
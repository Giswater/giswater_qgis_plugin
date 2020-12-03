/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


DROP VIEW vi_curves;
CREATE OR REPLACE VIEW vi_curves AS 
 SELECT
        CASE
            WHEN a.x_value IS NULL THEN a.curve_type::character varying(16)
            ELSE a.curve_id
        END AS curve_id,
    a.x_value::numeric(12,4) AS x_value,
    a.y_value::numeric(12,4) AS y_value,
    NULL::text AS other
FROM ( SELECT DISTINCT ON (inp_curve.curve_id) ( SELECT min(sub.id) AS min
                   FROM inp_curve sub
                  WHERE sub.curve_id::text = inp_curve.curve_id::text) AS id,
            inp_curve.curve_id,
            concat(';', inp_curve_id.curve_type, ':', inp_curve_id.descript) AS curve_type,
            NULL::numeric AS x_value,
            NULL::numeric AS y_value
           FROM inp_curve_id
             JOIN inp_curve ON inp_curve.curve_id::text = inp_curve_id.id::text
	UNION
         SELECT inp_curve.id,
            inp_curve.curve_id,
            inp_curve_id.curve_type,
            inp_curve.x_value,
            inp_curve.y_value
           FROM inp_curve
             JOIN inp_curve_id ON inp_curve.curve_id::text = inp_curve_id.id::text
		ORDER BY 1, 4 DESC) a
JOIN ( SELECT inp_pump.node_id,
            inp_pump.curve_id
           FROM inp_pump
		UNION
		SELECT inp_tank.node_id,
            inp_tank.curve_id
           FROM inp_tank) b USING (curve_id)

JOIN (SELECT * FROM (SELECT node_1 AS node_id , arc.sector_id FROM node JOIN arc on node_1=node_id UNION SELECT node_2, arc.sector_id FROM node JOIN arc ON node_2=node_id)c JOIN inp_selector_sector 
USING (sector_id)) d using (node_id);



DROP VIEW if exists vi_patterns;
CREATE OR REPLACE VIEW vi_patterns AS 
SELECT pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18
	FROM (
		SELECT a.id, a.pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, 
		factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18 
		FROM inp_pattern_value a JOIN rpt_inp_node b ON a.pattern_id=b.pattern_id
	UNION
		SELECT a.id, a.pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, 
		factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18 
		FROM inp_pattern_value a JOIN inp_reservoir b ON a.pattern_id=b.pattern_id
	UNION
		SELECT a.id, a.pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, 
		factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18 
		FROM inp_pattern_value a JOIN vi_demands b ON a.pattern_id=b.pattern_id
	UNION   
		SELECT id+1000000, pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, factor_9, 
		factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18
		FROM rpt_inp_pattern_value WHERE result_id= (select result_id from inp_selector_result WHERE cur_user=current_user ) 	
	ORDER BY 1)a

  
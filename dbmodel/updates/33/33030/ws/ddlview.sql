/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE OR REPLACE VIEW vi_reservoirs AS 
 SELECT inp_reservoir.node_id,
    rpt_inp_node.elevation AS head,
    inp_reservoir.pattern_id
   FROM inp_selector_result,
    inp_reservoir
     JOIN rpt_inp_node ON inp_reservoir.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.epa_type = 'RESERVOIR' AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
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
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elevation AS head,
    rpt_inp_node.pattern_id
   FROM inp_selector_result,
    rpt_inp_node
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text AND rpt_inp_node.node_type::text = 'VIRT-RESERVOIR'::text;

drop VIEW IF EXISTS vi_curves;
drop view IF EXISTS vi_tanks;
CREATE OR REPLACE VIEW vi_tanks AS 
 SELECT node_id,
    elevation,
    (childparam->>'initlevel')::numeric(12,4) as initlevel,
    (childparam->>'minlevel')::numeric(12,4) as minlevel,
    (childparam->>'maxlevel')::numeric(12,4) as maxlevel,
    (childparam->>'diameter')::numeric(12,4) as diameter,
    (childparam->>'minvol')::numeric(12,4) as minvol,
    (childparam->>'curve_id') as curve_id
    FROM inp_selector_result,rpt_inp_node
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND rpt_inp_node.epa_type::text = 'TANK'::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT node_id,
    rpt_inp_node.elevation,
    (childparam->>'initlevel')::numeric(12,4) as initlevel,
    (childparam->>'minlevel')::numeric(12,4) as minlevel,
    (childparam->>'maxlevel')::numeric(12,4) as maxlevel,
    (childparam->>'diameter')::numeric(12,4) as diameter,
    (childparam->>'minvol')::numeric(12,4) as minvol,
    (childparam->>'curve_id') as curve_id
   FROM inp_selector_result, rpt_inp_node
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
  WHERE b.ct > 1 AND rpt_inp_node.epa_type::text = 'INLET'::text;


drop VIEW vi_pumps;
CREATE OR REPLACE VIEW vi_pumps AS 
 SELECT arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    ('POWER'::text || ' '::text) || (rpt_inp_arc.childparam->>'power')::text AS power,
    ('HEAD'::text || ' '::text) || (rpt_inp_arc.childparam->>'curve_id')::text AS head,
    ('SPEED'::text || ' '::text) || (rpt_inp_arc.childparam->>'speed')::text AS speed,
    ('PATTERN'::text || ' '::text) || (rpt_inp_arc.childparam->>'pattern')::text AS pattern
   FROM inp_selector_result, rpt_inp_arc
     WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
      AND epa_type = 'PUMP'::text
UNION
 SELECT rpt_inp_arc.arc_id::text AS arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    ('POWER'::text || ' '::text) || inp_pump_additional.power::text AS power,
    ('HEAD'::text || ' '::text) || inp_pump_additional.curve_id::text AS head,
    ('SPEED'::text || ' '::text) || inp_pump_additional.speed AS speed,
    ('PATTERN'::text || ' '::text) || inp_pump_additional.pattern::text AS pattern
   FROM inp_selector_result,  inp_pump_additional
     JOIN rpt_inp_arc ON rpt_inp_arc.flw_code::text = concat(inp_pump_additional.node_id, '_n2a')
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


drop VIEW vi_valves;
CREATE OR REPLACE VIEW vi_valves AS 
 SELECT rpt_inp_arc.arc_id::text,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    (childparam->>'valv_type')::character varying(18) as valv_type,
    childparam->>'pressure' AS setting,
    rpt_inp_arc.minorloss
   FROM inp_selector_result,rpt_inp_arc
  WHERE (childparam->>'valv_type' = 'PRV' OR childparam->>'valv_type' = 'PSV' OR childparam->>'valv_type' = 'PBV') 
  AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    childparam->>'valv_type',
    childparam->>'flow',
    rpt_inp_arc.minorloss
   FROM inp_selector_result, rpt_inp_arc
  WHERE (childparam->>'valv_type' = 'FCV') 
  AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    childparam->>'valv_type',
    childparam->>'coefloss',
    rpt_inp_arc.minorloss
   FROM inp_selector_result,
    rpt_inp_arc
WHERE (childparam->>'valv_type' = 'TCV') 
  AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    childparam->>'valv_type',
    childparam->>'curve_id',
    rpt_inp_arc.minorloss
   FROM inp_selector_result,
    rpt_inp_arc
WHERE (childparam->>'valv_type' = 'GPV') 
  AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION

-- doublevalve
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    'PRV'::character varying(18) AS valv_type,
    0::text AS setting,
    0::numeric AS minorloss
   FROM inp_selector_result,
    rpt_inp_arc
     JOIN inp_pump ON rpt_inp_arc.arc_id::text = concat(inp_pump.node_id, '_n2a_4')
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    'GPV'::character varying(18) AS valv_type,
    childparam->>'curve_id' AS setting,
    0::numeric(12,4) AS minorloss
   FROM inp_selector_result,
    rpt_inp_arc
     JOIN inp_pump ON rpt_inp_arc.arc_id::text = concat(inp_pump.node_id, '_n2a_5')
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION

--virtualvalve
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    childparam->>'valv_type',
    childparam->>'pressure',
    rpt_inp_arc.minorloss
   FROM inp_selector_result, rpt_inp_arc
  WHERE (childparam->>'valv_type' = 'PRV' OR childparam->>'valv_type' = 'PSV' OR childparam->>'valv_type' = 'PBV') 
  AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    childparam->>'valv_type',
    childparam->>'flow',
    rpt_inp_arc.minorloss
   FROM inp_selector_result, rpt_inp_arc
  WHERE (childparam->>'valv_type' = 'FCV') 
  AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    childparam->>'valv_type',
    childparam->>'coef_loss',
    rpt_inp_arc.minorloss
   FROM inp_selector_result, rpt_inp_arc
  WHERE (childparam->>'valv_type' = 'TCV') 
  AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    childparam->>'valv_type',
    childparam->>'curve_id',
    rpt_inp_arc.minorloss
   FROM inp_selector_result, rpt_inp_arc
   WHERE (childparam->>'valv_type' = 'GPV') 
  AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;

  
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
  WHERE 	((a.curve_id::text IN (SELECT vi_tanks.curve_id FROM vi_tanks)) 
		OR (concat('HEAD ', a.curve_id) IN ( SELECT vi_pumps.head FROM vi_pumps)) 
		OR (concat('GPV ', a.curve_id) IN ( SELECT vi_valves.setting FROM vi_valves)) 
		OR (a.curve_id::text IN ( SELECT vi_energy.energyvalue FROM vi_energy WHERE vi_energy.idval::text = 'EFFIC'::text)))
		OR (SELECT value FROM config_param_user WHERE parameter = 'inp_options_buildup_mode' and cur_user=current_user)::integer = 1;


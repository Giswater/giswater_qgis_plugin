
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
		OR (SELECT value FROM config_param_user WHERE parameter = 'inp_options_buildup_mode' and cur_user=current_user)::integer = 1
		
		
		
		
		

		
-- es tracta que quan la bomba no estigui definida, que s'agafi un valor per defecte. (IMNULL)
		INSERT INTO audit_cat_param_user VALUES 
('inp_options_buildup_distribution', 'hidden_value', 'Parameters for distribution buildup epanets models', 'role_epa', NULL, NULL, 'Distribution options for buildup model', NULL, NULL, true, NULL, NULL, 'ws', false, NULL, NULL, NULL, 
false, 'text', 'linetext', true, null,
'{"node":{"nullElevBuffer":100, "ceroElevBuffer":100}, "pipe":{"diameter":"160"}, "junction":{"defaultDemand":"0.00"}, 
"tank":{"distVirtualReservoir":0.01}, "pressGroup":{"status":"ACTIVE", "forceStatus":"ACTIVE"}, "curve":{"caseNotDefinedThen":"IM20"},
"pumpStation":{"status":"CLOSED", "forceStatus":"CLOSED"}, "PRV":{"status":"ACTIVE", "forceStatus":"ACTIVE"}, 
reservoir":{"switch2Junction":["ETAP", "POU", "CAPTACIO"]}}',
NULL, NULL, TRUE, NULL, NULL, NULL, NULL, FALSE)
ON conflict (id) DO NOTHING;


ALTER TABLE ws.rpt_inp_arc ADD COLUMN curve_id varchar(16);


-- Tercera opció de zonificació per pintar mapzones que sigui per plot
-- La zonificació dinàmica pot ser dirigida o totalment 

-- En la rapida:

- NOT DEFINED PA DENTRO
- STATE TYPE TOTS ELS EN SERVEI PA DENTRO (EXCEPTE ELS FORA DE SERVEI)
- LES BOMBES 'PASITO P'ATRAS SI TENIM MÉS D'UN TRAM....
- LES DE RETENCIÓ SON SEMPRE JUNCTIONS I TOT EL QUE NOS SIGUI REGULADORA FORA DE LES VALVULES EPANET
 




/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2456

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_dscenario (result_id_var character varying)  
RETURNS integer AS 
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_pg2epa_dscenario('prognosi')
SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${"data":{ "resultId":"test_bgeo_b1", "useNetworkGeom":"false"}}$$)

SELECT * FROM SCHEMA_NAME.temp_node WHERE node_id = 'VN257816';
*/

DECLARE

arc_rec record;
pump_rec record;
v_node text;
rec record;
record_new_arc record;
n1_geom public.geometry;
n2_geom public.geometry;
p1_geom public.geometry;
p2_geom public.geometry;
angle float;
dist float;
xp1 float;
yp1 float;
xp2 float;
yp2 float;
odd_var float;
pump_order float;
v_old_arc_id varchar(16);
v_addparam json;
rec_version record;


v_demandpriority integer; 
v_querytext text;
v_patternmethod integer;
v_userscenario integer[];
v_networkmode integer;
v_deafultpattern text;


BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	RAISE NOTICE 'Starting pg2epa for filling demand scenario';

	IF (SELECT count(*) FROM selector_inp_dscenario WHERE cur_user = current_user) > 0 THEN

		SELECT * INTO rec_version FROM sys_version ORDER BY id DESC LIMIT 1;

		-- assign value for record_new_arc for pump additional
		SELECT * INTO record_new_arc FROM arc LIMIT 1;
 
		v_networkmode = (SELECT value::integer FROM config_param_user WHERE parameter='inp_options_networkmode' AND cur_user=current_user);
		v_demandpriority = (SELECT value::integer FROM config_param_user WHERE parameter='inp_options_dscenario_priority' AND cur_user=current_user);
		v_patternmethod = (SELECT value::integer FROM config_param_user WHERE parameter='inp_options_patternmethod' AND cur_user=current_user);
		v_userscenario = (SELECT array_agg(dscenario_id) FROM selector_inp_dscenario where cur_user=current_user);
		v_deafultpattern = Coalesce((SELECT value FROM config_param_user WHERE parameter='inp_options_pattern' AND cur_user=current_user),''); 

		-- base demand management	
		IF v_demandpriority = 0 THEN -- Remove whole base demand
		
			UPDATE temp_node SET demand = 0, pattern_id = null;

		ELSIF	v_demandpriority = 1 THEN -- keep base demand and overwrites it when dscenario demand exists
			-- EPANET standard 
			
		ELSIF v_demandpriority = 2 THEN -- Dscenario and base demand are joined,  moving to temp_demand in order to do not lose base demand (because EPANET does)

			-- moving node demands to temp_demand
			INSERT INTO temp_demand (dscenario_id, feature_id, demand, pattern_id)
			SELECT DISTINCT ON (node_id) 0, node_id, n.demand, n.pattern_id 
			FROM temp_node n
			JOIN temp_demand ON node_id = feature_id
			WHERE n.demand IS NOT NULL AND n.demand <> 0;
		END IF;

		-- insert node demands from dscenario into temp_demand
		INSERT INTO temp_demand (dscenario_id, feature_id, demand, pattern_id, demand_type, source)
		SELECT dscenario_id, feature_id, d.demand, d.pattern_id, d.demand_type, d.source
		FROM temp_node n, inp_dscenario_demand d WHERE n.node_id = d.feature_id AND d.demand IS NOT NULL AND d.demand <> 0 
		AND dscenario_id IN (SELECT unnest(v_userscenario));

		-- insert connec demands from dscenario into temp_demand linking object which is exported	
		IF v_networkmode IN(1,2) THEN

			-- demands for connec related to arcs
			INSERT INTO temp_demand (dscenario_id, feature_id, demand, pattern_id, demand_type, source)
			SELECT dscenario_id, node_1 AS node_id, d.demand/2 as demand, d.pattern_id, demand_type, source FROM temp_arc JOIN v_edit_inp_connec USING (arc_id)
			JOIN inp_dscenario_demand d ON feature_id = connec_id WHERE dscenario_id IN (SELECT unnest(v_userscenario))
			UNION ALL
			SELECT dscenario_id, node_2 AS node_id, d.demand/2 as demand, d.pattern_id, demand_type, source  FROM temp_arc JOIN v_edit_inp_connec USING (arc_id)
			JOIN inp_dscenario_demand d ON feature_id = connec_id WHERE dscenario_id IN (SELECT unnest(v_userscenario));

			-- demands for connec related to nodes
			INSERT INTO temp_demand (dscenario_id, feature_id, demand, pattern_id, demand_type, source)
			SELECT dscenario_id, pjoint_id, d.demand as demand, d.pattern_id, demand_type, source  FROM v_edit_inp_connec 
			JOIN inp_dscenario_demand d ON feature_id = connec_id 
			WHERE pjoint_type = 'NODE'
			AND dscenario_id IN (SELECT unnest(v_userscenario));

			
		ELSIF v_networkmode = 3 THEN

			-- removed due refactor of 2022/6/12
			
		END IF;

		-- remove those demands which for some reason linked node is not exported
		DELETE FROM temp_demand WHERE feature_id IN (SELECT feature_id FROM temp_demand EXCEPT select node_id FROM temp_node);

		-- demands for virtual connec (3 , 4 only)
		INSERT INTO temp_demand (dscenario_id, feature_id, demand, pattern_id,  demand_type, source)
		SELECT dscenario_id, n.node_id, d.demand, d.pattern_id, demand_type, source 
		FROM  inp_dscenario_demand d ,temp_node n
		JOIN connec c ON concat('VC',c.pjoint_id) =  n.node_id
		WHERE c.connec_id = d.feature_id AND d.demand IS NOT NULL AND d.demand <> 0  
		AND dscenario_id IN (SELECT unnest(v_userscenario));
		
		-- pattern
		IF v_patternmethod = 11 THEN -- DEFAULT PATTERN
			UPDATE temp_demand SET pattern_id=v_deafultpattern;
		
		ELSIF v_patternmethod = 12 THEN -- SECTOR PATTERN (NODE)
			UPDATE temp_demand SET pattern_id=sector.pattern_id FROM node JOIN sector ON sector.sector_id=node.sector_id WHERE temp_demand.feature_id=node.node_id;
			UPDATE temp_demand SET pattern_id=sector.pattern_id FROM connec JOIN sector ON sector.sector_id=connec.sector_id WHERE temp_demand.feature_id=connec.connec_id;
		
		ELSIF v_patternmethod = 13 THEN -- DMA PATTERN (NODE)
			UPDATE temp_demand SET pattern_id=sector.pattern_id FROM node JOIN dma ON dma.sector_id=node.dma_id WHERE temp_demand.feature_id=node.node_id;
			UPDATE temp_demand SET pattern_id=sector.pattern_id FROM connec JOIN dma ON dma.sector_id=connec.dma_id WHERE temp_demand.feature_id=connec.connec_id;
			
		ELSIF v_patternmethod = 14 THEN -- FEATURE PATTERN (NODE)
			-- do nothing because values have been moved from feature
		END IF;

		
		-- move patterns used demands scenario table
		INSERT INTO rpt_inp_pattern_value (result_id, pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, 
			factor_9, factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18)
		SELECT  result_id_var, pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, 
			factor_9, factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18 
			from inp_pattern_value p 
			WHERE 
			pattern_id IN (SELECT distinct (pattern_id) FROM inp_dscenario_demand d, selector_inp_dscenario s WHERE cur_user = current_user AND d.dscenario_id = s.dscenario_id) AND 
			pattern_id NOT IN (SELECT distinct (pattern_id) FROM temp_node WHERE pattern_id IS NOT NULL)
			order by pattern_id, id;	

		-- set cero where null in order to prevent user's null values on demand table
		UPDATE temp_node SET demand=0 WHERE demand IS NULL;
		
		-- updating values for pipes (when are not trimed)
		UPDATE temp_arc t SET status = d.status FROM v_edit_inp_dscenario_pipe d 
		WHERE t.arc_id = d.arc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.status IS NOT NULL;
		UPDATE temp_arc t SET minorloss = d.minorloss FROM v_edit_inp_dscenario_pipe d 
		WHERE t.arc_id = d.arc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.minorloss IS NOT NULL;
		UPDATE temp_arc t SET diameter = d.dint FROM v_edit_inp_dscenario_pipe d 
		WHERE t.arc_id = d.arc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.dint IS NOT NULL;
		UPDATE temp_arc t SET roughness = d.roughness FROM v_edit_inp_dscenario_pipe d 
		WHERE t.arc_id = d.arc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.roughness IS NOT NULL;

		-- updating values for pipes (when are trimed, network mode  = 4)
		UPDATE temp_arc t SET status = d.status FROM v_edit_inp_dscenario_pipe d 
		WHERE substring (t.arc_id, 0, (case when position ('P' in t.arc_id) in (0) then 99 else position ('P' in t.arc_id) end)) = d.arc_id 		
		AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.status IS NOT NULL;
		
		UPDATE temp_arc t SET minorloss = d.minorloss FROM v_edit_inp_dscenario_pipe d 
		WHERE substring (t.arc_id, 0, (case when position ('P' in t.arc_id) in (0) then 99 else position ('P' in t.arc_id) end)) = d.arc_id
		AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.minorloss IS NOT NULL;

		UPDATE temp_arc t SET diameter = d.dint FROM v_edit_inp_dscenario_pipe d 
		WHERE substring (t.arc_id, 0, (case when position ('P' in t.arc_id) in (0) then 99 else position ('P' in t.arc_id) end)) = d.arc_id 
		AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.dint IS NOT NULL;

		UPDATE temp_arc t SET roughness = d.roughness FROM v_edit_inp_dscenario_pipe d 
		WHERE substring (t.arc_id, 0, (case when position ('P' in t.arc_id) in (0) then 99 else position ('P' in t.arc_id) end)) = d.arc_id 
		AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.roughness IS NOT NULL;

		-- updating values for shortpipes
		UPDATE temp_arc t SET status = d.status FROM v_edit_inp_dscenario_shortpipe d 
		WHERE t.arc_id = concat(d.node_id, '_n2a') AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.status IS NOT NULL;
		UPDATE temp_arc t SET minorloss = d.minorloss FROM v_edit_inp_dscenario_shortpipe d 
		WHERE t.arc_id = concat(d.node_id, '_n2a')  AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.minorloss IS NOT NULL;

		-- updating values for pumps
		UPDATE temp_arc t SET status = d.status FROM v_edit_inp_dscenario_pump d 
		WHERE t.arc_id = concat(d.node_id, '_n2a') AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.status IS NOT NULL;

		-- power
		UPDATE temp_arc t SET addparam = gw_fct_json_object_set_key(addparam::json, 'power',d.power) FROM v_edit_inp_dscenario_pump d 
		WHERE t.arc_id = concat(d.node_id, '_n2a')  AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.power IS NOT NULL AND d.power !='';
		UPDATE temp_arc t SET addparam = gw_fct_json_object_set_key(addparam::json, 'curve_id',NULL::TEXT) FROM v_edit_inp_dscenario_pump d 
		WHERE t.arc_id = concat(d.node_id, '_n2a')  AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.power IS NOT NULL AND d.power !='';

		-- curve_id
		UPDATE temp_arc t SET addparam = gw_fct_json_object_set_key(addparam::json, 'curve_id',d.curve_id) FROM v_edit_inp_dscenario_pump d 
		WHERE t.arc_id = concat(d.node_id, '_n2a')  AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.curve_id IS NOT NULL;
		UPDATE temp_arc t SET addparam = gw_fct_json_object_set_key(addparam::json, 'power',NULL::TEXT) FROM v_edit_inp_dscenario_pump d 
		WHERE t.arc_id = concat(d.node_id, '_n2a')  AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.curve_id IS NOT NULL;

		UPDATE temp_arc t SET addparam = gw_fct_json_object_set_key(addparam::json, 'speed',d.speed) FROM v_edit_inp_dscenario_pump d 
		WHERE t.arc_id = concat(d.node_id, '_n2a')  AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.speed IS NOT NULL;
		UPDATE temp_arc t SET addparam = gw_fct_json_object_set_key(addparam::json, 'pattern',d.pattern) FROM v_edit_inp_dscenario_pump d 
		WHERE t.arc_id = concat(d.node_id, '_n2a')  AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.pattern IS NOT NULL;

		-- updating values for pumps additional
		FOR v_node IN (SELECT DISTINCT a.node_id FROM v_edit_inp_dscenario_pump_additional a JOIN temp_arc ON concat(node_id,'_n2a')=arc_id 
		JOIN inp_pump p ON p.node_id = a.node_id WHERE pump_type = 'FLOWPUMP')
		LOOP
			SELECT * INTO arc_rec FROM temp_arc WHERE arc_id=concat(v_node,'_n2a');

			-- Loop for additional pumps
			FOR pump_rec IN SELECT * FROM v_edit_inp_dscenario_pump_additional WHERE node_id=v_node
			LOOP
					
				-- Id creation from pattern arc
				v_old_arc_id = arc_rec.arc_id;
				record_new_arc.arc_id=concat(arc_rec.arc_id,pump_rec.order_id);

				-- Right or left hand
				odd_var = pump_rec.order_id %2;
				
				if (odd_var)=0 then 
					angle=(ST_Azimuth(ST_startpoint(arc_rec.the_geom), ST_endpoint(arc_rec.the_geom)))+1.57;
				else 
					angle=(ST_Azimuth(ST_startpoint(arc_rec.the_geom), ST_endpoint(arc_rec.the_geom)))-1.57;
				end if;

				pump_order = (pump_rec.order_id);

				-- Copiyng values from patter arc
				record_new_arc.node_1 = arc_rec.node_1;
				record_new_arc.node_2 = arc_rec.node_2;
				record_new_arc.epa_type = arc_rec.epa_type;
				record_new_arc.sector_id = arc_rec.sector_id;
				record_new_arc.sector_id = arc_rec.sector_id;
				record_new_arc.dma_id = arc_rec.dma_id;
				record_new_arc.presszone_id = arc_rec.presszone_id;
				record_new_arc.dqa_id = arc_rec.dqa_id;
				record_new_arc.minsector_id = arc_rec.minsector_id;
				record_new_arc.state = arc_rec.state;
				record_new_arc.arccat_id = arc_rec.arccat_id;
				
				-- intermediate variables
				n1_geom = ST_LineInterpolatePoint(arc_rec.the_geom, 0.500000);
				dist = (ST_Distance(ST_transform(ST_startpoint(arc_rec.the_geom),rec_version.epsg), ST_LineInterpolatePoint(arc_rec.the_geom, 0.5000000))); 

				--create point1
				xp1 = ST_x(n1_geom)-(sin(angle))*dist*0.15000*(pump_order::float);
				yp1 = ST_y(n1_geom)-(cos(angle))*dist*0.15000*(pump_order::float);
							
				p1_geom = ST_SetSRID(ST_MakePoint(xp1, yp1),rec_version.epsg);	
				
				--create arc
				record_new_arc.the_geom=ST_makeline(ARRAY[ST_startpoint(arc_rec.the_geom), p1_geom, ST_endpoint(arc_rec.the_geom)]);

				IF pump_rec.curve_id IS NOT NULL THEN
					pump_rec.power = '';
				END IF;

				IF pump_rec.power IS NOT NULL AND pump_rec.power !='' THEN
					pump_rec.curve_id = '';
				END IF;

				--addparam
				v_addparam = concat('{"power":"',pump_rec.power,'","curve_id":"',pump_rec.curve_id,'","speed":"',pump_rec.speed,'","pattern":"', pump_rec.pattern,'","to_arc":"',
							 arc_rec.addparam::json->>'to_arc','"}');	

				-- delete from temp_arc in case additional pump exists because in this scenario we are overlaping the original one
				DELETE FROM temp_arc WHERE arc_id = record_new_arc.arc_id;
			
				-- Inserting into temp_arc
				INSERT INTO temp_arc (arc_id, node_1, node_2, arc_type, epa_type, sector_id, arccat_id, state, state_type, status, the_geom, expl_id, flw_code, addparam, 
				length, diameter, roughness, dma_id, presszone_id, dqa_id, minsector_id) 
				VALUES (record_new_arc.arc_id, record_new_arc.node_1, record_new_arc.node_2, 'NODE2ARC', record_new_arc.epa_type, record_new_arc.sector_id, 
				record_new_arc.arccat_id, record_new_arc.state, arc_rec.state_type, pump_rec.status, record_new_arc.the_geom, arc_rec.expl_id, v_old_arc_id, v_addparam, 
				arc_rec.length,	arc_rec.diameter, arc_rec.roughness, record_new_arc.dma_id, record_new_arc.presszone_id, record_new_arc.dqa_id, record_new_arc.minsector_id);
						
			END LOOP;
		END LOOP;

		-- updating values for valves
		UPDATE temp_arc t SET status = d.status FROM v_edit_inp_dscenario_valve d 
		WHERE t.arc_id = concat(d.node_id, '_n2a') AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.status IS NOT NULL;
		UPDATE temp_arc t SET addparam = gw_fct_json_object_set_key(addparam::json, 'valv_type',d.valv_type) FROM v_edit_inp_dscenario_valve d 
		WHERE t.arc_id = concat(d.node_id, '_n2a')  AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.valv_type IS NOT NULL;
		UPDATE temp_arc t SET addparam = gw_fct_json_object_set_key(addparam::json, 'pressure',d.pressure) FROM v_edit_inp_dscenario_valve d 
		WHERE t.arc_id = concat(d.node_id, '_n2a')  AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.pressure IS NOT NULL;
		UPDATE temp_arc t SET addparam = gw_fct_json_object_set_key(addparam::json, 'flow',d.flow) FROM v_edit_inp_dscenario_valve d 
		WHERE t.arc_id = concat(d.node_id, '_n2a')  AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.flow IS NOT NULL;
		UPDATE temp_arc t SET addparam = gw_fct_json_object_set_key(addparam::json, 'coef_loss',d.coef_loss) FROM v_edit_inp_dscenario_valve d 
		WHERE t.arc_id = concat(d.node_id, '_n2a')  AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.coef_loss IS NOT NULL;		
		UPDATE temp_arc t SET addparam = gw_fct_json_object_set_key(addparam::json, 'curve_id',d.curve_id) FROM v_edit_inp_dscenario_valve d 
		WHERE t.arc_id = concat(d.node_id, '_n2a')  AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.curve_id IS NOT NULL;
		UPDATE temp_arc t SET addparam = gw_fct_json_object_set_key(addparam::json, 'minorloss',d.minorloss) FROM v_edit_inp_dscenario_valve d 
		WHERE t.arc_id = concat(d.node_id, '_n2a')  AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.minorloss IS NOT NULL;		

		-- updating values for reservoir
		UPDATE temp_node t SET pattern_id = d.pattern_id FROM v_edit_inp_dscenario_reservoir d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.pattern_id IS NOT NULL;
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'head',d.head) FROM v_edit_inp_dscenario_reservoir d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.head IS NOT NULL;

		-- updating values for tanks
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'initlevel',d.initlevel) FROM v_edit_inp_dscenario_tank d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.initlevel IS NOT NULL;
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'minlevel',d.minlevel) FROM v_edit_inp_dscenario_tank d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.minlevel IS NOT NULL;
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'maxlevel',d.maxlevel) FROM v_edit_inp_dscenario_tank d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.maxlevel IS NOT NULL;
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'diameter',d.diameter) FROM v_edit_inp_dscenario_tank d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.diameter IS NOT NULL;
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'minvol',d.minvol) FROM v_edit_inp_dscenario_tank d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.minvol IS NOT NULL;
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'curve_id',d.curve_id) FROM v_edit_inp_dscenario_tank d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.curve_id IS NOT NULL;
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'overflow',d.overflow) FROM v_edit_inp_dscenario_tank d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.overflow IS NOT NULL;

		-- updating values for inlet
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'initlevel',d.initlevel) FROM v_edit_inp_dscenario_inlet d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.initlevel IS NOT NULL;
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'minlevel',d.minlevel) FROM v_edit_inp_dscenario_inlet d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.minlevel IS NOT NULL;
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'maxlevel',d.maxlevel) FROM v_edit_inp_dscenario_inlet d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.maxlevel IS NOT NULL;
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'diameter',d.diameter) FROM v_edit_inp_dscenario_inlet d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.diameter IS NOT NULL;
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'minvol',d.minvol) FROM v_edit_inp_dscenario_inlet d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.minvol IS NOT NULL;
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'curve_id',d.curve_id) FROM v_edit_inp_dscenario_inlet d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.curve_id IS NOT NULL;
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'overflow',d.overflow) FROM v_edit_inp_dscenario_inlet d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.overflow IS NOT NULL;

		-- updating values for junction
		UPDATE temp_node t SET demand = d.demand FROM v_edit_inp_dscenario_junction d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.demand IS NOT NULL;
		UPDATE temp_node t SET pattern_id = d.pattern_id FROM v_edit_inp_dscenario_junction d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.pattern_id IS NOT NULL;
		
		
		-- updating values for connec
		UPDATE temp_node t SET demand = d.demand FROM v_edit_inp_dscenario_connec d 
		WHERE t.node_id = d.connec_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.demand IS NOT NULL;
		UPDATE temp_node t SET pattern_id = d.pattern_id FROM v_edit_inp_dscenario_connec d 
		WHERE t.node_id = d.connec_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.pattern_id IS NOT NULL;
		UPDATE temp_arc t SET status = d.status FROM v_edit_inp_dscenario_connec d 
		WHERE t.arc_id = d.connec_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.status IS NOT NULL;
		UPDATE temp_arc t SET minorloss = d.minorloss FROM v_edit_inp_dscenario_connec d 
		WHERE t.arc_id = d.connec_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.minorloss IS NOT NULL;
		UPDATE temp_arc t SET diameter = d.custom_dint FROM v_edit_inp_dscenario_connec d 
		WHERE t.arc_id = d.connec_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.custom_dint IS NOT NULL;
		UPDATE temp_arc t SET length = d.custom_length FROM v_edit_inp_dscenario_connec d 
		WHERE t.arc_id = d.connec_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.custom_length IS NOT NULL;
		UPDATE temp_arc t SET roughness = d.custom_roughness FROM v_edit_inp_dscenario_connec d 
		WHERE t.arc_id = d.connec_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.custom_roughness IS NOT NULL;
		
		-- updating values for virtualvalve
		UPDATE temp_arc t SET status = d.status FROM v_edit_inp_dscenario_virtualvalve d 
		WHERE t.arc_id = d.arc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.status IS NOT NULL;
		UPDATE temp_arc t SET addparam = gw_fct_json_object_set_key(addparam::json, 'valv_type',d.valv_type) FROM v_edit_inp_dscenario_virtualvalve d 
		WHERE t.arc_id = d.arc_id  AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.valv_type IS NOT NULL;
		UPDATE temp_arc t SET addparam = gw_fct_json_object_set_key(addparam::json, 'pressure',d.pressure) FROM v_edit_inp_dscenario_virtualvalve d 
		WHERE t.arc_id = d.arc_id  AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.pressure IS NOT NULL;
		UPDATE temp_arc t SET addparam = gw_fct_json_object_set_key(addparam::json, 'flow',d.flow) FROM v_edit_inp_dscenario_virtualvalve d 
		WHERE t.arc_id = d.arc_id  AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.flow IS NOT NULL;
		UPDATE temp_arc t SET addparam = gw_fct_json_object_set_key(addparam::json, 'coef_loss',d.coef_loss) FROM v_edit_inp_dscenario_virtualvalve d 
		WHERE t.arc_id = d.arc_id  AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.coef_loss IS NOT NULL;		
		UPDATE temp_arc t SET addparam = gw_fct_json_object_set_key(addparam::json, 'curve_id',d.curve_id) FROM v_edit_inp_dscenario_virtualvalve d 
		WHERE t.arc_id = d.arc_id  AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.curve_id IS NOT NULL;
		UPDATE temp_arc t SET addparam = gw_fct_json_object_set_key(addparam::json, 'minorloss',d.minorloss) FROM v_edit_inp_dscenario_virtualvalve d 
		WHERE t.arc_id = d.arc_id  AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.minorloss IS NOT NULL;				
	END IF;

	RETURN 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
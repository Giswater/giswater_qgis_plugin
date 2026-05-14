/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2318

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_flwreg2arc(result_id_var text)
  RETURNS integer AS
$BODY$

/*
select SCHEMA_NAME.gw_fct_pg2epa_flwreg2arc('test1')
*/

DECLARE

arc_rec record;
pump_rec record;
rec record;
record_new_arc record;
n1_geom public.geometry;
p1_geom public.geometry;
angle float;
dist float;
xp1 float;
yp1 float;
odd_var float;
v_old_arc_id varchar(16);
v_addparam json;
flwreg_rec record;
arc_todelete text[];
v_order_id integer;
valve_rec record;
v_query_text text;
v_record record;
v_record_a1	record;
v_record_a2	record;
v_curve	text;
v_arc_id text;
v_node_1 text;
v_geom	public.geometry;
shortpipe_rec record;


BEGIN

	--  Search path
    SET search_path = "SCHEMA_NAME", public;

    SELECT * INTO rec FROM sys_version ORDER BY id DESC LIMIT 1;

	-- assign value for record_new_arc
	SELECT * INTO record_new_arc FROM temp_t_arc LIMIT 1;

	--  Start process
    RAISE NOTICE 'Starting flowreg process.';

	FOR flwreg_rec IN (SELECT element.*, m.node_id FROM element JOIN man_frelem m ON m.element_id = element.element_id LEFT JOIN temp_t_arc t ON t.arc_id = element.element_id::text
						WHERE element.epa_type IN ('FRPUMP', 'FRVALVE', 'FRSHORTPIPE') AND t.arc_id IS NULL)
	LOOP
		
		IF EXISTS (SELECT 1 FROM temp_t_node WHERE node_id = concat(flwreg_rec.node_id, '_n2a_1')) THEN

			SELECT * INTO arc_rec FROM temp_t_arc WHERE arc_id = concat(flwreg_rec.node_id, '_n2a');

			arc_todelete = array_append(arc_todelete, arc_rec.arc_id);
			
			-- Id creation from pattern arc
			record_new_arc.arc_id=flwreg_rec.element_id::text;

	-- 		-- Right or left hand
			SELECT order_id INTO v_order_id
			FROM (
    			SELECT element_id, ROW_NUMBER() OVER (ORDER BY element_id) AS order_id
    			FROM man_frelem
    			WHERE node_id = flwreg_rec.node_id
			) sub
			WHERE element_id = flwreg_rec.element_id;

	 		odd_var = v_order_id%2;
			if (odd_var)=0 then
				angle=(ST_Azimuth(ST_startpoint(ST_makeline(arc_rec.the_geom)), ST_endpoint(arc_rec.the_geom)))+1.57;
			else
				angle=(ST_Azimuth(ST_startpoint(arc_rec.the_geom), ST_endpoint(arc_rec.the_geom)))-1.57;
			end if;

	 		-- Copiyng values from patter arc
			record_new_arc.node_1 = arc_rec.node_1;
			record_new_arc.node_2 = arc_rec.node_2;
			record_new_arc.epa_type = flwreg_rec.epa_type;
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
			dist = (ST_Distance(ST_transform(ST_startpoint(arc_rec.the_geom),rec.epsg), ST_LineInterpolatePoint(arc_rec.the_geom, 0.5000000)));

	 		--create point1
			xp1 = ST_x(n1_geom)-(sin(angle))*dist*0.15000*(v_order_id::float);
			yp1 = ST_y(n1_geom)-(cos(angle))*dist*0.15000*(v_order_id::float);

	 		p1_geom = ST_SetSRID(ST_MakePoint(xp1, yp1),rec.epsg);

	 		--create arc
			IF (SELECT count(node_id) FROM man_frelem where node_id = flwreg_rec.node_id) > 1 THEN
	 			record_new_arc.the_geom=ST_makeline(ARRAY[ST_startpoint(arc_rec.the_geom), p1_geom, ST_endpoint(arc_rec.the_geom)]);
			ELSE
				record_new_arc.the_geom=ST_makeline(ST_startpoint(arc_rec.the_geom), ST_endpoint(arc_rec.the_geom));
			END IF;

	 		--addparam
			IF flwreg_rec.epa_type = 'FRPUMP' THEN
				SELECT * INTO pump_rec FROM ve_inp_frpump WHERE element_id = flwreg_rec.element_id;
				v_addparam=concat('{"power":"',pump_rec.power,'", "curve_id":"',pump_rec.curve_id,'", "speed":"',pump_rec.speed,'", "pattern":"',pump_rec.pattern_id,'",
				 "status":"',pump_rec.status,'", "to_arc":"',pump_rec.to_arc,'", "energy_price":"',pump_rec.energy_price,'", "energy_pattern_id":"'
				 ,pump_rec.energy_pattern_id,'", "pump_type":"',pump_rec.pump_type,'"}');
			ELSIF flwreg_rec.epa_type = 'FRVALVE' THEN
				SELECT * INTO valve_rec FROM ve_inp_frvalve WHERE element_id = flwreg_rec.element_id;
				v_addparam=concat('{"valve_type":"',valve_rec.valve_type,'", "setting":"',valve_rec.setting,'", "curve_id":"',valve_rec.curve_id,'", "status":"',valve_rec.status,'",
				 "minorloss":"',valve_rec.minorloss,'", "to_arc":"',valve_rec.to_arc,'", "add_settings":"',valve_rec.add_settings,'"}');
			ELSIF flwreg_rec.epa_type = 'FRSHORTPIPE' THEN
				SELECT * INTO shortpipe_rec FROM ve_inp_frshortpipe WHERE element_id = flwreg_rec.element_id;

				IF EXISTS (SELECT 1 FROM temp_t_node WHERE node_id = concat(flwreg_rec.node_id, '_n2a_1')) THEN
					UPDATE temp_t_node SET addparam=concat('{"minorloss":"',minorloss,'", "to_arc":"',to_arc,'", "status":"',status,'", "diameter":"", "roughness":"',arc_rec.roughness,'"}')
					FROM ve_inp_frshortpipe
					WHERE temp_t_node.node_id=concat(ve_inp_frshortpipe.node_id, '_n2a_1') AND ve_inp_frshortpipe.node_id = flwreg_rec.node_id;
				END IF;

				IF EXISTS (SELECT 1 FROM temp_t_node WHERE node_id = concat(flwreg_rec.node_id, '_n2a_2')) THEN
					UPDATE temp_t_node SET addparam=concat('{"minorloss":"',minorloss,'", "to_arc":"',to_arc,'", "status":"',status,'", "diameter":"", "roughness":"',arc_rec.roughness,'"}')
					FROM ve_inp_frshortpipe
					WHERE temp_t_node.node_id=concat(ve_inp_frshortpipe.node_id, '_n2a_2') AND ve_inp_frshortpipe.node_id = flwreg_rec.node_id;
				END IF;
				v_addparam = NULL;
			END IF;

	 		-- Inserting into temp_t_arc
			INSERT INTO temp_t_arc (arc_id, node_1, node_2, arc_type, epa_type, sector_id, arccat_id, state, state_type, the_geom, expl_id, flw_code, addparam,
			length, diameter, roughness, dma_id, presszone_id, dqa_id, minsector_id)
			VALUES (record_new_arc.arc_id, record_new_arc.node_1, record_new_arc.node_2, 'NODE2ARC', record_new_arc.epa_type, record_new_arc.sector_id,
			record_new_arc.arccat_id, record_new_arc.state, arc_rec.state_type, record_new_arc.the_geom, arc_rec.expl_id, v_old_arc_id, v_addparam,
			arc_rec.length,	arc_rec.diameter, arc_rec.roughness, record_new_arc.dma_id, record_new_arc.presszone_id, record_new_arc.dqa_id, record_new_arc.minsector_id);
		
			IF flwreg_rec.epa_type = 'FRVALVE' THEN
				UPDATE temp_t_arc SET status = valve_rec.status WHERE arc_id = record_new_arc.arc_id;
			ELSIF flwreg_rec.epa_type = 'FRSHORTPIPE' THEN
				UPDATE temp_t_arc SET status = shortpipe_rec.status, roughness = arc_rec.roughness, minorloss = shortpipe_rec.minorloss WHERE arc_id = record_new_arc.arc_id;
			END IF;
		ELSE
						
		END IF;
	END LOOP;

	DELETE FROM temp_t_arc WHERE arc_id = ANY (arc_todelete);

	v_query_text = 'SELECT temp_t_arc.arc_id, temp_t_arc.node_1, the_geom, addparam::json->>''curve_id'' FROM temp_t_arc
			JOIN inp_frpump a ON element_id::text=arc_id WHERE pump_type = ''HEADPUMP''';

	FOR v_arc_id, v_node_1, v_geom, v_curve IN EXECUTE v_query_text
	LOOP

		-- New node
		SELECT * INTO v_record FROM temp_t_node WHERE node_id = v_node_1;
		v_record.node_id = concat (reverse(substring(reverse(v_record.node_id),2)), '3');
		v_record.the_geom := ST_LineInterpolatePoint(v_geom, 0.5);
		INSERT INTO temp_t_node (result_id, node_id, top_elev, elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation, demand,
		the_geom, expl_id, pattern_id, dma_id, presszone_id, dqa_id, minsector_id)
		VALUES (v_record.result_id, v_record.node_id, v_record.top_elev, v_record.elev, v_record.node_type, v_record.nodecat_id, v_record.epa_type,
		v_record.sector_id, v_record.state, v_record.state_type, v_record.annotation, v_record.demand, v_record.the_geom, v_record.expl_id,
		v_record.pattern_id, v_record.dma_id, v_record.presszone_id, v_record.dqa_id, v_record.minsector_id);

		-- New arc (PRV)
		SELECT * INTO v_record_a1 FROM temp_t_arc WHERE arc_id = v_arc_id;
		v_record_a1.arc_id = concat (v_record_a1.arc_id, '_n2a_2');
		v_record_a1.arc_type =  'DOUBLE-NOD2ARC(PRV)';
		v_record_a1.epa_type =  'VALVE';
		v_record_a1.node_2 = v_record.node_id;
		v_record_a1.length = v_record_a1.length/2;
		v_record_a1.status = 'ACTIVE';
		v_record_a1.the_geom := ST_LineSubstring(v_record_a1.the_geom,0.5,1);
		v_record_a1.addparam = concat('{"setting":0.01}');
		INSERT INTO temp_t_arc	(result_id, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation, diameter, roughness, length, status, the_geom,
		expl_id, flw_code, addparam, dma_id, presszone_id, dqa_id, minsector_id)
		VALUES(v_record_a1.result_id, v_record_a1.arc_id, v_record_a1.node_1, v_record_a1.node_2, v_record_a1.arc_type, v_record_a1.arccat_id, v_record_a1.epa_type, v_record_a1.sector_id,
		v_record_a1.state, v_record_a1.state_type, v_record_a1.annotation, v_record_a1.diameter, v_record_a1.roughness, v_record_a1.length, v_record_a1.status, v_record_a1.the_geom,
		v_record_a1.expl_id, v_record_a1.flw_code, v_record_a1.addparam, v_record_a1.dma_id, v_record_a1.presszone_id, v_record_a1.dqa_id, v_record_a1.minsector_id);

		-- New arc (PUMP)
		SELECT * INTO v_record_a2 FROM temp_t_arc WHERE arc_id = v_arc_id;
		v_record_a2.arc_id = concat (v_record_a2.arc_id, '_n2a_1');
		v_record_a2.arc_type =  'DOUBLE-NOD2ARC(PUMP)';
		v_record_a2.epa_type =  'PUMP';
		v_record_a2.node_1 = v_record.node_id;
		v_record_a2.length = v_record_a2.length/2;
		v_record_a2.the_geom := ST_LineSubstring(v_record_a2.the_geom,0,0.5);
		INSERT INTO temp_t_arc	(result_id, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation, diameter, roughness, length, status, the_geom,
		expl_id, flw_code, addparam, dma_id, presszone_id, dqa_id, minsector_id)
		VALUES(v_record_a2.result_id, v_record_a2.arc_id, v_record_a2.node_1, v_record_a2.node_2, v_record_a2.arc_type, v_record_a2.arccat_id, v_record_a2.epa_type, v_record_a2.sector_id,
		v_record_a2.state, v_record_a2.state_type, v_record_a2.annotation, v_record_a2.diameter, v_record_a2.roughness, v_record_a2.length, v_record_a2.status, v_record_a2.the_geom,
		v_record_a2.expl_id, v_record_a2.flw_code, v_record_a2.addparam, v_record_a2.dma_id, v_record_a2.presszone_id, v_record_a2.dqa_id, v_record_a2.minsector_id);

		-- Deleting old arc
		DELETE FROM temp_t_arc WHERE arc_id = v_arc_id;

	END LOOP;

	-- Pressure sustain + reduce valve
	v_query_text = 'SELECT temp_t_arc.arc_id, temp_t_arc.node_1, the_geom, addparam::json->>''curve_id'' FROM temp_t_arc
			JOIN inp_frvalve a ON element_id::text=arc_id WHERE valve_type = ''PSRV''';

	FOR v_arc_id, v_node_1, v_geom, v_curve IN EXECUTE v_query_text
	LOOP
		-- New node
		SELECT * INTO v_record FROM temp_t_node WHERE node_id = v_node_1;
		v_record.node_id = concat (reverse(substring(reverse(v_record.node_id),2)), '3');
		v_record.the_geom := ST_LineInterpolatePoint(v_geom, 0.5);
		INSERT INTO temp_t_node (result_id, node_id, top_elev, elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation, demand, the_geom, expl_id,
		pattern_id, dma_id, presszone_id, dqa_id, minsector_id)
		VALUES (v_record.result_id, v_record.node_id, v_record.top_elev, v_record.elev, v_record.node_type, v_record.nodecat_id, v_record.epa_type, v_record.sector_id, v_record.state,
		v_record.state_type, v_record.annotation, v_record.demand, v_record.the_geom, v_record.expl_id, v_record.pattern_id, v_record.dma_id, v_record.presszone_id, v_record.dqa_id, v_record.minsector_id);

		-- New arc (PSV)
		SELECT * INTO v_record_a1 FROM temp_t_arc WHERE arc_id = v_arc_id;
		v_record_a1.arc_id = concat (v_record_a1.arc_id, '_n2a_2');
		v_record_a1.arc_type =  'DOUBLE-NOD2ARC(PSV)';
		v_record_a1.epa_type =  'VALVE';
		v_record_a1.node_2 = v_record.node_id;
		v_record_a1.length = v_record_a1.length/2;
		v_record_a1.the_geom := ST_LineSubstring(v_record_a1.the_geom,0.5,1);
		v_record_a1.addparam = gw_fct_json_object_set_key(v_record_a1.addparam::json, 'valve_type', 'PSV'::text);
		INSERT INTO temp_t_arc (result_id, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation,
		diameter, roughness, length, status, the_geom, expl_id, flw_code, addparam, dma_id, presszone_id, dqa_id, minsector_id)
		VALUES(v_record_a1.result_id, v_record_a1.arc_id, v_record_a1.node_1, v_record_a1.node_2, v_record_a1.arc_type, v_record_a1.arccat_id, v_record_a1.epa_type, v_record_a1.sector_id,
		v_record_a1.state, v_record_a1.state_type, v_record_a1.annotation, v_record_a1.diameter, v_record_a1.roughness, v_record_a1.length, v_record_a1.status, v_record_a1.the_geom,
		v_record_a1.expl_id, v_record_a1.flw_code, v_record_a1.addparam, v_record_a1.dma_id, v_record_a1.presszone_id, v_record_a1.dqa_id, v_record_a1.minsector_id);

		-- New arc (PRV)
		SELECT * INTO v_record_a2 FROM temp_t_arc WHERE arc_id = v_arc_id;
		v_record_a2.arc_id = concat (v_record_a2.arc_id, '_n2a_1');
		v_record_a2.arc_type =  'DOUBLE-NOD2ARC(PRV)';
		v_record_a2.epa_type =  'VALVE';
		v_record_a2.node_1 = v_record.node_id;
		v_record_a2.length = v_record_a2.length/2;
		v_record_a2.the_geom := ST_LineSubstring(v_record_a2.the_geom,0,0.5);
		v_record_a2.addparam = gw_fct_json_object_set_key(v_record_a2.addparam::json, 'valve_type', 'PRV'::text);
		v_record_a2.addparam = gw_fct_json_object_set_key(v_record_a2.addparam::json, 'setting', (v_record_a2.addparam::json->>'add_settings')::text);
		INSERT INTO temp_t_arc (result_id, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation,
		diameter, roughness, length, status, the_geom, expl_id, flw_code, addparam, dma_id, presszone_id, dqa_id, minsector_id)
		VALUES(v_record_a2.result_id, v_record_a2.arc_id, v_record_a2.node_1, v_record_a2.node_2, v_record_a2.arc_type, v_record_a2.arccat_id, v_record_a2.epa_type,
		v_record_a2.sector_id, v_record_a2.state, v_record_a2.state_type, v_record_a2.annotation, v_record_a2.diameter, v_record_a2.roughness, v_record_a2.length,
		v_record_a2.status, v_record_a2.the_geom, v_record_a2.expl_id, v_record_a2.flw_code, v_record_a2.addparam, v_record_a2.dma_id, v_record_a2.presszone_id, v_record_a2.dqa_id, v_record_a2.minsector_id);

		-- Deleting old arc
		DELETE FROM temp_t_arc WHERE arc_id = v_arc_id;

	END LOOP;

    RETURN 1;

END;


$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

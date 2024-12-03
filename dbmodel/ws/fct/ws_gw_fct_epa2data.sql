/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3180

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_epa2data(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_epa2data(p_data json)  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_epa2data($${"client":{"device":4, "infoType":1, "lang":"ES", "epsg":25831}, "data":{"resultId":"test", "isCorporate":false}}$$)
SELECT SCHEMA_NAME.gw_fct_epa2data($${"client":{"device":4, "infoType":1, "lang":"ES", "epsg":25831}, "data":{"resultId":"test_1", "isCorporate":true}}$$)
SELECT SCHEMA_NAME.gw_fct_epa2data($${"client":{"device":4, "infoType":1, "lang":"ES", "epsg":25831}, "data":{"resultId":"test_1", "action":"CHECK"}}$$)


SELECT * FROM arc_add
SELECT * FROM node_add
SELECT * FROM connec_add

*/

DECLARE

v_count_sector integer = 0;
v_result_id text;
v_current_selector text;
v_error_context text;
v_version text;
v_projectype text;
v_iscorporate boolean;
v_affected_result text;
v_mapzone text;
v_addparam jsonb;
v_network_type integer;
v_sectors text;
v_sql text;
v_results record;
v_message_text text; 
v_action_update boolean = false;
v_network_name text;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	SELECT giswater, project_type INTO v_version, v_projectype FROM sys_version ORDER BY id DESC LIMIT 1;

	--  Get system & user variables
	v_result_id = ((p_data ->>'data')::json->>'resultId')::text;
	v_iscorporate = ((p_data ->>'data')::json->>'isCorporate');
	v_action_update = ((p_data ->>'data')::json->>'action_update');

	-- Get the addparam
	SELECT COALESCE(addparam::jsonb, '{}') INTO v_addparam FROM rpt_cat_result WHERE result_id = v_result_id;
	-- Ensure the "corporateLastDates" key exists
	v_addparam := jsonb_set(
		v_addparam,
		'{corporateLastDates}',
		COALESCE(v_addparam->'corporateLastDates', '{"start": null, "end": null}')::jsonb,
		true
	);

	-- Get network_type
	SELECT network_type, idval INTO v_network_type, v_network_name FROM rpt_cat_result join inp_typevalue on network_type = id WHERE result_id = v_result_id and typevalue = 'inp_options_networkmode';

	-- Get sector_id
	SELECT sector_id INTO v_sectors FROM rpt_cat_result WHERE result_id = v_result_id;

	IF v_iscorporate then
	
		if (SELECT count(*)  FROM rpt_cat_result r WHERE r.network_type = v_network_type::text AND v_sectors::integer[] @> r.sector_id AND iscorporate IS TRUE) > 0 then 
			-- The result includes the same network type and sectors. Proceed with updating the corporate entity.
			if v_action_update is true then 
				UPDATE rpt_cat_result SET iscorporate = FALSE WHERE result_id in (SELECT result_id FROM rpt_cat_result r WHERE r.network_type = v_network_type::text AND v_sectors::integer[] @> r.sector_id AND iscorporate IS TRUE AND result_id != v_result_id);
				v_message_text = 'Epa corporate updated';
			else
				 SELECT CONCAT(
				        'To set this result as corporate, the following results will no longer be marked as corporate: (Network Type - ',v_network_name,') \n\n',
				        STRING_AGG(
				            CONCAT(
			                '- ', result_id, ' with sectors: ''', sector_id, ''''
			            	), '\n'
				        )
				    ) AS msg
				FROM (
				    SELECT 
				        result_id, 
				        network_type, 
				        sector_id::text
				    FROM rpt_cat_result r
				    WHERE r.network_type = v_network_type::text
				      AND v_sectors::integer[] @> r.sector_id
				      AND iscorporate IS TRUE
				) INTO v_message_text;
				RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Process done successfully"}, "version":"'||v_version||'"'||
						 ',"body":{"form":{}'||
					 ',"data":{ "question":{"level": 1, "status":"Accepted", "message":"'||v_message_text||'", "accept_action": "action_update"}'||
						'}}'||
					'}')::json, 3180, null, null, null);
			end if;
			
			
		elsif (SELECT count(*)  FROM rpt_cat_result r WHERE r.network_type = v_network_type::text AND r.sector_id && v_sectors::integer[] and iscorporate is true) > 0 then 
			-- The result contains the same network type with one or more sectors already associated with another corporate entity. It is not possible to create a new corporate entity under these circumstances.
			RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":2, "text":"It is impossible to proceed. You need to fix the current corporate result for the following sectors: '||(v_sectors)||'"}, "version":"'||v_version||'"'||
			 ',"body":{"form":{}'||
			 ',"data":{}}'||
			 '}')::json, 3180, null, null, null);
			
		else
			-- The result has a different network type or distinct sectors. Proceed with creating a new corporate entity.
		end if;
	
		UPDATE rpt_cat_result SET iscorporate=v_iscorporate WHERE result_id = v_result_id;

		SELECT result_id INTO v_current_selector FROM selector_rpt_main WHERE cur_user=current_user;

		DELETE FROM selector_rpt_main WHERE cur_user=current_user;
		INSERT INTO selector_rpt_main(result_id, cur_user) VALUES (v_result_id, current_user);

		INSERT INTO node_add (node_id, demand_max, demand_min, demand_avg, press_max, press_min, press_avg, head_max, head_min, head_avg, quality_max, quality_min, quality_avg, result_id)
		SELECT node_id, avg(demand_max)::numeric(12,2), avg(demand_min)::numeric(12,2), avg(demand_avg)::numeric(12,2), avg(press_max)::numeric(12,2), avg(press_min)::numeric(12,2), avg(press_avg)::numeric(12,2),
		avg(head_max)::numeric(12,2), avg(head_min)::numeric(12,2), avg(head_avg)::numeric(12,2), avg(quality_max)::numeric(12,2), avg(quality_min)::numeric(12,2), avg(quality_avg)::numeric(12,2), result_id FROM
		(SELECT split_part(node_id,'_',1) as node_id, demand_max, demand_min, demand_avg, press_max, press_min, press_avg, head_max, head_min, head_avg, quality_max, quality_min, quality_avg, result_id
		FROM v_rpt_node a WHERE result_id=v_result_id) a
		JOIN node USING (node_id)
		GROUP BY node_id, result_id
		ON CONFLICT (node_id) DO UPDATE SET
		demand_max = EXCLUDED.demand_max, demand_min = EXCLUDED.demand_min, demand_avg = EXCLUDED.demand_avg,
		press_max = EXCLUDED.press_max, press_min = EXCLUDED.press_min, press_avg = EXCLUDED.press_avg,
		head_max = EXCLUDED.head_max, head_min = EXCLUDED.head_min, head_avg = EXCLUDED.head_avg,
		quality_max = EXCLUDED.quality_max, quality_min = EXCLUDED.quality_min, quality_avg=EXCLUDED.quality_avg, result_id=EXCLUDED.result_id;

		INSERT INTO arc_add (arc_id, flow_max, flow_min, flow_avg, vel_max, vel_min, vel_avg, result_id)
		SELECT arc_id, avg(flow_max)::numeric(12,2), avg(flow_min)::numeric(12,2), avg(flow_avg)::numeric(12,2), avg(vel_max)::numeric(12,2), avg(vel_min)::numeric(12,2), avg(vel_avg)::numeric(12,2), result_id FROM
		(SELECT split_part(arc_id, 'P',1) as arc_id, flow_max, flow_min, flow_avg, vel_max, vel_min, vel_avg, result_id FROM v_rpt_arc a WHERE result_id=v_result_id)a
		GROUP by arc_id, result_id
		ON CONFLICT (arc_id) DO UPDATE SET
		flow_max = EXCLUDED.flow_max, flow_min = EXCLUDED.flow_min, flow_avg = EXCLUDED.flow_avg,
		vel_max = EXCLUDED.vel_max, vel_min = EXCLUDED.vel_min, vel_avg = EXCLUDED.vel_avg, result_id=EXCLUDED.result_id;

		INSERT INTO connec_add (connec_id, press_max, press_min, press_avg, quality_max, quality_min, quality_avg, result_id)
		SELECT node_id, press_max::numeric(12,2), press_min::numeric(12,2), press_avg::numeric(12,2),
		quality_max::numeric(12,4), quality_min::numeric(12,4), quality_avg::numeric(12,4), result_id
		FROM v_rpt_node a
		JOIN connec ON node_id = connec_id
		ON CONFLICT (connec_id) DO UPDATE SET
		press_max = EXCLUDED.press_max, press_min = EXCLUDED.press_min, press_avg = EXCLUDED.press_avg,
		quality_max = EXCLUDED.quality_max, quality_min = EXCLUDED.quality_min, quality_avg=EXCLUDED.quality_avg, result_id=EXCLUDED.result_id;

		--calc avg_press for mapzones
		for v_mapzone in select unnest(array['dma', 'sector', 'presszone'])
		loop

			execute 'update '||v_mapzone||' d set avg_press = a.avg_press from (
			with cn as (
				select na.node_id as feature_id, na.press_avg, n.'||v_mapzone||'_id::varchar from node_add na join node n using (node_id) 
				union select ca.connec_id as feature_id, ca.press_avg, c.'||v_mapzone||'_id::varchar from connec_add ca join connec c using (connec_id)
				) 
			select round(avg(press_avg),2) as avg_press, '||v_mapzone||'_id::varchar from cn group by '||v_mapzone||'_id
			)a where a.'||v_mapzone||'_id::varchar = d.'||v_mapzone||'_id::varchar
			and d.'||v_mapzone||'_id in (select distinct '||v_mapzone||'_id from node where node_id 
			in (select distinct node_id from rpt_node where result_id = '||quote_literal(v_result_id)||'))';

		end loop;

		--set start date
		v_addparam := jsonb_set(
			v_addparam,
			'{corporateLastDates,start}',
			to_jsonb(to_char(now(), 'DD-MM-YYY HH24:MI:SS')::text)
		);
		--set end date to null
		v_addparam := jsonb_set(
			v_addparam,
			'{corporateLastDates,end}',
			'null'::jsonb
		);
		-- Update the table with the modified jsonb converted back to json
		UPDATE rpt_cat_result SET addparam = v_addparam::json WHERE result_id = v_result_id;

		IF v_current_selector IS NOT NULL THEN
			DELETE FROM selector_rpt_main WHERE cur_user=current_user;
			INSERT INTO selector_rpt_main(result_id, cur_user) VALUES (v_current_selector, current_user);
		END IF;
		
	else
	
		UPDATE rpt_cat_result SET iscorporate=v_iscorporate WHERE result_id = v_result_id;
	
		DELETE FROM node_add WHERE result_id = v_result_id;
		DELETE FROM arc_add WHERE result_id = v_result_id;
		DELETE FROM connec_add WHERE result_id = v_result_id;

		--set end date
		v_addparam := jsonb_set(
			v_addparam,
			'{corporateLastDates,end}',
			to_jsonb(to_char(now(), 'DD-MM-YYY HH24:MI:SS')::text)
		);
		-- Update the table with the modified jsonb converted back to json
		UPDATE rpt_cat_result SET addparam = v_addparam::json WHERE result_id = v_result_id;

		--set avg_press null on mapzones when set corporate is false
		for v_mapzone in select unnest(array['dma', 'sector', 'presszone'])
		loop

			execute '
			UPDATE '||v_mapzone||' set avg_press = null where '||v_mapzone||'_id in 
			(select distinct '||v_mapzone||'_id from node where node_id in (select distinct node_id from rpt_node where result_id = '||quote_literal(v_result_id)||'))';

		end loop;
	END IF;
	
	-- Manage v_message_text
	if v_message_text is null then
		v_message_text = 'Process done successfully';
	end if;
	-- Manage nulls
	v_affected_result := COALESCE(v_affected_result, '[]');

  	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"'||v_message_text||'"}, "version":"'||v_version||'"'||
				 ',"body":{"form":{}'||
				 ',"data":{}}'||
			'}')::json, 3180, null, null, null);

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE, 'SQLCONTEXT', v_error_context)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

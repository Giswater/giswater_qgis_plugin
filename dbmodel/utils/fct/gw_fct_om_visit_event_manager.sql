/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2696

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_om_visit_event_manager(visit_id_aux integer)
  RETURNS text AS
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_om_visit_event_manager(19702)
*/

DECLARE

rec_parameter record;

id_last integer;
id_event integer;
mu_id_aux integer;
node_id_aux varchar;
rec_node record;
array_agg text[];
concat_agg text;
startdate_aux date;
rec_event record;	
query text;
event_aux integer;
work_aux integer;
builder_aux integer;
size_id_aux integer;
price_aux float;
campaign_aux integer;
event_date_aux date;
v_id_list bigint[];
v_visit_id bigint[];
v_node_id bigint;
v_parameter text;
v_querytext text;
rec_parameter_child record;
result text;
v_newclass integer;
v_schema text;
v_visit_type integer;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;
	
	v_schema = (SELECT project_type FROM sys_version ORDER BY id DESC LIMIT 1);

	-- select main values (stardate, node_id, mu_id)
	-- getting start date using event value (legacy)
	SELECT startdate INTO startdate_aux FROM om_visit WHERE id=visit_id_aux limit 1; 
	-- select other parameters using other tables

	IF v_schema = 'TM' THEN
		SELECT mu_id, node.node_id INTO mu_id_aux, node_id_aux FROM node 
		JOIN om_visit_x_node ON om_visit_x_node.node_id=node.node_id WHERE visit_id=visit_id_aux;
	ELSE
		SELECT muni_id, node.node_id INTO mu_id_aux, node_id_aux FROM node 
		JOIN om_visit_x_node ON om_visit_x_node.node_id=node.node_id WHERE visit_id=visit_id_aux;

	END IF;

	-- check if exits multiplier parameter (action type=1)
	v_parameter = (SELECT parameter_id2 FROM om_visit_event JOIN config_visit_parameter_action ON parameter_id=parameter_id1
		   JOIN config_visit_parameter ON parameter_id=config_visit_parameter.id 
		   WHERE visit_id=visit_id_aux AND action_type=1 AND feature_type='NODE'  AND config_visit_parameter.active IS TRUE 
		   AND config_visit_parameter_action.active IS TRUE limit 1);
	
	v_visit_type = (SELECT visit_type FROM config_visit_class JOIN om_visit ON om_visit.class_id = config_visit_class.id WHERE om_visit.id = visit_id_aux);
	
	IF v_visit_type = 1 THEN
		IF v_parameter IS NOT NULL THEN

		-- select simpleClass id
			SELECT ((param_options->>'paramDesmultiplier')::json->>'simpleClass')::integer INTO v_newclass FROM config_visit_class JOIN om_visit ON config_visit_class.id=class_id WHERE om_visit.id=visit_id_aux;

		-- loop for those nodes that has the same attribute
		FOR rec_node IN SELECT node_id, startdate_aux as startdate, node.the_geom FROM node WHERE mu_id=mu_id_aux AND node.node_id!=node_id_aux 
		LOOP
			rec_node.startdate= (SELECT startdate::date from om_visit join om_visit_x_node on visit_id=om_visit.id where node_id=rec_node.node_id order by startdate desc limit 1 );
		   
			-- insert visit
			INSERT INTO om_visit (visitcat_id, ext_code, startdate, enddate, user_name, webclient_id, expl_id, descript, is_done,status, class_id)
			SELECT visitcat_id, ext_code, startdate, enddate, user_name, webclient_id, expl_id, descript, is_done, 4, v_newclass
			FROM om_visit WHERE id=visit_id_aux RETURNING id into id_last;

			INSERT INTO om_visit_x_node (visit_id,node_id) VALUES (id_last, rec_node.node_id);
					

			
			-- insert parameters
			FOR rec_parameter IN SELECT * FROM om_visit_event JOIN config_visit_parameter_action ON parameter_id=parameter_id1
			JOIN config_visit_parameter ON parameter_id=config_visit_parameter.id 
			WHERE visit_id=visit_id_aux AND action_type=1 AND feature_type='NODE' AND config_visit_parameter.active IS TRUE
			AND config_visit_parameter_action.active IS TRUE
			LOOP 

				
				
				-- desmultiplier parameter (action_type=1)
				INSERT INTO om_visit_event (ext_code, visit_id, parameter_id, value, text) VALUES 
				(rec_parameter.ext_code, id_last, v_parameter, rec_parameter.value, rec_parameter.text) RETURNING id INTO id_event;




				-- sql parameter (action_type=4)
				FOR rec_parameter_child IN SELECT * FROM config_visit_parameter_action WHERE parameter_id1=v_parameter AND action_type=4
				AND config_visit_parameter_action.active IS TRUE
				LOOP 
					v_querytext:= rec_parameter_child.action_value||' WHERE node_id= '||quote_literal(rec_node.node_id);
		
					IF v_querytext is not null THEN
						EXECUTE v_querytext;    
					END IF;

				END LOOP;

				--price parameter (action type=5)
				FOR rec_parameter_child IN SELECT * FROM config_visit_parameter_action WHERE parameter_id1=v_parameter AND action_type=5
				AND config_visit_parameter_action.active IS TRUE
				LOOP 

					work_aux := (select action_value::text from config_visit_parameter_action WHERE parameter_id1=rec_parameter.parameter_id2 AND action_type=5);
					builder_aux:= (select om_visit_cat.id from om_visit_cat JOIN om_visit ON om_visit_cat.id=om_visit.visitcat_id WHERE om_visit.id=visit_id_aux);
					size_id_aux= (select size_id FROM node WHERE node_id=rec_node.node_id);
					event_date_aux=(SELECT date(startdate) FROM om_visit WHERE om_visit.id=visit_id_aux);
					campaign_aux=(select id FROM cat_campaign WHERE start_date<=event_date_aux and end_date>=event_date_aux AND active = TRUE);
					price_aux = (select price FROM cat_price WHERE size_id=size_id_aux AND work_id=work_aux AND campaign_id=campaign_aux);

					
					IF id_event in (select event_id FROM om_visit_work_x_node) then
						UPDATE om_visit_work_x_node SET work_id=work_aux, work_date=event_date_aux, builder_id=builder_aux, size_id=size_id_aux,
						 price=price_aux, work_cost=price_aux*1 WHERE event_id=id_event;
					ELSE 
						INSERT INTO om_visit_work_x_node (node_id, work_id, work_date, builder_id, size_id, price, units, work_cost, event_id) values 
						(rec_node.node_id, work_aux, event_date_aux, builder_aux, size_id_aux, price_aux, 1, price_aux*1, id_event);
					END IF;

				END LOOP;
				
			END LOOP;

			IF rec_node.the_geom is not null then
				concat_agg=concat(concat_agg, (SELECT concat('POINT (',st_x(the_geom),' ', st_y(the_geom),'),') FROM node WHERE node_id=rec_node.node_id)::text);
			END IF;
			
		END LOOP;

		-- update initial visit from parameter_m to parameter without m
		v_querytext = 'UPDATE om_visit_event SET parameter_id = '||quote_literal(v_parameter)||' WHERE visit_id='||visit_id_aux;
		
		IF v_querytext IS NOT NULL THEN
			EXECUTE v_querytext;
		END IF;

		-- update class visit to multi to simple 
		UPDATE om_visit SET class_id=v_newclass WHERE om_visit.id=visit_id_aux;
					--check if the function was planned before by poblacion
				IF v_schema = 'TM' THEN
					PERFORM tm_fct_planned_visit(visit_id_aux, 2);
				END IF;
		
		  ELSE
					--check if the function was planned before by unit
			IF v_schema = 'TM' THEN
			
				PERFORM tm_fct_planned_visit(visit_id_aux,1);
				
			END IF;
			
		  END IF;

		 -- check if exits sql sentence parameter related to the query text parameter (action type=4)
		 IF (SELECT count(*) FROM om_visit_event JOIN config_visit_parameter_action ON parameter_id=parameter_id1
			JOIN config_visit_parameter ON parameter_id=config_visit_parameter.id 
			WHERE visit_id=visit_id_aux AND action_type=4 AND feature_type='NODE' AND config_visit_parameter.active IS TRUE
			AND config_visit_parameter_action.active IS TRUE)>0  THEN

			FOR rec_parameter IN SELECT * FROM om_visit_event JOIN config_visit_parameter_action ON parameter_id=parameter_id1
			JOIN config_visit_parameter ON parameter_id=config_visit_parameter.id 
			WHERE visit_id=visit_id_aux AND action_type=4 AND feature_type='NODE'  AND config_visit_parameter.active IS TRUE
			AND config_visit_parameter_action.active IS TRUE
			LOOP 
			v_querytext:= rec_parameter.action_value||' WHERE node_id= '||quote_literal(node_id_aux);
			IF v_querytext IS NOT NULL THEN
				EXECUTE v_querytext;   
			END IF;
			END LOOP;

		END IF;

		-- check if exits price parameter related to the price parameter (action type=5)
			-- check if exits price parameter related to the price parameter (action type=5)
		 IF (SELECT count(*) FROM om_visit_event JOIN config_visit_parameter_action ON parameter_id=parameter_id1
			JOIN config_visit_parameter ON parameter_id=config_visit_parameter.id 
			WHERE visit_id=visit_id_aux AND (action_type=5 OR action_type=4) AND feature_type='NODE' 
			AND config_visit_parameter.active IS TRUE  AND config_visit_parameter_action.active IS TRUE)>0  THEN

			FOR rec_parameter IN SELECT * FROM om_visit_event JOIN config_visit_parameter_action ON parameter_id=parameter_id1
			JOIN config_visit_parameter ON parameter_id=config_visit_parameter.id 
			WHERE visit_id=visit_id_aux AND (action_type=5 OR action_type=4) AND feature_type='NODE' 
			AND config_visit_parameter.active IS TRUE AND config_visit_parameter_action.active IS TRUE

			LOOP
				IF rec_parameter.action_type=4 then
				work_aux:=(SELECT id FROM cat_work WHERE parameter_id=rec_parameter.parameter_id); 
			ELSE 
				work_aux := rec_parameter.action_value;
			END IF;

				builder_aux:= (select om_visit_cat.id from om_visit_cat JOIN om_visit ON om_visit_cat.id=om_visit.visitcat_id WHERE om_visit.id=visit_id_aux);
				size_id_aux= (select size_id FROM node WHERE node_id=node_id_aux);
				event_date_aux=(SELECT date(startdate) FROM om_visit WHERE om_visit.id=visit_id_aux);
				campaign_aux=(select id FROM cat_campaign WHERE start_date<=event_date_aux and end_date>=event_date_aux AND active = TRUE);
				price_aux = (select price FROM cat_price WHERE size_id=size_id_aux AND work_id=work_aux AND campaign_id=campaign_aux);
				  
				  
				IF rec_parameter.id in (select event_id FROM om_visit_work_x_node) then
					UPDATE om_visit_work_x_node SET work_id=work_aux, work_date=event_date_aux, builder_id=builder_aux, size_id=size_id_aux,
					price=price_aux, work_cost=price_aux*1 WHERE event_id=rec_parameter.id;			
				ELSE 
					INSERT INTO om_visit_work_x_node (node_id, work_id, work_date, builder_id, size_id, price, units, work_cost, event_id) values 
					(node_id_aux, work_aux, event_date_aux, builder_aux, size_id_aux, price_aux, 1, price_aux*1, rec_parameter.id);
				END IF;

						   
			END LOOP;
			
		END IF;

		-- check if exits incompatible events (action type=2)
		
		-- get node_id
		select node_id from SCHEMA_NAME.om_visit_x_node where visit_id = visit_id_aux into v_node_id;
		
		-- get visits ids
		SELECT ARRAY(SELECT om_visit.id from SCHEMA_NAME.om_visit JOIN SCHEMA_NAME.om_visit_x_node ON visit_id=om_visit.id WHERE node_id = v_node_id::text) into v_visit_id;

		-- get parameter_id current visit
		SELECT parameter_id FROM SCHEMA_NAME.om_visit_event where visit_id = visit_id_aux into v_parameter;
		
		IF (SELECT om_visit_event.visit_id FROM SCHEMA_NAME.om_visit_event 
			JOIN SCHEMA_NAME.om_visit ON visit_id=om_visit.id 
			JOIN SCHEMA_NAME.config_visit_parameter_action ON parameter_id=config_visit_parameter_action.parameter_id2
			WHERE visit_id = ANY(v_visit_id)
			AND action_type = 2
			AND parameter_id = config_visit_parameter_action.parameter_id2
			AND config_visit_parameter_action.active IS TRUE
			ORDER BY startdate LIMIT 1) IS NOT NULL THEN
					
			FOR rec_parameter IN 
			SELECT * FROM SCHEMA_NAME.om_visit_event 
			JOIN SCHEMA_NAME.om_visit ON visit_id=om_visit.id 
			JOIN SCHEMA_NAME.config_visit_parameter_action ON parameter_id=config_visit_parameter_action.parameter_id2
			WHERE visit_id = ANY(v_visit_id)
			AND action_type = 2
			AND parameter_id1 = v_parameter
			AND parameter_id = config_visit_parameter_action.parameter_id2
			AND config_visit_parameter_action.active IS TRUE
			ORDER BY startdate desc LIMIT 1
			
			LOOP
				IF rec_parameter.visit_id != visit_id_aux THEN
				-- incompatible events (action_type=2)
				-- rec_parameter.action_value is integer (0 = False / 1 = True)
					UPDATE om_visit_event SET value2 = rec_parameter.action_value::integer WHERE visit_id = rec_parameter.visit_id AND parameter_id = rec_parameter.parameter_id2;
				END IF;
			END LOOP;
			
		END IF;
	ELSIF v_visit_type = 2 AND  v_schema = 'TM'THEN
		EXECUTE 'SELECT tm_fct_incident($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
		"data":{"action":"INSERT", "visit_id":'||visit_id_aux||'}}$$);';
	END IF;

	-- adding the initial node to array
	concat_agg=concat(concat_agg, (SELECT concat('POINT (',st_x(the_geom),' ', st_y(the_geom),')') FROM node WHERE node_id=node_id_aux)::text);
	
   
	RETURN concat_agg;

END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
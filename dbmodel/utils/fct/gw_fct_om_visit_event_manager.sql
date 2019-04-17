CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_om_visit_event_manager(visit_id_aux integer)
  RETURNS text AS
$BODY$
DECLARE
rec_parameter record;
id_last integer;
id_event integer;
mu_id_aux integer;
node_id_aux varchar;
rec_node record;
count integer;
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

BEGIN



--  Search path
    SET search_path = "SCHEMA_NAME", public;

    count=0;
    -- select main values (stardate, node_id, mu_id)
    SELECT startdate INTO startdate_aux FROM om_visit WHERE id=visit_id_aux; 
    SELECT mu_id, node.node_id INTO mu_id_aux, node_id_aux FROM node JOIN om_visit_x_node ON om_visit_x_node.node_id=node.node_id 
    WHERE visit_id=visit_id_aux;
    
    --  Delete previous parameters with cost (if exists on the referenced node due with this update will insert again the same values
    DELETE FROM om_visit_work_x_node WHERE node_id=node_id_aux AND work_date=startdate_aux;

    -- check if exits multiplier parameter (action type=1)
    IF (SELECT count(*) FROM om_visit_event JOIN om_visit_parameter_x_parameter ON parameter_id=parameter_id1 
    JOIN om_visit_parameter ON parameter_id=om_visit_parameter.id WHERE visit_id=visit_id_aux AND action_type=1 AND feature_type='NODE')>0  THEN

	-- loop for those nodes that has the same attribute
	FOR rec_node IN SELECT node_id, startdate_aux as startdate, node.the_geom FROM node WHERE mu_id=mu_id_aux AND node.node_id!=node_id_aux 
	LOOP
	
		rec_node.startdate= (SELECT startdate::date from om_visit join om_visit_x_node on visit_id=om_visit.id where node_id=rec_node.node_id order by startdate desc limit 1 );


		count=count+1;
        
		-- inserting (or update) visits
		IF (rec_node.startdate < now()-interval'1 day') OR (rec_node.startdate IS NULL) THEN
	
			INSERT INTO om_visit (visitcat_id, ext_code, startdate, enddate, user_name, webclient_id, expl_id, descript, is_done,status)
			SELECT visitcat_id, ext_code, startdate, enddate, user_name, webclient_id, expl_id, descript, is_done, 4
			FROM om_visit WHERE id=visit_id_aux RETURNING id into id_last;
    
		    INSERT INTO om_visit_x_node (node_id, visit_id) VALUES (rec_node.node_id, id_last);
		ELSE 
		
		    SELECT visit_id INTO id_last FROM om_visit_x_node WHERE node_id=rec_node.node_id;

		END IF;

		raise notice 'NODE %' , rec_node.node_id;

		-- inserting (or not) parameters

		FOR rec_parameter IN SELECT * FROM om_visit_event JOIN om_visit_parameter_x_parameter ON parameter_id=parameter_id1 
		JOIN om_visit_parameter ON parameter_id=om_visit_parameter.id WHERE visit_id=visit_id_aux AND action_type=1 AND feature_type='NODE'
		LOOP 
			raise notice 'rec_parameter %' , rec_parameter;
			IF (SELECT parameter_id FROM om_visit_event WHERE visit_id=id_last AND parameter_id=rec_parameter.parameter_id2 limit 1) IS NULL THEN
			
				-- desmultiplier parameter (action_type=1)
				INSERT INTO om_visit_event (ext_code, visit_id, parameter_id, value, text) VALUES 
				(rec_parameter.ext_code, id_last, rec_parameter.parameter_id2, rec_parameter.value, rec_parameter.text) RETURNING id INTO id_event;
				
			END IF;

		END LOOP;

		FOR rec_parameter IN SELECT * FROM om_visit_event JOIN om_visit_parameter_x_parameter ON parameter_id=parameter_id1 
		JOIN om_visit_parameter ON parameter_id=om_visit_parameter.id WHERE visit_id=visit_id_aux AND action_type=4 AND feature_type='NODE'
		LOOP 

			IF (SELECT parameter_id FROM om_visit_event WHERE visit_id=id_last AND parameter_id=rec_parameter.parameter_id2 limit 1) IS NULL THEN

				-- sql parameter (action_type=4)
				query:=((SELECT action_value FROM om_visit_parameter_x_parameter WHERE 
				action_type=4 AND rec_parameter.parameter_id2=parameter_id1)||' WHERE node_id= '||quote_literal(rec_node.node_id));

				IF query is not null THEN
				    EXECUTE query;    
				END IF;
			
			END IF;
			
		END LOOP;

		FOR rec_parameter IN SELECT * FROM om_visit_event JOIN om_visit_parameter_x_parameter ON parameter_id=parameter_id1 
		JOIN om_visit_parameter ON parameter_id=om_visit_parameter.id WHERE visit_id=visit_id_aux AND action_type=5 AND feature_type='NODE'
		LOOP 

			IF (SELECT parameter_id FROM om_visit_event WHERE visit_id=id_last AND parameter_id=rec_parameter.parameter_id2 limit 1) IS NULL THEN

				--price parameter (action type=5)
				IF (SELECT parameter_id1 FROM om_visit_parameter_x_parameter WHERE parameter_id1=rec_parameter.parameter_id2 AND action_type=5) IS NOT NULL THEN
				
				    work_aux := (select action_value::text from om_visit_parameter_x_parameter WHERE parameter_id1=rec_parameter.parameter_id2 AND action_type=5);
				    builder_aux:= (select om_visit_cat.id from om_visit_cat JOIN om_visit ON om_visit_cat.id=om_visit.visitcat_id WHERE om_visit.id=visit_id_aux);
				    size_id_aux= (select size_id FROM node WHERE node_id=rec_node.node_id);
				    event_date_aux=(SELECT date(tstamp) FROM om_visit_event WHERE id=rec_parameter.id);
				    campaign_aux=(select id FROM cat_campaign WHERE start_date<=event_date_aux and end_date>=event_date_aux AND active = TRUE);
				    price_aux = (select price FROM cat_price WHERE size_id=size_id_aux AND work_id=work_aux AND campaign_id=campaign_aux);
				
				    INSERT INTO om_visit_work_x_node (node_id, work_id, work_date, builder_id, size_id, price, units, work_cost, event_id) values 
				    (rec_node.node_id, work_aux, startdate_aux, builder_aux, size_id_aux, price_aux, 1, price_aux*1, id_event);
				  
				END IF;
			END IF;
			
		END LOOP;

		IF rec_node.the_geom is not null then
		    concat_agg=concat(concat_agg, (SELECT concat('POINT (',st_x(the_geom),' ', st_y(the_geom),'),') FROM node WHERE node_id=rec_node.node_id)::text);
		END IF;
		
		UPDATE om_visit SET is_done=TRUE where id=visit_id_aux;

	END LOOP;


    

    IF count >0 THEN
        UPDATE om_visit_event SET parameter_id= rec_parameter.parameter_id2 WHERE parameter_id=rec_parameter.parameter_id AND visit_id=visit_id_aux;
    END IF;
    
      END IF;

          -- check if exits sql sentence parameter (action type=4)
     IF (SELECT count(*) FROM om_visit_event JOIN om_visit_parameter_x_parameter ON parameter_id=parameter_id1 
        JOIN om_visit_parameter ON parameter_id=om_visit_parameter.id WHERE visit_id=visit_id_aux AND action_type=4 AND feature_type='NODE')>0  THEN

        FOR event_aux IN SELECT om_visit_event.id FROM om_visit_event JOIN om_visit_parameter_x_parameter ON parameter_id=parameter_id1 
        JOIN om_visit_parameter ON parameter_id=om_visit_parameter.id WHERE visit_id=visit_id_aux AND action_type=4 AND feature_type='NODE'
        LOOP 
            query:=((SELECT action_value FROM om_visit_parameter_x_parameter JOIN om_visit_parameter ON om_visit_parameter.id=parameter_id1 
            JOIN om_visit_event ON parameter_id=parameter_id1 WHERE om_visit_event.id=event_aux )||' WHERE node_id='||quote_literal(node_id_aux)||';' );
            EXECUTE query;    
        END LOOP;

    END IF;

    -- check if exits price parameter (action type=5)
     IF (SELECT count(*) FROM om_visit_event JOIN om_visit_parameter_x_parameter ON parameter_id=parameter_id1 
        JOIN om_visit_parameter ON parameter_id=om_visit_parameter.id WHERE visit_id=visit_id_aux AND action_type=5 AND feature_type='NODE')>0  THEN

        FOR rec_parameter IN SELECT om_visit_event.id,  om_visit_parameter_x_parameter.* FROM om_visit_event JOIN om_visit_parameter_x_parameter ON parameter_id=parameter_id1 
        JOIN om_visit_parameter ON parameter_id=om_visit_parameter.id WHERE visit_id=visit_id_aux AND action_type=5 AND feature_type='NODE'

        LOOP
            work_aux := (select action_value::text from om_visit_parameter_x_parameter WHERE parameter_id1=rec_parameter.parameter_id1 AND action_type=5);
            builder_aux:= (select om_visit_cat.id from om_visit_cat JOIN om_visit ON om_visit_cat.id=om_visit.visitcat_id WHERE om_visit.id=visit_id_aux);
            size_id_aux= (select size_id FROM node WHERE node_id=node_id_aux);
            event_date_aux=(SELECT date(tstamp) FROM om_visit_event WHERE id=rec_parameter.id);
            campaign_aux=(select id FROM cat_campaign WHERE start_date<=event_date_aux and end_date>=event_date_aux AND active = TRUE);
            price_aux = (select price FROM cat_price WHERE size_id=size_id_aux AND work_id=work_aux AND campaign_id=campaign_aux);
               
            INSERT INTO om_visit_work_x_node (node_id, work_id, work_date, builder_id, size_id, price, units, work_cost, event_id) values 
            (node_id_aux, work_aux, startdate_aux, builder_aux, size_id_aux, price_aux, 1, price_aux*1, rec_parameter.id);
            
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
	    JOIN SCHEMA_NAME.om_visit_parameter_x_parameter ON parameter_id=om_visit_parameter_x_parameter.parameter_id2 
	    WHERE visit_id = ANY(v_visit_id)
	    AND action_type = 2
	    AND parameter_id = om_visit_parameter_x_parameter.parameter_id2
	    ORDER BY startdate LIMIT 1) IS NOT NULL THEN
	    		
		FOR rec_parameter IN 
		SELECT * FROM SCHEMA_NAME.om_visit_event 
		JOIN SCHEMA_NAME.om_visit ON visit_id=om_visit.id 
		JOIN SCHEMA_NAME.om_visit_parameter_x_parameter ON parameter_id=om_visit_parameter_x_parameter.parameter_id2 
		WHERE visit_id = ANY(v_visit_id)
		AND action_type = 2
		AND parameter_id1 = v_parameter
		AND parameter_id = om_visit_parameter_x_parameter.parameter_id2
		ORDER BY startdate desc LIMIT 1
		
		LOOP
		    
		    
		    IF rec_parameter.visit_id != visit_id_aux THEN
			-- incompatible events (action_type=2)
			-- rec_parameter.action_value is integer (0 = False / 1 = True)
		        UPDATE om_visit_event SET value2 = rec_parameter.action_value::integer WHERE visit_id = rec_parameter.visit_id AND parameter_id = rec_parameter.parameter_id2;
		    END IF;
		END LOOP;
		
	    END IF;

      -- adding the initial node to array
      concat_agg=concat(concat_agg, (SELECT concat('POINT (',st_x(the_geom),' ', st_y(the_geom),')') FROM node WHERE node_id=node_id_aux)::text);
      raise notice '%', concat_agg;
      

RETURN concat_agg;

         
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


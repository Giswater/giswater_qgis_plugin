/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2316


DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_pg2epa_nod2arc(varchar);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_nod2arc(result_id_var varchar, p_only_mandatory_nodarc boolean)  RETURNS integer 
AS $BODY$

/*example
select SCHEMA_NAME.gw_fct_pg2epa_nod2arc ('testbgeo3', true)
*/

DECLARE
v_node record;
v_arc record;
v_arc1 record;
v_arc2 record;
v_newarc record;
v_nodediam double precision;
v_arc_geom geometry;
v_node1_geom geometry;
v_node2_geom geometry;
v_arcreduced_geom geometry;
v_node_id text;
v_numarcs integer;
v_shortpipe record;
v_toarc text;
v_arc_id text;
v_error text;
v_nod2arc float;
v_querytext text;
v_arcsearchnodes float;
v_status text;
v_nodarc_min float;
v_count integer = 1;
v_buildupmode int2 = 2;
v_angle1 float;
v_angle2 float;

BEGIN

	--  Search path
	SET search_path = "ws", public;

	SELECT value INTO v_buildupmode FROM config_param_user WHERE parameter = 'inp_options_buildup_mode' AND cur_user=current_user;

	--  Looking for nodarc values
	SELECT min(st_length(the_geom)) FROM rpt_inp_arc JOIN inp_selector_sector ON inp_selector_sector.sector_id=rpt_inp_arc.sector_id WHERE result_id=result_id_var
		INTO v_nodarc_min;

	v_nod2arc := (SELECT value::float FROM config_param_user WHERE parameter = 'inp_options_nodarc_length' and cur_user=current_user limit 1)::float;
	IF v_nod2arc is null then 
		v_nod2arc = 0.3;
	END IF;
	
	IF v_nod2arc > v_nodarc_min-0.01 THEN
		v_nod2arc = v_nodarc_min-0.01;
	END IF;

	v_arcsearchnodes := 0.1;
    
	--  Move valves to arc
	RAISE NOTICE 'Start loop.....';

	-- taking nod2arcs with less than two arcs
	DELETE FROM anl_node WHERE fprocesscat_id=67 and cur_user=current_user;
	INSERT INTO anl_node (fprocesscat_id, node_id, nodecat_id, the_geom, descript)
	SELECT 67, a.node_id, a.nodecat_id, a.the_geom, 'Node2arc with less than two arcs' FROM (
		SELECT node_id, nodecat_id, v_edit_node.the_geom FROM v_edit_node JOIN v_edit_arc a1 ON node_id=a1.node_1
		WHERE v_edit_node.epa_type IN ('SHORTPIPE', 'VALVE', 'PUMP') AND a1.sector_id IN (SELECT sector_id FROM inp_selector_sector WHERE cur_user=current_user)
			UNION ALL
		SELECT node_id, nodecat_id, v_edit_node.the_geom FROM v_edit_node JOIN v_edit_arc a1 ON node_id=a1.node_2
		WHERE v_edit_node.epa_type IN ('SHORTPIPE', 'VALVE', 'PUMP') AND a1.sector_id IN (SELECT sector_id FROM inp_selector_sector WHERE cur_user=current_user))a
	GROUP by node_id, nodecat_id, the_geom
	HAVING count(*) < 2;


	IF v_buildupmode = 1 THEN

		-- taking nod2arcs with more than two arcs
		DELETE FROM anl_node WHERE fprocesscat_id=66 and cur_user=current_user;
		INSERT INTO anl_node (fprocesscat_id, node_id, nodecat_id, the_geom, descript)
		SELECT 66, a.node_id, a.nodecat_id, a.the_geom, 'Node2arc with more than two arcs' FROM (
			SELECT node_id, nodecat_id, v_edit_node.the_geom FROM v_edit_node JOIN v_edit_arc a1 ON node_id=a1.node_1
			WHERE v_edit_node.epa_type IN ('SHORTPIPE', 'VALVE', 'PUMP') AND a1.sector_id IN (SELECT sector_id FROM inp_selector_sector WHERE cur_user=current_user)
			UNION ALL
			SELECT node_id, nodecat_id, v_edit_node.the_geom FROM v_edit_node JOIN v_edit_arc a1 ON node_id=a1.node_2
			WHERE v_edit_node.epa_type IN ('SHORTPIPE', 'VALVE', 'PUMP') AND a1.sector_id IN (SELECT sector_id FROM inp_selector_sector WHERE cur_user=current_user))a
		GROUP by node_id, nodecat_id, the_geom
		HAVING count(*) > 2;
	
		v_querytext = 'SELECT a.node_id FROM rpt_inp_node a JOIN inp_valve ON a.node_id=inp_valve.node_id WHERE result_id='||quote_literal(result_id_var)||'
				AND a.node_id NOT IN (SELECT node_id FROM anl_node WHERE fprocesscat_id IN (66,67) and cur_user=current_user) UNION 
				SELECT a.node_id FROM rpt_inp_node a JOIN inp_pump ON a.node_id=inp_pump.node_id WHERE result_id='||quote_literal(result_id_var)||'
				AND a.node_id NOT IN (SELECT node_id FROM anl_node WHERE fprocesscat_id IN (66,67) and cur_user=current_user) UNION 
				SELECT a.node_id FROM rpt_inp_node a JOIN inp_shortpipe ON a.node_id=inp_shortpipe.node_id WHERE result_id='||quote_literal(result_id_var)||
				' AND to_arc IS NOT NULL AND a.node_id NOT IN (SELECT node_id FROM anl_node WHERE fprocesscat_id IN (66,67) and cur_user=current_user)';

	ELSIF v_buildupmode > 1 AND p_only_mandatory_nodarc THEN
		v_querytext = 'SELECT a.node_id FROM rpt_inp_node a JOIN inp_valve ON a.node_id=inp_valve.node_id WHERE result_id='||quote_literal(result_id_var)||' 
				AND a.node_id NOT IN (SELECT node_id FROM anl_node WHERE fprocesscat_id IN (67) and cur_user=current_user) UNION  
				SELECT a.node_id FROM rpt_inp_node a JOIN inp_pump ON a.node_id=inp_pump.node_id WHERE result_id='||quote_literal(result_id_var)||' 
				AND a.node_id NOT IN (SELECT node_id FROM anl_node WHERE fprocesscat_id IN (67) and cur_user=current_user) UNION 
				SELECT a.node_id FROM rpt_inp_node a JOIN inp_shortpipe ON a.node_id=inp_shortpipe.node_id WHERE result_id='||quote_literal(result_id_var)||
				' AND to_arc IS NOT NULL AND a.node_id NOT IN (SELECT node_id FROM anl_node WHERE fprocesscat_id IN (67) and cur_user=current_user)';
			
	ELSIF v_buildupmode > 1 AND p_only_mandatory_nodarc IS FALSE THEN
		v_querytext = 'SELECT a.node_id FROM rpt_inp_node a JOIN inp_valve ON a.node_id=inp_valve.node_id WHERE result_id ='||quote_literal(result_id_var)||' 
				 AND a.node_id NOT IN (SELECT node_id FROM anl_node WHERE fprocesscat_id IN (67) and cur_user=current_user) UNION 
				SELECT a.node_id FROM rpt_inp_node a JOIN inp_pump ON a.node_id=inp_pump.node_id WHERE result_id ='||quote_literal(result_id_var)||' 
				 AND a.node_id NOT IN (SELECT node_id FROM anl_node WHERE fprocesscat_id IN (67) and cur_user=current_user) UNION 
				SELECT a.node_id FROM rpt_inp_node a JOIN inp_shortpipe ON a.node_id=inp_shortpipe.node_id WHERE result_id ='||quote_literal(result_id_var)||'
				 AND a.node_id NOT IN (SELECT node_id FROM anl_node WHERE fprocesscat_id IN (67) and cur_user=current_user)';
	END IF;

    FOR v_node_id IN EXECUTE v_querytext
    LOOP
    
	v_count = v_count + 1;
	
        -- Get node data
	SELECT * INTO v_node FROM rpt_inp_node WHERE node_id = v_node_id AND result_id=result_id_var;

        -- Get arc data
        SELECT COUNT(*) INTO v_numarcs FROM rpt_inp_arc WHERE (node_1 = v_node_id OR node_2 = v_node_id) AND result_id=result_id_var;

        -- Get arcs
        SELECT * INTO v_arc1 FROM rpt_inp_arc WHERE node_1 = v_node_id AND result_id=result_id_var;
        SELECT * INTO v_arc2 FROM rpt_inp_arc WHERE node_2 = v_node_id AND result_id=result_id_var;

        IF v_numarcs = 0 THEN
            CONTINUE;      
        
        ELSIF v_numarcs = 1 THEN

            -- Compute valve geometry
            IF v_arc2 ISNULL THEN

                -- Use arc 1 as reference
                v_newarc = v_arc1;
                v_node1_geom := ST_StartPoint(v_arc1.the_geom);
                v_node2_geom := ST_LineInterpolatePoint(v_arc1.the_geom, v_nod2arc / ST_Length(v_arc1.the_geom));

                -- Correct arc geometry
                v_arcreduced_geom := ST_LineSubstring(v_arc1.the_geom,ST_LineLocatePoint(v_arc1.the_geom,v_node2_geom),1);
       		IF ST_GeometryType(v_arcreduced_geom) != 'ST_LineString' THEN
			v_error = concat(v_arc1.arc_id,',',ST_GeometryType(v_arcreduced_geom));
			PERFORM audit_function(2022,2316,v_error);
		END IF;    
		UPDATE rpt_inp_arc SET the_geom = v_arcreduced_geom, node_1 = (SELECT concat(v_node_id, '_n2a_2')) WHERE arc_id = v_arc1.arc_id AND result_id=result_id_var; 
 	    
            ELSIF v_arc1 ISNULL THEN
 
                -- Use arc 2 as reference
                v_newarc = v_arc2;
                v_node2_geom := ST_EndPoint(v_arc2.the_geom);
                v_node1_geom := ST_LineInterpolatePoint(v_arc2.the_geom, 1 - v_nod2arc / ST_Length(v_arc2.the_geom));

                -- Correct arc geometry
                v_arcreduced_geom := ST_LineSubstring(v_arc2.the_geom,0,ST_LineLocatePoint(v_arc2.the_geom,v_node1_geom));
		IF ST_GeometryType(v_arcreduced_geom) != 'ST_LineString' THEN
			v_error = concat(v_arc1.arc_id,',',ST_GeometryType(v_arcreduced_geom));
			PERFORM audit_function(2022,2316,v_error);
		END IF;
                UPDATE rpt_inp_arc SET the_geom = v_arcreduced_geom, node_2 = (SELECT concat(v_node_id, '_n2a_1')) WHERE arc_id = v_arc2.arc_id AND result_id=result_id_var;

            END IF;

        ELSIF v_numarcs = 2 THEN

            -- Two 'node_2' arcs
            IF v_arc1 ISNULL THEN

                -- Get arcs
                SELECT * INTO v_arc2 FROM rpt_inp_arc WHERE node_2 = v_node_id AND result_id=result_id_var ORDER BY arc_id DESC LIMIT 1;
                SELECT * INTO v_arc1 FROM rpt_inp_arc WHERE node_2 = v_node_id AND result_id=result_id_var ORDER BY arc_id ASC LIMIT 1;

                -- Use arc 1 as reference (TODO: Why?)
                v_newarc = v_arc1;
    
                -- TODO: Control pipe shorter than 0.5 m!
                v_node1_geom := ST_LineInterpolatePoint(v_arc2.the_geom, 1 - v_nod2arc / ST_Length(v_arc2.the_geom) / 2);
                v_node2_geom := ST_LineInterpolatePoint(v_arc1.the_geom, 1 - v_nod2arc / ST_Length(v_arc1.the_geom) / 2);

                -- Correct arc geometry
                v_arcreduced_geom := ST_LineSubstring(v_arc1.the_geom,0,ST_LineLocatePoint(v_arc1.the_geom,v_node2_geom));
		IF ST_GeometryType(v_arcreduced_geom) != 'ST_LineString' THEN
			v_error = concat(v_arc1.arc_id,',',ST_GeometryType(v_arcreduced_geom));
			PERFORM audit_function(2022,2316,v_error);
		END IF;
                UPDATE rpt_inp_arc AS a SET the_geom = v_arcreduced_geom, node_2 = (SELECT concat(v_node_id, '_n2a_2')) WHERE a.arc_id = v_arc1.arc_id AND result_id=result_id_var; 

                v_arcreduced_geom := ST_LineSubstring(v_arc2.the_geom,0,ST_LineLocatePoint(v_arc2.the_geom,v_node1_geom));
		IF ST_GeometryType(v_arcreduced_geom) != 'ST_LineString' THEN
			v_error = concat(v_arc1.arc_id,',',ST_GeometryType(v_arcreduced_geom));
			PERFORM audit_function(2022,2316,v_error);
		END IF;
                UPDATE rpt_inp_arc SET the_geom = v_arcreduced_geom, node_2 = (SELECT concat(v_node_id, '_n2a_1')) WHERE a.arc_id = v_arc2.arc_id AND result_id=result_id_var;


            -- Two 'node_1' arcs
            ELSIF v_arc2 ISNULL THEN

                -- Get arcs
                SELECT * INTO v_arc1 FROM rpt_inp_arc WHERE node_1 = v_node_id AND result_id=result_id_var ORDER BY arc_id DESC LIMIT 1;
                SELECT * INTO v_arc2 FROM rpt_inp_arc WHERE node_1 = v_node_id AND result_id=result_id_var ORDER BY arc_id ASC LIMIT 1;

                -- Use arc 1 as reference (TODO: Why?)
                v_newarc = v_arc1;
    
                -- TODO: Control arc shorter than 0.5 m!
                v_node1_geom := ST_LineInterpolatePoint(v_arc2.the_geom, v_nod2arc / ST_Length(v_arc2.the_geom) / 2);
                v_node2_geom := ST_LineInterpolatePoint(v_arc1.the_geom, v_nod2arc / ST_Length(v_arc1.the_geom) / 2);

                -- Correct arc geometry
                v_arcreduced_geom := ST_LineSubstring(v_arc1.the_geom,ST_LineLocatePoint(v_arc1.the_geom,v_node2_geom),1);
		IF ST_GeometryType(v_arcreduced_geom) != 'ST_LineString' THEN
			v_error = concat(v_arc1.arc_id,',',ST_GeometryType(v_arcreduced_geom));
			PERFORM audit_function(2022,2316,v_error);
		END IF;
                UPDATE rpt_inp_arc AS a SET the_geom = v_arcreduced_geom, node_1 = (SELECT concat(v_node_id, '_n2a_2')) WHERE a.arc_id = v_arc1.arc_id AND result_id=result_id_var; 

                v_arcreduced_geom := ST_LineSubstring(v_arc2.the_geom,ST_LineLocatePoint(v_arc2.the_geom,v_node1_geom),1);
		IF ST_GeometryType(v_arcreduced_geom) != 'ST_LineString' THEN
			v_error = concat(v_arc1.arc_id,',',ST_GeometryType(v_arcreduced_geom));
			PERFORM audit_function(2022,2316,v_error);
		END IF;
                UPDATE rpt_inp_arc SET the_geom = v_arcreduced_geom, node_1 = (SELECT concat(v_node_id, '_n2a_1')) WHERE a.arc_id = v_arc2.arc_id AND result_id=result_id_var;
                        

            -- One 'node_1' and one 'node_2'
            ELSE

                -- Use arc 1 as reference (TODO: Why?)
                v_newarc = v_arc1;

		-- control pipes
                IF ST_Length(v_arc2.the_geom)/2 < v_nod2arc OR ST_Length(v_arc1.the_geom)/2 <  v_nod2arc THEN
			--RAISE EXCEPTION 'It''s impossible to continue. Nodarc % has close pipes with length:( %, % ) versus nodarc length ( % )', v_node_id, ST_Length(v_arc2.the_geom), ST_Length(v_arc1.the_geom),v_nod2arc ;
			v_nod2arc = 0.001;
                END IF;
    
                v_node1_geom := ST_LineInterpolatePoint(v_arc2.the_geom, 1 - v_nod2arc / ST_Length(v_arc2.the_geom) / 2);
                v_node2_geom := ST_LineInterpolatePoint(v_arc1.the_geom, v_nod2arc / ST_Length(v_arc1.the_geom) / 2);

                -- Correct arc geometry
                v_arcreduced_geom := ST_LineSubstring(v_arc1.the_geom,ST_LineLocatePoint(v_arc1.the_geom,v_node2_geom),1);
		IF ST_GeometryType(v_arcreduced_geom) != 'ST_LineString' THEN
			v_error = concat(v_arc1.arc_id,',',ST_GeometryType(v_arcreduced_geom));
			PERFORM audit_function(2022,2316,v_error);
		END IF;
                UPDATE rpt_inp_arc AS a SET the_geom = v_arcreduced_geom, node_1 = (SELECT concat(a.node_1, '_n2a_2')) WHERE a.arc_id = v_arc1.arc_id AND result_id=result_id_var; 

                v_arcreduced_geom := ST_LineSubstring(v_arc2.the_geom,0,ST_LineLocatePoint(v_arc2.the_geom,v_node1_geom));
		IF ST_GeometryType(v_arcreduced_geom) != 'ST_LineString' THEN
			v_error = concat(v_arc1.arc_id,',',ST_GeometryType(v_arcreduced_geom));
			PERFORM audit_function(2022,2316,v_error);
		END IF;
                UPDATE rpt_inp_arc SET the_geom = v_arcreduced_geom, node_2 = (SELECT concat(a.node_2, '_n2a_1')) WHERE a.arc_id = v_arc2.arc_id AND result_id=result_id_var;
                        
            END IF;

        ELSIF v_numarcs > 2 THEN

		-- get arc with maximun radial separation againts others
		v_angle1 = 0;
		v_angle2 = 0;
		
		FOR v_arc1 IN (SELECT *, case when ST_Azimuth (st_startpoint(the_geom), st_endpoint(the_geom)) > 3.14 then abs(ST_Azimuth (st_startpoint(the_geom), st_endpoint(the_geom))-6.28) 
		else ST_Azimuth (st_startpoint(the_geom), st_endpoint(the_geom)) end as angle FROM 
		(SELECT * FROM rpt_inp_arc WHERE node_1 = v_node_id AND result_id=result_id_var UNION SELECT * FROM rpt_inp_arc WHERE node_2 = v_node_id AND result_id=result_id_var)a)
		LOOP		
			FOR v_arc2 IN (SELECT *,case when ST_Azimuth (st_startpoint(the_geom), st_endpoint(the_geom)) > 3.14 then abs(ST_Azimuth (st_startpoint(the_geom), st_endpoint(the_geom))-6.28) 
			else ST_Azimuth (st_startpoint(the_geom), st_endpoint(the_geom)) end as angle FROM
			(SELECT * FROM rpt_inp_arc WHERE node_1 = v_node_id AND result_id=result_id_var UNION SELECT * FROM rpt_inp_arc WHERE node_2 = v_node_id AND result_id=result_id_var)a)
			LOOP 
				v_angle2 = v_angle2 + abs(v_arc1.angle - v_arc2.angle);
			END LOOP;

			-- setting new value of arc
			IF  v_angle2 > v_angle1 THEN
				v_arc = v_arc2;
				v_angle1 = v_angle2;
			END IF;
			v_angle2 = 0;
			
		END LOOP;

                -- Use arc as reference
                v_newarc = v_arc;

		IF v_arc.node_1 = v_node.node_id THEN
			v_node1_geom := ST_StartPoint(v_arc1.the_geom);
			v_node2_geom := ST_LineInterpolatePoint(v_arc1.the_geom, v_nod2arc / ST_Length(v_arc1.the_geom));

			-- Correct arc geometry
			v_arcreduced_geom := ST_LineSubstring(v_arc1.the_geom,ST_LineLocatePoint(v_arc1.the_geom,v_node2_geom),1);
			IF ST_GeometryType(v_arcreduced_geom) != 'ST_LineString' THEN
				v_error = concat(v_arc1.arc_id,',',ST_GeometryType(v_arcreduced_geom));
				PERFORM audit_function(2022,2316,v_error);
			END IF;    
			UPDATE rpt_inp_arc SET the_geom = v_arcreduced_geom, node_1 = (SELECT concat(v_node_id, '_n2a_2')) WHERE arc_id = v_arc1.arc_id AND result_id=result_id_var; 
 	    
		ELSIF v_arc.node_2 = v_node.node_id THEN
			v_node2_geom := ST_EndPoint(v_arc2.the_geom);
			v_node1_geom := ST_LineInterpolatePoint(v_arc2.the_geom, 1 - v_nod2arc / ST_Length(v_arc2.the_geom));

			-- Correct arc geometry
			v_arcreduced_geom := ST_LineSubstring(v_arc2.the_geom,0,ST_LineLocatePoint(v_arc2.the_geom,v_node1_geom));
			IF ST_GeometryType(v_arcreduced_geom) != 'ST_LineString' THEN
				v_error = concat(v_arc1.arc_id,',',ST_GeometryType(v_arcreduced_geom));
				PERFORM audit_function(2022,2316,v_error);
			END IF;
			UPDATE rpt_inp_arc SET the_geom = v_arcreduced_geom, node_2 = (SELECT concat(v_node_id, '_n2a_1')) WHERE arc_id = v_arc2.arc_id AND result_id=result_id_var;
		END IF; 
        END IF;

        -- Create new arc geometry
        v_arc_geom := ST_MakeLine(v_node1_geom, v_node2_geom);

        -- Values to insert into arc table
        v_newarc.arc_id := concat(v_node_id, '_n2a');   
	v_newarc.arccat_id := v_node.nodecat_id;
	v_newarc.epa_type := v_node.epa_type;
        v_newarc.sector_id := v_node.sector_id;
        v_newarc.state := v_node.state;
        v_newarc.state_type := v_node.state_type;
        v_newarc.annotation := v_node.annotation;
        v_newarc.length := ST_length2d(v_arc_geom);
        v_newarc.the_geom := v_arc_geom;
        v_newarc.minorloss := v_node.childparam->>'minorloss';
        v_newarc.diameter := v_node.childparam->>'diameter';
        v_newarc.status := v_node.childparam->>'status';
        v_newarc.childparam := gw_fct_json_object_delete_keys(v_node.childparam, 'minorloss', 'diameter', 'status');
       
        -- Identifing and updating (if it's needed) the right direction
	SELECT to_arc,status INTO v_toarc, v_status FROM (SELECT node_id,to_arc,status FROM inp_valve UNION SELECT node_id,to_arc,status FROM inp_shortpipe UNION 
								SELECT node_id,to_arc,status FROM inp_pump) a WHERE node_id=v_node_id;

	SELECT arc_id INTO v_arc_id FROM rpt_inp_arc WHERE (ST_DWithin(ST_endpoint(v_newarc.the_geom), rpt_inp_arc.the_geom, v_arcsearchnodes)) AND result_id=result_id_var
			ORDER BY ST_Distance(rpt_inp_arc.the_geom, ST_endpoint(v_newarc.the_geom)) LIMIT 1;

	IF v_arc_id=v_toarc THEN
		v_newarc.node_1 := concat(v_node_id, '_n2a_1');
		v_newarc.node_2 := concat(v_node_id, '_n2a_2');
	ELSE
		v_newarc.node_2 := concat(v_node_id, '_n2a_1');
		v_newarc.node_1 := concat(v_node_id, '_n2a_2');
		v_newarc.the_geom := st_reverse(v_newarc.the_geom);
	END IF; 

        -- Inserting new arc into arc table
        INSERT INTO rpt_inp_arc (result_id, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, state, state_type, diameter, roughness, annotation, length, status, the_geom, minorloss, chidparam)
	VALUES(result_id_var, v_newarc.arc_id, v_newarc.node_1, v_newarc.node_2, 'NODE2ARC', v_newarc.arccat_id, v_newarc.epa_type, v_newarc.sector_id, 
	v_newarc.state, v_newarc.state_type, v_newarc.diameter, v_newarc.roughness, v_newarc.annotation, v_newarc.length, v_status, v_newarc.the_geom, v_newarc.minorloss, v_newarc.childparam);

        -- Inserting new node1 into node table
        v_node.epa_type := 'JUNCTION';
        v_node.the_geom := v_node1_geom;
        v_node.node_id := concat(v_node_id, '_n2a_1');
        INSERT INTO rpt_inp_node (result_id, node_id, elevation, elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation, demand, the_geom) 
	VALUES(result_id_var, v_node.node_id, v_node.elevation, v_node.elev, 'NODE2ARC', v_node.nodecat_id, v_node.epa_type, 
	v_node.sector_id, v_node.state, v_node.state_type, v_node.annotation, 0, v_node.the_geom);

        -- Inserting new node2 into node table
        v_node.epa_type := 'JUNCTION';
        v_node.the_geom := v_node2_geom;
        v_node.node_id := concat(v_node_id, '_n2a_2');
        INSERT INTO rpt_inp_node (result_id, node_id, elevation, elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation, demand, the_geom) 
	VALUES(result_id_var, v_node.node_id, v_node.elevation, v_node.elev, 'NODE2ARC', v_node.nodecat_id, v_node.epa_type, 
	v_node.sector_id, v_node.state, v_node.state_type, v_node.annotation, 0, v_node.the_geom);

        -- Deleting old node from node table
        DELETE FROM rpt_inp_node WHERE node_id =  v_node_id AND result_id=result_id_var;

    END LOOP;

    RETURN 1;
		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

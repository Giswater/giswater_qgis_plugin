/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2224

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_nod2arc(result_id_var character varying)
    RETURNS integer
AS $BODY$

/*
SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${"client":{"device":4, "infoType":1, "lang":"ES"}, "data":{"resultId":"test1", "useNetworkGeom":"false", "dumpSubcatch":"true"}}$$)

SELECT * FROM SCHEMA_NAME.temp_t_arc

*/


DECLARE

rec_node record;
rec_arc1 record;
rec_arc2 record;
rec_arc record;
rec_new_arc record;
rec_flowreg record;
nodarc_rec record;

v_nodarc_node_1_geom public.geometry;
v_nodarc_node_2_geom public.geometry;
v_arc_reduced_geom public.geometry;
v_arc text;
v_node_1 text;
v_node_2 text;
v_geom public.geometry;
v_node_yinit double precision;
v_counter integer;
odd_var float;
angle float;
dist float;

n1_geom public.geometry;
n2_geom public.geometry;
p1_geom public.geometry;
p2_geom public.geometry;
xp1 float;
yp1 float;
xp2 float;
yp2 float;
old_node_id text;
old_to_arc text;
epa_type_aux text;
v_version record;
v_count integer = 1;
old_node_2 varchar;
max_flwreg_length numeric;
arc_geom_old_node integer = -1;
arc_geom_old_to_arc2 integer = -1;


BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	SELECT * INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;


	--  Move valves to arc
	RAISE NOTICE 'Starting process of nodarcs';
	INSERT INTO temp_t_element SELECT * FROM element;

	-- setting record_new_arc
	SELECT * INTO rec_new_arc FROM temp_t_arc LIMIT 1;

	-- TODO: review this code, with new elements logic of flow regulators
	FOR rec_flowreg IN
		SELECT element_id, to_arc, flwreg_length, flw_type, epa_type, node_id FROM
		(
			SELECT temp_t_element.element_id, to_arc, flwreg_length, 'OR'::text as flw_type, node_id, 'FRORIFICE' as epa_type FROM inp_frorifice join man_frelem using (element_id)
			JOIN temp_t_element ON temp_t_element.element_id = man_frelem.element_id
			JOIN selector_sector ON selector_sector.sector_id=temp_t_element.sector_id
			UNION
			SELECT temp_t_element.element_id, to_arc, flwreg_length, 'OT'::text as flw_type, node_id, 'FROUTLET' as epa_type FROM inp_froutlet join man_frelem using (element_id)
			JOIN temp_t_element ON temp_t_element.element_id = man_frelem.element_id
			JOIN selector_sector ON selector_sector.sector_id=temp_t_element.sector_id
			UNION
			SELECT temp_t_element.element_id, to_arc, flwreg_length, 'PU'::text as flw_type, node_id, 'FRPUMP' as epa_type FROM inp_frpump join man_frelem using (element_id)
			JOIN temp_t_element ON temp_t_element.element_id = man_frelem.element_id
			JOIN selector_sector ON selector_sector.sector_id=temp_t_element.sector_id
			UNION
			SELECT temp_t_element.element_id, to_arc, flwreg_length, 'WE'::text as flw_type, node_id, 'FRWEIR' as epa_type FROM inp_frweir join man_frelem using (element_id)
			JOIN temp_t_element ON temp_t_element.element_id = man_frelem.element_id
			JOIN selector_sector ON selector_sector.sector_id=temp_t_element.sector_id
		) a
		ORDER BY node_id, to_arc, flw_type, element_id

	LOOP
		-- Getting data from node
		SELECT * INTO rec_node FROM temp_t_node WHERE node_id = rec_flowreg.node_id::text;

		SELECT max(flwreg_length) INTO max_flwreg_length FROM man_frelem WHERE node_id=rec_flowreg.node_id AND to_arc=rec_flowreg.to_arc;
		
		IF arc_geom_old_node != rec_flowreg.node_id OR arc_geom_old_to_arc2 != rec_flowreg.to_arc THEN
			SELECT the_geom INTO v_geom FROM temp_t_arc WHERE arc_id=rec_flowreg.to_arc::text;
		END IF;	
		-- Getting data from arc
		SELECT arc_id, node_1, node_2 INTO v_arc, v_node_1, v_node_2 FROM temp_t_arc WHERE arc_id=rec_flowreg.to_arc::text;

		arc_geom_old_node = rec_flowreg.node_id;
		arc_geom_old_to_arc2 = rec_flowreg.to_arc;
		IF v_arc IS NULL THEN

		ELSE
			IF v_node_2=rec_flowreg.node_id::text THEN

				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"2038", "function":"2240","parameters":{"arc_id":"'||v_arc||'"}, "is_process":true}}$$);';

			ELSE
				-- Create the extrem nodes of the new nodarc
				v_nodarc_node_1_geom := ST_StartPoint(v_geom);
				v_nodarc_node_2_geom := ST_LineInterpolatePoint(v_geom, (max_flwreg_length / ST_Length(v_geom)));

				-- Correct old arc geometry
				v_arc_reduced_geom := ST_LineSubstring(v_geom, (max_flwreg_length / ST_Length(v_geom)),1);
				UPDATE temp_t_arc SET the_geom = v_arc_reduced_geom WHERE arc_id = v_arc;

				IF ST_GeometryType(v_arc_reduced_geom) != 'ST_LineString' THEN
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
					"data":{"message":"2040", "function":"2240","parameters":{"arc_id":"'||rec_arc1.arc_id||'", "geom_type":"'||ST_GeometryType(v_arc_reduced_geom)||'"}, "is_process":true}}$$);';
				END IF;

				IF old_node_id = rec_flowreg.node_id::text AND old_to_arc = rec_flowreg.to_arc::text THEN
					rec_new_arc.node_2 = old_node_2;

				ELSIF old_node_id = rec_flowreg.node_id::text AND old_to_arc != rec_flowreg.to_arc::text THEN
					v_count = v_count + 1;
					rec_new_arc.node_2 = concat(rec_node.node_id,'VN', v_count);

				ELSIF old_node_id != rec_flowreg.node_id::text OR old_node_id IS NULL THEN
					v_count = 1;
					rec_new_arc.node_2 = concat(rec_node.node_id,'VN', v_count);
				END IF;

				-- Values to insert into arc table
				rec_new_arc.arc_id := rec_flowreg.element_id;
				rec_new_arc.node_1:= rec_node.node_id;
				rec_new_arc.arc_type:= 'NODE2ARC';
				rec_new_arc.arccat_id := 'MAINSTREAM';
				rec_new_arc.epa_type := rec_flowreg.epa_type;
				rec_new_arc.sector_id := rec_node.sector_id;
				rec_new_arc.state := rec_node.state;
				rec_new_arc.state_type := rec_node.state_type;
				rec_new_arc.expl_id := rec_node.expl_id;
				rec_new_arc.annotation := rec_node.annotation;

				-- Create new arc geometry
				rec_new_arc.the_geom := ST_MakeLine(v_nodarc_node_1_geom, v_nodarc_node_2_geom);

				-- Inserting new arc into arc table
				INSERT INTO temp_t_arc (result_id, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation, length, expl_id, the_geom)
				VALUES(result_id_var, rec_new_arc.arc_id, rec_new_arc.node_1, rec_new_arc.node_2, rec_new_arc.arc_type, rec_new_arc.arccat_id,
				rec_new_arc.epa_type, rec_new_arc.sector_id, rec_new_arc.state, rec_new_arc.state_type, rec_new_arc.annotation, rec_new_arc.length, rec_new_arc.expl_id, rec_new_arc.the_geom);


				IF old_node_id= rec_flowreg.node_id::text AND old_to_arc =rec_flowreg.to_arc::text THEN
					v_counter:=v_counter+1;

					-- Right or left hand
					odd_var = v_counter %2;

					IF (odd_var)=0 then
						angle=(ST_Azimuth(ST_startpoint(rec_new_arc.the_geom), ST_endpoint(rec_new_arc.the_geom)))+1.57;
					ELSE
						angle=(ST_Azimuth(ST_startpoint(rec_new_arc.the_geom), ST_endpoint(rec_new_arc.the_geom)))-1.57;
					END IF;

					-- Geometry construction from pattern arc
					-- intermediate variables
					n1_geom = ST_LineInterpolatePoint(rec_new_arc.the_geom, 0.4);
					n2_geom = ST_LineInterpolatePoint(rec_new_arc.the_geom, 0.6);
					dist = (ST_Distance(ST_transform(ST_startpoint(rec_new_arc.the_geom),v_version.epsg), ST_LineInterpolatePoint(rec_new_arc.the_geom, 0.3)));

					--create point1
					yp1 = ST_y(n1_geom)-(cos(angle))*dist*0.1*(v_counter)::float;
					xp1 = ST_x(n1_geom)-(sin(angle))*dist*0.1*(v_counter)::float;
					p1_geom = ST_SetSRID(ST_MakePoint(xp1, yp1),v_version.epsg);

					--create point2
					yp2 = ST_y(n2_geom)-cos(angle)*dist*0.1*(v_counter)::float;
					xp2 = ST_x(n2_geom)-sin(angle)*dist*0.1*(v_counter)::float;
					p2_geom = ST_SetSRID(ST_MakePoint(xp2, yp2),v_version.epsg);

					--create the modified geom
					rec_new_arc.the_geom=ST_makeline(ARRAY[ST_startpoint(rec_new_arc.the_geom), p1_geom, p2_geom, ST_endpoint(rec_new_arc.the_geom)]);
					UPDATE temp_t_arc SET arccat_id='SECONDARY', the_geom=rec_new_arc.the_geom WHERE arc_id = rec_flowreg.element_id::text;
				ELSE
					-- Inserting new node into node table
					rec_node.epa_type := 'JUNCTION';
					rec_node.the_geom := v_nodarc_node_1_geom;
					v_node_yinit =(SELECT value::float FROM config_param_user WHERE parameter='epa_junction_y0_vdefault' AND cur_user=current_user);
					IF v_node_yinit IS NULL THEN v_node_yinit = 0; END IF;

					INSERT INTO temp_t_node (result_id, node_id, top_elev, ymax, elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation, y0, ysur, apond, expl_id, the_geom)
					VALUES (result_id_var, rec_new_arc.node_2, rec_node.top_elev, (rec_node.top_elev-rec_node.elev), rec_node.elev, rec_node.node_type, rec_node.nodecat_id, rec_node.epa_type,
					rec_node.sector_id, rec_node.state, rec_node.state_type, rec_node.annotation, v_node_yinit, rec_node.ysur, rec_node.apond, rec_node.expl_id, v_nodarc_node_2_geom)
					ON CONFLICT (node_id) DO NOTHING;

					SELECT * INTO nodarc_rec FROM temp_t_arc WHERE arc_id=concat(rec_flowreg.node_id,rec_flowreg.flw_type);

					-- udpating the feature
					v_counter :=1;
				END IF;

				old_node_id= rec_flowreg.node_id;
				old_to_arc= rec_flowreg.to_arc;
				old_node_2 = rec_new_arc.node_2;

				UPDATE temp_t_arc SET node_1 = rec_new_arc.node_2 WHERE arc_id = rec_flowreg.to_arc::text;

				IF rec_flowreg.epa_type = 'FRPUMP' THEN
					INSERT INTO temp_t_arc_flowregulator (arc_id, type, curve_id, status, startup, shutoff)
					SELECT rec_new_arc.arc_id, 'PUMP', curve_id, status, startup, shutoff
					FROM ve_inp_frpump
					WHERE ve_inp_frpump.element_id = rec_flowreg.element_id;
				ELSIF rec_flowreg.epa_type = 'FRORIFICE' THEN
					INSERT INTO temp_t_arc_flowregulator (arc_id, type, ori_type, offsetval, cd, orate, flap, shape, geom1, geom2, geom3, geom4)
					SELECT rec_new_arc.arc_id, 'ORIFICE', orifice_type, offsetval, cd, orate, flap, shape, geom1, geom2, 0, 0
					FROM ve_inp_frorifice
					WHERE ve_inp_frorifice.element_id = rec_flowreg.element_id;
				ELSIF rec_flowreg.epa_type = 'FROUTLET' THEN
					INSERT INTO temp_t_arc_flowregulator (arc_id, type, outlet_type, offsetval, curve_id, cd1, cd2, flap)
					SELECT rec_new_arc.arc_id, 'OUTLET', outlet_type, offsetval,curve_id, cd1, cd2, flap
					FROM ve_inp_froutlet
					WHERE ve_inp_froutlet.element_id = rec_flowreg.element_id;
				ELSIF rec_flowreg.epa_type = 'FRWEIR' THEN
					INSERT INTO temp_t_arc_flowregulator (arc_id, type, weir_type, offsetval, cd, ec, cd2, flap, shape, geom1, geom2, geom3, geom4, road_width,
					road_surf, coef_curve, surcharge)
					SELECT rec_new_arc.arc_id, 'WEIR', weir_type, offsetval, cd, ec, cd2, flap, inp_typevalue.descript, geom1, geom2, geom3, geom4, road_width,
					road_surf, coef_curve, surcharge
					FROM ve_inp_frweir
					LEFT JOIN inp_typevalue ON inp_typevalue.id::text = ve_inp_frweir.weir_type::text
					WHERE ve_inp_frweir.element_id = rec_flowreg.element_id;
				END IF;

				-- update values on node_2 when flow regulator it's a pump, fixing ysur as maximum as possible
				IF rec_flowreg.flw_type='PU' THEN
					UPDATE temp_t_node SET y0=0, ysur=9999 WHERE node_id=rec_new_arc.node_2;
				END IF;
			END IF;
		END IF;
	END LOOP;
	RETURN 1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
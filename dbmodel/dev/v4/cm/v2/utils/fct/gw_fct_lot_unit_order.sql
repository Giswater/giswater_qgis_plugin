/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3145

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_lot_unit_order(p_data json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_lot_unit_order(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*
EXAMPLE
-------
SELECT gw_fct_lot_unit('{"data":{"parameters":{"lotId":9999, "arcBuffer":0.5, "linkBuffer":1, "areaFactor":1, "azimuthFactor":1, "elevFactor":0}}}');
SELECT gw_fct_lot_unit_order('{"data":{"parameters":{"lotId":9999, "step":1, "unitBuffer":0.4}}}');
SELECT gw_fct_lot_unit_order('{"data":{"parameters":{"lotId":9999, "step":2, "unitBuffer":1}}}');

SELECT * FROM om_visit_lot_x_macrounit where lot_id  = 9999

DETAIL
------
Units created with gw_fct_lot_unit need to be orderded.
The order follows two logics:
	- Route optimization
	- hydraulic criteria
It seems not possible to automatize at all. As result function is called using two steps:
	- step1: creation of macrounits: All those units wich belongs to same catchment (in strictly terms of hydraulic conductivy using the topology of the units (unit_id, arc_id, node_1, node_2) in spite of topology of arc-node)
		 After this function, user need to order using UI this macrounits accordint their bussiness rules
	- step2: ordering the units. As user have been ordeder the macrounits, units are orderded inside macrounit under stricty hydraulic critera

CHECK
-----

SELECT gw_fct_lot_unit_order('{"data":{"parameters":{"lotId":9999, "step":2, "unitBuffer":1}}}')

SELECT distinct(trace) FROM temp_anlgraph;
SELECT * FROM temp_anlgraph order by 4;


-- LOT 9999 test environment

insert into om_visit_lot values (9999) on conflict (id) do nothing;
delete from selector_lot where cur_user = current_user; insert into selector_lot (lot_id, cur_user) values (9999, current_user);
delete from om_visit_lot_x_gully where lot_id = 9999;
DELETE FROM om_visit_lot_x_arc WHERE lot_id = 9999;
delete from om_visit_lot_x_node where lot_id = 9999;
delete from om_visit_lot_x_unit where lot_id = 9999;
DELETE FROM om_visit_lot_x_arc WHERE lot_id = 9999;


insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (5947,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (5799,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (5800,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (5017,9999,1);


insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (6031,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (6893,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (6894,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (7898,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (6895,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (4509,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (6896,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (6897,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (1690,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (1675,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (3244,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (4974,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (4973,9999,1);

SELECT gw_fct_lot_unit('{"data":{"parameters":{"action":"create", "lotId":9999, "arcBuffer":0.5, "linkBuffer":1, "areaFactor":1, "azimuthFactor":1, "elevFactor":0}}}');
SELECT gw_fct_lot_unit_order('{"data":{"parameters":{"lotId":9999, "step":1, "unitBuffer":1}}}');
SELECT gw_fct_lot_unit_order('{"data":{"parameters":{"lotId":9999, "step":2, "unitBuffer":1}}}');
----


grant all on all tables in schema SCHEMA_NAME to bgeoadmin
select * from temp_anlgraph
select * from om_visit_lot_x_unit WHERE lot_id = 9999 and macrounit_id = 10036
select * from om_visit_lot_x_macrounit WHERE lot_id = 9997 and macrounit_id = 10036

SELECT gw_fct_lot_unit_order('{"data":{"parameters":{"lotId":10014, "step":1, "unitBuffer":2}}}')
SELECT gw_fct_lot_unit_order('{"data":{"parameters":{"lotId":10014, "step":2, "unitBuffer":1}}}')


CHECK BUG-202208.1
------------------
DELETE FROM om_visit_lot WHERE id  = 9999;
insert into om_visit_lot values (9999) on conflict (id) do nothing;
delete from om_visit_lot_x_arc where lot_id = 9999;
insert into om_visit_lot_x_arc (lot_id, arc_id, status)
select 9999, arc_id, 1 from arc where dma_id in (select dma_id from arc where arc_id = '2691');

DELETE FROM selector_lot where cur_user = current_user;
insert into selector_lot (lot_id, cur_user) VALUES (9999, current_user);

SELECT gw_fct_lot_unit('{"data":{"parameters":{"action":"create", "lotId":9999, "arcBuffer":0.5, "linkBuffer":1, "areaFactor":1, "azimuthFactor":1, "elevFactor":0}}}');
SELECT gw_fct_lot_unit_order('{"data":{"parameters":{"lotId":9999, "step":1, "unitBuffer":2}}}');
SELECT gw_fct_lot_unit_order('{"data":{"parameters":{"lotId":9999, "step":2, "unitBuffer":1}}}');



CHECK BUG-202208.2
------------------

DELETE FROM om_visit_lot WHERE id  = 9999;
insert into om_visit_lot values (9999) on conflict (id) do nothing;
delete from om_visit_lot_x_arc where lot_id = 9999;

insert into om_visit_lot_x_arc (lot_id, arc_id, status) select 9999, arc_id, 1 from om_visit_lot_x_arc where lot_id = 10233;

insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (3207,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (4235,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (3205,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (45562,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (864,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (3206,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (45561,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (847,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (8403,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (846,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (845,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (840,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (839,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (838,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (844,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (7915,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (7916,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (1112,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (1113,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (4346,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (6641,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (7741,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (7742,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (653,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (652,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (6527,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (6526,9999,1);

insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (6530,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (6528,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (6529,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (6531,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (6532,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (649,9999,1);


DELETE FROM selector_lot where cur_user = current_user;
insert into selector_lot (lot_id, cur_user) VALUES (9999, current_user);

SELECT gw_fct_lot_unit('{"data":{"parameters":{"action":"create", "lotId":9999, "arcBuffer":0.5, "linkBuffer":1, "areaFactor":1, "azimuthFactor":1, "elevFactor":0}}}');
SELECT gw_fct_lot_unit_order('{"data":{"parameters":{"lotId":9999, "step":1, "unitBuffer":2}}}');
SELECT gw_fct_lot_unit_order('{"data":{"parameters":{"lotId":9999, "step":2, "unitBuffer":1}}}');


CHECK BUG-202208.4
------------------

--step 1
DELETE FROM om_visit_lot WHERE id  = 9999;
insert into om_visit_lot values (9999) on conflict (id) do nothing;
delete from om_visit_lot_x_arc where lot_id = 9999;

insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (5609,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (5610,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (5608,9999,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (5604,9999,1);

SELECT gw_fct_lot_unit('{"data":{"parameters":{"action":"create", "lotId":9999, "arcBuffer":0.5, "linkBuffer":1, "areaFactor":1, "azimuthFactor":1, "elevFactor":0}}}');

DELETE FROM selector_lot where cur_user = current_user;
insert into selector_lot (lot_id, cur_user) VALUES (9999, current_user);


--step 2
UPDATE om_visit_lot_x_arc SET unit_id = 5608 WHERE lot_id = 9999 and arc_id = '5609';
SELECT gw_fct_lot_unit('{"data":{"parameters":{"action":"update", "lotId":9999, "arcBuffer":0.5, "linkBuffer":1, "areaFactor":1, "azimuthFactor":1, "elevFactor":0}}}');

select * from om_visit_lot_x_arc where lot_id = 9999

*/


DECLARE

v_result_info json;
v_result_point json;
v_result_line json;
v_result_polygon json;
v_result text;
v_count integer = 0;
v_version text;
v_input json;
v_error_context text;
v_checkdata boolean;
v_returnerror boolean = false;
v_lot integer;
v_unit integer;
v_fid integer = 134;
v_cont1 integer = 0;
v_cont2 integer = 0;
v_arc text;
v_querytext text;
v_affectedrow integer= 0;
v_order integer = 1;
rec_macrounit record;
rec_unit record;
rec_node record;
v_max integer;
v_rid integer;
v_unitbuffer float;
v_step integer;
v_node integer;
v_keepmacrounit integer;
v_deletemacrounit integer[];
v_areafactor float;
v_azimuthfactor float;
v_elevfactor float;
v_temp record;
i integer = 0;
v_paralel record;
v_paralel_t text[];

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- select config values
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- get variables
	v_lot = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'lotId');
	v_unitbuffer = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'unitBuffer');
	v_step = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'step');
	v_areafactor = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'areaFactor');
	v_azimuthfactor = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'azimuthFactor');
	v_elevfactor = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'elevFactor');

	-- setting values in case of null values for input parameters
	IF v_unitbuffer IS NULL THEN v_unitbuffer = (SELECT value::json->>'unitBuffer' FROM config_param_system WHERE parameter = 'om_lotmanage_units')::float; END IF;
	IF v_areafactor IS NULL THEN v_areafactor = (SELECT value::json->>'areaFactor' FROM config_param_system WHERE parameter = 'om_lotmanage_units')::float; END IF;
	IF v_azimuthfactor IS NULL THEN v_azimuthfactor = (SELECT value::json->>'azimuthFactor' FROM config_param_system WHERE parameter = 'om_lotmanage_units')::float; END IF;
	IF v_elevfactor IS NULL THEN v_elevfactor = (SELECT value::json->>'elevFactor' FROM config_param_system WHERE parameter = 'om_lotmanage_units')::float; END IF;

	-- reset selectors
	DELETE FROM selector_state WHERE cur_user=current_user;
	INSERT INTO selector_state (state_id, cur_user) VALUES (1, current_user);

	-- reset tables
	DELETE FROM temp_anlgraph;
	DELETE FROM temp_table;
	DELETE FROM anl_arc WHERE fid=v_fid AND cur_user=current_user;
	DELETE FROM audit_check_data WHERE fid=v_fid AND cur_user=current_user;
	DELETE FROM anl_node WHERE fid = v_fid AND cur_user=current_user;

	-- Starting process
	INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('MINSECTOR DYNAMIC SECTORITZATION'));
	INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('---------------------------------------------------'));

	-- create macrounits
	IF v_step = 1 THEN

		-- create graph of units
		INSERT INTO temp_anlgraph ( arc_id, node_1, node_2, water, flag, checkf, orderby, trace)
		SELECT  unit_id, node_1, node_2, 0, 0, 0, 0, macrounit_id FROM om_visit_lot_x_unit WHERE unit_type ='ARC' AND lot_id = v_lot;

		-- setting the outlet's for this macrounit (the starting element)
		UPDATE temp_anlgraph t SET checkf = 1 FROM
			(select node_2 FROM om_visit_lot_x_unit WHERE unit_type ='ARC' AND lot_id = v_lot
			EXCEPT
			select node_1 FROM om_visit_lot_x_unit WHERE unit_type ='ARC' AND lot_id = v_lot)a
			WHERE t.node_2 = a.node_2;

		-- setting the dividers is profile true as stoppers
		UPDATE temp_anlgraph t SET flag = 1 FROM

			(SELECT node_1 FROM temp_anlgraph
			JOIN node ON node_1 =node_id
			JOIN cat_feature_node f ON f.id = node_type
			WHERE isprofilesurface IS TRUE
			GROUP BY node_1 HAVING count(*) >1) a
			WHERE t.node_1 = a.node_1;

		-- setting as non-stopper only one from divider is profile true (lower sys_elev1) in order to enable algorithm to flow upstream
		UPDATE temp_anlgraph t SET flag = 0 FROM

			(SELECT b.node_1, unit_id FROM ve_arc a JOIN om_visit_lot_x_arc USING (arc_id)
			JOIN   (SELECT node_1, min(sys_elev1) as sys_elev1 FROM ve_arc
				JOIN (SELECT node_1 FROM arc
					JOIN node ON node_1 =node_id
					JOIN cat_feature_node f ON f.id = node_type
					WHERE isprofilesurface IS TRUE
					GROUP BY node_1 HAVING count(*) >1) a USING (node_1)
					WHERE state = 1
					GROUP BY node_1
					order by 1) b USING (sys_elev1,  node_1)
					WHERE lot_id = v_lot
				order by 1) c
			WHERE c.node_1 = t.node_1 AND unit_id = t.arc_id::integer;

		-- remove macrounits
		DELETE FROM om_visit_lot_x_macrounit WHERE lot_id = v_lot;

		LOOP
			-- starting engine
			SELECT id INTO v_rid FROM temp_anlgraph WHERE water=0 AND checkf = 1 LIMIT 1;
			EXIT WHEN v_rid IS NULL;

			-- set the starting element
			v_querytext = 'UPDATE temp_anlgraph SET water=1, trace=node_2::integer  WHERE id='||quote_literal(v_rid)||';';
			EXECUTE v_querytext;
			v_cont1 = 0;

			-- inundation process
			LOOP
				raise notice 'v_cont1 %', v_cont1;
				v_cont1 = v_cont1+1;
				UPDATE temp_anlgraph n SET water=1, trace = a.trace FROM v_anl_graphanalytics_upstream a where n.arc_id = a.arc_id;
				GET DIAGNOSTICS v_affectedrow =row_count;
				EXIT WHEN v_affectedrow = 0;
				EXIT WHEN v_cont1 = 2000;
			END LOOP;
		END LOOP;

		-- crate macrounits for arcs
		INSERT INTO om_visit_lot_x_macrounit
		SELECT distinct (trace), v_lot  FROM temp_anlgraph WHERE trace is not null
		ON CONFLICT (macrounit_id, lot_id) DO NOTHING;

		UPDATE om_visit_lot_x_unit SET macrounit_id = null WHERE lot_id =v_lot;
		UPDATE om_visit_lot_x_arc SET macrounit_id = null WHERE lot_id =v_lot;
		UPDATE om_visit_lot_x_node SET macrounit_id = null WHERE lot_id =v_lot;
		UPDATE om_visit_lot_x_gully SET macrounit_id = null WHERE lot_id =v_lot;

		-- update arc macrounit
		UPDATE om_visit_lot_x_unit u SET macrounit_id = trace FROM temp_anlgraph t WHERE t.arc_id::integer = u.unit_id AND trace IS NOT NULL AND lot_id = v_lot;
		UPDATE om_visit_lot_x_arc u SET macrounit_id = t.macrounit_id FROM om_visit_lot_x_unit t WHERE t.unit_id = u.unit_id AND t.lot_id = v_lot AND u.lot_id = t.lot_id;

		-- create macrounits for orphan nodes
		INSERT INTO om_visit_lot_x_macrounit
		SELECT node_id::integer, v_lot FROM om_visit_lot_x_node WHERE source='ORPHAN' and lot_id = v_lot
		ON CONFLICT (macrounit_id, lot_id) DO NOTHING;

		UPDATE om_visit_lot_x_node a SET macrounit_id = node_id::integer WHERE source='ORPHAN' and lot_id = v_lot;
		UPDATE om_visit_lot_x_unit u SET macrounit_id = n.macrounit_id FROM om_visit_lot_x_node n WHERE n.unit_id = u.unit_id AND unit_type = 'NODE'
		AND u.lot_id = v_lot AND n.lot_id = v_lot;

		-- update node macrounit
		UPDATE om_visit_lot_x_node a SET macrounit_id = b.macrounit_id FROM
		(SELECT node_1 as  node_id, macrounit_id FROM om_visit_lot_x_arc JOIN arc USING (arc_id) WHERE lot_id = v_lot
		UNION
		SELECT node_2, macrounit_id FROM om_visit_lot_x_arc JOIN arc USING (arc_id) WHERE lot_id = v_lot)b
		WHERE a.node_id = b.node_id AND lot_id = v_lot;

		-- update macrounit for gully linked to nodes
		UPDATE om_visit_lot_x_gully g SET macrounit_id = a.macrounit_id FROM
		(SELECT feature_id as gully_id, macrounit_id FROM ve_link JOIN om_visit_lot_x_node ON exit_id = node_id AND exit_type = 'NODE' AND lot_id = v_lot) a
		WHERE a.gully_id = g.gully_id;

		-- update macrounit for gully those linked to arc but arc does not exists on unit
		INSERT INTO om_visit_lot_x_macrounit
		SELECT gully_id::integer, v_lot FROM om_visit_lot_x_gully WHERE source = 'ORPHAN' AND lot_id  = v_lot
		ON CONFLICT (macrounit_id, lot_id) DO NOTHING;

		-- update macrounit for gully orphan
		UPDATE om_visit_lot_x_gully SET macrounit_id = gully_id::integer WHERE source = 'ORPHAN' AND macrounit_id IS NULL  AND lot_id  = v_lot;

		-- update macrounit for gully linked to arcs
		UPDATE om_visit_lot_x_gully a SET macrounit_id = b.macrounit_id FROM (SELECT gully_id, arc_id, macrounit_id FROM ve_gully
		JOIN om_visit_lot_x_arc USING (arc_id) WHERE lot_id = v_lot)b WHERE a.gully_id = b.gully_id;

		-- update unit for gully
		UPDATE om_visit_lot_x_unit u SET macrounit_id = a.macrounit_id FROM (SELECT DISTINCT macrounit_id, unit_id FROM om_visit_lot_x_gully WHERE lot_id = v_lot)a
		WHERE u.unit_id = a.unit_id AND u.lot_id = v_lot;

		-- update length for macrounits
		UPDATE om_visit_lot_x_macrounit SET length = a.length FROM (
		SELECT sum(length) length, macrounit_id FROM (
		SELECT length, macrounit_id FROM om_visit_lot_x_arc WHERE lot_id = v_lot
		UNION
		SELECT length, macrounit_id FROM om_visit_lot_x_gully WHERE lot_id = v_lot)b
		GROUP BY macrounit_id)a
		WHERE a.macrounit_id = om_visit_lot_x_macrounit.macrounit_id;

		-- setting random value for orderby
		UPDATE om_visit_lot_x_macrounit m
			SET orderby = ob FROM (SELECT row_number() over (order by macrounit_id) ob , macrounit_id FROM om_visit_lot_x_macrounit) a
			WHERE m.macrounit_id = a.macrounit_id AND lot_id = v_lot;

	-- order units
	ELSIF v_step  = 2 THEN

		FOR rec_macrounit IN SELECT * FROM om_visit_lot_x_macrounit WHERE lot_id = v_lot ORDER BY orderby desc
		LOOP

			-- create graph
			INSERT INTO temp_anlgraph ( arc_id, node_1, node_2, water, flag, checkf, orderby, trace)
			SELECT  unit_id, node_1, node_2, 0, 0, 0, 0, macrounit_id FROM om_visit_lot_x_unit WHERE unit_type ='ARC' AND lot_id = v_lot AND macrounit_id = rec_macrounit.macrounit_id;

			raise notice 'MACRO %', rec_macrounit.macrounit_id;

			-- setting the outlet's for graph macrounit (the starting element)
			UPDATE temp_anlgraph t SET checkf = 1 FROM
			(select node_2 FROM temp_anlgraph WHERE trace = rec_macrounit.macrounit_id EXCEPT select node_1 FROM temp_anlgraph WHERE trace = rec_macrounit.macrounit_id)a
			WHERE t.node_2 = a.node_2;

			FOR v_rid IN SELECT id FROM temp_anlgraph WHERE checkf = 1
			LOOP
				IF v_rid IS NULL THEN -- for those macros stand alone (gully or node)

					v_unit = (SELECT unit_id FROM om_visit_lot_x_unit WHERE macrounit_id = rec_macrounit.macrounit_id AND lot_id = v_lot);

					-- register into temp table
					RAISE NOTICE ' MACRO %, UNIT % ', rec_macrounit.macrounit_id, v_unit;
					INSERT INTO temp_table (fid, sector_id, macrosector_id) VALUES (v_fid, v_unit, rec_macrounit.macrounit_id);

				ELSE
					v_querytext = 'UPDATE temp_anlgraph SET water=1 WHERE id='||quote_literal(v_rid)||';';
					EXECUTE v_querytext;

					v_cont1 = 0;

					SELECT arc_id, node_1 INTO v_arc, v_node FROM temp_anlgraph WHERE checkf = 1 AND trace = rec_macrounit.macrounit_id;

					v_unit = (SELECT unit_id FROM om_visit_lot_x_arc WHERE arc_id = v_arc AND lot_id = v_lot);

					-- register into temp table
					RAISE NOTICE ' MACRO %, UNIT %, ARC % , NODE %', rec_macrounit.macrounit_id, v_unit, v_arc, v_node;
					INSERT INTO temp_table (fid, text_column, sector_id, macrosector_id) VALUES (v_fid, v_arc, v_unit, rec_macrounit.macrounit_id);

					PERFORM gw_fct_lot_unit_order_recursive(v_node, v_areafactor, v_azimuthfactor, v_elevfactor, v_lot, rec_macrounit.macrounit_id );
				END IF;
			END LOOP;

			DELETE FROM temp_anlgraph;

		END LOOP;

		UPDATE om_visit_lot_x_unit SET orderby = null where lot_id = v_lot ;

		-- reordering from top to down (ums ARC)
		UPDATE temp_table SET expl_id = od FROM (SELECT row_number() over (order by id desc) od, id FROM temp_table)a WHERE temp_table.id=a.id;

		-- looking for paralelized arc
		FOR v_paralel IN SELECT a.unit_id a, b.unit_id b, a.expl_id FROM
		(SELECT * FROM om_visit_lot_x_unit JOIN temp_table ON sector_id = unit_id WHERE lot_id = v_lot) a,
		(SELECT * FROM om_visit_lot_x_unit JOIN temp_table ON sector_id = unit_id WHERE lot_id = v_lot) b
		WHERE a.node_1 = b.node_1 AND a.node_2 = b.node_2 AND a.unit_id != b.unit_id
		AND a.node_1 != a.node_2 AND a.expl_id > b.expl_id order by 2
		LOOP
			UPDATE temp_table SET expl_id = v_paralel.expl_id WHERE sector_id = v_paralel.b;
		END LOOP;

		-- update macroexpl_id as new counter for orderby
		UPDATE temp_table SET macroexpl_id = od FROM (SELECT row_number() over (order by expl_id asc) od, id FROM temp_table)a WHERE temp_table.id=a.id;

		-- update order (ums ARC)
		UPDATE om_visit_lot_x_unit u SET orderby = ob FROM
		(
		SELECT row_number() over (order by expl_id asc) ob, unit_id FROM (SELECT DISTINCT ON (sector_id) id ,macroexpl_id, expl_id, sector_id as unit_id FROM temp_table)a
		)b
		WHERE b.unit_id::integer = u.unit_id AND lot_id = v_lot ;

	END IF;

	-- update geometries
	UPDATE om_visit_lot_x_macrounit u SET the_geom = a.geom FROM
		(SELECT macrounit_id, st_multi(st_buffer(st_collect(geom),0.01)) as geom
		    FROM
		    (SELECT macrounit_id, st_multi((st_buffer(st_collect(the_geom),v_unitbuffer))) as geom
		    FROM om_visit_lot_x_unit
		    WHERE lot_id = v_lot AND the_geom is not null
		    GROUP BY macrounit_id::integer)a
		GROUP BY macrounit_id)a
	WHERE u.macrounit_id = a.macrounit_id AND u.macrounit_id IS NOT NULL AND lot_id = v_lot;

	UPDATE om_visit_lot_x_unit SET orderby = null WHERE unit_type = 'GULLY' AND lot_id = v_lot;

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by id) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');

	--points
	v_result = null;
	v_result_point = COALESCE(v_result, '{}');

	--lines
	v_result = null;
	v_result_line = COALESCE(v_result, '{}');

	--polygons
	v_result = null;
	v_result_polygon = COALESCE(v_result, '{}');

	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}');
	v_result_point := COALESCE(v_result_point, '{}');
	v_result_line := COALESCE(v_result_line, '{}');
	v_result_polygon := COALESCE(v_result_polygon, '{}');

	--  Return
	RETURN ('{"status":"Accepted", "message":{"level":1, "text":"Maintenance Units order done succesfully"}, "version":"'||v_version||'"'||
		     ',"body":{"form":{}'||
			     ',"data":{ "info":'||v_result_info||','||
					'"point":'||v_result_point||','||
					'"line":'||v_result_line||','||
					'"polygon":'||v_result_polygon||'}'||
			       '}'||
		    '}')::json;

END;
$function$
;
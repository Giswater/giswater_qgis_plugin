/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3135

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_lot_unit(p_data json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_lot_unit(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*

DETAIL
-------
function to aggregate objects (arcs, nodes and gullies) following clean sanitation network criteria
The aggregated elements are called units.

This function works with gw_fct_lot_unit_recursive wich has the 'core' criteria to create or not units.
This core criteria works with this expression:

(farea * darea) + (fazimuth * dazimuth) + (felev + delev).


OM_VISIT_LOT_X_UNIT TABLE
-------------------------
unit_id: pk
lot_id: lot
status: status
orderby: result of the algortitm
the_geom: geomtetry
unit_type: ARC / NODE / GULLY -> NODE & GULLY for UI selection of user
length: Summ of length for unit (not applied for NODE)
way_type: REGISTRE / EMBORNAL - Object type to entry
way_in: Id of the object to entry in UM
way_out: Id of the object to exit from UM
macrounit: Macrounit where unit belongs
trace_type: (Internal proposes). Object type used to trace UM
trace_id: (Internal proposes). Object id to trace UM
node_1: (Internal proposes), to create a topology. Sometimes is same value of way_in, but some times not. For those node not registre node_1 is the end of the UM but node_1 is not place to entry to UM
node_2: (Internal proposes), to create a topology. Sometimes is same value of way_in, but some times not. For those node not registre node_1 is the end of the UM but node_1 is not place to entry to UM


INITIAL SCENARIO FOR DEV (2022.05)
----------------------------------
SELECT gw_fct_lot_unit('{"data":{"parameters":{"lotId":10104, "arcBuffer":0.5, "linkBuffer":1, "areaFactor":1, "azimuthFactor":1, "elevFactor":0}}}');
SELECT gw_fct_lot_unit_order('{"data":{"parameters":{"lotId":10104, "step":1, "unitBuffer":2}}}');
SELECT gw_fct_lot_unit_order('{"data":{"parameters":{"lotId":10104, "step":2, "unitBuffer":1}}}');

SELECT gw_fct_lot_unit($${"client":{"device":"4", "infoType":"1", "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{},
"parameters":{"action":"create", "lotId":"10034", "arcBuffer":"2", "linkBuffer":"1", "nodeBuffer":"5", "areaFactor":"1", "azimuthFactor":"1", "elevFactor":"0"}}}$$);

insert into om_visit_lot values (9999) on conflict (id) do nothing;
delete from om_visit_lot_x_arc where lot_id = 9998;
delete from om_visit_lot_x_node where lot_id = 9998;
delete from om_visit_lot_x_gully where lot_id = 9999;
delete from om_visit_lot_x_unit where lot_id = 9999;

insert into om_visit_lot_x_arc (arc_id, lot_id, status)
select arc_id, 9999, 1from arc where dma_id = 2001;

delete from  selector_lot where cur_user = 'bgeoadmin'; insert into selector_lot (lot_id, cur_user) VALUES (10104,current_user)

insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (46090,9998,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (46091,9998,1);
insert into om_visit_lot_x_arc (arc_id, lot_id,  status) VALUES (46092,9998,1);

delete from om_visit_lot_x_arc where lot_id = 207;
delete from om_visit_lot_x_node where lot_id = 207;
delete from om_visit_lot_x_gully where lot_id = 207;
delete from om_visit_lot_x_unit where lot_id = 207;
insert into om_visit_lot_x_node (lot_id, node_id, status, source) values (207,'15421',1,'ORPHAN');
insert into om_visit_lot_x_node (lot_id, node_id, status, source) values (207,'15470',1,'ORPHAN');

insert into om_visit_lot_x_gully (lot_id, gully_id, status, source) values (207,'26049',1,'ORPHAN');
insert into om_visit_lot_x_gully (lot_id, gully_id, status, source) values (207,'32354',1,'ORPHAN');
insert into om_visit_lot_x_gully (lot_id, gully_id, status, source) values (207,'32351',1,'ORPHAN');

insert into om_visit_lot_x_arc (lot_id, arc_id, status) values (207,'8426',1);
insert into om_visit_lot_x_arc (lot_id, arc_id, status) values (207,'8427',1);
insert into om_visit_lot_x_arc (lot_id, arc_id, status) values (207,'6643',1);
insert into om_visit_lot_x_arc (lot_id, arc_id, status) values (207,'6644',1);
insert into om_visit_lot_x_arc (lot_id, arc_id, status) values (207,'8073',1);
insert into om_visit_lot_x_arc (lot_id, arc_id, status) values (207,'5092',1);
insert into om_visit_lot_x_arc (lot_id, arc_id, status) values (207,'5095',1);
insert into om_visit_lot_x_arc (lot_id, arc_id, status) values (207,'5097',1);
insert into om_visit_lot_x_arc (lot_id, arc_id, status) values (207,'4798',1);
insert into om_visit_lot_x_arc (lot_id, arc_id, status) values (207,'4797',1);
insert into om_visit_lot_x_arc (lot_id, arc_id, status) values (207,'5096',1);
insert into om_visit_lot_x_arc (lot_id, arc_id, status) values (207,'5091',1);
insert into om_visit_lot_x_arc (lot_id, arc_id, status) values (207,'7416',1);
insert into om_visit_lot_x_arc (lot_id, arc_id, status) values (207,'8424',1);
insert into om_visit_lot_x_arc (lot_id, arc_id, status) values (207,'4249',1);
insert into om_visit_lot_x_arc (lot_id, arc_id, status) values (207,'3896',1);
insert into om_visit_lot_x_arc (lot_id, arc_id, status) values (207,'8074',1);
insert into om_visit_lot_x_arc (lot_id, arc_id, status) values (207,'8425',1);
insert into om_visit_lot_x_arc (lot_id, arc_id, status) values (207,'8428',1);

SELECT gw_fct_lot_unit_order('{"data":{"parameters":{"lotId":9999, "step":1, "unitBuffer":2}}}');
SELECT gw_fct_lot_unit_order('{"data":{"parameters":{"lotId":9999, "step":2, "unitBuffer":1}}}');


CHECK BUG-202206.1
------------------

delete from om_visit_lot_x_unit where lot_id = 9999;
----
update om_visit_lot_x_unit SET macrounit_id = null WHERE lot_id = 9999;
update om_visit_lot_x_arc SET macrounit_id = null WHERE lot_id = 9999;
update om_visit_lot_x_node SET macrounit_id = null WHERE lot_id = 9999;
update om_visit_lot_x_gully SET macrounit_id = null WHERE lot_id = 9999;

INSERT INTO om_visit_lot_x_unit (lot_id, unit_id) VALUES (9999,11)
UPDATE om_visit_lot_x_arc set unit_id = 11 WHERE arc_id IN ('5341','5340','5339')

SELECT gw_fct_lot_unit('{"data":{"parameters":{"lotId":9999, "arcBuffer":2, "linkBuffer":1, "areaFactor":1, "azimuthFactor":1, "elevFactor":0}}}');
SELECT gw_fct_lot_unit_order('{"data":{"parameters":{"lotId":9999, "step":1, "unitBuffer":2}}}');
SELECT gw_fct_lot_unit_order('{"data":{"parameters":{"lotId":9999, "step":2, "unitBuffer":1}}}');
delete from selector_lot where cur_user = current_user; insert into selector_lot (lot_id, cur_user) values (9999, current_user);


SELECT * FROM temp_anlgraph
SELECT * from om_visit_lot_x_unit where lot_id = 9999
SELECT * FROM om_visit_lot_x_macrounit where lot_id  =207

SELECT * FROM om_visit_lot_x_arc where lot_id = 9999
SELECT * FROM om_visit_lot_x_node where lot_id = 9999
SELECT * FROM om_visit_lot_x_gully where lot_id = 9999

SELECT * FROM om_visit_lot_x_gully where lot_id  = 9998
SELECT * FROM om_visit_lot_x_unit where lot_id  =207



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

CHECK BUG-202208.2
------------------
DELETE FROM om_visit_lot WHERE id  = 9999;
insert into om_visit_lot values (9999) on conflict (id) do nothing;
delete from om_visit_lot_x_arc where lot_id = 9999;
insert into om_visit_lot_x_arc (lot_id, arc_id, status)
select 9999, arc_id, 1 from om_visit_lot_x_arc where lot_id = 10231;

DELETE FROM selector_lot where cur_user = current_user;
insert into selector_lot (lot_id, cur_user) VALUES (9999, current_user);

SELECT gw_fct_lot_unit('{"data":{"parameters":{"action":"create", "lotId":9999, "arcBuffer":0.5, "linkBuffer":1, "areaFactor":1, "azimuthFactor":1, "elevFactor":0}}}');
SELECT gw_fct_lot_unit_order('{"data":{"parameters":{"lotId":9999, "step":1, "unitBuffer":2}}}');
SELECT gw_fct_lot_unit_order('{"data":{"parameters":{"lotId":9999, "step":2, "unitBuffer":1}}}');


CHECK BUG-202208.3
------------------
DELETE FROM om_visit_lot WHERE id  = 9999;
insert into om_visit_lot values (9999) on conflict (id) do nothing;
delete from om_visit_lot_x_arc where lot_id = 9999;

insert into om_visit_lot_x_arc (lot_id, arc_id, status) values (9999,'5608',1);
insert into om_visit_lot_x_arc (lot_id, arc_id, status) values (9999,'5604',1);
insert into om_visit_lot_x_arc (lot_id, arc_id, status) values (9999,'5609',1);
insert into om_visit_lot_x_arc (lot_id, arc_id, status) values (9999,'5610',1);

DELETE FROM selector_lot where cur_user = current_user;
insert into selector_lot (lot_id, cur_user) VALUES (9999, current_user);

SELECT gw_fct_lot_unit('{"data":{"parameters":{"action":"create", "lotId":9999, "arcBuffer":0.5, "linkBuffer":1, "areaFactor":1, "azimuthFactor":1, "elevFactor":0}}}');
SELECT gw_fct_lot_unit_order('{"data":{"parameters":{"lotId":9999, "step":1, "unitBuffer":2}}}');
SELECT gw_fct_lot_unit_order('{"data":{"parameters":{"lotId":9999, "step":2, "unitBuffer":1}}}');

*/

DECLARE

v_trace integer;
v_fid integer = 134;
v_querytext text;
v_result_info json;
v_result_point json;
v_result_line json;
v_result_polygon json;
v_result text;
v_count integer = 0;
v_version text;
v_input json;
v_error_context text;
v_returnerror boolean = false;
v_lot integer;
v_unit integer;
rec record;
rec_2 record;
v_stopper text[];
rec_node record;
rec_gully record;
v_node integer;
v_flag integer;
v_arc integer;
v_arcbuffer float;
v_nodebuffer float;
v_linkbuffer float;
v_areafactor float;
v_azimuthfactor float;
v_elevfactor float;
rec_unit record;
v_max integer;
v_action text;
v_maxlinklength float;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get variables
	v_lot = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'lotId');
	v_arcbuffer = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'arcBuffer');
	v_linkbuffer = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'linkBuffer');
	v_nodebuffer = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'nodeBuffer');
	v_areafactor = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'areaFactor');
	v_azimuthfactor = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'azimuthFactor');
	v_elevfactor = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'elevFactor');
	v_action = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'action');
	v_maxlinklength = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'maxLinkLength');

	-- setting values in case of null values for input parameters
	IF v_arcbuffer IS NULL THEN v_arcbuffer = (SELECT value::json->>'arcBuffer' FROM config_param_system WHERE parameter = 'om_lotmanage_units')::float; END IF;
	IF v_linkbuffer IS NULL THEN v_linkbuffer = (SELECT value::json->>'linkBuffer' FROM config_param_system WHERE parameter = 'om_lotmanage_units')::float; END IF;
	IF v_nodebuffer IS NULL THEN v_nodebuffer = (SELECT value::json->>'nodeBuffer' FROM config_param_system WHERE parameter = 'om_lotmanage_units')::float; END IF;
	IF v_areafactor IS NULL THEN v_areafactor = (SELECT value::json->>'areaFactor' FROM config_param_system WHERE parameter = 'om_lotmanage_units')::float; END IF;
	IF v_azimuthfactor IS NULL THEN v_azimuthfactor = (SELECT value::json->>'azimuthFactor' FROM config_param_system WHERE parameter = 'om_lotmanage_units')::float; END IF;
	IF v_elevfactor IS NULL THEN v_elevfactor = (SELECT value::json->>'elevFactor' FROM config_param_system WHERE parameter = 'om_lotmanage_units')::float; END IF;
	IF v_maxlinklength IS NULL THEN v_maxlinklength = (SELECT value::json->>'maxLinkLength' FROM config_param_system WHERE parameter = 'om_lotmanage_units')::float; END IF;

	-- select features that works as stopers
	SELECT array_agg(id) INTO v_stopper FROM cat_feature_node where isprofilesurface is true;

	-- select config values
	SELECT giswater, epsg INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	DELETE FROM temp_data;
	DELETE FROM temp_table;

	-- set environment
	IF v_action  = 'create' then
		UPDATE om_visit_lot_x_arc set unit_id = null WHERE lot_id = v_lot;
		UPDATE om_visit_lot_x_node set unit_id = null WHERE lot_id = v_lot;
		UPDATE om_visit_lot_x_gully set unit_id = null WHERE lot_id = v_lot;
		DELETE FROM om_visit_lot_x_unit WHERE lot_id = v_lot;
	ELSIF v_action  = 'update' THEN
		UPDATE om_visit_lot_x_unit SET macrounit_id = null WHERE lot_id = v_lot;
		UPDATE om_visit_lot_x_arc SET macrounit_id = null WHERE lot_id = v_lot;
		UPDATE om_visit_lot_x_node SET macrounit_id = null WHERE lot_id = v_lot;
		UPDATE om_visit_lot_x_gully SET macrounit_id = null WHERE lot_id = v_lot;
	END IF;

	-- reset graph & audit_log tables
	TRUNCATE temp_anlgraph;
	DELETE FROM audit_log_data WHERE fid=v_fid AND cur_user=current_user;
	DELETE FROM audit_check_data WHERE fid=134 AND cur_user=current_user;

	-- Starting process
	INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('UNIT DYNAMIC SECTORITZATION'));
	INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('---------------------------------------------------'));

	SELECT count(*) INTO v_count FROM cat_feature_node WHERE isprofilesurface IS TRUE;
	IF v_count < 0 THEN
		INSERT INTO audit_check_data (fid, criticity, error_message)
		VALUES (v_fid, 3, concat('ERROR-',v_fid,': There are null values on cat_feature_node.graphdelimiter. Please fill it before continue'));
	END IF;

	-- reset selectors
	DELETE FROM selector_state WHERE cur_user=current_user;
	INSERT INTO selector_state (state_id, cur_user) VALUES (1, current_user);


	-- create graph
	IF v_action = 'create' THEN
		INSERT INTO temp_anlgraph (arc_id, node_1, node_2, water, flag, checkf, trace, user_defined)
		SELECT arc_id, node_1, node_2, 0, 0, 0, unit_id, False
		FROM ve_arc
		JOIN om_visit_lot_x_arc USING (arc_id)
		WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL AND lot_id = v_lot;
	    ELSE
		INSERT INTO temp_anlgraph (arc_id, node_1, node_2, water, flag, checkf, trace, user_defined)
		SELECT arc_id, ve.node_1, ve.node_2, 0, 0, 0, lot_unit.unit_id, lot_unit.user_defined
		FROM ve_arc AS ve
		JOIN om_visit_lot_x_arc USING (arc_id)
		JOIN om_visit_lot_x_unit AS lot_unit USING (lot_id, unit_id)
		WHERE ve.node_1 IS NOT NULL AND ve.node_2 IS NOT NULL AND lot_unit.lot_id = v_lot;
	END IF;

	-- update trace
	UPDATE temp_anlgraph SET trace = arc_id::integer WHERE trace is null;

	-- setting graph by usign isprofilesurface = true
	UPDATE temp_anlgraph SET flag=1 FROM ve_node JOIN cat_feature_node ON id = node_type WHERE node_2 = node_id AND isprofilesurface =  true;

	LOOP
	    -- starting engine
	    -- checkf 1 it means that outlet node for unit is not profilesurface
	    SELECT node_2, trace, arc_id INTO v_node, v_trace, v_arc FROM temp_anlgraph WHERE flag=1 AND water = 0 LIMIT 1;
	    EXIT WHEN v_node IS NULL;
	    UPDATE temp_anlgraph SET flag=2, checkf=1 WHERE node_2::integer = v_node AND arc_id::integer = v_arc ;
	    RAISE NOTICE '---------- INIT NODE SURFACE TRUE % -------------', v_node;
	    PERFORM gw_fct_lot_unit_recursive(v_node, v_trace, v_node, v_areafactor, v_azimuthfactor, v_elevfactor, v_arc::integer);
	END LOOP;

	-- setting graph by usign isprofilesurface = false those nodes all ther dowstream is water =1
	UPDATE temp_anlgraph SET flag=1 WHERE water = 0 AND node_2 IN (SELECT node_1 FROM temp_anlgraph WHERE water = 1 EXCEPT SELECT node_1 FROM temp_anlgraph WHERE water = 0);

	-- setting graph by usign isprofilesurface = false those nodes that they are starting points
	UPDATE temp_anlgraph SET flag=1 WHERE water = 0 AND node_2 NOT IN (SELECT node_1 FROM temp_anlgraph);

	LOOP
	    -- starting engine
	    -- checkf 2 it means that outlet node for unit is not profilesurface
	    SELECT node_2, trace, arc_id INTO v_node, v_trace, v_arc FROM temp_anlgraph WHERE flag=1 AND water = 0 LIMIT 1;
	    EXIT WHEN v_node IS NULL;
	    UPDATE temp_anlgraph SET flag=2, checkf=2 WHERE node_2::integer = v_node AND arc_id::integer = v_arc ;
	    RAISE NOTICE '---------- INIT NODE SURFACE FALSE % -------------', v_node;
	    PERFORM gw_fct_lot_unit_recursive(v_node, v_trace, v_node, v_areafactor, v_azimuthfactor, v_elevfactor, v_arc::integer);

	END LOOP;

	FOR rec IN (SELECT DISTINCT trace FROM temp_anlgraph)
	LOOP

	    INSERT INTO om_visit_lot_x_unit(lot_id, unit_id, status, unit_type, trace_type, trace_id)
	    SELECT v_lot, trace, 1, 'ARC', 'ARC', trace
	    from temp_anlgraph where trace=rec.trace group by trace
	    ON CONFLICT (lot_id, unit_id) DO NOTHING;

	    v_unit = rec.trace;
	    raise notice 'v_unit,%',v_unit;

	    UPDATE om_visit_lot_x_arc a
	    SET unit_id = v_unit
	    FROM temp_anlgraph t
	    WHERE trace = rec.trace AND a.arc_id = t.arc_id AND lot_id = v_lot AND user_defined IS false;

	    -- insert nodes_1
	    FOR rec_2 IN
		SELECT v_lot, node_id, ve_node.code AS code, v_unit, 'JOINED', 1
		FROM temp_anlgraph a JOIN ve_node ON node_id = node_1
		WHERE node_type = ANY(v_stopper::text[]) AND a.trace = rec.trace
	    LOOP
		INSERT INTO om_visit_lot_x_node (lot_id, node_id, code, unit_id, source, status)
		VALUES (v_lot, rec_2.node_id, rec_2.code, v_unit, 'JOINED', 1)
		ON CONFLICT (lot_id, node_id) DO UPDATE SET unit_id = v_unit;
	    END LOOP;

	    -- insert nodes_2
	    FOR rec_2 IN
		SELECT v_lot, node_id, ve_node.code AS code, v_unit, 'JOINED', 1
		FROM temp_anlgraph a JOIN ve_node ON node_id = node_2
		WHERE a.trace = rec.trace
	    LOOP
		INSERT INTO om_visit_lot_x_node (lot_id, node_id, code, unit_id, source, status)
		VALUES (v_lot, rec_2.node_id, rec_2.code, v_unit, 'JOINED', 1)
		ON CONFLICT (lot_id, node_id) DO UPDATE SET unit_id = v_unit;
	    END LOOP;

	    -- set init node for um
	    UPDATE om_visit_lot_x_unit SET way_type = 'REGISTRE', way_in = node_id, node_1 = node_id FROM
	    (SELECT node_1 as node_id FROM arc a JOIN om_visit_lot_x_arc b USING (arc_id) WHERE b.lot_id = v_lot AND b.unit_id = v_unit
	    EXCEPT SELECT node_2 FROM arc a JOIN om_visit_lot_x_arc b USING (arc_id) WHERE b.lot_id = v_lot AND b.unit_id = v_unit)a
	    WHERE lot_id = v_lot AND unit_id = v_unit;

	    -- set end node for um
	    UPDATE om_visit_lot_x_unit SET way_type = 'REGISTRE', way_out = node_id, node_2 = node_id FROM
	    (SELECT node_2 as node_id FROM arc a JOIN om_visit_lot_x_arc b USING (arc_id) WHERE b.lot_id = v_lot AND b.unit_id = v_unit
	    EXCEPT SELECT node_1 FROM arc a JOIN om_visit_lot_x_arc b USING (arc_id) WHERE b.lot_id = v_lot AND b.unit_id = v_unit)a
	    WHERE lot_id = v_lot AND unit_id = v_unit;

	    -- when way_out isprofilesurface false then way_in
	    IF (SELECT isprofilesurface FROM om_visit_lot_x_unit JOIN node ON way_out = node_id JOIN cat_feature_node ON id = node_type WHERE lot_id = v_lot AND unit_id = v_unit) IS FALSE THEN
		    UPDATE om_visit_lot_x_unit SET way_out = way_in WHERE lot_id = v_lot AND unit_id = v_unit;
	    END IF;

	    -- when way_in isprofilesurface false then way_out
	    IF (SELECT isprofilesurface FROM om_visit_lot_x_unit JOIN node ON way_in = node_id JOIN cat_feature_node ON id = node_type WHERE lot_id = v_lot AND unit_id = v_unit) IS FALSE THEN
		    UPDATE om_visit_lot_x_unit SET way_in = way_out WHERE lot_id = v_lot AND unit_id = v_unit;
	    END IF;

	END LOOP;

	-- insert thoses gullys those are connected with some init/final
	INSERT INTO om_visit_lot_x_gully (lot_id, gully_id, code, unit_id, source, status)
	SELECT lot_id, gully_id, g.code, unit_id, 'NODE', 1
	FROM om_visit_lot_x_node
	JOIN ve_link ON exit_id =node_id
	JOIN ve_gully g ON gully_id = feature_id
	WHERE lot_id = v_lot
	ON CONFLICT (lot_id, gully_id) DO NOTHING;

	raise notice 'end 1';

	--draw units for orphan nodes (wich are selected manually by user)
	FOR rec_node IN (SELECT node_id, the_geom FROM om_visit_lot_x_node JOIN ve_node using (node_id) where lot_id=v_lot and source='ORPHAN')
	LOOP
		INSERT INTO om_visit_lot_x_unit(lot_id, status, orderby, the_geom, unit_type, way_type, way_in, way_out, trace_type, trace_id, node_1, node_2)
		VALUES (v_lot, 1, null, ST_Multi(st_buffer(rec_node.the_geom,2)), 'NODE', 'REGISTRE', rec_node.node_id, rec_node.node_id, 'NODE', rec_node.node_id::INTEGER, rec_node.node_id, rec_node.node_id )
		RETURNING unit_id INTO v_unit;

		UPDATE om_visit_lot_x_node SET unit_id = v_unit WHERE lot_id = v_lot AND node_id = rec_node.node_id;

	END LOOP;

	raise notice 'end 2';

	-- temporary draw link for those nodes wich they do not have link
	DELETE FROM temp_table;
	INSERT INTO temp_table (fid, text_column)
	SELECT  134, gully_id FROM om_visit_lot_x_gully WHERE gully_id NOT IN (SELECT feature_id FROM link WHERE feature_type = 'GULLY' ) AND lot_id = v_lot AND gully_id IS NOT NULL;

	-- execute setlinktonetwork
	PERFORM gw_fct_setlinktonetwork($${"client":{"device":4, "infoType":1,"lang":"ES"},"feature":{"id": "SELECT array_to_json(array_agg(text_column::text)) FROM temp_table WHERE fid = 134"},"data":{"feature_type":"GULLY"}}$$);

	-- trim those links with length large than maxlinklength
	UPDATE link SET the_geom = ST_LineSubstring(the_geom, 0.0, v_maxlinklength/st_length(the_geom))
	WHERE feature_type = 'GULLY' and feature_id IN (SELECT text_column FROM temp_table WHERE fid = 134) AND st_length(the_geom) > v_maxlinklength;

	-- draw units for integrated gullys (wich flows with selected node)
	FOR rec_gully IN (SELECT g.gully_id, l.the_geom, gis_length, exit_id AS node_id FROM gully g JOIN ve_link l ON feature_id = gully_id
		    JOIN om_visit_lot_x_gully USING (gully_id) WHERE source= 'NODE' AND lot_id = v_lot)
	LOOP
		INSERT INTO om_visit_lot_x_unit(lot_id, status, orderby, the_geom, unit_type, length, way_type, way_in, way_out, trace_type, trace_id, node_1, node_2)
		VALUES (v_lot, 1, null, ST_Multi(st_buffer(rec_gully.the_geom, v_nodebuffer)), 'GULLY', rec_gully.gis_length, 'REGISTRE', rec_gully.node_id, rec_gully.node_id,
		'NODE', rec_gully.node_id::INTEGER, rec_gully.node_id, rec_gully.node_id )
		RETURNING unit_id INTO v_unit;

		UPDATE om_visit_lot_x_gully SET unit_id = v_unit WHERE lot_id = v_lot AND gully_id = rec_gully.gully_id;

	END LOOP;

	raise notice 'end 3';
	--draw units for orphan gullies (wich are selected manually by user)
	FOR rec_gully IN (SELECT g.gully_id, l.the_geom, gis_length, arc_id FROM gully g JOIN ve_link l ON feature_id = gully_id
		    JOIN om_visit_lot_x_gully USING (gully_id) WHERE source='ORPHAN' AND lot_id = v_lot)
	LOOP
		INSERT INTO om_visit_lot_x_unit(lot_id, status, orderby, the_geom, unit_type, length, way_type, way_in, way_out, trace_type, trace_id, node_1, node_2)
		VALUES (v_lot, 1, null, ST_Multi(st_buffer(rec_gully.the_geom,v_linkbuffer)), 'GULLY', rec_gully.gis_length, 'EMBORNAL', rec_gully.gully_id, rec_gully.gully_id,
		'ARC', rec_gully.arc_id::INTEGER, rec_gully.gully_id, rec_gully.gully_id)
		RETURNING unit_id INTO v_unit;

		UPDATE om_visit_lot_x_gully SET unit_id = v_unit WHERE lot_id = v_lot AND gully_id = rec_gully.gully_id;
	END LOOP;

	-- remove temporary links for gullies without real link
	DELETE FROM link WHERE feature_type = 'GULLY' and feature_id IN (SELECT text_column FROM temp_table WHERE fid = 134);

	raise notice 'end 4';

	-- execute update geom function
	PERFORM gw_fct_lot_unit_update_geom(concat('{"data":{"parameters":{"lotId":',v_lot,', "arcBuffer":',v_arcbuffer,', "linkBuffer":',v_linkbuffer,', "nodeBuffer":',v_nodebuffer,'}}}')::json);


	-- delete not arc units
	DELETE FROM om_visit_lot_x_unit WHERE unit_id NOT IN
	(SELECT unit_id FROM om_visit_lot_x_arc WHERE lot_id = v_lot
	UNION SELECT unit_id FROM om_visit_lot_x_node WHERE lot_id = v_lot
	UNION SELECT unit_id FROM om_visit_lot_x_gully WHERE lot_id = v_lot)
	AND lot_id = v_lot AND user_defined is false;

	raise notice 'end 5';


	-- create orderby based on proximity -initalize
	INSERT INTO temp_data (fid, feature_type, feature_id, float_value, flag)
	with query as (SELECT a.unit_id u1, b.unit_id u2, st_distance((a.the_geom), (b.the_geom)) d
		FROM om_visit_lot_x_unit a, om_visit_lot_x_unit b
		WHERE a.unit_id != b.unit_id AND a.lot_id = v_lot AND b.lot_id = v_lot and st_distance((a.the_geom), (b.the_geom)) < 10
		ORDER BY 3 asc)
	SELECT v_fid, a.u1, b.u2, d, false FROM (SELECT u1, min(d) FROM query GROUP BY u1)a
	JOIN query b ON a.u1=b.u1 order by d;

	raise notice 'end 6';

	-- taking only headers
	LOOP
		-- get unit
		SELECT feature_type INTO v_unit FROM temp_data
		JOIN om_visit_lot_x_unit on unit_id = feature_type::INTEGER AND lot_id = v_lot WHERE node_1 IN
		(
		SELECT node_1 as n FROM(
		SELECT node_1 FROM om_visit_lot_x_unit WHERE lot_id = v_lot
		UNION ALL
		SELECT node_2 FROM om_visit_lot_x_unit WHERE lot_id = v_lot)a
		group by n
		having count(*) = 1) AND flag is not true LIMIT 1;
		PERFORM  gw_fct_lot_unit_orderbydist_recursive (v_unit);
		EXIT WHEN v_unit is null;

	END LOOP;

	-- taking disconnected objects
	LOOP

		SELECT feature_type INTO v_unit FROM temp_data WHERE flag is not true LIMIT 1;
		PERFORM  gw_fct_lot_unit_orderbydist_recursive (v_unit);
		EXIT WHEN v_unit is null;

	END LOOP;

	raise notice 'end 7';

	-- reordering um's
	UPDATE om_visit_lot_x_unit u SET orderby_2 = ob FROM
	(SELECT row_number() over (order by id desc) ob, text_column as unit_id FROM (SELECT id, text_column FROM temp_table)a)b
	WHERE b.unit_id::integer = u.unit_id AND lot_id = v_lot ;

	-- delete orderby for um type gully
	UPDATE om_visit_lot_x_unit SET orderby = null WHERE lot_id = v_lot AND unit_type = 'GULLY';

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
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Mapzones dynamic analysis done succesfully"}, "version":"'||v_version||'"'||
		     ',"body":{"form":{}'||
			     ',"data":{ "info":'||v_result_info||','||
					'"point":'||v_result_point||','||
					'"line":'||v_result_line||','||
					'"polygon":'||v_result_polygon||'}'||
			       '}'||
		    '}')::json, 2706, null, null, null);

	--  Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$function$
;
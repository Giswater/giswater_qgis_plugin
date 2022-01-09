/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2234

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_pg2epa_fill_data(varchar);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_pg2epa_fill_data(result_id_var varchar)
RETURNS integer AS 
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${"client":{"device":4, "infoType":1, "lang":"ES","epsg":25831}, "data":{"resultId":"test1", "dumpSubcatch":"true","step":"0"}}$$) -- FULL PROCESS
INSERT INTO SCHEMA_NAME.rpt_cat_result VALUES ('r1');
SELECT "SCHEMA_NAME".gw_fct_pg2epa_fill_data ('r1');

select * from temp_arc
	select * from temp_node where epa_type = 'DIVIDER'


*/ 

-- fid: 113

DECLARE

v_rainfall text;
v_isoperative boolean;
v_statetype text;
v_networkmode integer;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- Delete previous results on temp_node & arc tables
	TRUNCATE temp_node;
	TRUNCATE temp_node_other;
	TRUNCATE temp_arc;
	TRUNCATE temp_arc_flowregulator;
	TRUNCATE temp_gully;
	DELETE FROM rpt_inp_raingage WHERE result_id = result_id_var;


	-- set all timeseries of raingage using user's value
	v_rainfall:= (SELECT value FROM config_param_user WHERE parameter='inp_options_setallraingages' AND cur_user=current_user);

	v_isoperative = (SELECT value::json->>'onlyIsOperative' FROM config_param_user WHERE parameter='inp_options_debug' AND cur_user=current_user)::boolean;

	v_networkmode = (SELECT value FROM config_param_user WHERE parameter='inp_options_networkmode' AND cur_user=current_user);
	
	IF v_rainfall IS NOT NULL THEN
		UPDATE raingage SET timser_id=v_rainfall, rgage_type='TIMESERIES' WHERE expl_id IN (SELECT expl_id FROM selector_expl WHERE cur_user=current_user);
	END IF;

	--Use state_type only is operative true or not
	IF v_isoperative THEN
		v_statetype = ' AND value_state_type.is_operative = TRUE ';
	ELSE
		v_statetype = ' AND (value_state_type.is_operative = TRUE OR value_state_type.is_operative = FALSE)';
	END IF;

	-- to do: implement isoperative strategy

	-- Insert on node rpt_inp table
	-- the strategy of selector_sector is not used for nodes. The reason is to enable the posibility to export the sector=-1. In addition using this it's impossible to export orphan nodes
	EXECUTE 'INSERT INTO temp_node (result_id, node_id, top_elev, ymax, elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation, expl_id, y0, ysur, apond, the_geom)
	SELECT '||quote_literal(result_id_var)||',
	node.node_id, sys_top_elev, sys_ymax, v_edit_node.sys_elev, node.node_type, node.nodecat_id, node.epa_type, node.sector_id, node.state, 
	node.state_type, node.annotation, node.expl_id, y0, ysur, apond, node.the_geom
	FROM selector_sector, node
		LEFT JOIN v_edit_node USING (node_id) -- we need to use v_edit_node to work with sys_* fields
		JOIN inp_junction ON node.node_id=inp_junction.node_id
		JOIN (SELECT node_1 AS node_id FROM vi_parent_arc JOIN value_state_type ON id=state_type WHERE sector_id > 0 AND epa_type !=''UNDEFINED'' '||
		v_statetype ||' UNION SELECT node_2 FROM vi_parent_arc JOIN value_state_type ON id=state_type WHERE sector_id > 0 AND epa_type !=''UNDEFINED'' '||v_statetype ||')a ON node.node_id=a.node_id
	UNION
	SELECT '||quote_literal(result_id_var)||',
	node.node_id, sys_top_elev, sys_ymax, v_edit_node.sys_elev, node.node_type, node.nodecat_id, node.epa_type, node.sector_id, node.state, 
	node.state_type, node.annotation, node.expl_id, y0, ysur, apond, node.the_geom
	FROM selector_sector, node 
		LEFT JOIN v_edit_node USING (node_id) 
		JOIN inp_divider ON node.node_id=inp_divider.node_id
		JOIN (SELECT node_1 AS node_id FROM vi_parent_arc JOIN value_state_type ON id=state_type WHERE sector_id > 0 AND epa_type !=''UNDEFINED'' '||
		v_statetype ||' UNION SELECT node_2 FROM vi_parent_arc JOIN value_state_type ON id=state_type WHERE sector_id > 0 AND epa_type !=''UNDEFINED'' '||v_statetype ||')a ON node.node_id=a.node_id
	UNION
	SELECT '||quote_literal(result_id_var)||',
	node.node_id, sys_top_elev, sys_ymax, v_edit_node.sys_elev, node.node_type, node.nodecat_id, node.epa_type, node.sector_id, 
	node.state, node.state_type, node.annotation, node.expl_id, y0, ysur, apond, node.the_geom
	FROM selector_sector, node 
		LEFT JOIN v_edit_node USING (node_id) 	
		JOIN inp_storage ON node.node_id=inp_storage.node_id
		JOIN (SELECT node_1 AS node_id FROM vi_parent_arc JOIN value_state_type ON id=state_type WHERE sector_id > 0 AND epa_type !=''UNDEFINED'' '||
		v_statetype ||' UNION SELECT node_2 FROM vi_parent_arc JOIN value_state_type ON id=state_type WHERE sector_id > 0 AND epa_type !=''UNDEFINED'' '||v_statetype ||')a ON node.node_id=a.node_id
	UNION
	SELECT '||quote_literal(result_id_var)||',
	node.node_id, sys_top_elev, sys_ymax, v_edit_node.sys_elev, node.node_type, node.nodecat_id, node.epa_type, node.sector_id, 
	node.state, node.state_type, node.annotation, node.expl_id, null, null, null, node.the_geom
	FROM selector_sector, node 
		LEFT JOIN v_edit_node USING (node_id)
		JOIN inp_outfall ON node.node_id=inp_outfall.node_id
		JOIN (SELECT node_1 AS node_id FROM vi_parent_arc JOIN value_state_type ON id=state_type WHERE sector_id > 0 AND epa_type !=''UNDEFINED'' '||
		v_statetype ||' UNION SELECT node_2 FROM vi_parent_arc JOIN value_state_type ON id=state_type WHERE sector_id > 0 AND epa_type !=''UNDEFINED'' '||v_statetype ||')a ON node.node_id=a.node_id';

	-- node onfly transformation of junctions to outfalls (when outfallparam is fill and junction is node sink)
	PERFORM gw_fct_anl_node_sink($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{"tableName":"v_edit_inp_junction"},"data":{"parameters":{"saveOnDatabase":true}}}$$);
	
	-- update child param for divider
	UPDATE temp_node SET addparam=concat('{"divider_type":"',divider_type,'", "arc_id":"',arc_id,'", "curve_id":"',curve_id,'", "qmin":"',
	qmin,'", "ht":"',ht,'", "cd":"',cd,'"}')
	FROM inp_divider WHERE temp_node.node_id=inp_divider.node_id;

	-- update child param for storage
	UPDATE temp_node SET addparam=concat('{"storage_type":"',storage_type,'", "curve_id":"',curve_id,'", "a1":"',a1,'", "a2":"',a2,'", "a0":"',a0,'", "fevap":"',fevap,'", "sh":"',sh,'", "hc":"',hc,'", 
	"imd":"',imd,'"}')
	FROM inp_storage WHERE temp_node.node_id=inp_storage.node_id;

	-- update child param for outfall
	UPDATE temp_node SET addparam=concat('{"outfall_type":"',outfall_type,'", "state":"',state,'", "curve_id":"',curve_id,'", "timser_id":"',timser_id,'", "gate":"',gate,'"}')
	FROM inp_outfall WHERE temp_node.node_id=inp_outfall.node_id;

	UPDATE temp_node SET epa_type='OUTFALL' FROM anl_node a JOIN inp_junction USING (node_id) 
	WHERE outfallparam IS NOT NULL AND fid = 113 AND cur_user=current_user
	AND temp_node.node_id=a.node_id;

	INSERT INTO temp_node_other (node_id, type, timser_id, other, mfactor, sfactor, base, pattern_id)
	SELECT node_id, 'FLOW', timser_id, 'FLOW', 1, sfactor, base, pattern_id FROM v_edit_inp_inflows;

	INSERT INTO temp_node_other (node_id, type, timser_id, poll_id, other, mfactor, sfactor, base, pattern_id)
	SELECT node_id, 'POLLUTANT', timser_id, poll_id, form_type, mfactor, sfactor, base, pattern_id FROM v_edit_inp_inflows_poll;
	
	INSERT INTO temp_node_other (node_id, type, poll_id, other)
	SELECT node_id, 'TREATMENT', poll_id, function FROM v_edit_inp_treatment;

	-- Insert on arc rpt_inp table
	EXECUTE 'INSERT INTO temp_arc 
	(result_id, arc_id, node_1, node_2, elevmax1, elevmax2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation, length, n, expl_id, the_geom, q0, qmax, barrels, slope,
	culvert, kentry, kexit, kavg, flap, seepage)
	SELECT '||quote_literal(result_id_var)||',
	a.arc_id, node_1, node_2, a.sys_elev1, a.sys_elev2, a.arc_type, arccat_id, epa_type, a.sector_id, a.state, 
	a.state_type, a.annotation, 
	CASE
		WHEN custom_length IS NOT NULL THEN custom_length
		ELSE st_length2d(a.the_geom)
	END AS length,
	CASE
		WHEN custom_n IS NOT NULL THEN custom_n
		ELSE n
	END AS n,
	a.expl_id, 
	a.the_geom,
	q0,
	qmax,
	barrels,
	slope,
	culvert, kentry, kexit, kavg, flap, seepage
	FROM selector_sector, v_arc a
		LEFT JOIN value_state_type ON id=state_type
		LEFT JOIN cat_mat_arc ON matcat_id = cat_mat_arc.id
		LEFT JOIN inp_conduit ON a.arc_id = inp_conduit.arc_id
		WHERE epa_type !=''UNDEFINED'' '||v_statetype||' 
		AND a.sector_id > 0
		AND a.sector_id=selector_sector.sector_id AND selector_sector.cur_user=current_user';

	-- todo: UPDATE childparam for inp_weir, inp_orifice, inp_outlet, inp_pump

	-- fill temp_gully in order to work with 1D/2D
	IF v_networkmode = 2 THEN
	
		EXECUTE 'INSERT INTO temp_gully 
		SELECT 
		gully_id, g.gully_type, gratecat_id, g.sector_id, g.state, state_type, top_elev, top_elev-ymax, sandbox, units, groove, annotation, st_x(the_geom), st_y(the_geom),y0, ysur, -- gully
		c.length, c.width, total_area, effective_area, efficiency, n_barr_l, n_barr_w, n_barr_diag, a_param, b_param, -- grate
		(case when pjoint_type = ''VNODE'' THEN concat(''VN'',pjoint_id) ELSE pjoint_id end) as pjoint_id,
		pjoint_type,
		(case when custom_length is not null then custom_length else connec_length end),
		shape, 
		case when custom_n is not null then custom_n else n end, 
		connec_y1, connec_y2, geom1, geom2, geom3, geom4, q0, qmax, flap, -- connec		
		the_geom
		FROM selector_sector, v_edit_inp_gully g 
		JOIN cat_grate c ON id = gratecat_id 
		left JOIN cat_connec a ON connec_arccat_id = a.id
		left JOIN cat_mat_arc m ON m.id = g.connec_matcat_id
		left JOIN value_state_type s ON state_type = s.id
		WHERE g.sector_id=selector_sector.sector_id 
		AND selector_sector.cur_user=current_user
		AND g.sector_id > 0 '||v_statetype||';';
		
	END IF;

	-- orifice
	INSERT INTO temp_arc_flowregulator (arc_id, type, ori_type, offsetval, cd, orate, flap, shape, geom1, geom2, geom3, geom4, close_time)
	SELECT arc_id, 'ORIFICE', ori_type, offsetval, cd, orate, flap, shape, geom1, geom2, geom3, geom4, close_time
	FROM v_edit_inp_orifice;

	INSERT INTO temp_arc (arc_id, node_1, node_2, arccat_id, arc_type, epa_type, sector_id, state, state_type, annotation, the_geom, expl_id )
	SELECT arc_id, a.node_1, a.node_2, a.arccat_id, arc_type, epa_type, a.sector_id, a.state, a.state_type, a.annotation, a.the_geom, a.expl_id 
	FROM v_edit_inp_orifice JOIN arc a USING (arc_id);

	INSERT INTO temp_arc_flowregulator (arc_id, type, ori_type, offsetval, cd, orate, flap, shape, geom1, geom2, geom3, geom4, close_time)
	SELECT nodarc_id, 'ORIFICE', ori_type, offsetval, cd, orate, flap, shape, geom1, geom2, geom3, geom4, close_time
	FROM v_edit_inp_flwreg_orifice;

	-- outlet
	INSERT INTO temp_arc_flowregulator (arc_id, type, outlet_type, offsetval, curve_id, cd1, cd2, flap)
	SELECT arc_id, 'OUTLET', outlet_type, offsetval, curve_id, cd1, cd2, flap
	FROM v_edit_inp_outlet;

	INSERT INTO temp_arc_flowregulator (arc_id, type, outlet_type, offsetval, curve_id, cd1, cd2, flap)
	SELECT nodarc_id, 'OUTLET', outlet_type, offsetval,curve_id, cd1, cd2, flap
	FROM v_edit_inp_flwreg_outlet;

	-- pump
	INSERT INTO temp_arc_flowregulator (arc_id, type, curve_id, status, startup, shutoff)
	SELECT arc_id, 'PUMP', curve_id, status, startup, shutoff
	FROM v_edit_inp_pump;
	
	INSERT INTO temp_arc_flowregulator (arc_id, type, curve_id, status, startup, shutoff)
	SELECT nodarc_id, 'PUMP', curve_id, status, startup, shutoff
	FROM v_edit_inp_flwreg_pump;

	-- weir
	INSERT INTO temp_arc_flowregulator (arc_id, type, weir_type, offsetval, cd, ec, cd2, flap, shape, geom1, geom2, geom3, geom4, road_width, road_surf, coef_curve)
	SELECT arc_id, 'WEIR', weir_type, offsetval, cd, ec, cd2, flap, inp_typevalue.descript, geom1, geom2, geom3, geom4, road_width, road_surf, coef_curve
	FROM v_edit_inp_weir
	LEFT JOIN inp_typevalue ON inp_typevalue.id::text = v_edit_inp_weir.weir_type::text
	WHERE inp_typevalue.typevalue::text = 'inp_value_weirs';
	
	INSERT INTO temp_arc_flowregulator (arc_id, type, weir_type, offsetval, cd, ec, cd2, flap, shape, geom1, geom2, geom3, geom4, road_width, road_surf, coef_curve)
	SELECT nodarc_id, 'WEIR', weir_type, offsetval, cd, ec, cd2, flap, inp_typevalue.descript, geom1, geom2, geom3, geom4, road_width, road_surf, coef_curve
	FROM v_edit_inp_flwreg_weir
	LEFT JOIN inp_typevalue ON inp_typevalue.id::text = v_edit_inp_flwreg_weir.weir_type::text
	WHERE inp_typevalue.typevalue::text = 'inp_value_weirs';

	-- rpt_inp_raingage
	INSERT INTO rpt_inp_raingage
	SELECT result_id_var, * FROM v_edit_raingage;
	
	RETURN 1;	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
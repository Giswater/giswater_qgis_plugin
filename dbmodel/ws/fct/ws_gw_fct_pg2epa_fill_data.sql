/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2328

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_pg2epa_fill_data(varchar);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_fill_data(result_id_var varchar)  RETURNS integer AS 
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${"client":{"device":4, "infoType":1, "lang":"ES", "epsg":25831}, "data":{"resultId":"test1", "useNetworkGeom":"false"}}$$)
*/

DECLARE     

v_usedmapattern boolean;
v_buildupmode integer;
v_statetype text;
v_isoperative boolean;
v_networkmode integer;
v_minlength float;
v_forcereservoirsoninlets boolean;
v_forcetanksoninlets boolean;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	--  Get system & user variables
	v_usedmapattern = (SELECT value FROM config_param_user WHERE parameter='inp_options_use_dma_pattern' AND cur_user=current_user);
	v_buildupmode = (SELECT value FROM config_param_user WHERE parameter = 'inp_options_buildup_mode' AND cur_user=current_user);
	v_networkmode = (SELECT value FROM config_param_user WHERE parameter = 'inp_options_networkmode' AND cur_user=current_user);
	v_minlength := (SELECT value FROM config_param_system WHERE parameter = 'epa_arc_minlength');
	v_forcereservoirsoninlets := (SELECT value::json->>'forceReservoirsOnInlets' FROM config_param_user WHERE parameter = 'inp_options_debug' AND cur_user=current_user);
	v_forcetanksoninlets := (SELECT value::json->>'forceTanksOnInlets' FROM config_param_user WHERE parameter = 'inp_options_debug' AND cur_user=current_user);

	-- get debug parameters
	v_isoperative = (SELECT value::json->>'onlyIsOperative' FROM config_param_user WHERE parameter='inp_options_debug' AND cur_user=current_user)::boolean;

	raise notice 'Delete previous values from same result';

	-- Delete previous results on rpt_inp_node & arc tables
	TRUNCATE temp_node;
	TRUNCATE temp_arc;

	--Use state_type only is operative true or not
	IF v_isoperative THEN
		v_statetype = ' AND value_state_type.is_operative = TRUE ';
	ELSE
		v_statetype = ' AND (value_state_type.is_operative = TRUE OR value_state_type.is_operative = FALSE)';
	END IF;

	raise notice 'Inserting nodes on temp_node table';

	-- the strategy of selector_sector is not used for nodes. The reason is to enable the posibility to export the sector=-1. In addition using this it's impossible to export orphan nodes
	EXECUTE ' INSERT INTO temp_node (node_id, elevation, elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation, the_geom, expl_id, dma_id, presszone_id, dqa_id, minsector_id, age)
		WITH b AS (SELECT ve_arc.* FROM selector_sector, ve_arc
		JOIN value_state_type ON ve_arc.state_type = value_state_type.id
		WHERE ve_arc.sector_id = selector_sector.sector_id AND epa_type !=''UNDEFINED'' AND selector_sector.cur_user = "current_user"()::text 
		AND ve_arc.sector_id > 0 '
		||v_statetype||')
		SELECT DISTINCT ON (n.node_id)
		n.node_id, elevation, elevation-depth as elev, nodetype_id, nodecat_id, epa_type, a.sector_id, n.state, n.state_type, n.annotation, n.the_geom, n.expl_id, dma_id, presszone_id, dqa_id, minsector_id,
		(case when n.builtdate is not null then (now()::date-n.builtdate)/30 else 0 end)
		FROM node n 
		JOIN (SELECT node_1 AS node_id, sector_id FROM b UNION SELECT node_2, sector_id FROM b)a USING (node_id)
		JOIN cat_node c ON c.id=nodecat_id';

	-- create link exit
	IF v_networkmode in (3,4) THEN
		PERFORM gw_fct_linkexitgenerator(1);
	END IF;

	IF v_networkmode = 4 THEN
	
		EXECUTE ' INSERT INTO temp_node (node_id, elevation, elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation, the_geom, expl_id, dma_id, presszone_id, dqa_id, minsector_id, age)
			SELECT DISTINCT ON (c.connec_id)
			c.connec_id, elevation, elevation-depth as elev, ''CONNEC'', connecat_id, epa_type, c.sector_id, c.state, c.state_type, c.annotation, c.the_geom, c.expl_id, c.dma_id, c.presszone_id, c.dqa_id, c.minsector_id,
			(case when c.builtdate is not null then (now()::date-c.builtdate)/30 else 0 end)
			FROM selector_sector, v_edit_connec c
			JOIN value_state_type ON id = state_type
			WHERE c.sector_id = selector_sector.sector_id 
			AND c.sector_id > 0
			AND pjoint_id IS NOT NULL AND pjoint_type IS NOT NULL
			AND epa_type = ''JUNCTION''
			AND selector_sector.cur_user = "current_user"()::text '
			||v_statetype;		
	END IF;

	-- update child param for inp_reservoir
	UPDATE temp_node SET pattern_id=inp_reservoir.pattern_id FROM inp_reservoir WHERE temp_node.node_id=inp_reservoir.node_id;

	-- update head for those reservoirs head is not null
	UPDATE temp_node SET elevation = head, elev = head FROM inp_reservoir WHERE temp_node.node_id=inp_reservoir.node_id AND head is not null;
	
	-- update child param for inp_junction
	UPDATE temp_node SET demand=inp_junction.demand, pattern_id=inp_junction.pattern_id FROM inp_junction WHERE temp_node.node_id=inp_junction.node_id;

	-- update child param for inp_tank
	UPDATE temp_node SET addparam=concat('{"initlevel":"',initlevel,'", "minlevel":"',minlevel,'", "maxlevel":"',maxlevel,'", "diameter":"'
	,diameter,'", "minvol":"',minvol,'", "curve_id":"',curve_id,'", "overflow":"',overflow,'"}')
	FROM inp_tank WHERE temp_node.node_id=inp_tank.node_id;
	
	-- update child param for inp_inlet
	UPDATE temp_node SET addparam=concat('{"pattern_id":"',inp_inlet.pattern_id,'", "initlevel":"',initlevel,'", "minlevel":"',minlevel,'", "maxlevel":"',maxlevel,'", "diameter":"'
	,diameter,'", "minvol":"',minvol,'", "curve_id":"',curve_id,'", "overflow":"',overflow,'"}')
	FROM inp_inlet WHERE temp_node.node_id=inp_inlet.node_id;
	
	-- update child param for inp_valve
	UPDATE temp_node SET addparam=concat('{"valv_type":"',valv_type,'", "pressure":"',pressure,'", "diameter":"',custom_dint,'", "flow":"',
	flow,'", "coef_loss":"',coef_loss,'", "curve_id":"',curve_id,'", "minorloss":"',minorloss,'", "status":"',status,
	'", "to_arc":"',to_arc,'", "add_settings":"',add_settings,'"}')
	FROM inp_valve WHERE temp_node.node_id=inp_valve.node_id;

	-- update addparam for inp_pump
	UPDATE temp_node SET addparam=concat('{"power":"',power,'", "curve_id":"',curve_id,'", "speed":"',speed,'", "pattern_id":"',inp_pump.pattern_id,'", "status":"',status,'", "to_arc":"',to_arc,
	'", "effic_curve_id":"', effic_curve_id,'", "energy_price":"',energy_price,'", "energy_pattern_id":"',energy_pattern_id,'", "pump_type":"',pump_type,'"}')
	FROM inp_pump WHERE temp_node.node_id=inp_pump.node_id;

	IF v_forcereservoirsoninlets THEN

		UPDATE temp_node SET epa_type = 'RESERVOIR' WHERE epa_type = 'INLET';

	ELSIF v_forcetanksoninlets THEN

		UPDATE temp_node SET epa_type = 'TANK' WHERE epa_type = 'INLET';
	ELSE 

		-- manage inlets as reservoir (when there are as many pipes as you want but all are related to same sector)
		UPDATE temp_node SET epa_type = 'RESERVOIR' WHERE node_id IN (
		SELECT node_id FROM (
		SELECT a.sector_id, n1.node_id FROM temp_arc a JOIN temp_node n1 ON n1.node_id = node_1	WHERE n1.epa_type ='INLET'
		UNION
		SELECT a.sector_id, n2.node_id FROM temp_arc a JOIN temp_node n2 ON n2.node_id = node_2	WHERE n2.epa_type ='INLET')a
		group by node_id
		HAVING count(sector_id)=1);

		-- manage inlets as tanks  (when there are as many pipes as you want and there are at least two sectors involved)
		UPDATE temp_node SET epa_type = 'TANK' WHERE node_id IN (
		SELECT node_id FROM (
		SELECT a.sector_id, n1.node_id FROM temp_arc a JOIN temp_node n1 ON n1.node_id = node_1	WHERE n1.epa_type ='INLET'
		UNION
		SELECT a.sector_id, n2.node_id FROM temp_arc a JOIN temp_node n2 ON n2.node_id = node_2	WHERE n2.epa_type ='INLET')a
		group by node_id
		HAVING count(sector_id)>1);
	END IF;

	-- update child param for inp_reservoir
	UPDATE temp_node SET pattern_id=inp_reservoir.pattern_id FROM inp_reservoir WHERE temp_node.node_id=inp_reservoir.node_id;
	
	-- update child param for inp_junction
	UPDATE temp_node SET demand=inp_junction.demand, pattern_id=inp_junction.pattern_id FROM inp_junction WHERE temp_node.node_id=inp_junction.node_id;

	-- update child param for inp_tank
	UPDATE temp_node SET addparam=concat('{"initlevel":"',initlevel,'", "minlevel":"',minlevel,'", "maxlevel":"',maxlevel,'", "diameter":"'
	,diameter,'", "minvol":"',minvol,'", "curve_id":"',curve_id,'", "overflow":"',overflow,'"}')
	FROM inp_tank WHERE temp_node.node_id=inp_tank.node_id;
	
	-- update child param for inp_inlet
	UPDATE temp_node SET
	addparam=concat('{"pattern_id":"',i.pattern_id,'", "initlevel":"',initlevel,'", "minlevel":"',minlevel,'", "maxlevel":"',maxlevel,'", "diameter":"'
	,diameter,'", "minvol":"',minvol,'", "curve_id":"',curve_id,'", "overflow":"',overflow,'"}')
	FROM inp_inlet i WHERE temp_node.node_id=i.node_id;

	-- update head for those inlet acting as reservoir with head not null
	UPDATE temp_node SET elevation = head, elev = head FROM inp_inlet WHERE temp_node.node_id=inp_inlet.node_id AND head is not null AND epa_type = 'RESERVOIR';

	-- update head for those reservoirs with head is not null
	UPDATE temp_node SET elevation = head, elev = head FROM inp_reservoir WHERE temp_node.node_id=inp_reservoir.node_id AND head is not null;

	-- update child param for inp_valve
	UPDATE temp_node SET addparam=concat('{"valv_type":"',valv_type,'", "pressure":"',pressure,'", "diameter":"',custom_dint,'", "flow":"',
	flow,'", "coef_loss":"',coef_loss,'", "curve_id":"',curve_id,'", "minorloss":"',minorloss,'", "status":"',status,
	'", "to_arc":"',to_arc,'", "add_settings":"',add_settings,'"}')
	FROM inp_valve WHERE temp_node.node_id=inp_valve.node_id;

	-- update addparam for inp_pump
	UPDATE temp_node SET addparam=concat('{"power":"',power,'", "curve_id":"',curve_id,'", "speed":"',speed,'", "pattern":"',inp_pump.pattern_id,'", "status":"',status,'", "to_arc":"',to_arc,
	'", "energyparam":"', energyparam,'", "energyvalue":"',energyvalue,'", "pump_type":"',pump_type,'"}')
	FROM inp_pump WHERE temp_node.node_id=inp_pump.node_id;

	raise notice 'inserting arcs on temp_arc table';
	
	EXECUTE 'INSERT INTO temp_arc (arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation, roughness, 
		length, diameter, the_geom, expl_id, dma_id, presszone_id, dqa_id, minsector_id, age)
		SELECT
		v_arc.arc_id, node_1, node_2, v_arc.cat_arctype_id, arccat_id, epa_type, v_arc.sector_id, v_arc.state, v_arc.state_type, v_arc.annotation,
		CASE WHEN custom_roughness IS NOT NULL THEN custom_roughness ELSE roughness END AS roughness,
		(CASE WHEN v_arc.custom_length IS NOT NULL THEN custom_length ELSE gis_length END), 
		(CASE WHEN inp_pipe.custom_dint IS NOT NULL THEN custom_dint ELSE dint END),  -- diameter is child value but in order to make simple the query getting values from v_edit_arc (dint)...
		v_arc.the_geom,
		v_arc.expl_id, dma_id, presszone_id, dqa_id, minsector_id,
		(case when v_arc.builtdate is not null then (now()::date-v_arc.builtdate)/30 else 0 end)
		FROM selector_sector, v_arc
			LEFT JOIN value_state_type ON id=state_type
			LEFT JOIN cat_arc ON v_arc.arccat_id = cat_arc.id
			LEFT JOIN cat_mat_arc ON cat_arc.matcat_id = cat_mat_arc.id
			LEFT JOIN inp_pipe ON v_arc.arc_id = inp_pipe.arc_id
			LEFT JOIN inp_virtualpump ON v_arc.arc_id = inp_virtualpump.arc_id
			LEFT JOIN inp_virtualvalve ON v_arc.arc_id = inp_virtualvalve.arc_id
			LEFT JOIN cat_mat_roughness ON cat_mat_roughness.matcat_id = cat_mat_arc.id
			WHERE (now()::date - (CASE WHEN builtdate IS NULL THEN ''1900-01-01''::date ELSE builtdate END))/365 >= cat_mat_roughness.init_age
			AND (now()::date - (CASE WHEN builtdate IS NULL THEN ''1900-01-01''::date ELSE builtdate END))/365 < cat_mat_roughness.end_age '
			||v_statetype||' AND v_arc.sector_id=selector_sector.sector_id AND selector_sector.cur_user=current_user
			AND epa_type != ''UNDEFINED''
			AND v_arc.sector_id > 0
			AND st_length(v_arc.the_geom) >= '||v_minlength;

	IF v_networkmode =  4 THEN

		-- this need to be solved here in spite of fill_data functions because some kind of incosnstency done on this function on previous lines
		EXECUTE 'INSERT INTO temp_arc (arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation, roughness, length, diameter, the_geom,
			expl_id, dma_id, presszone_id, dqa_id, minsector_id, status, minorloss, age)
			SELECT concat(''CO'',connec_id), connec_id as node_1, CASE WHEN vnode_type = ''ARC'' THEN concat(''VN'',vnode_id) WHEN vnode_type = ''NODE'' THEN vnode_id::text ELSE pjoint_id end AS node_2, 
			''LINK'', connecat_id, ''PIPE'', c.sector_id, c.state, c.state_type, annotation, 
			(CASE WHEN custom_roughness IS NOT NULL THEN custom_roughness ELSE roughness END) AS roughness,
			(CASE WHEN custom_length IS NOT NULL THEN custom_length ELSE st_length(l.the_geom) END), 
			(CASE WHEN custom_dint IS NOT NULL THEN custom_dint ELSE dint END),  -- diameter is child value but in order to make simple the query getting values from v_edit_arc (dint)...
			l.the_geom,
			c.expl_id, c.dma_id, c.presszone_id, c.dqa_id, c.minsector_id, inp_connec.status, inp_connec.minorloss,
			(case when c.builtdate is not null then (now()::date-c.builtdate)/30 else 0 end)
			FROM selector_sector, temp_link l 
			JOIN connec c ON connec_id = feature_id
			JOIN value_state_type ON value_state_type.id = state_type
			JOIN cat_connec ON cat_connec.id = connecat_id
			JOIN inp_connec USING (connec_id)
			LEFT JOIN cat_mat_roughness ON cat_mat_roughness.matcat_id = cat_connec.matcat_id
				WHERE (now()::date - (CASE WHEN builtdate IS NULL THEN ''1900-01-01''::date ELSE builtdate END))/365 >= cat_mat_roughness.init_age
				AND (now()::date - (CASE WHEN builtdate IS NULL THEN ''1900-01-01''::date ELSE builtdate END))/365 < cat_mat_roughness.end_age '
				||v_statetype||' AND c.sector_id=selector_sector.sector_id AND selector_sector.cur_user=current_user
				AND epa_type = ''JUNCTION''
				AND c.sector_id > 0
				AND pjoint_id IS NOT NULL AND pjoint_type IS NOT NULL';
	END IF;
        
	-- update child param for inp_pipe
	UPDATE temp_arc SET 
	minorloss = inp_pipe.minorloss,
	status = (CASE WHEN inp_pipe.status IS NULL THEN 'OPEN' ELSE inp_pipe.status END),	
	addparam=concat('{"reactionparam":"',inp_pipe.reactionparam, '","reactionvalue":"',inp_pipe.reactionvalue,'"}')
	FROM inp_pipe WHERE temp_arc.arc_id=inp_pipe.arc_id;

	-- update child param for inp_virtualvalve
	UPDATE temp_arc SET 
	minorloss = inp_virtualvalve.minorloss, 
	diameter = inp_virtualvalve.diameter, 
	status = inp_virtualvalve.status, 
	addparam=concat('{"valv_type":"',valv_type,'", "pressure":"',pressure,'", "flow":"',flow,'", "coef_loss":"',coef_loss,'", "curve_id":"',curve_id,'"}')
	FROM inp_virtualvalve WHERE temp_arc.arc_id=inp_virtualvalve.arc_id;

	-- update addparam for inp_virtualpump
	UPDATE temp_arc SET addparam=concat('{"power":"',power,'", "curve_id":"',curve_id,'", "speed":"',speed,'", "pattern_id":"',p.pattern_id,'", "status":"',p.status,'",
	"effic_curve_id":"', effic_curve_id,'", "energy_price":"',energy_price,'", "energy_pattern_id":"',energy_pattern_id,'", "pump_type":"FLOWPUMP"}')
	FROM inp_virtualpump p WHERE temp_arc.arc_id=p.arc_id;

	-- update addparam for inp_shortpipe (step 1)
	UPDATE temp_node SET addparam=concat('{"minorloss":"',minorloss,'", "to_arc":"',to_arc,'", "status":"',status,'", "diameter":"", "roughness":"',a.roughness,'"}')
	FROM inp_shortpipe 
	JOIN (SELECT node_1 as node_id, diameter, roughness FROM temp_arc) a USING (node_id)
	WHERE temp_node.node_id=inp_shortpipe.node_id;
 
	-- update addparam for inp_shortpipe (step 2)
	UPDATE temp_node SET addparam=concat('{"minorloss":"',minorloss,'", "to_arc":"',to_arc,'", "status":"',status,'", "diameter":"", "roughness":"',a.roughness,'"}')
	FROM inp_shortpipe 
	JOIN (SELECT node_2 as node_id, diameter, roughness FROM temp_arc) a USING (node_id)
	WHERE temp_node.node_id=inp_shortpipe.node_id;


    RETURN 1;
		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
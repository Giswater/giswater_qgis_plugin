/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3074

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_dscenario (result_id_var character varying)
RETURNS integer AS
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_pg2epa_dscenario('bgeo_residuals')
SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${"data":{ "resultId":"test_bgeo_b1", "useNetworkGeom":"false"}}$$)

SELECT * FROM SCHEMA_NAME.temp_t_node WHERE node_id = 'VN257816';
*/

DECLARE
v_querytext text;
v_userscenario integer[];

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	RAISE NOTICE 'Starting pg2epa for filling demand scenario';

	IF (SELECT count(*) FROM selector_inp_dscenario WHERE cur_user = current_user) > 0 THEN

		v_userscenario = (SELECT array_agg(dscenario_id) FROM selector_inp_dscenario where cur_user=current_user);

		-- updating values for raingage
		UPDATE t_rpt_inp_raingage t SET form_type = d.form_type FROM inp_dscenario_raingage d
		WHERE t.rg_id = d.rg_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.form_type IS NOT NULL AND result_id = result_id_var;
		UPDATE t_rpt_inp_raingage t SET intvl = d.intvl FROM inp_dscenario_raingage d
		WHERE t.rg_id = d.rg_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.intvl IS NOT NULL AND result_id = result_id_var;
		UPDATE t_rpt_inp_raingage t SET scf = d.scf FROM inp_dscenario_raingage d
		WHERE t.rg_id = d.rg_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.scf IS NOT NULL AND result_id = result_id_var;
		UPDATE t_rpt_inp_raingage t SET rgage_type = d.rgage_type FROM inp_dscenario_raingage d
		WHERE t.rg_id = d.rg_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.rgage_type IS NOT NULL AND result_id = result_id_var;
		UPDATE t_rpt_inp_raingage t SET timser_id = d.timser_id FROM inp_dscenario_raingage d
		WHERE t.rg_id = d.rg_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.timser_id IS NOT NULL AND result_id = result_id_var;
		UPDATE t_rpt_inp_raingage t SET fname = d.fname FROM inp_dscenario_raingage d
		WHERE t.rg_id = d.rg_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.fname IS NOT NULL AND result_id = result_id_var;
		UPDATE t_rpt_inp_raingage t SET sta = d.sta FROM inp_dscenario_raingage d
		WHERE t.rg_id = d.rg_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.sta IS NOT NULL AND result_id = result_id_var;
		UPDATE t_rpt_inp_raingage t SET units = d.units FROM inp_dscenario_raingage d
		WHERE t.rg_id = d.rg_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.units IS NOT NULL AND result_id = result_id_var;

		-- updating values for conduits
		UPDATE temp_t_arc t SET barrels = d.barrels FROM inp_dscenario_conduit d
		WHERE t.arc_id = d.arc_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.barrels IS NOT NULL;
		UPDATE temp_t_arc t SET culvert = d.culvert FROM inp_dscenario_conduit d
		WHERE t.arc_id = d.arc_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.culvert IS NOT NULL;
		UPDATE temp_t_arc t SET kentry = d.kentry FROM inp_dscenario_conduit d
		WHERE t.arc_id = d.arc_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.kentry IS NOT NULL;
		UPDATE temp_t_arc t SET kexit = d.kexit FROM inp_dscenario_conduit d
		WHERE t.arc_id = d.arc_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.kexit IS NOT NULL;
		UPDATE temp_t_arc t SET kavg = d.kavg FROM inp_dscenario_conduit d
		WHERE t.arc_id = d.arc_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.kavg IS NOT NULL;
		UPDATE temp_t_arc t SET flap = d.flap FROM inp_dscenario_conduit d
		WHERE t.arc_id = d.arc_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.flap IS NOT NULL;
		UPDATE temp_t_arc t SET q0 = d.q0 FROM inp_dscenario_conduit d
		WHERE t.arc_id = d.arc_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.q0 IS NOT NULL;
		UPDATE temp_t_arc t SET qmax = d.qmax FROM inp_dscenario_conduit d
		WHERE t.arc_id = d.arc_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.qmax IS NOT NULL;
		UPDATE temp_t_arc t SET seepage = d.seepage FROM inp_dscenario_conduit d
		WHERE t.arc_id = d.arc_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.seepage IS NOT NULL;
		UPDATE temp_t_arc t SET elevmax1 = d.elev1 FROM inp_dscenario_conduit d
		WHERE t.arc_id = d.arc_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.elev1 IS NOT NULL;
		UPDATE temp_t_arc t SET elevmax2 = d.elev2 FROM inp_dscenario_conduit d
		WHERE t.arc_id = d.arc_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.elev2 IS NOT NULL;

		-- arccat
		UPDATE temp_t_arc t SET arccat_id = d.arccat_id FROM inp_dscenario_conduit d
		WHERE t.arc_id = d.arc_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.arccat_id IS NOT NULL;

		-- n
		-- when material comes from arccat
		UPDATE temp_t_arc t SET n = d.n FROM (
			SELECT * FROM inp_dscenario_conduit a
			JOIN cat_arc c ON c.id = a.arccat_id
			JOIN cat_material b ON c.matcat_id = b.id
			WHERE 'ARC' = ANY(b.feature_type)
		) d
		WHERE t.arc_id = d.arc_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.arccat_id IS NOT NULL;

		-- when material is informed by user
		UPDATE temp_t_arc t SET n = d.n FROM (
			SELECT * FROM inp_dscenario_conduit a
			JOIN cat_material b ON a.matcat_id = b.id
			WHERE 'ARC' = ANY(b.feature_type)
			AND a.matcat_id IS NOT NULL
			) d
		WHERE t.arc_id = d.arc_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.matcat_id IS NOT NULL;

		-- when n is informed by user
		UPDATE temp_t_arc t SET n = d.custom_n FROM inp_dscenario_conduit d
		WHERE t.arc_id = d.arc_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.custom_n IS NOT NULL;

		-- update junctions
		UPDATE temp_t_node t SET elev = d.elev FROM inp_dscenario_junction d
		WHERE t.node_id = d.node_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.elev IS NOT NULL;
		UPDATE temp_t_node t SET ymax = d.ymax FROM inp_dscenario_junction d
		WHERE t.node_id = d.node_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.ymax IS NOT NULL;
		UPDATE temp_t_node t SET y0 = d.y0 FROM inp_dscenario_junction d
		WHERE t.node_id = d.node_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.y0 IS NOT NULL;
		UPDATE temp_t_node t SET ysur = d.ysur FROM inp_dscenario_junction d
		WHERE t.node_id = d.node_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.ysur IS NOT NULL;
		UPDATE temp_t_node t SET apond = d.apond FROM inp_dscenario_junction d
		WHERE t.node_id = d.node_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.apond IS NOT NULL;

		-- TODO: update outfallparam

		-- update outfalls
		UPDATE temp_t_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'outfall_type', d.outfall_type) FROM inp_dscenario_outfall d
		WHERE t.node_id = d.node_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.outfall_type IS NOT NULL;
		UPDATE temp_t_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'stage', d.stage) FROM inp_dscenario_outfall d
		WHERE t.node_id = d.node_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.stage IS NOT NULL;
		UPDATE temp_t_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'curve_id', d.curve_id) FROM inp_dscenario_outfall d
		WHERE t.node_id = d.node_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.curve_id IS NOT NULL;
		UPDATE temp_t_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'timser_id', d.timser_id) FROM inp_dscenario_outfall d
		WHERE t.node_id = d.node_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.timser_id IS NOT NULL;
		UPDATE temp_t_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'gate', d.gate) FROM inp_dscenario_outfall d
		WHERE t.node_id = d.node_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.gate IS NOT NULL;

		-- update storage
		UPDATE temp_t_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'storage_type', d.storage_type) FROM inp_dscenario_storage d
		WHERE t.node_id = d.node_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.storage_type IS NOT NULL;
		UPDATE temp_t_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'curve_id', d.curve_id) FROM inp_dscenario_storage d
		WHERE t.node_id = d.node_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.curve_id IS NOT NULL;
		UPDATE temp_t_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'a1', d.a1) FROM inp_dscenario_storage d
		WHERE t.node_id = d.node_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.a1 IS NOT NULL;
		UPDATE temp_t_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'a2', d.a2) FROM inp_dscenario_storage d
		WHERE t.node_id = d.node_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.a2 IS NOT NULL;
		UPDATE temp_t_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'a0', d.a0) FROM inp_dscenario_storage d
		WHERE t.node_id = d.node_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.a0 IS NOT NULL;
		UPDATE temp_t_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'fevap', d.fevap) FROM inp_dscenario_storage d
		WHERE t.node_id = d.node_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.fevap IS NOT NULL;
		UPDATE temp_t_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'sh', d.sh) FROM inp_dscenario_storage d
		WHERE t.node_id = d.node_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.sh IS NOT NULL;
		UPDATE temp_t_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'hc', d.hc) FROM inp_dscenario_storage d
		WHERE t.node_id = d.node_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.hc IS NOT NULL;
		UPDATE temp_t_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'imd', d.imd) FROM inp_dscenario_storage d
		WHERE t.node_id = d.node_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.imd IS NOT NULL;
		UPDATE temp_t_node t SET y0 = d.y0 FROM inp_dscenario_storage d
		WHERE t.node_id = d.node_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.y0 IS NOT NULL;
		UPDATE temp_t_node t SET ysur = d.ysur FROM inp_dscenario_storage d
		WHERE t.node_id = d.node_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.ysur IS NOT NULL;
		UPDATE temp_t_node t SET elev = d.elev FROM inp_dscenario_storage d
		WHERE t.node_id = d.node_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.elev IS NOT NULL;
		UPDATE temp_t_node t SET ymax = d.ymax FROM inp_dscenario_storage d
		WHERE t.node_id = d.node_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.ymax IS NOT NULL;

		-- update inlets
		UPDATE temp_t_node t SET elev = d.elev FROM inp_dscenario_inlet d
		WHERE t.node_id = d.node_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.elev IS NOT NULL;
		UPDATE temp_t_node t SET ymax = d.ymax FROM inp_dscenario_inlet d
		WHERE t.node_id = d.node_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.ymax IS NOT NULL;
		UPDATE temp_t_node t SET y0 = d.y0 FROM inp_dscenario_inlet d
		WHERE t.node_id = d.node_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.y0 IS NOT NULL;
		UPDATE temp_t_node t SET ysur = d.ysur FROM inp_dscenario_inlet d
		WHERE t.node_id = d.node_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.ysur IS NOT NULL;
		UPDATE temp_t_node t SET apond = d.apond FROM inp_dscenario_inlet d
		WHERE t.node_id = d.node_id::text AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.apond IS NOT NULL;

		-- update flwreg orifice
		WITH src AS (
    		SELECT d.element_id::text AS arc_id,
			d.orifice_type,
			d.offsetval,
			d.cd,
			d.orate,
			d.flap,
			d.shape,
			d.geom1,
			d.geom2,
			d.geom3,
           	d.geom4
    		FROM inp_dscenario_frorifice AS d
			JOIN element_x_node AS en ON en.element_id = d.element_id
    		WHERE d.dscenario_id = ANY (v_userscenario)
		)
		UPDATE temp_t_arc_flowregulator AS t
		SET ori_type  = src.orifice_type, offsetval = src.offsetval, cd = src.cd, orate = src.orate, flap = src.flap, shape = src.shape, geom1 = src.geom1, geom2 = src.geom2,
		geom3 = src.geom3, geom4 = src.geom4
		FROM src
		WHERE t.arc_id = src.arc_id
  		AND (
			(src.orifice_type IS NOT NULL AND t.ori_type  IS DISTINCT FROM src.orifice_type) OR 
			(src.offsetval IS NOT NULL AND t.offsetval IS DISTINCT FROM src.offsetval) OR
			(src.cd IS NOT NULL AND t.cd IS DISTINCT FROM src.cd) OR
			(src.orate IS NOT NULL AND t.orate IS DISTINCT FROM src.orate) OR
			(src.flap IS NOT NULL AND t.flap IS DISTINCT FROM src.flap) OR
			(src.shape IS NOT NULL AND t.shape IS DISTINCT FROM src.shape) OR
			(src.geom1 IS NOT NULL AND t.geom1 IS DISTINCT FROM src.geom1) OR
			(src.geom2 IS NOT NULL AND t.geom2 IS DISTINCT FROM src.geom2) OR
			(src.geom3 IS NOT NULL AND t.geom3 IS DISTINCT FROM src.geom3) OR
			(src.geom4 IS NOT NULL AND t.geom4 IS DISTINCT FROM src.geom4)
		);

		-- update flwreg outlet
		WITH src AS (
    		SELECT d.element_id::text AS arc_id,
			d.outlet_type,
			d.offsetval,
			d.curve_id,
			d.cd1,
			d.cd2,
			d.flap
    		FROM inp_dscenario_froutlet AS d
			JOIN element_x_node AS en ON en.element_id = d.element_id
    		WHERE d.dscenario_id = ANY (v_userscenario)
		)
		UPDATE temp_t_arc_flowregulator AS t
		SET outlet_type = src.outlet_type, offsetval = src.offsetval, curve_id = src.curve_id, cd1 = src.cd1, cd2 = src.cd2, flap = src.flap
		FROM src
		WHERE t.arc_id = src.arc_id
  		AND (
			(src.outlet_type IS NOT NULL AND t.outlet_type  IS DISTINCT FROM src.outlet_type) OR 
			(src.offsetval IS NOT NULL AND t.offsetval IS DISTINCT FROM src.offsetval) OR
			(src.curve_id IS NOT NULL AND t.curve_id IS DISTINCT FROM src.curve_id) OR
			(src.cd1 IS NOT NULL AND t.cd1 IS DISTINCT FROM src.cd1) OR
			(src.cd2 IS NOT NULL AND t.cd2 IS DISTINCT FROM src.cd2) OR
			(src.flap IS NOT NULL AND t.flap IS DISTINCT FROM src.flap)
		);


		-- update flwreg pump
		WITH src AS (
    		SELECT d.element_id::text AS arc_id,
			d.curve_id,
			d.status,
			d.startup,
			d.shutoff
    		FROM inp_dscenario_frpump AS d
			JOIN element_x_node AS en ON en.element_id = d.element_id
    		WHERE d.dscenario_id = ANY (v_userscenario)
		)
		UPDATE temp_t_arc_flowregulator AS t
		SET curve_id = src.curve_id, status = src.status, startup = src.startup, shutoff = src.shutoff
		FROM src
		WHERE t.arc_id = src.arc_id
  		AND (
			(src.curve_id IS NOT NULL AND t.curve_id IS DISTINCT FROM src.curve_id) OR 
			(src.status IS NOT NULL AND t.status IS DISTINCT FROM src.status) OR
			(src.startup IS NOT NULL AND t.startup IS DISTINCT FROM src.startup) OR
			(src.shutoff IS NOT NULL AND t.shutoff IS DISTINCT FROM src.shutoff)
		);


		-- update flwreg weir
		WITH src AS (
    		SELECT d.element_id::text AS arc_id,
			d.weir_type,
			d.offsetval,
			d.cd,
			d.ec,
			d.cd2,
			d.flap,
			d.geom1,
			d.geom2,
			d.geom3,
			d.geom4,
			d.surcharge,
			d.road_width,
			d.road_surf,
			d.coef_curve
    		FROM inp_dscenario_frweir AS d
			JOIN element_x_node AS en ON en.element_id = d.element_id
    		WHERE d.dscenario_id = ANY (v_userscenario)
		)
		UPDATE temp_t_arc_flowregulator AS t
		SET weir_type = src.weir_type, offsetval = src.offsetval, cd = src.cd, ec = src.ec, cd2 = src.cd2, flap = src.flap, geom1 = src.geom1, geom2 = src.geom2, geom3 = src.geom3, geom4 = src.geom4, surcharge = src.surcharge, road_width = src.road_width, road_surf = src.road_surf, coef_curve = src.coef_curve
		FROM src
		WHERE t.arc_id = src.arc_id
  		AND (
			(src.weir_type IS NOT NULL AND t.weir_type IS DISTINCT FROM src.weir_type) OR 
			(src.offsetval IS NOT NULL AND t.offsetval IS DISTINCT FROM src.offsetval) OR
			(src.cd IS NOT NULL AND t.cd IS DISTINCT FROM src.cd) OR
			(src.ec IS NOT NULL AND t.ec IS DISTINCT FROM src.ec) OR
			(src.cd2 IS NOT NULL AND t.cd2 IS DISTINCT FROM src.cd2) OR
			(src.flap IS NOT NULL AND t.flap IS DISTINCT FROM src.flap) OR
			(src.geom1 IS NOT NULL AND t.geom1 IS DISTINCT FROM src.geom1) OR
			(src.geom2 IS NOT NULL AND t.geom2 IS DISTINCT FROM src.geom2) OR
			(src.geom3 IS NOT NULL AND t.geom3 IS DISTINCT FROM src.geom3) OR
			(src.geom4 IS NOT NULL AND t.geom4 IS DISTINCT FROM src.geom4) OR
			(src.surcharge IS NOT NULL AND t.surcharge IS DISTINCT FROM src.surcharge) OR
			(src.road_width IS NOT NULL AND t.road_width IS DISTINCT FROM src.road_width) OR
			(src.road_surf IS NOT NULL AND t.road_surf IS DISTINCT FROM src.road_surf) OR
			(src.coef_curve IS NOT NULL AND t.coef_curve IS DISTINCT FROM src.coef_curve)
		);

		-- insert lid-usage
		INSERT INTO temp_t_lid_usage SELECT subc_id, lidco_id, numelem, area, width, initsat, fromimp, toperv, rptfile
		FROM ve_inp_dscenario_lids
		ON CONFLICT (subc_id, lidco_id) DO NOTHING;

		-- insertar inflows
		INSERT INTO temp_t_node_other (node_id, type, timser_id, other, sfactor, base, pattern_id, active)
		SELECT node_id, 'FLOW', timser_id, order_id, sfactor, base, pattern_id, active FROM inp_dscenario_inflows d
		WHERE dscenario_id IN (SELECT unnest(v_userscenario))
		ON CONFLICT (node_id, other, type) DO NOTHING;

		-- insertar inflows poll
		INSERT INTO temp_t_node_other (node_id, type, poll_id, timser_id, other,  mfactor, sfactor, base, pattern_id)
		SELECT node_id, 'POLLUTANT', poll_id, timser_id, form_type, mfactor, sfactor, base, pattern_id FROM inp_dscenario_inflows_poll d
		WHERE dscenario_id IN (SELECT unnest(v_userscenario))
		ON CONFLICT (node_id, other, type) DO NOTHING;

		-- insertar treatment
		INSERT INTO temp_t_node_other (node_id, poll_id, other)
		SELECT node_id, poll_id, function FROM inp_dscenario_treatment d
		WHERE dscenario_id IN (SELECT unnest(v_userscenario))
		ON CONFLICT (node_id, other, type) DO NOTHING;
	END IF;


	RETURN 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
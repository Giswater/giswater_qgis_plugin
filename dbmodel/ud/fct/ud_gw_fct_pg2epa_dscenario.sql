/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3074

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_dscenario (result_id_var character varying)  
RETURNS integer AS 
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_pg2epa_dscenario('prognosi')
SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${"data":{ "resultId":"test_bgeo_b1", "useNetworkGeom":"false"}}$$)

SELECT * FROM SCHEMA_NAME.temp_node WHERE node_id = 'VN257816';
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
		UPDATE rpt_inp_raingage t SET form_type = d.form_type FROM v_edit_inp_dscenario_raingage d
		WHERE t.rg_id = d.rg_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.form_type IS NOT NULL AND result_id = result_id_var;
		UPDATE rpt_inp_raingage t SET intvl = d.intvl FROM v_edit_inp_dscenario_raingage d
		WHERE t.rg_id = d.rg_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.intvl IS NOT NULL AND result_id = result_id_var;
		UPDATE rpt_inp_raingage t SET scf = d.scf FROM v_edit_inp_dscenario_raingage d
		WHERE t.rg_id = d.rg_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.scf IS NOT NULL AND result_id = result_id_var;
		UPDATE rpt_inp_raingage t SET rgage_type = d.rgage_type FROM v_edit_inp_dscenario_raingage d
		WHERE t.rg_id = d.rg_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.rgage_type IS NOT NULL AND result_id = result_id_var;
		UPDATE rpt_inp_raingage t SET timser_id = d.timser_id FROM v_edit_inp_dscenario_raingage d
		WHERE t.rg_id = d.rg_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.timser_id IS NOT NULL AND result_id = result_id_var;	
		UPDATE rpt_inp_raingage t SET fname = d.fname FROM v_edit_inp_dscenario_raingage d
		WHERE t.rg_id = d.rg_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.fname IS NOT NULL AND result_id = result_id_var;
		UPDATE rpt_inp_raingage t SET sta = d.sta FROM v_edit_inp_dscenario_raingage d
		WHERE t.rg_id = d.rg_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.sta IS NOT NULL AND result_id = result_id_var;
		UPDATE rpt_inp_raingage t SET units = d.units FROM v_edit_inp_dscenario_raingage d
		WHERE t.rg_id = d.rg_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.units IS NOT NULL AND result_id = result_id_var;
	
		-- updating values for conduits
		UPDATE temp_arc t SET barrels = d.barrels FROM v_edit_inp_dscenario_conduit d 
		WHERE t.arc_id = d.arc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.barrels IS NOT NULL;
		UPDATE temp_arc t SET culvert = d.culvert FROM v_edit_inp_dscenario_conduit d 
		WHERE t.arc_id = d.arc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.culvert IS NOT NULL;
		UPDATE temp_arc t SET kentry = d.kentry FROM v_edit_inp_dscenario_conduit d 
		WHERE t.arc_id = d.arc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.kentry IS NOT NULL;
		UPDATE temp_arc t SET kexit = d.kexit FROM v_edit_inp_dscenario_conduit d 
		WHERE t.arc_id = d.arc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.kexit IS NOT NULL;
		UPDATE temp_arc t SET kavg = d.kavg FROM v_edit_inp_dscenario_conduit d 
		WHERE t.arc_id = d.arc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.kavg IS NOT NULL;
		UPDATE temp_arc t SET flap = d.flap FROM v_edit_inp_dscenario_conduit d 
		WHERE t.arc_id = d.arc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.flap IS NOT NULL;
		UPDATE temp_arc t SET q0 = d.q0 FROM v_edit_inp_dscenario_conduit d 
		WHERE t.arc_id = d.arc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.q0 IS NOT NULL;
		UPDATE temp_arc t SET qmax = d.qmax FROM v_edit_inp_dscenario_conduit d 
		WHERE t.arc_id = d.arc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.qmax IS NOT NULL;
		UPDATE temp_arc t SET seepage = d.seepage FROM v_edit_inp_dscenario_conduit d 
		WHERE t.arc_id = d.arc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.seepage IS NOT NULL;
		UPDATE temp_arc t SET y1 = d.y1 FROM v_edit_inp_dscenario_conduit d 
		WHERE t.arc_id = d.arc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.y1 IS NOT NULL;
		UPDATE temp_arc t SET y2 = d.y2 FROM v_edit_inp_dscenario_conduit d 
		WHERE t.arc_id = d.arc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.y2 IS NOT NULL;

		-- arccat
		UPDATE temp_arc t SET arccat_id = d.arccat_id FROM v_edit_inp_dscenario_conduit d 
		WHERE t.arc_id = d.arc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.arccat_id IS NOT NULL;

		-- n
		-- when material comes from arccat
		UPDATE temp_arc t SET n = d.n FROM (SELECT * FROM v_edit_inp_dscenario_conduit a 
		JOIN cat_arc c ON c.id = a.arccat_id  
		JOIN cat_mat_arc b ON c.matcat_id = b.id) d
		WHERE t.arc_id = d.arc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.arccat_id IS NOT NULL;

		-- when material is informed by user
		UPDATE temp_arc t SET n = d.n FROM (SELECT * FROM v_edit_inp_dscenario_conduit a JOIN cat_mat_arc b ON a.matcat_id = id WHERE a.matcat_id IS NOT NULL)d
		WHERE t.arc_id = d.arc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.matcat_id IS NOT NULL;

		-- when n is informed by user
		UPDATE temp_arc t SET n = d.custom_n FROM v_edit_inp_dscenario_conduit d 
		WHERE t.arc_id = d.arc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.custom_n IS NOT NULL;

		-- update junctions
		UPDATE temp_node t SET elev = d.elev FROM v_edit_inp_dscenario_junction d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.elev IS NOT NULL;		
		UPDATE temp_node t SET ymax = d.ymax FROM v_edit_inp_dscenario_junction d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.ymax IS NOT NULL;		
		UPDATE temp_node t SET y0 = d.y0 FROM v_edit_inp_dscenario_junction d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.y0 IS NOT NULL;		
		UPDATE temp_node t SET ysur = d.ysur FROM v_edit_inp_dscenario_junction d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.ysur IS NOT NULL;	
		UPDATE temp_node t SET apond = d.apond FROM v_edit_inp_dscenario_junction d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.apond IS NOT NULL;	

		-- TODO: update outfallparam

		-- update outfalls
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'outfall_type', d.outfall_type) FROM v_edit_inp_dscenario_outfall d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.outfall_type IS NOT NULL;		
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'stage', d.stage) FROM v_edit_inp_dscenario_outfall d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.stage IS NOT NULL;		
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'curve_id', d.curve_id) FROM v_edit_inp_dscenario_outfall d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.curve_id IS NOT NULL;		
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'timser_id', d.timser_id) FROM v_edit_inp_dscenario_outfall d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.timser_id IS NOT NULL;		
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'gate', d.gate) FROM v_edit_inp_dscenario_outfall d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.gate IS NOT NULL;		
		
		-- update storage
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'storage_type', d.storage_type) FROM v_edit_inp_dscenario_storage d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.storage_type IS NOT NULL;		
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'curve_id', d.curve_id) FROM v_edit_inp_dscenario_storage d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.curve_id IS NOT NULL;		
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'a1', d.a1) FROM v_edit_inp_dscenario_storage d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.a1 IS NOT NULL;		
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'a2', d.a2) FROM v_edit_inp_dscenario_storage d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.a2 IS NOT NULL;		
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'a0', d.a0) FROM v_edit_inp_dscenario_storage d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.a0 IS NOT NULL;		
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'fevap', d.fevap) FROM v_edit_inp_dscenario_storage d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.fevap IS NOT NULL;		
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'sh', d.sh) FROM v_edit_inp_dscenario_storage d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.sh IS NOT NULL;		
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'hc', d.hc) FROM v_edit_inp_dscenario_storage d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.hc IS NOT NULL;		
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'imd', d.imd) FROM v_edit_inp_dscenario_storage d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.imd IS NOT NULL;		
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'y0', d.y0) FROM v_edit_inp_dscenario_storage d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.y0 IS NOT NULL;		
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'ysur', d.ysur) FROM v_edit_inp_dscenario_storage d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.ysur IS NOT NULL;		
		UPDATE temp_node t SET addparam = gw_fct_json_object_set_key(addparam::json, 'apond', d.apond) FROM v_edit_inp_dscenario_storage d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.apond IS NOT NULL;		

		-- update flwreg orifice
		UPDATE temp_arc_flowregulator t SET ori_type = d.ori_type FROM v_edit_inp_dscenario_flwreg_orifice d 
		WHERE t.arc_id = d.nodarc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.ori_type IS NOT NULL;
		UPDATE temp_arc_flowregulator t SET offsetval = d.offsetval FROM v_edit_inp_dscenario_flwreg_orifice d 
		WHERE t.arc_id = d.nodarc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.offsetval IS NOT NULL;
		UPDATE temp_arc_flowregulator t SET cd = d.cd FROM v_edit_inp_dscenario_flwreg_orifice d 
		WHERE t.arc_id = d.nodarc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.cd IS NOT NULL;
		UPDATE temp_arc_flowregulator t SET orate = d.orate FROM v_edit_inp_dscenario_flwreg_orifice d 
		WHERE t.arc_id = d.nodarc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.orate IS NOT NULL;
		UPDATE temp_arc_flowregulator t SET cd2 = d.cd2 FROM v_edit_inp_dscenario_flwreg_orifice d 
		WHERE t.arc_id = d.nodarc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.flap IS NOT NULL;
		UPDATE temp_arc_flowregulator t SET shape = d.shape FROM v_edit_inp_dscenario_flwreg_orifice d 
		WHERE t.arc_id = d.nodarc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.shape IS NOT NULL;
		UPDATE temp_arc_flowregulator t SET geom1 = d.geom1 FROM v_edit_inp_dscenario_flwreg_orifice d 
		WHERE t.arc_id = d.nodarc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.geom1 IS NOT NULL;
		UPDATE temp_arc_flowregulator t SET geom2 = d.geom2 FROM v_edit_inp_dscenario_flwreg_orifice d 
		WHERE t.arc_id = d.nodarc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.geom2 IS NOT NULL;
		UPDATE temp_arc_flowregulator t SET geom3 = d.geom3 FROM v_edit_inp_dscenario_flwreg_orifice d 
		WHERE t.arc_id = d.nodarc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.geom3 IS NOT NULL;
		UPDATE temp_arc_flowregulator t SET geom4 = d.geom4 FROM v_edit_inp_dscenario_flwreg_orifice d 
		WHERE t.arc_id = d.nodarc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.geom4 IS NOT NULL;
		UPDATE temp_arc_flowregulator t SET close_time = d.close_time FROM v_edit_inp_dscenario_flwreg_orifice d 
		WHERE t.arc_id = d.nodarc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.close_time IS NOT NULL;

		-- update flwreg outlet
		UPDATE temp_arc_flowregulator t SET outlet_type = d.outlet_type FROM v_edit_inp_dscenario_flwreg_outlet d 
		WHERE t.arc_id = d.nodarc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.outlet_type IS NOT NULL;
		UPDATE temp_arc_flowregulator t SET offsetval = d.offsetval FROM v_edit_inp_dscenario_flwreg_outlet d 
		WHERE t.arc_id = d.nodarc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.offsetval IS NOT NULL;
		UPDATE temp_arc_flowregulator t SET curve_id = d.curve_id FROM v_edit_inp_dscenario_flwreg_outlet d 
		WHERE t.arc_id = d.nodarc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.curve_id IS NOT NULL;
		UPDATE temp_arc_flowregulator t SET cd1 = d.cd1 FROM v_edit_inp_dscenario_flwreg_outlet d 
		WHERE t.arc_id = d.nodarc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.cd1 IS NOT NULL;
		UPDATE temp_arc_flowregulator t SET ec = d.ec FROM v_edit_inp_dscenario_flwreg_outlet d 
		WHERE t.arc_id = d.nodarc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.cd2 IS NOT NULL;
		UPDATE temp_arc_flowregulator t SET flap = d.flap FROM v_edit_inp_dscenario_flwreg_outlet d 
		WHERE t.arc_id = d.nodarc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.flap IS NOT NULL;
		
		-- update flwreg pump
		UPDATE temp_arc_flowregulator t SET curve_id = d.curve_id FROM v_edit_inp_dscenario_flwreg_pump d 
		WHERE t.arc_id = d.nodarc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.curve_id IS NOT NULL;
		UPDATE temp_arc_flowregulator t SET status = d.status FROM v_edit_inp_dscenario_flwreg_pump d 
		WHERE t.arc_id = d.nodarc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.status IS NOT NULL;
		UPDATE temp_arc_flowregulator t SET startup = d.startup FROM v_edit_inp_dscenario_flwreg_pump d 
		WHERE t.arc_id = d.nodarc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.startup IS NOT NULL;
		UPDATE temp_arc_flowregulator t SET shutoff = d.shutoff FROM v_edit_inp_dscenario_flwreg_pump d 
		WHERE t.arc_id = d.nodarc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.shutoff IS NOT NULL;

		-- update flwreg weir
		UPDATE temp_arc_flowregulator t SET weir_type = d.weir_type FROM v_edit_inp_dscenario_flwreg_weir d 
		WHERE t.arc_id = d.nodarc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.weir_type IS NOT NULL;
		UPDATE temp_arc_flowregulator t SET offsetval = d.offsetval FROM v_edit_inp_dscenario_flwreg_weir d 
		WHERE t.arc_id = d.nodarc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.offsetval IS NOT NULL;
		UPDATE temp_arc_flowregulator t SET cd = d.cd FROM v_edit_inp_dscenario_flwreg_weir d 
		WHERE t.arc_id = d.nodarc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.cd IS NOT NULL;
		UPDATE temp_arc_flowregulator t SET ec = d.ec FROM v_edit_inp_dscenario_flwreg_weir d 
		WHERE t.arc_id = d.nodarc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.ec IS NOT NULL;
		UPDATE temp_arc_flowregulator t SET cd2 = d.cd2 FROM v_edit_inp_dscenario_flwreg_weir d 
		WHERE t.arc_id = d.nodarc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.cd2 IS NOT NULL;
		UPDATE temp_arc_flowregulator t SET flap = d.flap FROM v_edit_inp_dscenario_flwreg_weir d 
		WHERE t.arc_id = d.nodarc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.flap IS NOT NULL;
		UPDATE temp_arc_flowregulator t SET geom1 = d.geom1 FROM v_edit_inp_dscenario_flwreg_weir d 
		WHERE t.arc_id = d.nodarc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.geom1 IS NOT NULL;
		UPDATE temp_arc_flowregulator t SET geom2 = d.geom2 FROM v_edit_inp_dscenario_flwreg_weir d 
		WHERE t.arc_id = d.nodarc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.geom2 IS NOT NULL;
		UPDATE temp_arc_flowregulator t SET geom3 = d.geom3 FROM v_edit_inp_dscenario_flwreg_weir d 
		WHERE t.arc_id = d.nodarc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.geom3 IS NOT NULL;
		UPDATE temp_arc_flowregulator t SET geom4 = d.geom4 FROM v_edit_inp_dscenario_flwreg_weir d 
		WHERE t.arc_id = d.nodarc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.geom4 IS NOT NULL;
		UPDATE temp_arc_flowregulator t SET surcharge = d.surcharge FROM v_edit_inp_dscenario_flwreg_weir d 
		WHERE t.arc_id = d.nodarc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.surcharge IS NOT NULL;
		UPDATE temp_arc_flowregulator t SET road_width = d.road_width FROM v_edit_inp_dscenario_flwreg_weir d 
		WHERE t.arc_id = d.nodarc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.road_width IS NOT NULL;
		UPDATE temp_arc_flowregulator t SET road_surf = d.road_surf FROM v_edit_inp_dscenario_flwreg_weir d 
		WHERE t.arc_id = d.nodarc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.road_surf IS NOT NULL;
		UPDATE temp_arc_flowregulator t SET coef_curve = d.coef_curve FROM v_edit_inp_dscenario_flwreg_weir d 
		WHERE t.arc_id = d.nodarc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.coef_curve IS NOT NULL;
		
		-- update inflows
		UPDATE temp_node_other t SET order_id = d.order_id FROM v_edit_inp_dscenario_inflows d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.order_id IS NOT NULL;
		UPDATE temp_node_other t SET timser_id = d.timser_id FROM v_edit_inp_dscenario_inflows d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.timser_id IS NOT NULL;
		UPDATE temp_node_other t SET sfactor = d.sfactor FROM v_edit_inp_dscenario_inflows d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.sfactor IS NOT NULL;
		UPDATE temp_node_other t SET base = d.base FROM v_edit_inp_dscenario_inflows d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.base IS NOT NULL;
		UPDATE temp_node_other t SET pattern_id = d.pattern_id FROM v_edit_inp_dscenario_inflows d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.pattern_id IS NOT NULL;	

		-- update inflows poll
		UPDATE temp_node_other t SET poll_id = d.poll_id FROM v_edit_inp_dscenario_inflows_poll d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.poll_id IS NOT NULL;
		UPDATE temp_node_other t SET timser_id = d.timser_id FROM v_edit_inp_dscenario_inflows_poll d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.timser_id IS NOT NULL;
		UPDATE temp_node_other t SET form_type = d.form_type FROM v_edit_inp_dscenario_inflows_poll d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.form_type IS NOT NULL;
		UPDATE temp_node_other t SET mfactor = d.mfactor FROM v_edit_inp_dscenario_inflows_poll d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.mfactor IS NOT NULL;
		UPDATE temp_node_other t SET sfactor = d.sfactor FROM v_edit_inp_dscenario_inflows_poll d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.sfactor IS NOT NULL;
		UPDATE temp_node_other t SET base = d.base FROM v_edit_inp_dscenario_inflows_poll d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.base IS NOT NULL;
		UPDATE temp_node_other t SET pattern_id = d.pattern_id FROM v_edit_inp_dscenario_inflows_poll d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.pattern_id IS NOT NULL;		

		-- update treatment
		UPDATE temp_node_other t SET poll_id = d.poll_id FROM v_edit_inp_dscenario_treatment d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.poll_id IS NOT NULL;
		UPDATE temp_node_other t SET function = d.function FROM v_edit_inp_dscenario_treatment d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.function IS NOT NULL;	
					
	END IF;

	RETURN 1;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
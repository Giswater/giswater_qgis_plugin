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
v_demandpriority integer; 
v_querytext text;
v_patternmethod integer;
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

		-- arccat
		UPDATE temp_arc t SET arccat_id = d.arccat_id FROM v_edit_inp_dscenario_conduit d 
		WHERE t.arc_id = d.arc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.arccat_id IS NOT NULL;

		-- n
		-- when material comes from arccat
		UPDATE temp_arc t SET n = d.n FROM (SELECT * FROM v_edit_inp_dscenario_conduit a 
		JOIN cat_arc c ON c.id = a.arccat_id  
		JOIN cat_mat_arc b ON c.matcat_id = id) d
		WHERE t.arc_id = d.arc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.arccat_id IS NOT NULL;

		-- when material is informed by user
		UPDATE temp_arc t SET n = d.n FROM (SELECT * FROM v_edit_inp_dscenario_conduit a JOIN cat_mat_arc b ON a.matcat_id = id WHERE a.matcat_id IS NOT NULL)d
		WHERE t.arc_id = d.arc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.matcat_id IS NOT NULL;

		-- when n is informed by user
		UPDATE temp_arc t SET n = d.custom_n FROM v_edit_inp_dscenario_conduit d 
		WHERE t.arc_id = d.arc_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.custom_n IS NOT NULL;


		-- update junctions
		UPDATE temp_node t SET y0 = d.y0 FROM v_edit_inp_dscenario_junction d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.y0 IS NOT NULL;		
		UPDATE temp_node t SET ysur = d.ysur FROM v_edit_inp_dscenario_junction d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.ysur IS NOT NULL;	
		UPDATE temp_node t SET apond = d.apond FROM v_edit_inp_dscenario_junction d 
		WHERE t.node_id = d.node_id AND dscenario_id IN (SELECT unnest(v_userscenario)) AND d.apond IS NOT NULL;	

		-- TODO: update outfallparam
			
	END IF;

	RETURN 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
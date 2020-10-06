/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- FUNCTION NUMBER : 2812

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_vi()
  RETURNS trigger AS
$BODY$
DECLARE 
  v_view text;
  v_epsg integer;
  geom_array public.geometry array;
  v_point_geom public.geometry;
  rec_arc record;

  
BEGIN

    --Get schema name
    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    
    -- Get SRID
  SELECT epsg INTO v_epsg FROM sys_version LIMIT 1;
  
    --Get view name
    v_view = TG_ARGV[0];

    --inserts of data via editable views into corresponding arc, node, man_* and inp_* tables
    --split_part(NEW.other_val,';',1) splitting the values concatenated in a vie in order to put it in separated fields of a view
    --nullif(split_part(NEW.other_val,';',1),'')::numeric in case of trying to split the value that may not exist(optional value),
    --nullif function returns null instead of cast value error in case when there is no value in the inp data
    
   IF TG_OP = 'INSERT' THEN
	  IF v_view='vi_junctions' THEN
	    INSERT INTO node (node_id, elevation, nodecat_id,epa_type,sector_id, dma_id, expl_id, state, state_type) 
	    VALUES (NEW.node_id, NEW.elevation,'EPAJUN-CAT','JUNCTION',1,1,1,1,(SELECT id FROM value_state_type WHERE state=1 LIMIT 1)) ;
	    INSERT INTO inp_junction (node_id, demand, pattern_id) VALUES (NEW.node_id, NEW.demand, NEW.pattern_id);
	    INSERT INTO man_junction (node_id) VALUES (NEW.node_id); 
	    
	  ELSIF v_view='vi_reservoirs' THEN
	    INSERT INTO node (node_id, elevation, nodecat_id,epa_type,sector_id, dma_id, expl_id, state, state_type) 
	    VALUES (NEW.node_id, NEW.head,'EPARES-CAT','RESERVOIR',1,1,1,1,(SELECT id FROM value_state_type WHERE state=1 LIMIT 1)) ;
	    INSERT INTO inp_reservoir (node_id, pattern_id) VALUES (NEW.node_id, NEW.pattern_id);
	    INSERT INTO man_source(node_id) VALUES (NEW.node_id); 
	    
	  ELSIF v_view='vi_tanks' THEN
	    INSERT INTO node (node_id, elevation, nodecat_id,epa_type,sector_id, dma_id, expl_id, state, state_type) 
	    VALUES (NEW.node_id, NEW.elevation,'EPATAN-CAT','TANK',1,1,1,1,(SELECT id FROM value_state_type WHERE state=1 LIMIT 1));
	    INSERT INTO inp_tank (node_id, initlevel, minlevel, maxlevel, diameter, minvol, curve_id) 
	    VALUES (NEW.node_id, NEW.initlevel, NEW.minlevel, NEW.maxlevel, NEW.diameter, NEW.minvol, NEW.curve_id);
	    INSERT INTO man_tank (node_id) VALUES (NEW.node_id); 
	    
	  ELSIF v_view='vi_pipes' THEN
	    INSERT INTO arc (arc_id, node_1, node_2, arccat_id,epa_type,custom_length,sector_id, dma_id, expl_id, state, state_type) 
	    VALUES (NEW.arc_id,NEW.node_1, NEW.node_2,concat(NEW.roughness::numeric(10,3),'-',NEW.diameter::numeric(10,3))::text,'PIPE',NEW.length,1,1,1,1,(SELECT id FROM value_state_type WHERE state=1 LIMIT 1));
	    INSERT INTO inp_pipe (arc_id, minorloss) VALUES (NEW.arc_id, NEW.minorloss);
	    INSERT INTO man_pipe (arc_id) VALUES (NEW.arc_id); 
	    UPDATE inp_pipe SET status=id FROM inp_typevalue WHERE arc_id=NEW.arc_id AND NEW.status=inp_typevalue.idval AND typevalue='inp_value_status_pipe';

	    
	  ELSIF v_view='vi_pumps' THEN 
	    INSERT INTO arc (arc_id, node_1, node_2, arccat_id,epa_type,sector_id, dma_id, expl_id, state, state_type) 
	    VALUES (NEW.arc_id, NEW.node_1, NEW.node_2, 'EPAPUMP-CAT','PUMP',1,1,1,1,(SELECT id FROM value_state_type WHERE state=1 LIMIT 1));
	    IF NEW.power ='POWER' THEN
			NEW.power=NEW.head;
	    ELSIF NEW.power ='HEAD' THEN
			NEW.power=NULL;	   
	    END IF;
	    
	    INSERT INTO inp_pump_importinp (arc_id,power,curve_id,speed,pattern)
	    VALUES (NEW.arc_id,NEW.power, NEW.head, NEW.speed::numeric, NEW.pattern);
	    INSERT INTO man_pipe (arc_id) VALUES (NEW.arc_id); 
	    
	  ELSIF v_view='vi_valves' THEN
	    INSERT INTO arc (arc_id, node_1, node_2, arccat_id,epa_type,sector_id, dma_id, expl_id, state, state_type) 
	    VALUES (NEW.arc_id, NEW.node_1, NEW.node_2,concat('EPA',NEW.valv_type,'-CAT')::text,'VALVE',1,1,1,1,(SELECT id FROM value_state_type WHERE state=1 LIMIT 1));
	    INSERT INTO inp_valve_importinp (arc_id, diameter, valv_type, minorloss) VALUES (NEW.arc_id,NEW.diameter, NEW.valv_type, NEW.minorloss);
	      IF NEW.valv_type='PRV' THEN
		UPDATE inp_valve_importinp SET pressure=NEW.setting::numeric WHERE arc_id=NEW.arc_id;
	      ELSIF NEW.valv_type='FCV' THEN 
		UPDATE inp_valve_importinp SET flow=NEW.setting::numeric WHERE arc_id=NEW.arc_id;
	      ELSIF NEW.valv_type='TCV' THEN
		UPDATE inp_valve_importinp SET coef_loss=NEW.setting::numeric WHERE arc_id=NEW.arc_id;
	      ELSIF NEW.valv_type='GPV' THEN
		UPDATE inp_valve_importinp SET curve_id=NEW.setting WHERE arc_id=NEW.arc_id;
	      END IF;         
	    INSERT INTO man_pipe (arc_id) VALUES (NEW.arc_id); 
	    
	  ELSIF v_view='vi_tags' THEN 
	    INSERT INTO inp_tags(object, node_id, tag) VALUES (NEW.object, NEW.node_id, NEW.tag);
	    
	  ELSIF v_view='vi_demands' THEN 
	    INSERT INTO inp_demand (feature_id, demand, pattern_id, demand_type) VALUES (NEW.feature_id, NEW.demand, NEW.pattern_id, NEW.demand_type);
	      
	  ELSIF v_view='vi_status' THEN
	    IF NEW.arc_id IN (SELECT arc_id FROM inp_pump_importinp) THEN
	      UPDATE inp_pump_importinp SET status=upper(NEW.idval);
	    ELSIF NEW.arc_id IN (SELECT arc_id FROM inp_valve_importinp) THEN
      	      UPDATE inp_valve_importinp SET status=upper(NEW.idval);
	    END IF;
	    
	  ELSIF v_view='vi_patterns' THEN 
	    INSERT INTO inp_pattern_value (pattern_id, factor_1,factor_2,factor_3,factor_4,factor_5,factor_6,factor_7,factor_8, factor_9,factor_10,
					   factor_11,factor_12,factor_13,factor_14, factor_15, factor_16,factor_17, factor_18) VALUES 
					   (NEW.pattern_id, NEW.factor_1,NEW.factor_2,NEW.factor_3,NEW.factor_4,NEW.factor_5,NEW.factor_6,NEW.factor_7,NEW.factor_8, NEW.factor_9,
					   NEW.factor_10,NEW.factor_11,NEW.factor_12,NEW.factor_13,NEW.factor_14, NEW.factor_15, NEW.factor_16,NEW.factor_17, NEW.factor_18);
	  
	  ELSIF v_view='vi_curves' THEN

	    IF NEW.curve_id NOT IN (SELECT id FROM inp_curve) then
	      INSERT INTO inp_curve (id,curve_type,descript)  VALUES (NEW.curve_id, split_part(NEW.other,' ',1), split_part(NEW.other,' ',2));
	    END IF;
	    INSERT INTO inp_curve_value(curve_id, x_value, y_value) VALUES (NEW.curve_id, NEW.x_value, NEW.y_value);
	    
	  ELSIF v_view='vi_controls' THEN 
	    INSERT INTO inp_controls_x_arc (arc_id, text) VALUES (split_part(NEW.text,' ',2),NEW.text);
	    	    
	  ELSIF v_view='vi_rules' THEN  
		INSERT INTO inp_rules_importinp (text) VALUES (NEW.text);

	  ELSIF v_view='vi_emitters' THEN
	    INSERT INTO inp_emitter(node_id, coef) VALUES (NEW.node_id, NEW.coef);
	    
	  ELSIF v_view='vi_quality' THEN
	    INSERT INTO inp_quality (node_id,initqual) VALUES (NEW.node_id,NEW.initqual);
	    
	  ELSIF v_view='vi_sources' THEN
	    INSERT INTO inp_source(node_id, sourc_type, quality, pattern_id) VALUES (NEW.node_id, NEW.sourc_type, NEW.quality, NEW.pattern_id);
	    
	  ELSIF v_view='vi_reactions' THEN

	  	IF NEW.arc_id IN (SELECT arc_id FROM inp_pipe) THEN
	  		UPDATE inp_pipe SET reactionparam = NEW.idval, reactionvalue = NEW.reactionvalue WHERE arc_id=NEW.arc_id;
	  	ELSE 
	  		INSERT INTO inp_reactions (descript) VALUES (concat(NEW.idval,' ', NEW.arc_id,' ',NEW.reactionvalue));
	  	END IF;

	  ELSIF v_view='vi_energy' THEN
	  	IF NEW.pump_id ilike 'PUMP%' THEN
	  		UPDATE inp_pump_importinp SET energyparam = NEW.idval , energyvalue = NEW.energyvalue 
	  		WHERE arc_id = REGEXP_REPLACE(LTRIM (NEW.pump_id, 'PUMP '),' ','');
	  	ELSE
	  		INSERT INTO inp_energy(descript) select concat(NEW.pump_id, ' ',NEW.idval); 
	  	END IF;

	  ELSIF v_view='vi_mixing' THEN
	    INSERT INTO inp_mixing(node_id, mix_type, value) VALUES (NEW.node_id, NEW.mix_type, NEW.value);
	    
	  ELSIF v_view='vi_times' THEN 
	    IF NEW.value IS NULL THEN
	      INSERT INTO config_param_user (parameter, value, cur_user) 
	      VALUES (concat('inp_times_',(lower(split_part(NEW.parameter,'_',1)))), split_part(NEW.parameter,'_',2), current_user)
	      ON CONFLICT (parameter,cur_user) DO NOTHING;
	    ELSE
	      INSERT INTO config_param_user (parameter, value, cur_user) 
	      VALUES (concat('inp_times_',(lower(NEW.parameter))), NEW.value, current_user) 
	     ON CONFLICT (parameter,cur_user) DO NOTHING;
	    END IF;
	  ELSIF v_view='vi_report' THEN
	    INSERT INTO config_param_user (parameter, value, cur_user) 
	    SELECT id, vdefault, current_user FROM sys_param_user 
	    WHERE layoutname IN ('lyt_reports_1', 'lyt_reports_2') AND ismandatory=true AND vdefault IS NOT NULL
	    ON CONFLICT (parameter,cur_user) DO NOTHING;
	    
	  ELSIF v_view='vi_coordinates' THEN
	    UPDATE node SET the_geom=ST_SetSrid(ST_MakePoint(NEW.xcoord,NEW.ycoord),v_epsg) WHERE node_id=NEW.node_id;
	    
	  ELSIF v_view='vi_labels' THEN
	    INSERT INTO inp_label (xcoord, ycoord, label, node_id) VALUES (NEW.xcoord, NEW.ycoord, NEW.label, NEW.node_id);
	    
	  ELSIF v_view='vi_backdrop' THEN
	    INSERT INTO inp_backdrop(text) VALUES (NEW.text);
	    
	  ELSIF v_view='vi_options' THEN
	    INSERT INTO config_param_user (parameter, value, cur_user) 
	    VALUES (concat('inp_options_',(lower(NEW.parameter))), NEW.value, current_user) 
	    ON CONFLICT (parameter,cur_user) DO NOTHING;
	  END IF;
	  
	  RETURN NEW; 	
    END IF;

 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

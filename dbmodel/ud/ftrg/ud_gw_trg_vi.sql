	-- Function: SCHEMA_NAME.gw_trg_vi()

	-- DROP FUNCTION SCHEMA_NAME.gw_trg_vi();

	CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_vi()
	  RETURNS trigger AS
	$BODY$
	DECLARE 
		v_view text;
		v_epsg integer;


	BEGIN

	    --Get schema name
	    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	    -- Get SRID
		SELECT epsg INTO v_epsg FROM version LIMIT 1;
		
	    --Get view name
	    v_view = TG_ARGV[0];
	    --inserts of data via editable views into corresponding arc, node, man_* and inp_* tables
	    --split_part(NEW.other_val,';',1) splitting the values concatenated in a view in order to put it in separated fields of the tables
	    --nullif(split_part(NEW.other_val,';',1),'')::numeric in case of trying to split the value that may not exist(optional value),
	    --nullif function returns null instead of cast value error in case when there is no value in the inp data

	    IF TG_OP = 'INSERT' THEN
		IF v_view='vi_options' THEN
			INSERT INTO config_param_user (parameter, value, cur_user) VALUES (concat('inp_options_',(lower(NEW.parameter))), NEW.value, current_user) ;
		ELSIF v_view='vi_report' THEN
			INSERT INTO config_param_user (parameter, value, cur_user) VALUES (concat('inp_report_',(lower(NEW.parameter))), NEW.value, current_user) ;
		ELSIF v_view='vi_files' THEN
			INSERT INTO inp_files (actio_type, file_type, fname) VALUES (NEW.actio_type, NEW.file_type, NEW.fname);
		ELSIF v_view='vi_evaporation' THEN 
			INSERT INTO inp_evaporation (evap_type, value) SELECT inp_typevalue.id, NEW.value
			FROM inp_typevalue WHERE upper(split_part(NEW.value,';',1))=idval AND typevalue='inp_typevalue_evap';
		ELSIF v_view='vi_raingages' THEN
			IF split_part(NEW.other_val,';',1) ILIKE 'TIMESERIES' THEN
				INSERT INTO raingage (rg_id, form_type, intvl, scf, rgage_type, timser_id, expl_id) VALUES (NEW.rg_id,NEW.form_type,NEW.intvl,NEW.scf, 'TIMESERIES_RAIN',
				split_part(NEW.other_val,';',2),1);
			ELSIF split_part(NEW.other_val,';',1) ILIKE 'FILE' THEN
				INSERT INTO raingage (rg_id, form_type, intvl, scf, rgage_type, fname, sta, units, expl_id) VALUES (NEW.rg_id,NEW.form_type,NEW.intvl,NEW.scf, 'FILE_RAIN',
				split_part(NEW.other_val,';',2),split_part(NEW.other_val,';',3),split_part(NEW.other_val,';',4),1);
			END IF;
		ELSIF v_view='vi_temperature' THEN 
			INSERT INTO inp_temperature (temp_type, value) SELECT inp_typevalue.id, NEW.value
				FROM inp_typevalue WHERE upper(NEW.temp_type)=idval AND typevalue='inp_typevalue_pattern';
		ELSIF v_view='vi_subcatchments' THEN 
			INSERT INTO subcatchment (subc_id, rg_id, node_id, area, imperv, width, slope, clength,snow_id) 
			VALUES (NEW.subc_id, NEW.rg_id, NEW.node_id, NEW.area, NEW.imperv, NEW.width, NEW.slope, NEW.clength,NEW.snow_id);
		ELSIF v_view='vi_subareas' THEN
			UPDATE subcatchment SET nimp=NEW.nimp, nperv=NEW.nperv, simp=NEW.simp, sperv=NEW.sperv, zero=NEW.zero, routeto=NEW.routeto, rted=NEW.rted WHERE subc_id=NEW.subc_id;
		ELSIF v_view='vi_infiltration' THEN 
			IF (SELECT value FROM config_param_user WHERE cur_user=current_user AND parameter='inp_options_infiltration') like 'CURVE_NUMBER' THEN
				UPDATE subcatchment SET curveno=nullif(split_part(NEW.other_val,';',1),'')::numeric,
				conduct_2=nullif(split_part(NEW.other_val,';',2),'')::numeric,drytime_2=nullif(split_part(NEW.other_val,';',3),'')::numeric
				WHERE subc_id=NEW.subc_id;
			ELSIF (SELECT value FROM config_param_user WHERE cur_user=current_user AND parameter='inp_options_infiltration') like 'GREEN_AMPT' THEN
				UPDATE subcatchment SET suction=nullif(split_part(NEW.other_val,';',1),'')::numeric,conduct=nullif(split_part(NEW.other_val,';',2),'')::numeric,
				initdef=nullif(split_part(NEW.other_val,';',3),'')::numeric WHERE subc_id=NEW.subc_id;
			ELSIF (SELECT value FROM config_param_user WHERE cur_user=current_user AND parameter='inp_options_infiltration') like '%HORTON' THEN
				UPDATE subcatchment SET maxrate=nullif(split_part(NEW.other_val,';',1),'')::numeric, minrate=nullif(split_part(NEW.other_val,';',2),'')::numeric,
				decay=nullif(split_part(NEW.other_val,';',3),'')::numeric, drytime=nullif(split_part(NEW.other_val,';',4),'')::numeric,
				maxinfil=nullif(split_part(NEW.other_val,';',5),'')::numeric WHERE subc_id=NEW.subc_id;
			END IF;
		ELSIF v_view='vi_aquifers' THEN
			INSERT INTO inp_aquifer (aquif_id, por, wp, fc, k, ks, ps, uef, led, gwr, be, wte, umc, pattern_id) 
			VALUES (NEW.aquif_id, NEW.por, NEW.wp, NEW.fc, NEW.k, NEW.ks, NEW.ps, NEW.uef, NEW.led, NEW.gwr, NEW.be, NEW.wte, NEW.umc, NEW.pattern_id);
		ELSIF v_view='vi_groundwater' THEN
			INSERT INTO inp_groundwater (subc_id, aquif_id, node_id, surfel, a1, b1, a2, b2, a3, tw, h) 
			VALUES (NEW.subc_id, NEW.aquif_id, NEW.node_id, NEW.surfel, NEW.a1, NEW.b1, NEW.a2, NEW.b2, NEW.a3, NEW.tw, NEW.h);
		ELSIF v_view='vi_snowpacks' THEN
			INSERT INTO inp_snowpack (snow_id, snow_type, value_1, value_2, value_3, value_4, value_5, value_6, value_7)
			VALUES (NEW.snow_id,NEW.snow_type, NEW.value_1, NEW.value_2, NEW.value_3, NEW.value_4, NEW.value_5, NEW.value_6, NEW.value_7);
		ELSIF v_view='vi_gwf' THEN 
			UPDATE inp_groundwater set fl_eq_lat=split_part(NEW.fl_eq_lat,';',2),fl_eq_deep=split_part(NEW.fl_eq_deep,';',2) WHERE subc_id=NEW.subc_id;
		ELSIF v_view='vi_junction' THEN
			INSERT INTO node (node_id, elev, ymax,node_type,nodecat_id,epa_type,sector_id, dma_id, expl_id, state, state_type) 
			VALUES (NEW.node_id, NEW.elev, NEW.ymax,'EPAMANHOLE','EPAMANHOLE-DEF','JUNCTION',1,1,1,1,2);
			INSERT INTO man_manhole (node_id) VALUES (NEW.node_id);
			INSERT INTO inp_junction(node_id, y0, ysur, apond) VALUES (NEW.node_id, NEW.y0, NEW.ysur, NEW.apond);
		ELSIF v_view='vi_outfalls' THEN
			INSERT INTO node (node_id, elev,node_type,nodecat_id,epa_type,sector_id, dma_id, expl_id, state, state_type) 
			VALUES (NEW.node_id, NEW.elev,'EPAOUTFALL','EPAOUTFALL-DEF','JUNCTION',1,1,1,1,2);
			INSERT INTO man_outfall (node_id) VALUES (NEW.node_id);
			
			IF NEW.outfall_type  like 'FREE' or NEW.outfall_type  like 'NORMAL' THEN
				INSERT INTO inp_outfall  (node_id, outfall_type, gate) values (NEW.node_id, NEW.outfall_type, NEW.other_val);
			ELSIF NEW.outfall_type like 'FIXED' THEN 
				INSERT INTO inp_outfall (node_id, outfall_type,stage, gate) values (NEW.node_id, NEW.outfall_type,split_part(NEW.other_val,' ',1),split_part(NEW.other_val,' ',2));
			ELSIF NEW.outfall_type like 'TIDAL' THEN
				INSERT INTO inp_outfall (node_id, outfall_type,curve_id, gate) values (NEW.node_id,NEW.outfall_type,split_part(NEW.other_val,' ',1),split_part(NEW.other_val,' ',2));
			ELSIF NEW.outfall_type like 'TIMESERIES' THEN
				INSERT INTO inp_outfall (node_id, outfall_type,timser_id, gate) values (NEW.node_id, NEW.outfall_type,split_part(NEW.other_val,' ',1),split_part(NEW.other_val,' ',2));
			END IF;
			ELSIF v_view='vi_dividers' THEN
			IF NEW.divider_type LIKE 'CUTOFF' THEN
				INSERT INTO inp_divider (node_id, arc_id, divider_type, qmin, y0,ysur,apond) VALUES (NEW.node_id, NEW.arc_id,'CUTOFF', nullif(split_part(NEW.other_val,';',1),'')::numeric,
				nullif(split_part(NEW.other_val,';',2),'')::numeric,nullif(split_part(NEW.other_val,';',3),'')::numeric,nullif(split_part(NEW.other_val,';',4),'')::numeric);
			ELSIF NEW.divider_type LIKE 'OVERFLOW' THEN
				INSERT INTO inp_divider (node_id, arc_id, divider_type, y0,ysur,apond) VALUES (NEW.node_id, NEW.arc_id, 'OVERFLOW', nullif(split_part(NEW.other_val,';',1),'')::numeric,
				nullif(split_part(NEW.other_val,';',2),'')::numeric,nullif(split_part(NEW.other_val,';',3),'')::numeric);
			ELSIF NEW.divider_type LIKE 'TABULAR' THEN
				INSERT INTO inp_divider (node_id, arc_id, divider_type, curve_id, y0,ysur,apond) VALUES (NEW.node_id, NEW.arc_id, 'TABULAR_DIVIDER',split_part(NEW.other_val,';',1),
				nullif(split_part(NEW.other_val,';',2),'')::numeric,nullif(split_part(NEW.other_val,';',3),'')::numeric,nullif(split_part(NEW.other_val,';',4),'')::numeric);
			ELSIF NEW.divider_type LIKE 'WEIR' THEN
				INSERT INTO inp_divider (node_id, arc_id, divider_type, qmin,ht,cd, y0,ysur,apond) VALUES (NEW.node_id, NEW.arc_id, 'WEIR', nullif(split_part(NEW.other_val,';',1),'')::numeric,
				nullif(split_part(NEW.other_val,';',2),'')::numeric,nullif(split_part(NEW.other_val,';',3),'')::numeric,nullif(split_part(NEW.other_val,';',4),'')::numeric,
				nullif(split_part(NEW.other_val,';',5),'')::numeric,nullif(split_part(NEW.other_val,';',6),'')::numeric);
			END IF;
		ELSIF v_view='vi_storage' THEN
			INSERT INTO node (node_id, elev, ymax,node_type,nodecat_id,epa_type,sector_id, dma_id, expl_id, state, state_type) 
			VALUES (NEW.node_id, NEW.elev, NEW.ymax,'EPASTORAGE','EPASTORAGE-DEF','STORAGE',1,1,1,1,2);
			INSERT INTO man_storage (node_id) VALUES (NEW.node_id);
			IF NEW.storage_type = 'FUNCTIONAL' THEN 
				INSERT INTO inp_storage(node_id,y0,storage_type,a1,a2,a0,apond, fevap, sh, hc, imd) 
				VALUES (NEW.node_id,NEW.y0,'FUNCTIONAL', nullif(split_part(NEW.other_val,';',1),'')::numeric,
				nullif(split_part(NEW.other_val,';',2),'')::numeric,nullif(split_part(NEW.other_val,';',3),'')::numeric,nullif(split_part(NEW.other_val,';',4),'')::numeric,
				nullif(split_part(NEW.other_val,';',5),'')::numeric,nullif(split_part(NEW.other_val,';',6),'')::numeric,
				nullif(split_part(NEW.other_val,';',7),'')::numeric,nullif(split_part(NEW.other_val,';',8),'')::numeric);
			ELSIF NEW.storage_type like 'TABULAR' THEN
				INSERT INTO inp_storage(node_id,y0,storage_type,curve_id,apond,fevap, sh, hc, imd) VALUES (NEW.node_id,NEW.y0,'TABULAR_STORAGE',split_part(NEW.other_val,';',1),
				nullif(split_part(NEW.other_val,';',2),'')::numeric,nullif(split_part(NEW.other_val,';',3),'')::numeric,nullif(split_part(NEW.other_val,';',4),'')::numeric,
				nullif(split_part(NEW.other_val,';',5),'')::numeric,nullif(split_part(NEW.other_val,';',6),'')::numeric);
			END IF;
		ELSIF v_view='vi_conduits' THEN 
			INSERT INTO arc (arc_id, node_1,node_2,y1,y2, sys_length, arc_type, arccat_id, epa_type, sector_id, dma_id, expl_id, state, state_type) 
			VALUES (NEW.arc_id, NEW.node_1, NEW.node_2,NEW.z1, NEW.z2, NEW.length, 'EPACONDUIT','EPACONDUIT-DEF','CONDUIT',1,1,1,1,2);
			INSERT INTO man_conduit(arc_id) VALUES (NEW.arc_id);
			INSERT INTO inp_conduit (arc_id,custom_n, q0, qmax) VALUES (NEW.arc_id,NEW.n, NEW.q0, NEW.qmax); 
		ELSIF v_view='vi_pumps' THEN 
			INSERT INTO arc (arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, dma_id, expl_id, state, state_type) 
			VALUES (NEW.arc_id, NEW.node_1, NEW.node_2, 'EPAPUMP','EPAPUMP-DEF','CONDUIT',1,1,1,1,2);
			INSERT INTO man_varc (arc_id) VALUES (NEW.arc_id);
			INSERT INTO inp_pump (arc_id, curve_id, status, startup, shutoff) VALUES (NEW.arc_id, NEW.curve_id, NEW.status, NEW.startup, NEW.shutoff);
		ELSIF v_view='vi_orifices' THEN 
			INSERT INTO arc (arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, dma_id, expl_id, state, state_type) 
			VALUES (NEW.arc_id, NEW.node_1, NEW.node_2, 'EPAORIFICE','EPAORIFICE-DEF','CONDUIT',1,1,1,1,2);
			INSERT INTO man_varc (arc_id) VALUES (NEW.arc_id);
			INSERT INTO inp_orifice (arc_id, ori_type, "offset", cd, flap, orate) VALUES (NEW.arc_id, NEW.ori_type, NEW."offset", NEW.cd, NEW.flap, NEW.orate);
		ELSIF v_view='vi_weirs' THEN 
			INSERT INTO arc (arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, dma_id, expl_id, state, state_type) 
			VALUES (NEW.arc_id, NEW.node_1, NEW.node_2, 'EPAWEIR','EPAWEIR-DEF','CONDUIT',1,1,1,1,2);
			INSERT INTO man_varc (arc_id) VALUES (NEW.arc_id);
			INSERT INTO inp_weir (arc_id, weir_type, "offset", cd, flap, ec, cd2, surcharge) VALUES (NEW.arc_id, NEW.weir_type, NEW."offset", NEW.cd, NEW.flap, NEW.ec, NEW.cd2, NEW.surcharge);
		ELSIF v_view='vi_outlets' THEN 
			INSERT INTO arc (arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, dma_id, expl_id, state, state_type) 
			VALUES (NEW.arc_id, NEW.node_1, NEW.node_2, 'EPAOUTLET','EPAOUTLET-DEF','CONDUIT',1,1,1,1,2);
			INSERT INTO man_varc (arc_id) VALUES (NEW.arc_id);
			IF NEW.outlet_type LIKE 'FUNCTIONAL%' THEN
				INSERT INTO inp_outlet (arc_id, "offset", outlet_type, cd1, cd2,flap) VALUES (NEW.arc_id, NEW."offset", NEW.outlet_type, nullif(split_part(NEW.other_val,';',1),'')::numeric,
				nullif(split_part(NEW.other_val,';',2),'')::numeric,split_part(NEW.other_val,';',3));
			ELSIF NEW.outlet_type LIKE 'TABULAR%' THEN
				INSERT INTO inp_outlet (arc_id, "offset", outlet_type, curve_id,flap) VALUES (NEW.arc_id, NEW."offset", NEW.outlet_type, split_part(NEW.other_val,';',1),
				split_part(NEW.other_val,';',2));
			END IF;
		ELSIF v_view='vi_xsections' THEN 
			UPDATE arc SET arccat_id=NEW.shape WHERE arc_id=NEW.arc_id;
		ELSIF v_view='vi_losses' THEN
			UPDATE inp_conduit SET kentry=NEW.kentry,kexit=NEW.kexit, kavg=NEW.kavg, flap=NEW.flap, seepage=NEW.seepage WHERE arc_id=NEW.arc_id;
		ELSIF v_view='vi_transects' THEN 
			INSERT INTO inp_transects_id (id) SELECT split_part(NEW.text,' ',1) WHERE split_part(NEW.text,' ',1)  NOT IN (SELECT id from inp_transects_id);
			INSERT INTO inp_transects (tsect_id,text) VALUES (split_part(NEW.text,' ',1),NEW.text);
		ELSIF v_view='vi_controls' THEN
			IF split_part(NEW.text,' ',2) IN (SELECT node_id FROM node) THEN
				INSERT INTO inp_controls_x_node (node_id,text) VALUES (split_part(NEW.text,' ',2), NEW.text);
			ELSIF split_part(NEW.text,' ',2) IN (SELECT arc_id FROM arc) THEN 
				INSERT INTO inp_controls_x_arc (arc_id,text) VALUES (split_part(NEW.text,' ',2), NEW.text);
			END IF;
		ELSIF v_view='vi_pollutants' THEN 
			INSERT INTO inp_pollutants (poll_id, units_type, crain, cgw, cii, kd, sflag, copoll_id, cofract, cdwf) 
			VALUES (NEW.poll_id, NEW.units_type, NEW.crain, NEW.cgw, NEW.cii, NEW.kd, NEW.sflag, NEW.copoll_id, NEW.cofract, NEW.cdwf);
		ELSIF v_view='vi_landuses' THEN 
			INSERT INTO inp_landuses (landus_id, sweepint, availab, lastsweep) VALUES (NEW.landus_id, NEW.sweepint, NEW.availab, NEW.lastsweep);
		ELSIF v_view='vi_coverages' THEN 
			INSERT INTO inp_coverage_land_x_subc(subc_id, landus_id, percent) VALUES (NEW.subc_id, NEW.landus_id, NEW.percent);
		ELSIF v_view='vi_buildup' THEN
			INSERT INTO inp_buildup_land_x_pol(landus_id, poll_id, funcb_type, c1, c2, c3, perunit) 
			VALUES (NEW.landus_id, NEW.poll_id, NEW.funcb_type, NEW.c1, NEW.c2, NEW.c3, NEW.perunit);
		ELSIF v_view='vi_washoff' THEN
			INSERT INTO inp_washoff_land_x_pol (landus_id, poll_id, funcw_type, c1, c2, sweepeffic, bmpeffic) 
			VALUES (NEW.landus_id, NEW.poll_id, NEW.funcw_type, NEW.c1, NEW.c2, NEW.sweepeffic, NEW.bmpeffic);
		ELSIF v_view='vi_treatment' THEN
			INSERT INTO inp_treatment_node_x_pol (node_id, poll_id, function) VALUES (NEW.node_id, NEW.poll_id, NEW.function);
		ELSIF v_view='vi_dwf' THEN
			INSERT INTO inp_dwf(node_id,  value, pat1, pat2, pat3, pat4)
			VALUES (NEW.node_id, NEW.value, NEW.pat1, NEW.pat2, NEW.pat3, NEW.pat4);
		ELSIF v_view='vi_patterns' THEN
			IF NEW.pattern_type IN ('MONTHLY','DAILY','WEEKEND','HOURLY') THEN
				INSERT INTO inp_pattern (pattern_id,pattern_type) SELECT NEW.pattern_id,inp_typevalue.id
				FROM inp_typevalue WHERE upper(NEW.pattern_type)=idval AND typevalue='inp_typevalue_pattern';
				
				INSERT INTO inp_pattern_value (pattern_id,factor_1,factor_2,factor_3,factor_4,factor_5,factor_6,factor_7,factor_8,factor_9,factor_10,factor_11,factor_12,
				factor_13,factor_14,factor_15,factor_16,factor_17,factor_18,factor_19,factor_20,factor_21,factor_22,factor_23,factor_24) 
				VALUES (NEW.pattern_id, nullif(split_part(NEW.multipliers,';',1),'')::numeric,nullif(split_part(NEW.multipliers,';',2),'')::numeric,nullif(split_part(NEW.multipliers,';',3),'')::numeric,
				nullif(split_part(NEW.multipliers,';',4),'')::numeric,nullif(split_part(NEW.multipliers,';',5),'')::numeric,nullif(split_part(NEW.multipliers,';',6),'')::numeric,
				nullif(split_part(NEW.multipliers,';',7),'')::numeric, nullif(split_part(NEW.multipliers,';',8),'')::numeric,nullif(split_part(NEW.multipliers,';',9),'')::numeric,
				nullif(split_part(NEW.multipliers,';',10),'')::numeric,nullif(split_part(NEW.multipliers,';',11),'')::numeric,nullif(split_part(NEW.multipliers,';',12),'')::numeric,
				nullif(split_part(NEW.multipliers,';',13),'')::numeric,nullif(split_part(NEW.multipliers,';',14),'')::numeric,nullif(split_part(NEW.multipliers,';',15),'')::numeric,
				nullif(split_part(NEW.multipliers,';',16),'')::numeric,nullif(split_part(NEW.multipliers,';',17),'')::numeric,nullif(split_part(NEW.multipliers,';',18),'')::numeric,
				nullif(split_part(NEW.multipliers,';',19),'')::numeric, nullif(split_part(NEW.multipliers,';',20),'')::numeric,nullif(split_part(NEW.multipliers,';',21),'')::numeric,
				nullif(split_part(NEW.multipliers,';',22),'')::numeric,nullif(split_part(NEW.multipliers,';',23),'')::numeric,nullif(split_part(NEW.multipliers,';',24),'')::numeric);
			ELSE 
				INSERT INTO inp_pattern_value (pattern_id,factor_1,factor_2,factor_3,factor_4,factor_5,factor_6,factor_7,factor_8,factor_9,factor_10,factor_11,factor_12,
				factor_13,factor_14,factor_15,factor_16,factor_17,factor_18,factor_19,factor_20,factor_21,factor_22,factor_23,factor_24) 
				VALUES (NEW.pattern_id, nullif(split_part(NEW.multipliers,';',1),'')::numeric,nullif(split_part(NEW.multipliers,';',2),'')::numeric,nullif(split_part(NEW.multipliers,';',3),'')::numeric,
				nullif(split_part(NEW.multipliers,';',4),'')::numeric,nullif(split_part(NEW.multipliers,';',5),'')::numeric,nullif(split_part(NEW.multipliers,';',6),'')::numeric,
				nullif(split_part(NEW.multipliers,';',7),'')::numeric, nullif(split_part(NEW.multipliers,';',8),'')::numeric,nullif(split_part(NEW.multipliers,';',9),'')::numeric,
				nullif(split_part(NEW.multipliers,';',10),'')::numeric,nullif(split_part(NEW.multipliers,';',11),'')::numeric,nullif(split_part(NEW.multipliers,';',12),'')::numeric,
				nullif(split_part(NEW.multipliers,';',13),'')::numeric,nullif(split_part(NEW.multipliers,';',14),'')::numeric,nullif(split_part(NEW.multipliers,';',15),'')::numeric,
				nullif(split_part(NEW.multipliers,';',16),'')::numeric,nullif(split_part(NEW.multipliers,';',17),'')::numeric,nullif(split_part(NEW.multipliers,';',18),'')::numeric,
				nullif(split_part(NEW.multipliers,';',19),'')::numeric, nullif(split_part(NEW.multipliers,';',20),'')::numeric,nullif(split_part(NEW.multipliers,';',21),'')::numeric,
				nullif(split_part(NEW.multipliers,';',22),'')::numeric,nullif(split_part(NEW.multipliers,';',23),'')::numeric,nullif(split_part(NEW.multipliers,';',24),'')::numeric);
			END IF;
		ELSIF v_view='vi_inflows' THEN
			IF NEW.type_flow ILIKE 'FLOW' THEN
				INSERT INTO inp_inflows(node_id, timser_id, sfactor, base, pattern_id) VALUES (NEW.node_id,NEW.timser_id, nullif(split_part(NEW.other_val,';',3),'')::numeric,
				nullif(split_part(NEW.other_val,';',4),'')::numeric,split_part(NEW.other_val,';',5));
			ELSE
				INSERT INTO inp_inflows_pol_x_node (node_id, timser_id, poll_id,form_type, mfactor, sfactor, base, pattern_id) 
				SELECT NEW.node_id,NEW.timser_id, NEW.type_flow, inp_typevalue.id, nullif(split_part(NEW.other_val,';',2),'')::numeric,
				nullif(split_part(NEW.other_val,';',3),'')::numeric,nullif(split_part(NEW.other_val,';',4),'')::numeric,split_part(NEW.other_val,';',5)
				FROM inp_typevalue WHERE upper(split_part(NEW.other_val,';',1))=idval AND typevalue='inp_value_inflows';
			END IF;	
		ELSIF v_view='vi_loadings' THEN
			INSERT INTO inp_loadings_pol_x_subc (subc_id, poll_id, ibuildup) VALUES (NEW.subc_id, NEW.poll_id, NEW.ibuildup);
		ELSIF v_view='vi_rdii' THEN
			INSERT INTO inp_rdii(node_id, hydro_id, sewerarea) VALUES (NEW.node_id, NEW.hydro_id, NEW.sewerarea);
		ELSIF v_view='vi_hydrographs' THEN
			INSERT INTO inp_hydrograph (text) VALUES (NEW.text);
		ELSIF v_view='vi_curves' THEN
			IF upper(NEW.curve_type) IN ('CONTROL', 'TIDAL', 'DIVERSION', 'PUMP1', 'PUMP2', 'PUMP3', 'PUMP4', 'RATING', 'SHAPE', 'STORAGE', 'TIDAL') THEN
				INSERT INTO inp_curve_id(id, curve_type) SELECT NEW.curve_id, inp_typevalue.id FROM inp_typevalue WHERE upper(NEW.curve_type)=idval AND typevalue='inp_value_curve';
				INSERT INTO inp_curve (curve_id,x_value,y_value) VALUES (NEW.curve_id,NEW.x_value,NEW.y_value);
			ELSE
				INSERT INTO inp_curve (curve_id,x_value,y_value) VALUES (NEW.curve_id,NEW.curve_type::numeric,NEW.x_value);
			END IF;
		ELSIF v_view='vi_timeseries' THEN 
			IF split_part(NEW.other_val,';',1) ilike 'FILE' THEN
				IF NEW.timser_id NOT IN (SELECT id FROM inp_timser_id) THEN
					INSERT INTO inp_timser_id(id,times_type) VALUES (NEW.timser_id,'FILE_TIME') ;
				END IF;
				INSERT INTO inp_timeseries (timser_id,fname) VALUES (NEW.timser_id,split_part(NEW.other_val,';',2));
			ELSIF split_part(NEW.other_val,';',1) ilike '%:%'  THEN
				IF NEW.timser_id NOT IN (SELECT id FROM inp_timser_id) THEN
					INSERT INTO inp_timser_id(id,times_type) VALUES (NEW.timser_id,'RELATIVE');
				END IF;
				INSERT INTO inp_timeseries (timser_id,"time",value)  VALUES (NEW.timser_id,split_part(NEW.other_val,';',1),split_part(NEW.other_val,';',2)::numeric);
			ELSE
				IF NEW.timser_id NOT IN (SELECT id FROM inp_timser_id) THEN
					INSERT INTO inp_timser_id(id,times_type) VALUES (NEW.timser_id,'ABSOLUTE');
				END IF;
				INSERT INTO inp_timeseries (timser_id,date , hour, value) VALUES (NEW.timser_id,nullif(split_part(NEW.other_val,';',1),'')::date,split_part(NEW.other_val,';',2),
				nullif(split_part(NEW.other_val,';',3),'')::numeric);
			END IF;
		ELSIF v_view='vi_lid_controls' THEN 
			INSERT INTO inp_lid_control (lidco_id, lidco_type, value_2, value_3, value_4, value_5, value_6, value_7, value_8)
			SELECT NEW.lidco_id, inp_typevalue.id, nullif(split_part(NEW.other_val,';',1),'')::numeric, nullif(split_part(NEW.other_val,';',2),'')::numeric,
			nullif(split_part(NEW.other_val,';',3),'')::numeric,nullif(split_part(NEW.other_val,';',4),'')::numeric,nullif(split_part(NEW.other_val,';',5),'')::numeric,
			nullif(split_part(NEW.other_val,';',6),'')::numeric,nullif(split_part(NEW.other_val,';',7),'')::numeric
			FROM inp_typevalue WHERE upper(NEW.lidco_type)=idval AND typevalue='inp_value_lidcontrol';
		ELSIF v_view='vi_lid_usage' THEN
			INSERT INTO inp_lidusage_subc_x_lidco (subc_id, lidco_id, "number", area, width, initsat, fromimp, toperv, rptfile) 
			VALUES (NEW.subc_id, NEW.lidco_id, NEW."number", NEW.area, NEW.width, NEW.initsat, NEW.fromimp, NEW.toperv, NEW.rptfile);
		ELSIF v_view='vi_adjustments' THEN
			INSERT INTO inp_adjustments (adj_type, value_1, value_2, value_3, value_4, value_5, value_6, value_7, value_8, value_9, value_10, value_11, value_12)
			VALUES (NEW.adj_type, nullif(split_part(NEW.monthly_adj,';',1),'')::numeric,nullif(split_part(NEW.monthly_adj,';',2),'')::numeric,
			nullif(split_part(NEW.monthly_adj,';',3),'')::numeric,nullif(split_part(NEW.monthly_adj,';',4),'')::numeric,
			nullif(split_part(NEW.monthly_adj,';',5),'')::numeric,nullif(split_part(NEW.monthly_adj,';',6),'')::numeric,
			nullif(split_part(NEW.monthly_adj,';',7),'')::numeric,nullif(split_part(NEW.monthly_adj,';',8),'')::numeric,
			nullif(split_part(NEW.monthly_adj,';',9),'')::numeric,nullif(split_part(NEW.monthly_adj,';',10),'')::numeric,
			nullif(split_part(NEW.monthly_adj,';',11),'')::numeric,nullif(split_part(NEW.monthly_adj,';',12),'')::numeric);
		ELSIF v_view='vi_map' THEN
			IF NEW.type_dim ILIKE 'DIMENSIONS' THEN
				INSERT INTO inp_mapdim (type_dim,x1, y1, x2, y2) 
				VALUES (NEW.type_dim, nullif(split_part(NEW.other_val,';',1),'')::numeric, nullif(split_part(NEW.other_val,';',2),'')::numeric,
				nullif(split_part(NEW.other_val,';',3),'')::numeric,nullif(split_part(NEW.other_val,';',4),'')::numeric);
			ELSIF NEW.type_dim ILIKE 'UNITS' THEN
				INSERT INTO inp_mapunits (type_units, map_type) VALUES (NEW.type_dim, split_part(NEW.other_val,';',1));
			END IF;
		ELSIF v_view='vi_backdrop' THEN 
			INSERT INTO inp_backdrop (text) VALUES (NEW.text);
		ELSIF v_view='vi_labels' THEN
			INSERT INTO inp_labels (xcoord, ycoord, label, anchor, font, size, bold, italic) 
			VALUES (NEW.xcoord, NEW.ycoord, NEW.label, NEW.anchor, NEW.font, NEW.size, NEW.bold, NEW.italic);
		ELSIF v_view='vi_coordinates' THEN
			UPDATE node SET the_geom=ST_SetSrid(ST_MakePoint(NEW.xcoord,NEW.ycoord),v_epsg) WHERE node_id=NEW.node_id;
	    END IF;
	    END IF;


	    RETURN NEW;

	END;
	$BODY$
	  LANGUAGE plpgsql VOLATILE
	  COST 100;





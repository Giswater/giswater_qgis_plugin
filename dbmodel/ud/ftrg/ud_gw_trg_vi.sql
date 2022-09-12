/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- FUNCTION NUMBER : 2812

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_vi()
  RETURNS trigger AS
$BODY$

/* 
This function load inp file to giswater 3
The main characterisitics mapping from SWMM to GW are:
	- Material Catalog is created on fly using manning as is. Material is desvinculated from arc catalog and related directly to table arc
	- Flow regulators are mapped as arcs not using the issue of giswater to define it without geometry on inp_flw_regulator tables
*/


DECLARE 
v_view text;
v_epsg integer;
v_epatype text;
v_catalog text;
v_linkoffsets text;
v_y1 float;
v_y2 float;

BEGIN

    --Get schema name
    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    -- Get SRID
	SELECT epsg INTO v_epsg FROM sys_version ORDER BY id DESC LIMIT 1;
		
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
			INSERT INTO inp_evaporation (evap_type, value) VALUES (NEW.evap_type, NEW.value);

		ELSIF v_view='vi_temperature' THEN
			INSERT INTO inp_temperature (temp_type, value) VALUES (NEW.temp_type, NEW.value);
	
		ELSIF v_view='vi_raingages' THEN
			IF NEW.raingage_type ILIKE 'TIMESERIES' THEN
				INSERT INTO raingage (rg_id, form_type, intvl, scf, rgage_type, timser_id, expl_id) 
				VALUES (NEW.rg_id, NEW.form_type, NEW.intvl, NEW.scf, 'TIMESERIES', NEW.other1, 1);
			ELSE
				INSERT INTO raingage (rg_id, form_type, intvl, scf, rgage_type, fname, sta, units, expl_id) 
				VALUES (NEW.rg_id,NEW.form_type,NEW.intvl,NEW.scf, 'FILE', NEW.other1, NEW.other2, NEW.other3, 1);
			END IF;

		ELSIF v_view='vi_aquifers' THEN
			INSERT INTO inp_aquifer (aquif_id, por, wp, fc, k, ks, ps, uef, led, gwr, be, wte, umc, pattern_id) 
			VALUES (NEW.aquif_id, NEW.por, NEW.wp, NEW.fc, NEW.k, NEW.ks, NEW.ps, NEW.uef, NEW.led, NEW.gwr, NEW.be, NEW.wte, NEW.umc, NEW.pattern_id);
			
		ELSIF v_view='vi_groundwater' THEN
			INSERT INTO inp_groundwater (subc_id, aquif_id, node_id, surfel, a1, b1, a2, b2, a3, tw, h, hydrology_id) 
			VALUES (NEW.subc_id, NEW.aquif_id, NEW.node_id, NEW.surfel, NEW.a1, NEW.b1, NEW.a2, NEW.b2, NEW.a3, NEW.tw, NEW.h, 1);
			
		ELSIF v_view='vi_snowpacks' THEN
			INSERT INTO inp_snowpack_value (snow_id, snow_type, value_1, value_2, value_3, value_4, value_5, value_6, value_7)
			VALUES (NEW.snow_id,NEW.snow_type, NEW.value_1, NEW.value_2, NEW.value_3, NEW.value_4, NEW.value_5, NEW.value_6, NEW.value_7);
			
			INSERT INTO inp_snowpack (snow_id) 
			SELECT NEW.snow_id FROM inp_snowpack WHERE NEW.snow_id not in (select snow_id FROM inp_snowpack_id);

		ELSIF v_view='vi_gwf' THEN 
			UPDATE inp_groundwater set fl_eq_lat=split_part(NEW.fl_eq_lat,';',2),fl_eq_deep=split_part(NEW.fl_eq_deep,';',2) WHERE subc_id=NEW.subc_id;
			
		ELSIF v_view='vi_outfalls' THEN
			INSERT INTO node (node_id, elev,node_type,nodecat_id,epa_type,sector_id, dma_id, expl_id, state, state_type) 
			VALUES (NEW.node_id, NEW.elev,'OUTFALL','OUTFALL','OUTFALL',1,1,1,1,2);
			INSERT INTO man_outfall (node_id) VALUES (NEW.node_id);
			
			IF NEW.outfall_type  like 'FREE' or NEW.outfall_type  like 'NORMAL' THEN
				INSERT INTO inp_outfall  (node_id, outfall_type, gate) values (NEW.node_id, NEW.outfall_type, NEW.other1);
				
			ELSIF NEW.outfall_type like 'FIXED' THEN 
				INSERT INTO inp_outfall (node_id, outfall_type,stage, gate) values (NEW.node_id, NEW.outfall_type,NEW.other1::numeric, NEW.other2);
				
			ELSIF NEW.outfall_type like 'TIDAL' THEN
				INSERT INTO inp_outfall (node_id, outfall_type,curve_id, gate) SELECT NEW.node_id,inp_typevalue.id,NEW.other1, NEW.other2
				FROM inp_typevalue WHERE NEW.outfall_type=idval  and typevalue='inp_typevalue_outfall';
				
			ELSIF NEW.outfall_type like 'TIMESERIES' THEN
				INSERT INTO inp_outfall (node_id, outfall_type,timser_id, gate) SELECT NEW.node_id, inp_typevalue.id,NEW.other1, NEW.other2 
				FROM inp_typevalue WHERE NEW.outfall_type=idval  and typevalue='inp_typevalue_outfall';
			END IF;
			
		ELSIF v_view='vi_dividers' THEN
			INSERT INTO node (node_id, elev, node_type, nodecat_id, epa_type, sector_id, dma_id, expl_id, state, state_type) 
			VALUES (NEW.node_id, NEW.elev, 'MANHOLE', 'MANHOLE', 'DIVIDER', 1, 1, 1, 1, 2);

			INSERT INTO man_junction (node_id) VALUES (NEW.node_id);

			IF NEW.divider_type LIKE 'CUTOFF' THEN
				INSERT INTO inp_divider (node_id, arc_id, divider_type, qmin, y0,ysur,apond) 
				VALUES (NEW.node_id, NEW.arc_id,'CUTOFF', NEW.other1::numeric, NEW.other2, NEW.other3, NEW.other4::numeric);
				
			ELSIF NEW.divider_type LIKE 'OVERFLOW' THEN
				INSERT INTO inp_divider (node_id, arc_id, divider_type, y0,ysur,apond) 
				VALUES (NEW.node_id, NEW.arc_id,'OVERFLOW', NEW.other1::numeric, NEW.other2, NEW.other3::numeric);
				
			ELSIF NEW.divider_type LIKE 'TABULAR' THEN
				INSERT INTO inp_divider (node_id, arc_id, divider_type, curve_id, y0,ysur,apond) 
				VALUES (NEW.node_id, NEW.arc_id,'TABULAR', NEW.other1, NEW.other2, NEW.other3, NEW.other4::numeric);
				
			ELSIF NEW.divider_type LIKE 'WEIR' THEN
				INSERT INTO inp_divider (node_id, arc_id, divider_type, qmin, ht, cd, y0, ysur, apond) 
				VALUES (NEW.node_id, NEW.arc_id,'WEIR', NEW.other1::numeric, NEW.other2, NEW.other3, NEW.other4, NEW.other5, NEW.other6::numeric);
			END IF;
			
		ELSIF v_view='vi_storage' THEN
			INSERT INTO node (node_id, elev, ymax,node_type,nodecat_id,epa_type,sector_id, dma_id, expl_id, state, state_type) 
			VALUES (NEW.node_id, NEW.elev, NEW.ymax, 'STORAGE', 'STORAGE', 'STORAGE', 1, 1, 1, 1, 2);
			INSERT INTO man_storage (node_id) VALUES (NEW.node_id);
			
			IF NEW.storage_type = 'FUNCTIONAL' THEN 
				INSERT INTO inp_storage(node_id,y0,storage_type,a1,a2,a0,apond, fevap, sh, hc, imd) 
				VALUES (NEW.node_id,NEW.y0,'FUNCTIONAL', NEW.other1::numeric, NEW.other2::numeric, NEW.other3::numeric, NEW.other4::numeric, NEW.other5::numeric, NEW.other6::numeric, NEW.other7::numeric, NEW.other8::numeric);
				
			ELSIF NEW.storage_type like 'TABULAR' THEN
				INSERT INTO inp_storage(node_id,y0,storage_type,curve_id,apond,fevap, sh, hc, imd) 
				VALUES (NEW.node_id,NEW.y0,'TABULAR',NEW.other1, NEW.other2::numeric, NEW.other3::numeric, NEW.other4::numeric, NEW.other5::numeric, NEW.other6::numeric);
			END IF;	
			
		ELSIF v_view='vi_pumps' THEN 
			INSERT INTO arc (arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, dma_id, expl_id, state, state_type) 
			VALUES (NEW.arc_id, NEW.node_1, NEW.node_2, 'PUMP','PUMP','PUMP',1,1,1,1,2);
			INSERT INTO man_varc (arc_id) VALUES (NEW.arc_id);
			INSERT INTO inp_pump (arc_id, curve_id, status, startup, shutoff) VALUES (NEW.arc_id, NEW.curve_id, NEW.status, NEW.startup, NEW.shutoff);
			
		ELSIF v_view='vi_orifices' THEN 
			INSERT INTO arc (arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, dma_id, expl_id, state, state_type) 
			VALUES (NEW.arc_id, NEW.node_1, NEW.node_2, 'ORIFICE','ORIFICE','ORIFICE', 1, 1, 1, 1, 2);
			INSERT INTO man_varc (arc_id) VALUES (NEW.arc_id);
			INSERT INTO inp_orifice (arc_id, ori_type, offsetval, cd, flap, orate, close_time) 
			VALUES (NEW.arc_id, NEW.ori_type, NEW.offsetval, NEW.cd, NEW.flap, NEW.orate, NEW.close_time);
			
		ELSIF v_view='vi_weirs' THEN 
			INSERT INTO arc (arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, dma_id, expl_id, state, state_type) 
			VALUES (NEW.arc_id, NEW.node_1, NEW.node_2, 'WEIR','WEIR','WEIR', 1, 1, 1, 1, 2);
			INSERT INTO man_varc (arc_id) VALUES (NEW.arc_id);
			INSERT INTO inp_weir (arc_id, weir_type, offsetval, cd, flap, ec, cd2, surcharge, road_width, road_surf, coef_curve) 
			VALUES (NEW.arc_id, NEW.weir_type, NEW.offsetval, NEW.cd, NEW.flap, NEW.ec, NEW.cd2, NEW.surcharge,
			NEW.road_width, NEW.road_surf, NEW.coef_curve);
			
		ELSIF v_view='vi_outlets' THEN 
			INSERT INTO arc (arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, dma_id, expl_id, state, state_type) 
			VALUES (NEW.arc_id, NEW.node_1, NEW.node_2, 'OUTLET','OUTLET','OUTLET', 1, 1, 1, 1, 2);
			INSERT INTO man_varc (arc_id) VALUES (NEW.arc_id);
			
			IF NEW.outlet_type LIKE 'FUNCTIONAL%' THEN
				INSERT INTO inp_outlet (arc_id, offsetval, outlet_type, cd1, cd2,flap) 
				VALUES (NEW.arc_id, NEW.offsetval, NEW.outlet_type, NEW.other1::numeric, NEW.other2::numeric, NEW.other3);
				
			ELSIF NEW.outlet_type LIKE 'TABULAR%' THEN
				INSERT INTO inp_outlet (arc_id, offsetval, outlet_type, curve_id,flap) 
				VALUES (NEW.arc_id, NEW.offsetval, NEW.outlet_type, NEW.other1, NEW.other2);
			END IF;
			
		ELSIF v_view='vi_xsections' THEN 
		
			IF NEW.shape='IRREGULAR' THEN
				v_catalog = concat(NEW.shape::varchar(9),'-',NEW.other1::varchar(12));
				UPDATE arc SET arccat_id=v_catalog WHERE arc_id=NEW.arc_id;
				INSERT INTO cat_arc (id, shape, tsect_id) 
				VALUES (v_catalog, NEW.shape::varchar(16), NEW.other1::varchar(16)) ON CONFLICT (id) DO nothing;
								
			ELSIF NEW.shape='CUSTOM' THEN
				v_catalog = concat(NEW.shape::varchar(9),'-',NEW.other1::varchar(5),'-', NEW.other2::varchar(12));
				UPDATE arc SET arccat_id=v_catalog WHERE arc_id=NEW.arc_id;
				UPDATE inp_conduit SET barrels=NEW.other5::smallint WHERE arc_id=NEW.arc_id;
				INSERT INTO cat_arc (id, shape, geom1, curve_id) 
				VALUES (v_catalog, NEW.shape::varchar(16), NEW.other1::float, NEW.other2::varchar(16)) ON CONFLICT (id) DO nothing;				
			ELSE
				v_epatype= (SELECT epa_type FROM arc WHERE arc_id=NEW.arc_id);
				IF v_epatype='CONDUIT' THEN
					v_catalog = concat(NEW.shape::varchar(9),'-',NEW.other1::varchar(4),'-', NEW.other2::varchar(4),'-', NEW.other3::varchar(4),'-', NEW.other4::varchar(4));
					UPDATE arc SET arccat_id=v_catalog WHERE arc_id=NEW.arc_id;
					UPDATE inp_conduit SET barrels=NEW.other5::smallint, culvert=NEW.other6 WHERE arc_id=NEW.arc_id;
					INSERT INTO cat_arc (id, shape, geom1, geom2, geom3, geom4) VALUES (v_catalog, NEW.shape::varchar(16), NEW.other1::float, NEW.other2::float, NEW.other3::float, NEW.other4::float) ON CONFLICT (id) DO nothing;
				ELSIF v_epatype='WEIR' THEN
					UPDATE inp_weir SET geom1=NEW.other1::numeric, geom2=NEW.other2::numeric, geom3=NEW.other3::numeric, geom4=NEW.other4::numeric WHERE arc_id=NEW.arc_id;
				ELSIF v_epatype='ORIFICE' THEN
					UPDATE inp_orifice SET shape=NEW.shape, geom1=NEW.other1::numeric, geom2=NEW.other2::numeric, geom3=NEW.other3::numeric, geom4=NEW.other4::numeric WHERE arc_id=NEW.arc_id;
				END IF;
			END IF;
						
		ELSIF v_view='vi_losses' THEN
			UPDATE inp_conduit SET kentry=NEW.kentry,kexit=NEW.kexit, kavg=NEW.kavg, flap=NEW.flap, seepage=NEW.seepage WHERE arc_id=NEW.arc_id;
			
		ELSIF v_view='vi_transects' THEN 
			INSERT INTO inp_transects (id) SELECT split_part(NEW.text,' ',1) WHERE split_part(NEW.text,' ',1)  NOT IN (SELECT id from inp_transects);
			IF split_part(NEW.text,' ',1)='X1' THEN
				INSERT INTO inp_transects (id) SELECT split_part(NEW.text,' ',2) WHERE split_part(NEW.text,' ',2)  NOT IN (SELECT id from inp_transects);			
			END IF;
			INSERT INTO inp_transects_value (tsect_id,text) VALUES (split_part(NEW.text,' ',1),NEW.text);
						
		ELSIF v_view='vi_pollutants' THEN 
			INSERT INTO inp_pollutant (poll_id, units_type, crain, cgw, cii, kd, sflag, copoll_id, cofract, cdwf, cinit) 
			VALUES (NEW.poll_id, NEW.units_type, NEW.crain, NEW.cgw, NEW.cii, NEW.kd, NEW.sflag, NEW.copoll_id, NEW.cofract, NEW.cdwf, NEW.cinit);
			
		ELSIF v_view='vi_landuses' THEN 
			INSERT INTO inp_landuses (landus_id, sweepint, availab, lastsweep) VALUES (NEW.landus_id, NEW.sweepint, NEW.availab, NEW.lastsweep);
			
		ELSIF v_view='vi_coverages' THEN 
			INSERT INTO inp_coverage(subc_id, landus_id, percent, hydrology_id) VALUES (NEW.subc_id, NEW.landus_id, NEW.percent, 1);
			
			INSERT INTO inp_landuses (landus_id) VALUES (NEW.landus_id) ON CONFLICT  (landus_id) DO NOTHING;

		ELSIF v_view='vi_buildup' THEN
			INSERT INTO inp_buildup(landus_id, poll_id, funcb_type, c1, c2, c3, perunit) 
			VALUES (NEW.landus_id, NEW.poll_id, NEW.funcb_type, NEW.c1, NEW.c2, NEW.c3, NEW.perunit);
			
		ELSIF v_view='vi_washoff' THEN
			INSERT INTO inp_washoff (landus_id, poll_id, funcw_type, c1, c2, sweepeffic, bmpeffic) 
			VALUES (NEW.landus_id, NEW.poll_id, NEW.funcw_type, NEW.c1, NEW.c2, NEW.sweepeffic, NEW.bmpeffic);
			
		ELSIF v_view='vi_treatment' THEN
			INSERT INTO inp_treatment (node_id, poll_id, function) VALUES (NEW.node_id, NEW.poll_id, NEW.function);
			
		ELSIF v_view='vi_dwf' THEN
		
			IF NEW.type_dwf ='FLOW' THEN
				INSERT INTO inp_dwf(node_id, value, pat1, pat2, pat3, pat4, dwfscenario_id)
				VALUES (NEW.node_id, NEW.value, NEW.pat1, NEW.pat2, NEW.pat3, NEW.pat4, 1);
			ELSE 
				INSERT INTO inp_dwf_pol_x_node (poll_id, node_id, value, pat1, pat2, pat3, pat4, dwfscenario_id)
				VALUES (NEW.type_dwf, NEW.node_id, NEW.value, NEW.pat1, NEW.pat2, NEW.pat3, NEW.pat4, 1);
			END IF;
			
		ELSIF v_view='vi_patterns' THEN
	
			INSERT INTO inp_pattern (pattern_id,pattern_type) 
			SELECT NEW.pattern_id,inp_typevalue.id FROM inp_typevalue WHERE upper(NEW.pattern_type)=idval AND typevalue='inp_typevalue_pattern'
			AND NEW.pattern_id not in (select pattern_id FROM inp_pattern);
				
			INSERT INTO inp_pattern_value (pattern_id,factor_1,factor_2,factor_3,factor_4,factor_5,factor_6,factor_7,factor_8,factor_9,factor_10,factor_11,factor_12,
			factor_13,factor_14,factor_15,factor_16,factor_17,factor_18,factor_19,factor_20,factor_21,factor_22,factor_23,factor_24) 
			VALUES (NEW.pattern_id,NEW.factor_1,NEW.factor_2,NEW.factor_3,NEW.factor_4,NEW.factor_5,NEW.factor_6,NEW.factor_7,NEW.factor_8,NEW.factor_9,NEW.factor_10,NEW.factor_11,NEW.factor_12,
			NEW.factor_13,NEW.factor_14,NEW.factor_15,NEW.factor_16,NEW.factor_17,NEW.factor_18,NEW.factor_19,NEW.factor_20,NEW.factor_21,NEW.factor_22,NEW.factor_23,NEW.factor_24);
			
			
		ELSIF v_view='vi_inflows' THEN
		
			IF NEW.type_flow ILIKE 'FLOW' THEN
				INSERT INTO inp_inflows(node_id, timser_id, sfactor, base, pattern_id) VALUES (NEW.node_id,NEW.timser_id, NEW.sfactor,
				NEW.base,NEW.pattern_id);
			ELSE
				INSERT INTO inp_inflows_poll (node_id, timser_id, poll_id,form_type, mfactor, sfactor, base, pattern_id) 
				SELECT NEW.node_id,NEW.timser_id, NEW.type_flow, inp_typevalue.id, NEW.mfactor,
				NEW.sfactor,NEW.base,NEW.pattern_id
				FROM inp_typevalue WHERE NEW.type=idval AND typevalue='inp_value_inflows';
			END IF;	
			
		ELSIF v_view='vi_loadings' THEN
			INSERT INTO inp_loadings (subc_id, poll_id, ibuildup, hydrology_id) VALUES (NEW.subc_id, NEW.poll_id, NEW.ibuildup, 1);
			
		ELSIF v_view='vi_rdii' THEN
			INSERT INTO inp_rdii(node_id, hydro_id, sewerarea) VALUES (NEW.node_id, NEW.hydro_id, NEW.sewerarea);

			INSERT INTO inp_hydrograph_id (id) SELECT DISTINCT hydro_id FROM inp_rdii WHERE hydro_id NOT IN  (SELECT id FROM inp_hydrograph_id);

		ELSIF v_view='vi_hydrographs' THEN
			INSERT INTO inp_hydrograph (text) VALUES (NEW.text);
			
		ELSIF v_view='vi_curves' THEN
			IF upper(NEW.curve_type) IN ('CONTROL', 'TIDAL', 'DIVERSION', 'PUMP1', 'PUMP2', 'PUMP3', 'PUMP4', 'RATING', 'SHAPE', 'STORAGE') THEN
				INSERT INTO inp_curve(id, curve_type) SELECT NEW.curve_id, inp_typevalue.id FROM inp_typevalue WHERE upper(NEW.curve_type)=idval AND typevalue='inp_value_curve';
				INSERT INTO inp_curve_value (curve_id,x_value,y_value) VALUES (NEW.curve_id,NEW.x_value,NEW.y_value);
			ELSE
				INSERT INTO inp_curve_value (curve_id,x_value,y_value) VALUES (NEW.curve_id,NEW.curve_type::numeric,NEW.x_value);
			END IF;
			
		ELSIF v_view='vi_timeseries' THEN 
			IF NEW.other1 ilike 'FILE' THEN
				IF NEW.timser_id NOT IN (SELECT id FROM inp_timeseries) THEN
					INSERT INTO inp_timeseries(id, idval, times_type,fname) VALUES (NEW.timser_id, NEW.timser_id,'FILE',NEW.other2) ;
				END IF;
				INSERT INTO inp_timeseries_value (timser_id) VALUES (NEW.timser_id);
				
			ELSIF  NEW.other1 ilike '%:%' OR NEW.other1 ~ '^\d+$' OR NEW.other1 ilike '%:%' THEN
			
				IF NEW.timser_id NOT IN (SELECT id FROM inp_timeseries) THEN
					INSERT INTO inp_timeseries(id, idval, times_type) VALUES (NEW.timser_id, NEW.timser_id,'RELATIVE');
				END IF;
				
				IF (SELECT times_type FROM inp_timeseries WHERE id = NEW.timser_id) = 'ABSOLUTE' THEN
					INSERT INTO inp_timeseries_value (timser_id, date, hour, value) VALUES (NEW.timser_id, null, NEW.other1, NEW.other2::numeric);				
				ELSE
					INSERT INTO inp_timeseries_value (timser_id, "time", value)  VALUES (NEW.timser_id, NEW.other1, NEW.other2::numeric);
				END IF;				
			ELSE	
				IF NEW.timser_id NOT IN (SELECT id FROM inp_timeseries) THEN
					INSERT INTO inp_timeseries(id, idval, times_type) VALUES (NEW.timser_id, NEW.timser_id,'ABSOLUTE');
				END IF;
				IF NEW.other2 ~ '^\d+$' then
					NEW.other2 = concat(NEW.other2,':00');
				END IF;
				IF NEW.other3 IS NOT NULL THEN
					INSERT INTO inp_timeseries_value (timser_id, date, hour, value) VALUES (NEW.timser_id, NEW.other1, NEW.other2, NEW.other3::numeric);
				END IF;
			END IF;
			
		ELSIF v_view='vi_lid_controls' THEN 
			INSERT INTO inp_lid (lidco_id, lidco_type)
			SELECT NEW.lidco_id, inp_typevalue.id FROM inp_typevalue WHERE upper(NEW.lidco_type)=id AND typevalue='inp_value_lidtype';

			INSERT INTO inp_lid_value (lidco_id, lidlayer, value_2, value_3, value_4, value_5, value_6, value_7, value_8)
			SELECT NEW.lidco_id, inp_typevalue.id, NEW.other1, NEW.other2, NEW.other3, NEW.other4, NEW.other5, NEW.other6, NEW.other7
			FROM inp_typevalue WHERE upper(NEW.lidco_type)=id AND typevalue='inp_value_lidlayer';
			
		ELSIF v_view='vi_lid_usage' THEN
			INSERT INTO temp_lid_usage (subc_id, lidco_id, numelem, area, width, initsat, fromimp, toperv, rptfile) 
			VALUES (NEW.subc_id, NEW.lidco_id, NEW.numelem, NEW.area, NEW.width, NEW.initsat, NEW.fromimp, NEW.toperv, NEW.rptfile);
			
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

		ELSIF v_view='vi_symbols' THEN
			UPDATE	raingage SET the_geom=st_setsrid(st_makepoint(NEW.xcoord, NEW.ycoord), v_epsg) WHERE rg_id=NEW.rg_id;	
			
		ELSIF v_view='vi_backdrop' THEN 
			INSERT INTO inp_backdrop (text) VALUES (NEW.text);
			
		ELSIF v_view='vi_labels' THEN
			INSERT INTO inp_label (xcoord, ycoord, label, anchor, font, size, bold, italic) 
			VALUES (NEW.xcoord, NEW.ycoord, NEW.label, NEW.anchor, NEW.font, NEW.size, NEW.bold, NEW.italic);
	    END IF;
	END IF;


	RETURN NEW;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
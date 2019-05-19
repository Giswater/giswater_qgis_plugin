/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION CODE: 2512


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_utils_csv2pg_import_patterns()
  RETURNS integer AS
$BODY$


/*INSTRUCTIONS

TO EXECUTE:
SELECT SCHEMA_NAME.gw_fct_utils_csv2pg_import_patterns()

TO CHECK RESULTS:
select * from SCHEMA_NAME.inp_pattern
select * from SCHEMA_NAME.inp_pattern_value
select * from SCHEMA_NAME.ext_rtc_scada_dma_period 


The csv file must contain

id;20171115000015
source;00000000
descript;descript text
dma_id;{840102, 840103}; 
losses;m3_period_volume;1254404  (losses; effc;0.7) -- There two ways of define losses. Using m3_period_volume (will be compared with crm values) or directy the coffecient
cat_period_id;201704
values;48.1176;51.8873;51.6861;48.9647;49.2083;47.2704;45.5338;45.1632;44.5172;41.8170;41.8805;41.7746;40.5251;40.5780;39.7838;39.4238
values;37.9413;36.8400;36.3000;36.4482;38.4919;39.1379;39.8156;42.0393;45.4067;50.1083;54.3758;63.6414;73.3412;81.2831;81.5690;83.6233
values;80.8172;81.6325;82.9350;79.3347;73.3722;75.6620;76.0308;77.7251;78.9922;79.9781;81.1031;77.3161;78.6252;74.6436;77.7675;72.3976
values;73.3835;70.3973;75.7606;75.8932;70.4477;70.2703;72.3246;69.1332;72.7164;72.8248;72.5510;72.1340;69.3702;69.2961;67.4218;67.9724
values;66.2146;64.2873;60.5176;60.8035;59.9881;58.6750;59.5751;58.4844;58.8974;60.8670;62.2224;66.4899;66.4687;68.7772;69.9632;71.6892
values;73.0870;74.8448;76.0202;77.1745;71.7634;73.5953;70.3973;66.9770;64.6686;58.9292;52.8827;49.8330;46.4656;45.8620;44.8878;44.1572
*/

DECLARE
	v_csv record;
	v_pattern text;
	v_source  text;
	v_descript text;
	v_dma text[];
	v_effc float;
	v_m3totalvolume float;
	v_period text;
	v_dma_array integer;
	v_sum float;
	v_min float;
	v_max float;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;


	-- Insert into audit table
	INSERT INTO audit_log_csv2pg 
	(csv2pgcat_id, user_name,csv1,csv2,csv3,csv4,csv5,csv6,csv7,csv8,csv9,csv10,csv11,csv12,csv13,csv14,csv15,csv16,csv17,csv18,csv19,csv20)
	SELECT csv2pgcat_id, user_name,csv1,csv2,csv3,csv4,csv5,csv6,csv7,csv8,csv9,csv10,csv11,csv12,csv13,csv14,csv15,csv16,csv17,csv18,csv19,csv20
	FROM temp_csv2pg WHERE csv2pgcat_id=17;

	FOR v_csv IN SELECT * FROM temp_csv2pg WHERE csv2pgcat_id=17 AND user_name=current_user ORDER BY id asc
	LOOP

		raise notice 'v_csv %', v_csv;
		RAISE NOTICE 'v_pattern % v_source % v_descript % v_dma % v_effc % v_m3totalvolume % v_period %', v_pattern , v_source, v_descript, v_dma, v_effc, v_m3totalvolume, v_period;

		IF v_csv.csv1 = 'id' THEN
			v_pattern = v_csv.csv2;

			-- control if pattern exists
			IF (SELECT pattern_id FROM inp_pattern WHERE pattern_id=v_pattern) IS NOT NULL THEN
				DELETE FROM inp_pattern WHERE pattern_id=v_pattern;
			END IF;
			
		ELSIF v_csv.csv1 = 'source' THEN
			v_source = v_csv.csv2;
		
		ELSIF v_csv.csv1 = 'descript' THEN
			v_descript = v_csv.csv2;
		
		ELSIF v_csv.csv1 = 'dma_id' THEN
			v_dma = v_csv.csv2;

		ELSIF v_csv.csv1 = 'losses' THEN
			IF v_csv.csv2 = 'effc' THEN 
				v_effc = v_csv.csv3;
				v_m3totalvolume=null;
			ELSE
				v_effc = null;
				v_m3totalvolume = v_csv.csv3;
			END IF;
			
		ELSIF v_csv.csv1 = 'cat_period_id' THEN
			v_period = v_csv.csv2;	

			-- control if cat_period_id does not exists
			IF (SELECT id FROM ext_cat_period WHERE id=v_period) IS NULL THEN
				RAISE EXCEPTION 'Period does not exists';
			END IF;

			-- insert values on inp_pattern table
			INSERT INTO inp_pattern VALUES (v_pattern, concat('{"source":"',v_source,'","descript":"',v_descript,'","period":"',v_period,'","dma":',v_dma,'}'));

			/* update effc, m3_total_period and pattern columns on ext_rtc_scada_dma_period table
			INFO: 	Table ext_rtc_scada_dma_period is inserted value when firt register of that cat_period_id is inserted (dma_id, period_id)
				Table ext_rtc_scada_dma_period is updated by daily process using function gw_fct_utils_update_dma_hydroval adding period values from dma customers. 
				Fields updated are: m3_total_period, m3_total_period_hdyro, effc=1 . As you can see  (m3_total_period = m3_total_period_hdyro) is updated without losses	
			*/

			FOREACH v_dma_array IN ARRAY v_dma
			LOOP 
				IF v_effc IS NOT NULL THEN
					UPDATE ext_rtc_scada_dma_period SET effc=v_effc, m3_total_period_hydro=m3_total_period/v_effc, pattern_id=v_pattern WHERE dma_id::integer=v_dma_array AND cat_period_id=v_period;

				ELSIF v_m3totalvolume IS NOT NULL THEN
					UPDATE ext_rtc_scada_dma_period SET effc=m3_total_period/v_m3totalvolume, m3_total_period_hydro=v_m3totalvolume, pattern_id=v_pattern WHERE dma_id::integer=v_dma_array AND cat_period_id=v_period;
				ELSE
					RAISE EXCEPTION 'The csv has some inconsistency data on losses. It is impossible to continue';
				END IF;
				
			END LOOP;
			
		ELSIF v_csv.csv1 = 'values' THEN

			-- insert row on inp_pattern_value table
			INSERT INTO inp_pattern_value VALUES ((SELECT nextval('SCHEMA_NAME.inp_pattern_id_seq'::regclass)), v_pattern, v_csv.csv2::numeric, v_csv.csv3::numeric, v_csv.csv4::numeric, v_csv.csv5::numeric, 
								v_csv.csv6::numeric, v_csv.csv7::numeric, v_csv.csv8::numeric, v_csv.csv9::numeric, v_csv.csv10::numeric, v_csv.csv11::numeric, v_csv.csv12::numeric, 
								v_csv.csv13::numeric, v_csv.csv14::numeric, v_csv.csv15::numeric, v_csv.csv16::numeric, v_csv.csv17::numeric);
		END IF;
	
	END LOOP;

	-- normalize factor
	v_sum = (SELECT sum(factor_1)+sum(factor_2)+sum(factor_3)+sum(factor_4)+sum(factor_5)+sum(factor_6)+sum(factor_7)+sum(factor_8)+sum(factor_9)+sum(factor_10)+sum(factor_11)
			+sum(factor_12)+sum(factor_13)+ sum(factor_14)+sum(factor_15)+sum(factor_16) FROM inp_pattern_value WHERE pattern_id=v_pattern)::float;

	--UPDATE inp_pattern_value SET factor_1=factor_1/v_sum, factor_2=factor_2/v_sum, factor_3=factor_3/v_sum, factor_4=factor_4/v_sum, factor_5=factor_5/v_sum, factor_6=factor_6/v_sum, factor_7=factor_7/v_sum,
	--		factor_8=factor_8/v_sum, factor_9=factor_9/v_sum, factor_10=factor_10/v_sum, factor_11=factor_11/v_sum, factor_12=factor_12/v_sum, factor_13=factor_13/v_sum, factor_14=factor_14/v_sum,
	--		factor_15=factor_15/v_sum, factor_16=factor_16/v_sum WHERE pattern_id=v_pattern;

	-- get min value from pattern
	v_min = (SELECT  min(min) FROM (SELECT min(factor_1) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
					SELECT min(factor_2) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
					SELECT min(factor_3) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
					SELECT min(factor_4) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
					SELECT min(factor_5) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
					SELECT min(factor_6) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
					SELECT min(factor_7) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
					SELECT min(factor_8) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
					SELECT min(factor_9) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
					SELECT min(factor_10) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
					SELECT min(factor_11) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
					SELECT min(factor_12) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
					SELECT min(factor_13) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
					SELECT min(factor_14) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
					SELECT min(factor_15) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
					SELECT min(factor_16) FROM inp_pattern_value WHERE pattern_id=v_pattern)a);

	-- get max value from pattern
	v_max = (SELECT  max(max) FROM (SELECT max(factor_1) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
					SELECT max(factor_2) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
					SELECT max(factor_3) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
					SELECT max(factor_4) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
					SELECT max(factor_5) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
					SELECT max(factor_6) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
					SELECT max(factor_7) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
					SELECT max(factor_8) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
					SELECT max(factor_9) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
					SELECT max(factor_10) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
					SELECT max(factor_11) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
					SELECT max(factor_12) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
					SELECT max(factor_13) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
					SELECT max(factor_14) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
					SELECT max(factor_15) FROM inp_pattern_value WHERE pattern_id=v_pattern UNION
					SELECT max(factor_16) FROM inp_pattern_value WHERE pattern_id=v_pattern)a);

	-- update ext_rtc_scada_dma_period with min and max values
	UPDATE ext_rtc_scada_dma_period SET minc=v_min, maxc=v_max WHERE dma_id::integer=v_dma_array AND cat_period_id=v_period;

RETURN 0;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


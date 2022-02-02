/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/01/31
DROP VIEW IF EXISTS v_edit_inp_pattern;
CREATE OR REPLACE VIEW v_edit_inp_pattern AS 
 SELECT DISTINCT p.pattern_id,
    p.pattern_type,
    p.observ,
    p.tsparameters::text AS tsparameters,
    p.expl_id,
    p.log
   FROM selector_expl s, inp_pattern p
WHERE p.expl_id = s.expl_id AND s.cur_user = "current_user"()::text OR p.expl_id IS NULL
ORDER BY p.pattern_id;

DROP VIEW IF EXISTS v_edit_inp_pattern_value;
CREATE OR REPLACE VIEW v_edit_inp_pattern_value AS 
 SELECT DISTINCT inp_pattern_value.id,
    p.pattern_id,
    p.pattern_type,
    p.observ,
    p.tsparameters::text AS tsparameters,
    p.expl_id,
    inp_pattern_value.factor_1,
    inp_pattern_value.factor_2,
    inp_pattern_value.factor_3,
    inp_pattern_value.factor_4,
    inp_pattern_value.factor_5,
    inp_pattern_value.factor_6,
    inp_pattern_value.factor_7,
    inp_pattern_value.factor_8,
    inp_pattern_value.factor_9,
    inp_pattern_value.factor_10,
    inp_pattern_value.factor_11,
    inp_pattern_value.factor_12,
    inp_pattern_value.factor_13,
    inp_pattern_value.factor_14,
    inp_pattern_value.factor_15,
    inp_pattern_value.factor_16,
    inp_pattern_value.factor_17,
    inp_pattern_value.factor_18
   FROM selector_expl s, inp_pattern p
     JOIN inp_pattern_value USING (pattern_id)
  WHERE p.expl_id = s.expl_id AND s.cur_user = "current_user"()::text OR p.expl_id IS NULL
  ORDER BY inp_pattern_value.id;


CREATE OR REPLACE VIEW v_edit_inp_timeseries AS 
SELECT DISTINCT p.id,
    p.timser_type,
    p.times_type,
    p.idval,
    p.descript,
    p.fname,
    p.expl_id,
    p.log
   FROM selector_expl s, inp_timeseries p
WHERE p.expl_id = s.expl_id AND s.cur_user = "current_user"()::text OR p.expl_id IS NULL
ORDER BY p.id;


CREATE OR REPLACE VIEW v_edit_inp_timeseries_value AS 
SELECT DISTINCT p.id,
   p.timser_id,
   t.timser_type,
   t.times_type,
   t.idval,
   t.expl_id,
   p.date,
   p.hour,
   p."time",
   p.value
   FROM selector_expl s, inp_timeseries t
   JOIN inp_timeseries_value p ON t.id=timser_id
WHERE t.expl_id = s.expl_id AND s.cur_user = "current_user"()::text OR t.expl_id IS NULL
ORDER BY p.id;

DROP VIEW IF EXISTS vi_outlets;
CREATE OR REPLACE VIEW vi_outlets AS 
SELECT arc_id,
node_1,
node_2,
offsetval,
outlet_type,
case when curve_id is null then cd1::text else curve_id end as other1,
cd2::text AS other2,
f.flap::varchar AS other3
FROM temp_arc_flowregulator f
JOIN temp_arc USING (arc_id)
WHERE type='OUTLET';

DROP VIEW IF EXISTS vi_orifices;
CREATE OR REPLACE VIEW vi_orifices AS 
SELECT arc_id,
node_1,
node_2,
ori_type,
offsetval,
cd,
f.flap,
orate,
close_time
FROM temp_arc_flowregulator f
JOIN temp_arc USING (arc_id)
WHERE type='ORIFICE';

DROP VIEW IF EXISTS vi_weirs;
CREATE OR REPLACE VIEW vi_weirs AS 
SELECT arc_id,
node_1,
node_2,
weir_type,
offsetval,
cd,
f.flap,
ec,
cd2,
surcharge,
road_width,
road_surf,
coef_curve
FROM temp_arc_flowregulator f
JOIN temp_arc USING (arc_id)
WHERE type='WEIR';

DROP VIEW vi_outfalls;
CREATE OR REPLACE VIEW vi_outfalls AS 
SELECT 
node_id,
elev,
addparam::json->>'outfall_type' as outfall_type,
addparam::json->>'gate' as other1,
null::text as other2
FROM temp_node WHERE epa_type  ='OUTFALL' 
AND addparam::json->>'outfall_type' IN ('FREE','NORMAL')
UNION
SELECT 
node_id,
elev,
addparam::json->>'outfall_type' as outfall_type,
addparam::json->>'state' as other1,
addparam::json->>'gate' as other2
FROM temp_node WHERE epa_type  ='OUTFALL' 
AND addparam::json->>'outfall_type' = 'FIXED'
UNION
SELECT 
node_id,
elev,
addparam::json->>'outfall_type' as outfall_type,
addparam::json->>'curve_id' as other1,
addparam::json->>'gate' as other2
FROM temp_node WHERE epa_type  ='OUTFALL' 
AND addparam::json->>'outfall_type' = 'TIDAL'
UNION
SELECT 
node_id,
elev,
addparam::json->>'outfall_type' as outfall_type,
addparam::json->>'timser_id' as other1,
addparam::json->>'gate' as other2
FROM temp_node WHERE epa_type  ='OUTFALL' 
AND addparam::json->>'outfall_type' = 'TIMESERIES';



CREATE OR REPLACE VIEW vi_raingages AS 
SELECT r.rg_id,
    r.form_type,
    r.intvl,
    r.scf,
    inp_typevalue.idval AS raingage_type,
    r.timser_id AS other1,
    NULL::character varying AS other2,
    NULL::character varying AS other3
   FROM selector_inp_result s, rpt_inp_raingage r
     LEFT JOIN inp_typevalue ON inp_typevalue.id::text = r.rgage_type::text
  WHERE inp_typevalue.typevalue::text = 'inp_typevalue_raingage'::text AND r.rgage_type::text = 'TIMESERIES'::text 
  AND s.result_id::text = r.result_id::text AND s.cur_user = current_user
UNION
 SELECT r.rg_id,
    r.form_type,
    r.intvl,
    r.scf,
    inp_typevalue.idval AS raingage_type,
    r.fname AS other1,
    r.sta AS other2,
    r.units AS other3
   FROM selector_inp_result s,
    rpt_inp_raingage r
     LEFT JOIN inp_typevalue ON inp_typevalue.id::text = r.rgage_type::text
  WHERE inp_typevalue.typevalue::text = 'inp_typevalue_raingage'::text AND r.rgage_type::text = 'FILE'::text
  AND s.result_id::text = r.result_id::text AND s.cur_user = current_user;

 
CREATE OR REPLACE VIEW v_edit_inp_dscenario_lid_usage AS 
 SELECT 
    dscenario_id,
    l.hydrology_id,
    l.subc_id,
    l.lidco_id,
    l.numelem,
    l.area,
    l.width,
    l.initsat,
    l.fromimp,
    l.toperv,
    l.rptfile,
    l.descript,
    s.the_geom
   FROM inp_dscenario_lid_usage l
     JOIN v_edit_inp_subcatchment s USING (subc_id)
  WHERE s.hydrology_id = l.hydrology_id;



  
/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/12/22
CREATE OR REPLACE VIEW v_edit_sector AS 
 SELECT sector.sector_id,
    sector.name,
    sector.descript,
    sector.macrosector_id,
    sector.the_geom,
    sector.undelete,
    sector.active,
    sector.parent_id
   FROM selector_sector, sector
  WHERE sector.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;


--2021/12/29
CREATE OR REPLACE VIEW v_edit_inp_curve AS 
 SELECT DISTINCT c.id,
    c.curve_type,
    c.descript,
    c.sector_id,
    c.log
   FROM selector_sector, inp_curve c
  WHERE c.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text OR c.sector_id IS NULL
  ORDER BY c.id;


CREATE OR REPLACE VIEW vi_options AS 
SELECT a.parameter,
a.value
   FROM ( SELECT a_1.idval AS parameter,
            b.value,
                CASE
                    WHEN a_1.layoutname ~~ '%general_1%'::text THEN '1'::text
                    WHEN a_1.layoutname ~~ '%hydraulics_1%'::text THEN '2'::text
                    WHEN a_1.layoutname ~~ '%hydraulics_2%'::text THEN '3'::text
                    WHEN a_1.layoutname ~~ '%date_1%'::text THEN '3'::text
                    WHEN a_1.layoutname ~~ '%date_2%'::text THEN '4'::text
                    WHEN a_1.layoutname ~~ '%general_2%'::text THEN '5'::text
                    ELSE NULL::text
                END AS layoutname,
            a_1.layoutorder
           FROM sys_param_user a_1
             JOIN config_param_user b ON a_1.id = b.parameter::text
          WHERE (a_1.layoutname = ANY (ARRAY['lyt_general_1'::text, 'lyt_general_2'::text, 'lyt_hydraulics_1'::text, 'lyt_hydraulics_2'::text, 'lyt_date_1'::text, 'lyt_date_2'::text])) AND b.cur_user::name = "current_user"() AND b.value IS NOT NULL AND a_1.idval IS NOT NULL
        UNION
         SELECT 'INFILTRATION'::text AS parameter,
            cat_hydrology.infiltration AS value,
            '1'::text AS text,
            2
           FROM config_param_user,
            cat_hydrology
          WHERE config_param_user.parameter::text = 'inp_options_hydrology_scenario'::text AND config_param_user.cur_user::text = "current_user"()::text) a
  ORDER BY a.layoutname, a.layoutorder;


--2022/01/05
 CREATE VIEW v_edit_cat_dwf_dscenario AS
 SELECT DISTINCT ON (c.id)
 id,
 idval,
 startdate,
 enddate,
 observ,
 c.expl_id,
 c.active,
 log
 FROM cat_dwf_scenario c, selector_expl s
 WHERE (s.expl_id = c.expl_id AND cur_user = current_user)
 OR c.expl_id is null;


CREATE VIEW v_edit_cat_hydrology AS
SELECT DISTINCT ON (hydrology_id)
hydrology_id,
name,
infiltration,
text,
c.expl_id,
c.active,
log
FROM cat_hydrology c, selector_expl s
WHERE (s.expl_id = c.expl_id AND cur_user = current_user)
OR c.expl_id is null;



CREATE OR REPLACE VIEW v_edit_inp_weir AS 
 SELECT v_arc.arc_id,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.y1,
    v_arc.custom_y1,
    v_arc.elev1,
    v_arc.custom_elev1,
    v_arc.sys_elev1,
    v_arc.y2,
    v_arc.custom_y2,
    v_arc.elev2,
    v_arc.custom_elev2,
    v_arc.sys_elev2,
    v_arc.arccat_id,
    v_arc.gis_length,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.inverted_slope,
    v_arc.custom_length,
    v_arc.expl_id,
    inp_weir.weir_type,
    inp_weir."offset",
    inp_weir.cd,
    inp_weir.ec,
    inp_weir.cd2,
    inp_weir.flap,
    inp_weir.geom1,
    inp_weir.geom2,
    inp_weir.geom3,
    inp_weir.geom4,
    inp_weir.surcharge,
    v_arc.the_geom,
    road_width,  
    road_surf,
    coef_curve
   FROM selector_sector, v_arc
   JOIN inp_weir USING (arc_id)
   WHERE v_arc.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_inp_orifice AS 
 SELECT v_arc.arc_id,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.y1,
    v_arc.custom_y1,
    v_arc.elev1,
    v_arc.custom_elev1,
    v_arc.sys_elev1,
    v_arc.y2,
    v_arc.custom_y2,
    v_arc.elev2,
    v_arc.custom_elev2,
    v_arc.sys_elev2,
    v_arc.arccat_id,
    v_arc.gis_length,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.inverted_slope,
    v_arc.custom_length,
    v_arc.expl_id,
    inp_orifice.ori_type,
    inp_orifice."offset",
    inp_orifice.cd,
    inp_orifice.orate,
    inp_orifice.flap,
    inp_orifice.shape,
    inp_orifice.geom1,
    inp_orifice.geom2,
    inp_orifice.geom3,
    inp_orifice.geom4,
    v_arc.the_geom,
    close_time
   FROM selector_sector, v_arc
     JOIN inp_orifice USING (arc_id)
  WHERE v_arc.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;



CREATE VIEW v_edit_inp_flwreg_weir AS
SELECT
concat(node_id,'_wei',order_id) as nodarc_id,
node_id,
order_id,
to_arc,
flwreg_length,
weir_type,
"offset",
cd,
ec,
cd2, 
flap, 
geom1, 
geom2,
geom3,
geom4,
surcharge,
road_width, 
road_surf,
coef_curve,
the_geom
FROM inp_flwreg_weir f
JOIN node USING (node_id);


CREATE VIEW v_edit_inp_flwreg_pump AS
SELECT
concat(node_id,'_pum',order_id) as nodarc_id,
node_id,
order_id,
to_arc,
flwreg_length,
curve_id,
status,
startup,
shutoff,
the_geom
FROM inp_flwreg_pump f
JOIN node USING (node_id);

  

CREATE VIEW v_edit_inp_flwreg_orifice AS
SELECT
concat(node_id,'_ori',order_id) as nodarc_id,
node_id,
order_id,
to_arc,
flwreg_length,
ori_type, 
"offset", 
cd, 
orate,
flap, 
shape, 
geom1, 
geom2,
geom3, 
geom4, 
close_time,
the_geom
FROM inp_flwreg_orifice f
JOIN node USING (node_id);


CREATE VIEW v_edit_inp_flwreg_outlet AS
SELECT
concat(node_id,'_out',order_id) as nodarc_id,
node_id,
order_id,
to_arc, 
flwreg_length,
outlet_type, 
"offset", 
curve_id, 
cd1, 
cd2, 
flap,
the_geom
FROM inp_flwreg_outlet f
JOIN node USING (node_id);


CREATE VIEW v_edit_inp_dscenario_outfall AS
SELECT
s.dscenario_id,
node_id, 
outfall_type,
stage, 
curve_id,
timser_id, 
gate, 
the_geom
FROM selector_inp_dscenario s, inp_dscenario_outfall f
JOIN node USING (node_id)
WHERE s.dscenario_id = f.dscenario_id AND cur_user = current_user;


CREATE VIEW v_edit_inp_dscenario_storage AS
SELECT
s.dscenario_id,
node_id, 
storage_type,
curve_id, 
a1, 
a2, 
a0, 
fevap, 
sh, 
hc, 
imd, 
y0,
ysur,
apond,
the_geom
FROM selector_inp_dscenario s, inp_dscenario_storage f
JOIN node USING (node_id)
WHERE s.dscenario_id = f.dscenario_id AND cur_user = current_user;


CREATE VIEW v_edit_inp_dscenario_divider AS
SELECT
s.dscenario_id,
node_id, 
divider_type,
f.arc_id, 
curve_id,
qmin, 
ht, 
cd, 
y0, 
ysur,
apond 
FROM selector_inp_dscenario s, inp_dscenario_divider f
JOIN node USING (node_id)
WHERE s.dscenario_id = f.dscenario_id AND cur_user = current_user;


CREATE VIEW v_edit_inp_dscenario_flwreg_weir AS
SELECT
s.dscenario_id,
concat(node_id,'_wei',order_id) as nodarc_id,
node_id,
order_id,
to_arc,
flwreg_length,
weir_type,
"offset",
cd,
ec,
cd2, 
flap, 
geom1, 
geom2,
geom3,
geom4,
surcharge,
road_width, 
road_surf,
coef_curve,
the_geom
FROM selector_inp_dscenario s, inp_dscenario_flwreg_weir f
JOIN node USING (node_id)
WHERE s.dscenario_id = f.dscenario_id AND cur_user = current_user;



CREATE VIEW v_edit_inp_dscenario_flwreg_pump AS
SELECT
s.dscenario_id,
concat(node_id,'_pum',order_id) as nodarc_id,
node_id,
order_id,
to_arc,
flwreg_length,
curve_id,
status,
startup,
shutoff,
the_geom
FROM selector_inp_dscenario s, inp_dscenario_flwreg_pump f
JOIN node USING (node_id)
WHERE s.dscenario_id = f.dscenario_id AND cur_user = current_user;



CREATE VIEW v_edit_inp_dscenario_flwreg_orifice AS
SELECT
s.dscenario_id,
concat(node_id,'_ori',order_id) as nodarc_id,
node_id,
order_id,
to_arc,
flwreg_length,
ori_type,
"offset",
cd,
orate,
flap,
shape, 
geom1, 
geom2,
geom3,
geom4, 
close_time,
the_geom
FROM selector_inp_dscenario s, inp_dscenario_flwreg_orifice f
JOIN node USING (node_id)
WHERE s.dscenario_id = f.dscenario_id AND cur_user = current_user;



CREATE VIEW v_edit_inp_dscenario_flwreg_outlet AS
SELECT
s.dscenario_id,
concat(node_id,'_out',order_id) as nodarc_id,
node_id,
order_id,
to_arc,
flwreg_length,
outlet_type,
"offset",
curve_id,
cd1,
cd2,
flap,
the_geom
FROM selector_inp_dscenario s, inp_dscenario_flwreg_outlet f
JOIN node USING (node_id)
WHERE s.dscenario_id = f.dscenario_id AND cur_user = current_user;


CREATE VIEW v_edit_inp_inflows AS
SELECT
node_id,
order_id,
timser_id,
format_type,
mfactor,
sfactor,
base,
pattern_id,
the_geom
FROM inp_inflows
JOIN node USING (node_id);


CREATE VIEW v_edit_inp_dscenario_inflows AS
SELECT
s.dscenario_id,
node_id,
order_id,
timser_id,
format_type,
mfactor,
sfactor,
base,
pattern_id,
the_geom
FROM selector_inp_dscenario s, inp_dscenario_inflows f
JOIN node USING (node_id)
WHERE s.dscenario_id = f.dscenario_id AND cur_user = current_user;


CREATE VIEW v_edit_inp_inflows_pol AS
SELECT
poll_id,
node_id,
timser_id,
form_type,
mfactor,
sfactor,
base,
pattern_id,
the_geom
FROM inp_inflows_pol
JOIN node USING (node_id);


CREATE VIEW v_edit_inp_dscenario_inflows_pol AS
SELECT
s.dscenario_id,
poll_id,
node_id,
timser_id,
form_type,
mfactor,
sfactor,
base,
pattern_id,
the_geom
FROM selector_inp_dscenario s, inp_dscenario_inflows_pol f
JOIN node USING (node_id)
WHERE s.dscenario_id = f.dscenario_id AND cur_user = current_user;


CREATE VIEW v_edit_inp_treatment AS
SELECT
node_id,
poll_id,
function,
the_geom
FROM inp_treatment
JOIN node USING (node_id);


CREATE VIEW v_edit_inp_dscenario_treatment AS
SELECT
s.dscenario_id,
node_id, 
poll_id, 
function,
the_geom
FROM selector_inp_dscenario s, inp_dscenario_treatment f
JOIN node USING (node_id)
WHERE s.dscenario_id = f.dscenario_id AND cur_user = current_user;
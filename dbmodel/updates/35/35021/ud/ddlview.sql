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




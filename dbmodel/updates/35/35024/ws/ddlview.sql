/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/04/06
CREATE OR REPLACE VIEW v_edit_inp_dscenario_rules AS 
SELECT id,
d.dscenario_id,
i.sector_id,
i.text,
i.active
FROM selector_inp_dscenario, inp_dscenario_rules i 
JOIN cat_dscenario d USING (dscenario_id)
WHERE i.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW vi_curves AS 
SELECT
        CASE
            WHEN a.x_value IS NULL THEN a.curve_type::character varying(16)
            ELSE a.curve_id
        END AS curve_id,
    a.x_value::numeric(12,4) AS x_value,
    a.y_value::numeric(12,4) AS y_value,
    NULL::text AS other
   FROM ( SELECT DISTINCT ON (inp_curve_value.curve_id) ( SELECT min(sub.id) AS min
                   FROM inp_curve_value sub
                  WHERE sub.curve_id::text = inp_curve_value.curve_id::text) AS id,
            inp_curve_value.curve_id,
            concat(';', inp_curve.curve_type, ':', inp_curve.descript) AS curve_type,
            NULL::numeric AS x_value,
            NULL::numeric AS y_value
           FROM inp_curve
             JOIN inp_curve_value ON inp_curve_value.curve_id::text = inp_curve.id::text
        UNION
         SELECT inp_curve_value.id,
            inp_curve_value.curve_id,
            inp_curve.curve_type,
            inp_curve_value.x_value,
            inp_curve_value.y_value
           FROM inp_curve_value
             JOIN inp_curve ON inp_curve_value.curve_id::text = inp_curve.id::text
  ORDER BY 1, 4 DESC) a
  WHERE (a.curve_id::text IN ( SELECT temp_node.addparam::json ->> 'curve_id'::text
           FROM temp_node
        UNION
         SELECT temp_arc.addparam::json ->> 'curve_id'::text
           FROM temp_arc))
  ORDER BY id ASC ,4;

--2022/04/17
CREATE OR REPLACE VIEW v_om_waterbalance AS
SELECT
e.name as exploitation,
d.name as dma,
p.code as period,
(coalesce(auth_bill_met_export,0) + coalesce(auth_bill_met_hydro,0) + coalesce(auth_bill_unmet,0))::numeric(12,2) as auth_bill,
(coalesce(auth_unbill_met,0) + coalesce(auth_unbill_unmet,0) + coalesce(loss_app_unath,0))::numeric(12,2) as auth_unbill,
(coalesce(loss_app_met_error,0) + coalesce(loss_app_data_error,0))::numeric(12,2) as loss_app,
(coalesce(loss_real_leak_main,0) + coalesce(loss_real_leak_service,0) + coalesce(loss_real_storage,0))::numeric(12,2) as loss_real,
coalesce(total_sys_input,0) as total
FROM om_waterbalance
JOIN exploitation e USING (expl_id)
JOIN dma d USING (dma_id)
JOIN ext_cat_period p ON id = cat_period_id;


CREATE OR REPLACE VIEW v_om_waterbalance_nrw AS
SELECT
exploitation,
dma,
period,
total,
auth_bill::numeric(12,2) as rw,
(total - auth_bill)::numeric(12,2) as nrw,
case when total > 0 then (100*auth_bill/total)::numeric(12,2) else 0::numeric(12,2) end as eff
FROM v_om_waterbalance;


CREATE OR REPLACE VIEW v_om_waterbalance_loss AS
SELECT
exploitation,
dma,
period,
total,
(auth_bill + auth_unbill)::numeric(12,2) as auth,
(total - auth_bill - auth_unbill)::numeric(12,2) as loss,
case when total > 0 then (100*(auth_bill+auth_unbill)/total)::numeric(12,2) else 0::numeric(12,2) end as eff
FROM v_om_waterbalance;


-- 2022/05/18
CREATE OR REPLACE VIEW v_edit_cat_feature_node AS
SELECT
id,
system_id,
epa_default,
isarcdivide,
isprofilesurface,
choose_hemisphere,
code_autofill,
double_geom::text,
num_arcs,
graf_delimiter,
shortcut_key,
link_path,
descript,
active
FROM cat_feature
JOIN cat_feature_node USING (id);

CREATE OR REPLACE VIEW v_edit_cat_feature_arc AS
SELECT
id,
system_id,
epa_default,
code_autofill,
shortcut_key,
link_path,
descript,
active
FROM cat_feature
JOIN cat_feature_arc USING (id);


CREATE OR REPLACE VIEW v_edit_cat_feature_connec AS
SELECT
id,
system_id,
epa_default,
code_autofill,
shortcut_key,
link_path,
descript,
active
FROM cat_feature
JOIN cat_feature_connec USING (id);


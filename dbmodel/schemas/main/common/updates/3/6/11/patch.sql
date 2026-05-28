/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE cat_manager RENAME COLUMN username TO rolename;
ALTER TABLE config_user_x_expl DROP CONSTRAINT config_user_x_expl_username_fkey;
ALTER TABLE config_user_x_sector DROP CONSTRAINT config_user_x_sector_username_fkey;

ALTER TABLE config_user_x_sector DROP CONSTRAINT config_user_x_sector_manager_id_fkey;
ALTER TABLE config_user_x_sector ADD CONSTRAINT config_user_x_sector_manager_id_fkey
FOREIGN KEY (manager_id) REFERENCES cat_manager(id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE config_user_x_expl DROP CONSTRAINT config_user_x_expl_manager_id_fkey;
ALTER TABLE config_user_x_expl ADD CONSTRAINT config_user_x_expl_manager_id_fkey
FOREIGN KEY (manager_id) REFERENCES cat_manager(id) ON DELETE CASCADE ON UPDATE CASCADE;


DO $$
DECLARE
    v_utils boolean;
BEGIN

	SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	IF v_utils IS true THEN

		CREATE TABLE selector_municipality (
			muni_id integer NOT NULL,
			cur_user text NOT NULL DEFAULT CURRENT_USER,
			CONSTRAINT selector_municipality_pkey PRIMARY KEY (muni_id, cur_user),
			CONSTRAINT selector_municipality_fkey FOREIGN KEY (muni_id)
			REFERENCES utils.municipality (muni_id) MATCH SIMPLE
			ON UPDATE CASCADE ON DELETE CASCADE
		);

	ELSE

		CREATE TABLE selector_municipality
		(
			muni_id integer NOT NULL,
			cur_user text NOT NULL DEFAULT CURRENT_USER,
			CONSTRAINT selector_municipality_pkey PRIMARY KEY (muni_id, cur_user),
			CONSTRAINT selector_municipality_fkey FOREIGN KEY (muni_id)
			REFERENCES ext_municipality (muni_id) MATCH SIMPLE
			ON UPDATE CASCADE ON DELETE CASCADE
		);

	END IF;
END; $$;


ALTER TABLE plan_psector ALTER COLUMN status SET NOT NULL;
ALTER TABLE plan_psector ALTER COLUMN status SET DEFAULT 2;
ALTER TABLE plan_psector ALTER COLUMN psector_type SET DEFAULT 1;

ALTER TABLE cat_feature RENAME COLUMN config TO addparam;


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"ext_municipality", "column":"ext_code", "dataType":"varchar(50)", "isUtils":"True"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"ext_region", "column":"ext_code", "dataType":"varchar(50)", "isUtils":"True"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD", "table":"ext_province", "column":"ext_code", "dataType":"varchar(50)", "isUtils":"True"}}$$);

DO $$
DECLARE
    v_utils boolean;
BEGIN

	SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	IF v_utils IS true THEN

		-- create table utils.region_x_province
	 	CREATE TABLE IF NOT EXISTS utils.region_x_province (
			region_id int4 NOT NULL,
			province_id int4 NOT NULL,
			CONSTRAINT region_x_province_pkey PRIMARY KEY (region_id, province_id));

		-- insert values on table
		INSERT INTO utils.region_x_province SELECT region_id, province_id
		FROM utils.municipality WHERE region_id IS NOT NULL AND province_id IS NOT NULL
		ON CONFLICT (region_id, province_id) DO NOTHING;

		-- drop province_id from ext_region
		DROP VIEW IF EXISTS ud.ext_region;
		DROP VIEW IF EXISTS ws.ext_region;
		DROP VIEW IF EXISTS SCHEMA_NAME.ext_region;

		CREATE TABLE IF NOT EXISTS utils._region_ AS SELECT * FROM utils.region;
		ALTER TABLE utils.region DROP COLUMN IF EXISTS province_id;

		-- refresh views
		CREATE OR REPLACE VIEW ud.ext_region AS SELECT * FROM utils.region;
		CREATE OR REPLACE VIEW ws.ext_region AS SELECT * FROM utils.region;
		CREATE OR REPLACE VIEW SCHEMA_NAME.ext_region AS SELECT * FROM utils.region;
		CREATE OR REPLACE VIEW ud.ext_province AS SELECT * FROM utils.province;
		CREATE OR REPLACE VIEW ws.ext_province AS SELECT * FROM utils.province;
		CREATE OR REPLACE VIEW SCHEMA_NAME.ext_province AS SELECT * FROM utils.province;

		-- create fk
		ALTER TABLE utils.municipality DROP CONSTRAINT IF EXISTS municipality_province_region_fk;
		ALTER TABLE utils.municipality ADD CONSTRAINT municipality_province_region_fk FOREIGN KEY (province_id, region_id)
        REFERENCES utils.region_x_province (province_id, region_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
        
		-- add region and province to ext_municipality view
		CREATE OR REPLACE VIEW SCHEMA_NAME.ext_municipality
		AS SELECT municipality.muni_id,
			municipality.name,
			municipality.observ,
			municipality.the_geom,
			municipality.active,
			municipality.region_id,
			municipality.province_id
		   FROM utils.municipality;

    ELSE

	 	-- create table region_x_province
     	CREATE TABLE IF NOT EXISTS SCHEMA_NAME.ext_region_x_province (
			region_id int4 NOT NULL,
			province_id int4 NOT NULL,
			CONSTRAINT ext_region_x_province_pkey PRIMARY KEY (region_id, province_id));

		-- insert values on table
		INSERT INTO ext_region_x_province SELECT region_id, province_id
		FROM ext_municipality where region_id IS NOT NULL AND province_id IS NOT NULL
		ON CONFLICT (region_id, province_id) DO NOTHING;

		-- drop province_id from ext_region
		CREATE TABLE IF NOT EXISTS SCHEMA_NAME._ext_region_ AS SELECT * FROM SCHEMA_NAME.ext_region;
		ALTER TABLE SCHEMA_NAME.ext_region DROP COLUMN province_id;

		-- create fk
		ALTER TABLE SCHEMA_NAME.ext_municipality ADD CONSTRAINT ext_municipality_province_region_fk FOREIGN KEY (province_id, region_id)
        REFERENCES SCHEMA_NAME.ext_region_x_province (province_id, region_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

	 END IF;
END; $$;


CREATE OR REPLACE VIEW v_plan_psector
AS SELECT plan_psector.psector_id,
    plan_psector.name,
    plan_psector.psector_type,
    plan_psector.descript,
    plan_psector.priority,
    a.suma::numeric(14,2) AS total_arc,
    b.suma::numeric(14,2) AS total_node,
    c.suma::numeric(14,2) AS total_other,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.rotation,
    plan_psector.scale,
    plan_psector.active,
    (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pem,
    plan_psector.gexpenses,
    (((100::numeric + plan_psector.gexpenses) / 100::numeric)::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pec,
    plan_psector.vat,
    (((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric))::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pec_vat,
    plan_psector.other,
    (((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric) * ((100::numeric + plan_psector.other) / 100::numeric))::numeric(14,2) * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pca,
    plan_psector.the_geom
   FROM selector_psector,
    plan_psector
     LEFT JOIN ( SELECT sum(v_plan_psector_x_arc.total_budget) AS suma,
            v_plan_psector_x_arc.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
                    v_plan_arc.arc_id,
                    v_plan_arc.node_1,
                    v_plan_arc.node_2,
                    v_plan_arc.arc_type,
                    v_plan_arc.arccat_id,
                    v_plan_arc.epa_type,
                    v_plan_arc.state,
                    v_plan_arc.sector_id,
                    v_plan_arc.expl_id,
                    v_plan_arc.annotation,
                    v_plan_arc.soilcat_id,
                    v_plan_arc.y1,
                    v_plan_arc.y2,
                    v_plan_arc.mean_y,
                    v_plan_arc.z1,
                    v_plan_arc.z2,
                    v_plan_arc.thickness,
                    v_plan_arc.width,
                    v_plan_arc.b,
                    v_plan_arc.bulk,
                    v_plan_arc.geom1,
                    v_plan_arc.area,
                    v_plan_arc.y_param,
                    v_plan_arc.total_y,
                    v_plan_arc.rec_y,
                    v_plan_arc.geom1_ext,
                    v_plan_arc.calculed_y,
                    v_plan_arc.m3mlexc,
                    v_plan_arc.m2mltrenchl,
                    v_plan_arc.m2mlbottom,
                    v_plan_arc.m2mlpav,
                    v_plan_arc.m3mlprotec,
                    v_plan_arc.m3mlfill,
                    v_plan_arc.m3mlexcess,
                    v_plan_arc.m3exc_cost,
                    v_plan_arc.m2trenchl_cost,
                    v_plan_arc.m2bottom_cost,
                    v_plan_arc.m2pav_cost,
                    v_plan_arc.m3protec_cost,
                    v_plan_arc.m3fill_cost,
                    v_plan_arc.m3excess_cost,
                    v_plan_arc.cost_unit,
                    v_plan_arc.pav_cost,
                    v_plan_arc.exc_cost,
                    v_plan_arc.trenchl_cost,
                    v_plan_arc.base_cost,
                    v_plan_arc.protec_cost,
                    v_plan_arc.fill_cost,
                    v_plan_arc.excess_cost,
                    v_plan_arc.arc_cost,
                    v_plan_arc.cost,
                    v_plan_arc.length,
                    v_plan_arc.budget,
                    v_plan_arc.other_budget,
                    v_plan_arc.total_budget,
                    v_plan_arc.the_geom,
                    plan_psector_x_arc.id,
                    plan_psector_x_arc.arc_id,
                    plan_psector_x_arc.psector_id,
                    plan_psector_x_arc.state,
                    plan_psector_x_arc.doable,
                    plan_psector_x_arc.descript,
                    plan_psector_x_arc.addparam
                   FROM v_plan_arc
                     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id::text = v_plan_arc.arc_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_arc.psector_id
                  WHERE plan_psector_x_arc.doable IS TRUE
                  ORDER BY plan_psector_x_arc.psector_id) v_plan_psector_x_arc(rid, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arc_id_1, psector_id, state_1, doable, descript, addparam)
          GROUP BY v_plan_psector_x_arc.psector_id) a ON a.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_node.budget) AS suma,
            v_plan_psector_x_node.psector_id
           FROM ( SELECT row_number() OVER (ORDER BY v_plan_node.node_id) AS rid,
                    v_plan_node.node_id,
                    v_plan_node.nodecat_id,
                    v_plan_node.node_type,
                    v_plan_node.top_elev,
                    v_plan_node.elev,
                    v_plan_node.epa_type,
                    v_plan_node.state,
                    v_plan_node.sector_id,
                    v_plan_node.expl_id,
                    v_plan_node.annotation,
                    v_plan_node.cost_unit,
                    v_plan_node.descript,
                    v_plan_node.cost,
                    v_plan_node.measurement,
                    v_plan_node.budget,
                    v_plan_node.the_geom,
                    plan_psector_x_node.id,
                    plan_psector_x_node.node_id,
                    plan_psector_x_node.psector_id,
                    plan_psector_x_node.state,
                    plan_psector_x_node.doable,
                    plan_psector_x_node.descript
                   FROM v_plan_node
                     JOIN plan_psector_x_node ON plan_psector_x_node.node_id::text = v_plan_node.node_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_node.psector_id
                  WHERE plan_psector_x_node.doable IS TRUE
                  ORDER BY plan_psector_x_node.psector_id) v_plan_psector_x_node(rid, node_id, nodecat_id, node_type, top_elev, elev, epa_type, state, sector_id, expl_id, annotation, cost_unit, descript, cost, measurement, budget, the_geom, id, node_id_1, psector_id, state_1, doable, descript_1)
          GROUP BY v_plan_psector_x_node.psector_id) b ON b.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_other.total_budget) AS suma,
            v_plan_psector_x_other.psector_id
           FROM ( SELECT plan_psector_x_other.id,
                    plan_psector_x_other.psector_id,
                    plan_psector_1.psector_type,
                    v_price_compost.id AS price_id,
                    v_price_compost.descript,
                    v_price_compost.price,
                    plan_psector_x_other.measurement,
                    (plan_psector_x_other.measurement * v_price_compost.price)::numeric(14,2) AS total_budget
                   FROM plan_psector_x_other
                     JOIN v_price_compost ON v_price_compost.id::text = plan_psector_x_other.price_id::text
                     JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_other.psector_id
                  ORDER BY plan_psector_x_other.psector_id) v_plan_psector_x_other
          GROUP BY v_plan_psector_x_other.psector_id) c ON c.psector_id = plan_psector.psector_id
  WHERE plan_psector.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;

INSERT INTO inp_typevalue VALUES ('inp_typevalue_dscenario','NETWORK','NETWORK');

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES(3308, 'gw_fct_admin_create_message', 'utils', 'function', 'json', 'json', 'Function to create sys_message efficiently', 'role_admin', NULL, 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_typevalue VALUES (
'tabname_typevalue','tab_municipality','tab_municipality','tabMunicipality');

INSERT INTO config_form_tabs VALUES ('selector_basic','tab_municipality','Muni','Municipality','role_basic',NULL,NULL,0,'{4,5}');

INSERT INTO config_param_system VALUES (
'basic_selector_tab_municipality',
'{"table":"ext_municipality","selector":"selector_municipality","table_id":"muni_id","selector_id":"muni_id","label":"muni_id, ''- '', name","orderBy":"muni_id","manageAll":true,"selectionMode":"keepPreviousUsingShift","query_filter":"AND muni_id > 0","typeaheadFilter":" AND lower(concat(muni_id, '' - '', name))","typeaheadForced":true,"explFromMuni":true}',
'Variable to configura all options related to search for the specificic tab','Selector variables',NULL,NULL,FALSE,NULL,'utils',NULL,NULL,'json','text');

UPDATE config_form_fields SET widgettype='combo',
dv_querytext='SELECT id, id as idval FROM sys_feature_type WHERE classlevel = 1 OR classlevel = 2',
dv_orderby_id=true, dv_isnullvalue = true WHERE formname='v_edit_dimensions' AND formtype='form_feature' AND columnname='feature_type' AND tabname='tab_none';


DELETE FROM sys_foreignkey WHERE typevalue_name = 'psector_type' AND target_table='plan_psector';
DELETE FROM plan_typevalue WHERE typevalue='psector_type' AND id='1';

INSERT INTO edit_typevalue VALUES ('presszone_type', 'BUSTER', 'BUSTER');
INSERT INTO edit_typevalue VALUES ('presszone_type', 'TANK', 'TANK');
INSERT INTO edit_typevalue VALUES ('presszone_type', 'PRV', 'PRV');
INSERT INTO edit_typevalue VALUES ('presszone_type', 'PSV', 'PSV');
INSERT INTO edit_typevalue VALUES ('presszone_type', 'PUMP', 'PUMP');
INSERT INTO edit_typevalue VALUES ('presszone_type', 'UNDEFINED', 'UNDEFINED');

INSERT INTO config_param_system ("parameter", value, descript, "label", project_type,"datatype", widgettype)
VALUES('plan_node_replace_code', 'false', 'If true, when a node replace in planification is performed, new arcs will have the same code as the replaced one. Otherwise, new arcs will have the same code as its arc_id.', 'Plan node replace code', 'utils', 'boolean', 'text') ON CONFLICT (parameter) DO NOTHING;


UPDATE config_form_fields
	SET linkedobject=NULL
	WHERE columnname IN ('date_visit_from', 'date_visit_to') AND tabname='tab_visit';

UPDATE config_form_fields
	SET widgetfunction='{"functionName": "filter_table", "parameters": {"columnfind": "Start date", "targetwidget": "tab_visit_tbl_visits"}}'::json
	WHERE columnname='date_visit_from' AND tabname='tab_visit';

UPDATE config_form_fields
	SET widgetfunction='{"functionName": "filter_table", "parameters": {"columnfind": "End date", "targetwidget": "tab_visit_tbl_visits"}}'::json
	WHERE columnname='date_visit_to' AND tabname='tab_visit';


INSERT INTO config_param_system VALUES ('edit_connec_autofill_plotcode', 'FALSE', 'Variable to automatic fill plot_code', 'Variable to automatic fill plot_code', null, null, TRUE, null, null, null, null, 'boolean', 'text'); 


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('v_edit_dma', 'form_feature', 'tab_data', 'expl_id2', 'lyt_data_1', 17, 'string', 'combo', 'expl_id2', 'expl_id2', NULL, false, false, true, false, NULL, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id is not null ', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);


UPDATE sys_param_user SET "label"='End date:' WHERE id='edit_enddate_vdefault';

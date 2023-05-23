/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2022/01/03
-- JUNCTION REFACTOR
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_junction", "column":"emitter_coeff", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_junction", "column":"init_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_junction", "column":"source_type", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_junction", "column":"source_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_junction", "column":"source_pattern_id", "dataType":"character varying(16)", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_junction", "column":"emitter_coeff", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_junction", "column":"init_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_junction", "column":"source_type", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_junction", "column":"source_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_junction", "column":"source_pattern_id", "dataType":"character varying(16)", "isUtils":"False"}}$$);

UPDATE inp_junction j SET emitter_coeff = coef FROM inp_emitter s WHERE s.node_id = j.node_id;
UPDATE inp_junction j SET init_quality = initqual FROM inp_quality s WHERE s.node_id = j.node_id;
UPDATE inp_junction j SET source_type = sourc_type FROM inp_source s WHERE s.node_id = j.node_id;
UPDATE inp_junction j SET source_quality = quality FROM inp_source s WHERE s.node_id = j.node_id;
UPDATE inp_junction j SET source_pattern_id = s.pattern_id FROM inp_source s WHERE s.node_id = j.node_id;

-- CONNEC REFACTOR
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_connec", "column":"emitter_coeff", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_connec", "column":"init_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_connec", "column":"source_type", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_connec", "column":"source_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_connec", "column":"source_pattern_id", "dataType":"character varying(16)", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_connec", "column":"emitter_coeff", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_connec", "column":"init_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_connec", "column":"source_type", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_connec", "column":"source_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_connec", "column":"source_pattern_id", "dataType":"character varying(16)", "isUtils":"False"}}$$);


--PUMP REFACTOR 
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"inp_pump", "column":"pattern", "newName":"pattern_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"inp_dscenario_pump", "column":"pattern", "newName":"pattern_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"inp_pump_additional", "column":"pattern", "newName":"pattern_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"inp_dscenario_pump_additional", "column":"pattern", "newName":"pattern_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"inp_pump_importinp", "column":"pattern", "newName":"pattern_id"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_pump", "column":"effic_curve_id", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_pump", "column":"energy_price", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_pump", "column":"energy_pattern_id", "dataType":"character varying(18)", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_pump", "column":"effic_curve_id", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_pump", "column":"energy_price", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_pump", "column":"energy_pattern_id", "dataType":"character varying(18)", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_pump_importinp", "column":"effic_curve_id", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_pump_importinp", "column":"energy_price", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_pump_importinp", "column":"energy_pattern_id", "dataType":"character varying(18)", "isUtils":"False"}}$$);

UPDATE inp_pump SET effic_curve_id=energyvalue 
WHERE energyparam ilike '%EFFIC%' AND energyvalue in (select id from inp_curve);

UPDATE inp_pump SET energy_price=energyvalue::float 
WHERE energyparam ilike '%PRICE%' and energyvalue ~ '^ *[-+]?[0-9]*([.][0-9]+)?[0-9]*(([eE][-+]?)[0-9]+)? *$' is true;

UPDATE inp_pump SET energy_pattern_id=energyvalue 
WHERE energyparam ilike '%PATTERN%' AND energyvalue in (select pattern_id from inp_pattern);

--PUMP_ADDITIONAL REFACTOR
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_pump_additional", "column":"effic_curve_id", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_pump_additional", "column":"energy_price", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_pump_additional", "column":"energy_pattern_id", "dataType":"character varying(18)", "isUtils":"False"}}$$);
--create table dscenario

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_pump_additional", "column":"effic_curve_id", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_pump_additional", "column":"energy_price", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_pump_additional", "column":"energy_pattern_id", "dataType":"character varying(18)", "isUtils":"False"}}$$);


UPDATE inp_pump_additional SET effic_curve_id=energyvalue 
WHERE energyparam ilike '%EFFIC%' AND energyvalue in (select id from inp_curve);

UPDATE inp_pump_additional SET energy_price=energyvalue::float 
WHERE energyparam ilike '%PRICE%' and energyvalue ~ '^ *[-+]?[0-9]*([.][0-9]+)?[0-9]*(([eE][-+]?)[0-9]+)? *$' is true;

UPDATE inp_pump_additional SET energy_pattern_id=energyvalue 
WHERE energyparam ilike '%PATTERN%' AND energyvalue in (select pattern_id from inp_pattern);

--PIPE REFACTOR
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_pipe", "column":"bulk_coeff", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_pipe", "column":"wall_coeff", "dataType":"float", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_pipe", "column":"bulk_coeff", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_pipe", "column":"wall_coeff", "dataType":"float", "isUtils":"False"}}$$);


UPDATE inp_pipe SET bulk_coeff=reactionvalue::float 
WHERE reactionparam ilike '%bulk%' and reactionvalue ~ '^ *[-+]?[0-9]*([.][0-9]+)?[0-9]*(([eE][-+]?)[0-9]+)? *$' is true;

UPDATE inp_pipe SET bulk_coeff=reactionvalue::float 
WHERE reactionparam ilike '%wall%' and reactionvalue ~ '^ *[-+]?[0-9]*([.][0-9]+)?[0-9]*(([eE][-+]?)[0-9]+)? *$' is true;

--SHORTPIPE REFACTOR
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_shortpipe", "column":"bulk_coeff", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_shortpipe", "column":"wall_coeff", "dataType":"float", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_shortpipe", "column":"bulk_coeff", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_shortpipe", "column":"wall_coeff", "dataType":"float", "isUtils":"False"}}$$);

--TANK REFACTOR
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_tank", "column":"mixing_model", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_tank", "column":"mixing_fraction", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_tank", "column":"reaction_coeff", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_tank", "column":"init_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_tank", "column":"source_type", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_tank", "column":"source_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_tank", "column":"source_pattern_id", "dataType":"character varying(16)", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_tank", "column":"mixing_model", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_tank", "column":"mixing_fraction", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_tank", "column":"reaction_coeff", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_tank", "column":"init_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_tank", "column":"source_type", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_tank", "column":"source_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_tank", "column":"source_pattern_id", "dataType":"character varying(16)", "isUtils":"False"}}$$);

UPDATE inp_tank j SET mixing_model = mix_type, mixing_fraction=value FROM inp_mixing s WHERE s.node_id = j.node_id;
UPDATE inp_tank j SET init_quality = initqual FROM inp_quality s WHERE s.node_id = j.node_id;
UPDATE inp_tank j SET source_type = sourc_type FROM inp_source s WHERE s.node_id = j.node_id;
UPDATE inp_tank j SET source_quality = quality FROM inp_source s WHERE s.node_id = j.node_id;
UPDATE inp_tank j SET source_pattern_id = s.pattern_id FROM inp_source s WHERE s.node_id = j.node_id;

-- RESERVOIR REFACTOR
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_reservoir", "column":"init_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_reservoir", "column":"source_type", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_reservoir", "column":"source_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_reservoir", "column":"source_pattern_id", "dataType":"character varying(16)", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_reservoir", "column":"init_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_reservoir", "column":"source_type", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_reservoir", "column":"source_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_reservoir", "column":"source_pattern_id", "dataType":"character varying(16)", "isUtils":"False"}}$$);

UPDATE inp_reservoir j SET init_quality = initqual FROM inp_quality s WHERE s.node_id = j.node_id;
UPDATE inp_reservoir j SET source_type = sourc_type FROM inp_source s WHERE s.node_id = j.node_id;
UPDATE inp_reservoir j SET source_quality = quality FROM inp_source s WHERE s.node_id = j.node_id;
UPDATE inp_reservoir j SET source_pattern_id = s.pattern_id FROM inp_source s WHERE s.node_id = j.node_id;


--VALVE REFACTOR
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_valve", "column":"init_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_valve", "column":"init_quality", "dataType":"float", "isUtils":"False"}}$$);

UPDATE inp_valve j SET init_quality = initqual FROM inp_quality s WHERE s.node_id = j.node_id;

--VIRTUALVALVE REFACTOR
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_virtualvalve", "column":"init_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_virtualvalve", "column":"init_quality", "dataType":"float", "isUtils":"False"}}$$);

UPDATE inp_virtualvalve j SET init_quality = initqual FROM inp_quality s WHERE s.node_id = j.arc_id;

--INLET REFACTOR
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_inlet", "column":"mixing_model", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_inlet", "column":"mixing_fraction", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_inlet", "column":"reaction_coeff", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_inlet", "column":"init_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_inlet", "column":"source_type", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_inlet", "column":"source_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_inlet", "column":"source_pattern_id", "dataType":"character varying(16)", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_inlet", "column":"mixing_model", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_inlet", "column":"mixing_fraction", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_inlet", "column":"reaction_coeff", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_inlet", "column":"init_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_inlet", "column":"source_type", "dataType":"character varying(18)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_inlet", "column":"source_quality", "dataType":"float", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_inlet", "column":"source_pattern_id", "dataType":"character varying(16)", "isUtils":"False"}}$$);

UPDATE inp_inlet j SET mixing_model = mix_type, mixing_fraction=value FROM inp_mixing s WHERE s.node_id = j.node_id;
UPDATE inp_inlet j SET init_quality = initqual FROM inp_quality s WHERE s.node_id = j.node_id;
UPDATE inp_inlet j SET source_type = sourc_type FROM inp_source s WHERE s.node_id = j.node_id;
UPDATE inp_inlet j SET source_quality = quality FROM inp_source s WHERE s.node_id = j.node_id;
UPDATE inp_inlet j SET source_pattern_id = s.pattern_id FROM inp_source s WHERE s.node_id = j.node_id;

---remove tables
ALTER TABLE inp_emitter RENAME TO _inp_emitter_;
ALTER TABLE inp_quality RENAME TO _inp_quality_;
ALTER TABLE inp_source RENAME TO _inp_source_;
ALTER TABLE inp_reactions RENAME TO _inp_reactions_;
ALTER TABLE inp_mixing RENAME TO _inp_mixing_;

DELETE FROM sys_table WHERE id  IN ('inp_quality', 'inp_source','inp_emitter','inp_reactions','inp_mixing');

DROP VIEW IF EXISTS v_edit_man_fountain_pol;
DROP VIEW IF EXISTS v_edit_man_register_pol;
DROP VIEW IF EXISTS v_edit_man_tank_pol;

/*

SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_node"], "fieldName":"_pol_id_","action":"DELETE-FIELD","hasChilds":"True","onlyChilds":"True"}}$$);

SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_node"], "action":"RESTORE-VIEW","hasChilds":"True"}}$$);

SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_connec"], "fieldName":"_pol_id_","action":"DELETE-FIELD","hasChilds":"True","onlyChilds":"True"}}$$);

SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_connec"], "action":"RESTORE-VIEW","hasChilds":"True"}}$$);

SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},"data":{"viewName":["v_edit_man_tank"],
"fieldName":"pol_id","alias":"man_tank._pol_id_ AS pol_id","action":"DELETE-FIELD","hasChilds":"False"}}$$);

SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_man_tank"], "action":"RESTORE-VIEW","hasChilds":"False"}}$$);

SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},"data":{"viewName":["v_edit_man_fountain"],
"fieldName":"pol_id","alias":"man_fountain._pol_id_ AS pol_id","action":"DELETE-FIELD","hasChilds":"False"}}$$);

SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_man_fountain"], "action":"RESTORE-VIEW","hasChilds":"False"}}$$);

SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},"data":{"viewName":["v_edit_man_register"],
"fieldName":"pol_id","alias":"man_register._pol_id_ AS pol_id","action":"DELETE-FIELD","hasChilds":"False"}}$$);

SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
"data":{"viewName":["v_edit_man_register"], "action":"RESTORE-VIEW","hasChilds":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_register", "column":"_pol_id_", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_fountain", "column":"_pol_id_", "dataType":"integer"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"man_tank", "column":"_pol_id_", "dataType":"integer"}}$$);

*/

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"presszone", "column":"tstamp", "dataType":"timestamp", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"presszone", "column":"insert_user", "dataType":"varchar(15)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"presszone", "column":"lastupdate", "dataType":"timestamp", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"presszone", "column":"lastupdate_user", "dataType":"varchar(15)", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dqa", "column":"tstamp", "dataType":"timestamp", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dqa", "column":"insert_user", "dataType":"varchar(15)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dqa", "column":"lastupdate", "dataType":"timestamp", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"dqa", "column":"lastupdate_user", "dataType":"varchar(15)", "isUtils":"False"}}$$);


ALTER TABLE presszone ALTER COLUMN tstamp SET DEFAULT now();
ALTER TABLE presszone ALTER COLUMN insert_user SET DEFAULT current_user;

ALTER TABLE dqa ALTER COLUMN tstamp SET DEFAULT now();
ALTER TABLE dqa ALTER COLUMN insert_user SET DEFAULT current_user;

CREATE TABLE IF NOT EXISTS rtc_hydrometer_x_node
(
    hydrometer_id character varying(16) COLLATE pg_catalog."default" NOT NULL,
    node_id character varying(16) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT rtc_hydrometer_x_node_pkey PRIMARY KEY (hydrometer_id),
    CONSTRAINT rtc_hydrometer_x_node_node_id_fkey FOREIGN KEY (node_id)
        REFERENCES node (node_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT rtc_hydrometer_x_node_hydrometer_id_fkey FOREIGN KEY (hydrometer_id)
        REFERENCES rtc_hydrometer (hydrometer_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS rtc_hydrometer_x_node_index_node_id
    ON rtc_hydrometer_x_node USING btree
    (node_id COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
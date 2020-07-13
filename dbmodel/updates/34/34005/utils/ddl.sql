/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE config_api_form_fields RENAME TO config_form_fields;

ALTER TABLE ext_rtc_scada_dma_period RENAME TO ext_rtc_dma_period;

--2020/06/15
ALTER TABLE cat_arc ADD COLUMN acoeff float;
ALTER TABLE cat_node ADD COLUMN acoeff float;

ALTER TABLE cat_work ADD COLUMN workcost float;

ALTER TABLE om_rec_result_arc ADD COLUMN builtcost float;
ALTER TABLE om_rec_result_arc ADD COLUMN builtdate timestamp;
ALTER TABLE om_rec_result_arc ADD COLUMN age float;
ALTER TABLE om_rec_result_arc ADD COLUMN acoeff float;
ALTER TABLE om_rec_result_arc ADD COLUMN aperiod text;
ALTER TABLE om_rec_result_arc ADD COLUMN arate float;
ALTER TABLE om_rec_result_arc ADD COLUMN amortized float;
ALTER TABLE om_rec_result_arc ADD COLUMN pending float;

ALTER TABLE om_rec_result_node ADD COLUMN builtcost float;
ALTER TABLE om_rec_result_node ADD COLUMN builtdate timestamp;
ALTER TABLE om_rec_result_node ADD COLUMN age float;
ALTER TABLE om_rec_result_node ADD COLUMN acoeff float;
ALTER TABLE om_rec_result_node ADD COLUMN aperiod text;
ALTER TABLE om_rec_result_node ADD COLUMN arate float;
ALTER TABLE om_rec_result_node ADD COLUMN amortized float;
ALTER TABLE om_rec_result_node ADD COLUMN pending float;


--2020/03/13
CREATE INDEX node_sector ON node USING btree (sector_id);
CREATE INDEX node_nodecat ON node USING btree (nodecat_id);
CREATE INDEX node_exploitation ON node USING btree (expl_id);
CREATE INDEX node_dma ON node USING btree (dma_id);
CREATE INDEX node_street1 ON node USING btree (streetaxis_id);
CREATE INDEX node_street2 ON node USING btree (streetaxis2_id);


CREATE INDEX arc_sector ON arc USING btree (sector_id);
CREATE INDEX arc_arccat ON arc USING btree (arccat_id);
CREATE INDEX arc_exploitation ON arc USING btree (expl_id);
CREATE INDEX arc_dma ON arc USING btree (dma_id);
CREATE INDEX arc_street1 ON arc USING btree (streetaxis_id);
CREATE INDEX arc_street2 ON arc USING btree (streetaxis2_id);


CREATE INDEX connec_sector ON connec USING btree (sector_id);
CREATE INDEX connec_connecat ON connec USING btree (connecat_id);
CREATE INDEX connec_exploitation ON connec USING btree (expl_id);
CREATE INDEX connec_dma ON connec USING btree (dma_id);
CREATE INDEX connec_street1 ON connec USING btree (streetaxis_id);
CREATE INDEX connec_street2 ON connec USING btree (streetaxis2_id);


--2020/06/04
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"district_id", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"node", "column":"district_id", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"connec", "column":"district_id", "dataType":"integer", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"samplepoint", "column":"district_id", "dataType":"integer", "isUtils":"False"}}$$);

--2020/06/08
ALTER TABLE cat_feature ADD COLUMN descript text;
ALTER TABLE cat_feature ADD COLUMN link_path text;
ALTER TABLE cat_feature ADD COLUMN code_autofill boolean;
ALTER TABLE cat_feature ADD COLUMN active boolean;


/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE doc ADD the_geom public.geometry(point, SRID_VALUE) NULL;
ALTER TABLE doc ADD name varchar(30) NULL;
ALTER TABLE doc ADD CONSTRAINT name_chk UNIQUE ("name");

DROP VIEW if EXISTS v_ui_doc;
CREATE OR REPLACE VIEW v_ui_doc
AS SELECT doc.id,
    doc.name,
    doc.observ,
    doc.doc_type,
    doc.path,
    doc.date,
    doc.user_name,
    doc.tstamp
   FROM doc;


--25/07/2024
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_cat_result", "column":"addparam", "dataType":"json"}}$$);

--26/07/2024
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_cat_result", "column":"expl_id_", "dataType":"int[]"}}$$);

UPDATE rpt_cat_result SET expl_id_ = ARRAY[expl_id];

DROP VIEW v_ui_rpt_cat_result;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"rpt_cat_result", "column":"expl_id"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"rpt_cat_result", "column":"expl_id_", "newName":"expl_id"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_cat_result", "column":"network_type", "dataType":"text"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_cat_result", "column":"sector_id", "dataType":"int[]"}}$$);

--29/07/2024
DROP VIEW if EXISTS v_ui_doc_x_workcat;
CREATE OR REPLACE VIEW v_ui_doc_x_workcat
AS SELECT doc_x_workcat.id,
    doc_x_workcat.workcat_id,
    doc.name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_workcat
     JOIN doc ON doc.id::text = doc_x_workcat.doc_id::text;

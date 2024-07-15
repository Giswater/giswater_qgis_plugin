/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE doc ADD the_geom public.geometry(point, SRID_VALUE) NULL;

DROP VIEW if EXISTS v_ui_doc
CREATE OR REPLACE VIEW v_ui_doc
AS SELECT doc.id,
    doc.id_val,
    doc.observ,
    doc.doc_type,
    doc.path,
    doc.date,
    doc.user_name,
    doc.tstamp
   FROM doc;

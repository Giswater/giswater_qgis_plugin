/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE OR REPLACE VIEW v_ui_doc_x_workcat AS
 SELECT doc_x_workcat.id,
    doc_x_workcat.workcat_id,
    doc_x_workcat.doc_id,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_workcat
   JOIN doc ON doc.id::text = doc_x_workcat.doc_id::text;
   

CREATE OR REPLACE VIEW v_anl_graf AS 
 SELECT anl_graf.arc_id,
    anl_graf.node_1,
    anl_graf.node_2,
    anl_graf.flag,
    a.flag AS flagi,
    a.value
   FROM temp_anlgraf anl_graf
     JOIN ( SELECT anl_graf_1.arc_id,
            anl_graf_1.node_1,
            anl_graf_1.node_2,
            anl_graf_1.water,
            anl_graf_1.flag,
            anl_graf_1.checkf,
            anl_graf_1.value
           FROM temp_anlgraf anl_graf_1
          WHERE anl_graf_1.water = 1) a ON anl_graf.node_1 = a.node_2
  WHERE anl_graf.flag < 2 AND a.water = 0 AND a.flag < 2;
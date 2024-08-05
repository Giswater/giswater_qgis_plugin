/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--05/08/2024
CREATE trigger gw_trg_ui_doc_x_visit instead OF
INSERT
    OR
DELETE
    OR
UPDATE
    ON
    v_ui_doc_x_visit FOR each row EXECUTE function gw_trg_ui_doc('doc_x_visit');
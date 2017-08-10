/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association

*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;
/*
-- ----------------------------
-- Default values of column views
-- ----------------------------

-- System values  (fields need values. User can customize, but it's forbidden to delete default values from this fields) 
ALTER VIEW v_edit_node ALTER top_elev SET DEFAULT 0.00;
ALTER VIEW v_edit_node ALTER ymax SET DEFAULT 0.00;
ALTER VIEW v_edit_node ALTER state SET DEFAULT 'ON_SERVICE';
ALTER VIEW v_edit_node ALTER verified SET DEFAULT 'TO REVIEW';

ALTER VIEW v_edit_arc ALTER y1 SET DEFAULT 0.00;
ALTER VIEW v_edit_arc ALTER y2 SET DEFAULT 0.00;
ALTER VIEW v_edit_arc ALTER state SET DEFAULT 'ON_SERVICE';
ALTER VIEW v_edit_arc ALTER inverted_slope SET DEFAULT false;
ALTER VIEW v_edit_arc ALTER verified SET DEFAULT 'TO REVIEW';


ALTER VIEW v_edit_connec ALTER top_elev SET DEFAULT 0.00;
ALTER VIEW v_edit_connec ALTER ymax SET DEFAULT 0.00;
ALTER VIEW v_edit_connec ALTER state SET DEFAULT 'ON_SERVICE';
ALTER VIEW v_edit_connec ALTER verified SET DEFAULT 'TO REVIEW';

ALTER TABLE element ALTER COLUMN state SET DEFAULT 'ON_SERVICE';
ALTER TABLE element ALTER COLUMN verified SET DEFAULT 'TO REVIEW';


-- Custom values (User can customize other fields....)
*/
/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


DROP RULE IF EXISTS review_status ON review_audit_node;
CREATE OR REPLACE RULE review_status AS ON INSERT TO review_audit_arc 
DO UPDATE review_arc SET verified='REVISED' WHERE arc_id=NEW.arc_id AND field_checked='TRUE';


DROP RULE IF EXISTS review_status ON review_audit_node;
CREATE OR REPLACE RULE review_status AS ON INSERT TO review_audit_node
DO UPDATE review_node SET verified='REVISED' WHERE node_id=NEW.node_id AND field_checked='TRUE';
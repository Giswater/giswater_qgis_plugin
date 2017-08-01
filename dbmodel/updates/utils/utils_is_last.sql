/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;





-- ----------------------------
--GLOBAL STATE/PSECTOR SELECTION
-- ----------------------------




-- ----------------------------
--DIMENSIONS
-- ----------------------------

	
  
  -- ----------------------------
--Link 
-- ----------------------------


-- ----------------------------
-- STATE TOPOLOGYC COHERENCE
-- ----------------------------

-- CATALOG OF FUNCTION


 
-- ----------------------------
-- IMPROVE STATE TOPOLOGY COHERENCE TOOLS
-- ----------------------------


--



-- ----------------------------
-- VDEFAULT STRATEGY
-- ----------------------------

/*
ALTER TABLE config ADD COLUMN state_vdefault character varying(16);
ALTER TABLE config ADD COLUMN workcat_vdefault character varying(30);
ALTER TABLE config ADD COLUMN verified_vdefault character varying(20);
ALTER TABLE config ADD COLUMN builtdate_vdefault date;

ALTER TABLE "config" ADD CONSTRAINT "confige_state_vdefault_fkey" FOREIGN KEY ("state_vdefault") REFERENCES "value_state" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "config" ADD CONSTRAINT "config_workcat_vdefault_fkey" FOREIGN KEY ("workcat_vdefault") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "config" ADD CONSTRAINT "config_verified_vdefault_fkey" FOREIGN KEY ("verified_vdefault") REFERENCES "value_verified" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "config" ADD CONSTRAINT "config_nodeinsert_catalog_vdefault_fkey" FOREIGN KEY ("nodeinsert_catalog_vdefault") REFERENCES "cat_node" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

*/


-- ----------------------------
-- ADDING GEOMETRY TO CATALOG OF WORKS
-- ----------------------------


-- ----------------------------
-- TRACEABILITY
-- ----------------------------



 
  -- ----------------------------
-- VALUE DOMAIN ON WEB/MOBILE CLIENT
-- ----------------------------
  





-- ----------------------------
-- IMPROVE VISIT STRATEGY
-- ----------------------------


-- ----------------------------
-- anl_arc_no_startend_node
-- ----------------------------


-- ----------------------------
-- review rules
-- ----------------------------



/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


ALTER TABLE SCHEMA_NAME.audit_function_actions ADD FOREIGN KEY ("audit_cat_error_id") 
REFERENCES SCHEMA_NAME.audit_cat_error ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE SCHEMA_NAME.audit_function_actions ADD FOREIGN KEY ("audit_cat_function_id") 
REFERENCES SCHEMA_NAME.audit_cat_function ("id") ON DELETE CASCADE ON UPDATE CASCADE;


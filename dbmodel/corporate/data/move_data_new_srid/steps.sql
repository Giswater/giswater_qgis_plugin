/*
steps to move all data from one schema to another with a new SRID
*/

--1: Create a new schema with the new SRID

--2: disable all triggers on this new schema
SELECT SCHEMA_NAME.gw_fct_disabletrg(false);

--3: drop all constraints and save it into temp_table to create them after the process (existing fct)
SELECT SCHEMA_NAME.gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, 
"data":{"action":"DROP"}}$$);

--4: delete all data from all tables except from temp_table
SELECT SCHEMA_NAME.gw_fct_truncatetables();

--5: run the move data function. Before, you need to change SRID_VALUE for the new SRID and OLD_SCHEMA_NAME for the name of the current schema, where the data will be copied from. There are some exceptions for tables with 2 geom columns or tables from utils schema
SELECT SCHEMA_NAME.gw_fct_movedata();

--6: maybe some more exceptions will be needed, for example, rule on insert_plan_psector_x_arc (remember to create rule after the process)
DROP RULE insert_plan_psector_x_arc ON SCHEMA_NAME.arc;

--7: enable triggers and reset constraints
SELECT SCHEMA_NAME.gw_fct_disabletrg(true);
SELECT SCHEMA_NAME.gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, 
"data":{"action":"ADD"}}$$);

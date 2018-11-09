/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_node_copy_attributes(    node_ori_aux character varying,    node_desti_aux character varying, table_aux character varying )  RETURNS void AS
$BODY$
DECLARE 
    rec record;  
    column_aux text;
    arc_rec record;
    arc_recPoint public.geometry;    
    connecPoint public.geometry;
    value_aux text;
    v_sql text;
    v_sql1 text;
    udt_name_aux text;
    nodetype1 text;
    nodetype2 text;
    
BEGIN 

	set search_path='SCHEMA_NAME_dev', public;
	
	--control same nodetype_id

	SELECT node_type into nodetype1 from node where node_id=node_ori_aux;
        SELECT node_type into nodetype2 from node where node_id=node_desti_aux;

	IF nodetype1=nodetype2 THEN
	ELSE
		RAISE EXCEPTION 'los node type no son iguales';
	END IF;

	
	-- taking values

	FOR column_aux, udt_name_aux IN select column_name, udt_name FROM information_schema.columns where table_schema='SCHEMA_NAME' and udt_name <> 'inet' and table_name=table_aux and column_name!='node_id' and column_name!='the_geom'
	LOOP
		v_sql1= 'SELECT '||column_aux||' FROM v_edit_man_junction where node_id='||quote_literal(node_ori_aux)||';';

		EXECUTE v_sql1 INTO value_aux;
	
		v_sql= 'UPDATE '||table_aux||' set '||column_aux||'='||quote_literal(value_aux)||'::'||udt_name_aux||' where node_id='||quote_literal(node_desti_aux)||';';
		raise notice 'v_sql %', v_sql;



		IF value_aux IS NOT NULL THEN
			EXECUTE v_sql; 
		ELSE
			raise notice 'v_sql is null';
		END IF;

	END LOOP;
   
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2702

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_unique_field() RETURNS trigger AS 

$BODY$
DECLARE 
table_name text;

BEGIN
   -- set search_path
   EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
   
   table_name:= TG_ARGV[0];
  
    IF table_name = 'connec' AND NEW.state = 1 THEN 
   
	   IF (SELECT count(connec_id) FROM connec WHERE state=1 AND customer_code=NEW.customer_code) > 1 THEN
	       EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
          "data":{"message":"3018", "function":"2702","debug_msg":null}}$$);';
	   END IF;
	   
    END IF;
			
RETURN NULL;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
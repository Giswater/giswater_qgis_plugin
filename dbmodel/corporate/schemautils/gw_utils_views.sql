/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



	-- WS
	CREATE OR REPLACE VIEW ws.ext_address  as SELECT  id , muni_id, postcode, streetaxis_id, postnumber, plot_id , the_geom , ws_expl_id as expl_id 
	FROM utils.address;

	CREATE OR REPLACE VIEW ws.ext_streetaxis as SELECT   id ,  code,  type,   name,   text,   the_geom,   ws_expl_id as expl_id,  muni_id   
	FROM utils.streetaxis;

	CREATE VIEW ws.ext_municipality AS SELECT * 
	FROM utils.municipality;

	CREATE OR REPLACE VIEW ws.ext_plot AS SELECT id,plot_code,muni_id,postcode,streetaxis_id,postnumber,complement,placement,square,observ,text,the_geom,ws_expl_id AS expl_id 
	FROM utils.plot;

	-- UD
	CREATE OR REPLACE VIEW ud.ext_address  as SELECT  id , muni_id, postcode, streetaxis_id, postnumber, plot_id , the_geom , ud_expl_id as expl_id
	FROM utils.address;

	CREATE OR REPLACE VIEW ud.ext_streetaxis as SELECT   id ,  code,  type,   name,   text,   the_geom,   ud_expl_id as expl_id,  muni_id   
	FROM utils.streetaxis;
			
	CREATE OR REPLACE VIEW ud.ext_municipality AS 
	SELECT * FROM utils.municipality;

	CREATE OR REPLACE VIEW ud.ext_plot AS SELECT id,plot_code,muni_id,postcode,streetaxis_id,postnumber,complement,placement,square,observ,text,the_geom,ud_expl_id AS expl_id 
	FROM utils.plot;
	


/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2952

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_plot()
  RETURNS trigger AS
$BODY$
DECLARE 

   
v_isutils boolean;
v_schema_utils text;
v_project_type text;
v_ws_schema text;
v_ud_schema text;
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    
    --check if schema utils is being used
    SELECT value::boolean INTO v_isutils FROM config_param_system WHERE parameter = 'admin_utils_schema';
    v_schema_utils = 'utils';
    
    --get the names of both ws and ud schema
    IF v_isutils is TRUE and v_schema_utils is not null THEN
      EXECUTE 'SELECT value FROM '||v_schema_utils||'.config_param_system WHERE parameter=''ws_current_schema'''
      INTO v_ws_schema;

      EXECUTE 'SELECT value FROM '||v_schema_utils||'.config_param_system WHERE parameter=''ud_current_schema'''
      INTO v_ud_schema;
    END IF;

    SELECT project_type INTO v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;
    
    IF TG_OP = 'INSERT' THEN
     
      IF v_isutils IS FALSE OR v_isutils IS NULL THEN  
        --get muni value if its null    
        IF NEW.muni_id IS NULL THEN
          NEW.muni_id := (SELECT muni_id FROM ext_municipality WHERE ST_DWithin(NEW.the_geom, ext_municipality.the_geom,0.001) AND active IS TRUE LIMIT 1);
        END IF;

        INSERT INTO ext_plot(id, plot_code, muni_id, postcode, streetaxis_id, postnumber, complement, placement, 
        square, observ, text, the_geom)
        VALUES (NEW.id, NEW.plot_code, NEW.muni_id, NEW.postcode, NEW.streetaxis_id, NEW.postnumber, NEW.complement, NEW.placement,
        NEW.square,NEW.observ,NEW.text, NEW.the_geom);

      ELSE
        --get muni value if its null
        IF NEW.muni_id IS NULL THEN
          EXECUTE 'SELECT muni_id FROM '||v_schema_utils||'.municipality 
          WHERE active IS TRUE AND ST_DWithin($1, municipality.the_geom,0.001) LIMIT 1'
          USING NEW.the_geom
          INTO NEW.muni_id;
        END IF; 

        EXECUTE 'INSERT INTO '||v_schema_utils||'.plot(id, plot_code, muni_id, postcode, streetaxis_id, postnumber, complement, placement, 
        square, observ, text, the_geom)
        VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)'
        USING NEW.id, NEW.plot_code, NEW.muni_id, NEW.postcode, NEW.streetaxis_id, NEW.postnumber, NEW.complement, 
        NEW.placement, NEW.square,NEW.observ,NEW.text, NEW.the_geom;

      END IF;

  RETURN NEW;
          
    ELSIF TG_OP = 'UPDATE' THEN

    IF v_isutils IS FALSE OR v_isutils IS NULL THEN  

      UPDATE ext_plot 
      SET id=NEW.id, plot_code=NEW.plot_code, muni_id=NEW.muni_id, postcode=NEW.postcode, streetaxis_id=NEW.streetaxis_id, 
      postnumber=NEW.postnumber, complement=NEW.complement, placement=NEW.placement, square=NEW.square, observ=NEW.observ,
      text=NEW.text, the_geom=NEW.the_geom
      WHERE id=NEW.id;
    
    ELSE

      IF v_project_type = 'WS' THEN
        EXECUTE 'UPDATE  '||v_schema_utils||'.plot 
        SET id=$1, plot_code=$2, muni_id=$3, postcode=$4, streetaxis_id=$5, postnumber=$6, 
        complement=$7, placement=$8, square=$9, observ=$10,
        text=$11, the_geom=$12 WHERE id=$1'
        USING NEW.id, NEW.plot_code, NEW.muni_id, NEW.postcode,NEW.streetaxis_id, NEW.postnumber, NEW.complement,
        NEW.placement, NEW.square, NEW.observ, NEW.text,NEW.the_geom;
       

      ELSIF v_project_type = 'UD' THEN
        EXECUTE 'UPDATE  '||v_schema_utils||'.plot 
        SET id=$1, plot_code=$2, muni_id=$3, postcode=$4, streetaxis_id=$5, postnumber=$6, 
        complement=$7, placement=$8, square=$9, observ=$10,
        text=$11, the_geom=$12 WHERE id=$1'
        USING NEW.id, NEW.plot_code, NEW.muni_id, NEW.postcode,NEW.streetaxis_id, NEW.postnumber, NEW.complement,
        NEW.placement, NEW.square, NEW.observ, NEW.text,NEW.the_geom;

      END IF;
    END IF;

  RETURN NEW;

  ELSIF TG_OP = 'DELETE' THEN     

    IF v_isutils IS FALSE OR v_isutils IS NULL THEN  
      DELETE FROM ext_plot WHERE id=OLD.id;
    ELSE
     EXECUTE 'DELETE FROM '||v_schema_utils||'.plot WHERE id=$1'
      USING OLD.id;
    END IF;

  RETURN NULL;

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;




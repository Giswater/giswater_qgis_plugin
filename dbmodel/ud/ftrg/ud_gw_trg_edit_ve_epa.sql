/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION NODE: 3136


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_ve_epa() 
RETURNS trigger AS 
$BODY$

DECLARE 
v_epatype varchar;


BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    v_epatype:= TG_ARGV[0];

   
    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN
        EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        "data":{"message":"1030", "function":"3136","debug_msg":null}}$$);';
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN

		IF v_epatype = 'junction' THEN
            UPDATE inp_junction 
            SET y0=NEW.y0, ysur=NEW.ysur, apond=NEW.apond, outfallparam = NEW.outfallparam::json
            WHERE node_id=OLD.node_id;
            
        ELSIF v_epatype = 'storage' THEN
            UPDATE inp_storage 
            SET storage_type=NEW.storage_type,curve_id=NEW.curve_id,a1=NEW.a1,a2=NEW.a2,a0=NEW.a0,fevap=NEW.fevap,sh=NEW.sh,hc=NEW.hc,imd=NEW.imd,y0=NEW.y0, ysur=NEW.ysur, apond=NEW.apond 
            WHERE node_id=OLD.node_id;
            
        ELSIF v_epatype = 'outfall' THEN          
            UPDATE inp_outfall 
            SET outfall_type=NEW.outfall_type,stage=NEW.stage,curve_id=NEW.curve_id,timser_id=NEW.timser_id,gate=NEW.gate 
            WHERE node_id=OLD.node_id;

        ELSIF v_epatype = 'conduit' THEN
            UPDATE inp_divider 
            SET divider_type=NEW.divider_type, arc_id=NEW.arc_id, curve_id=NEW.curve_id,qmin=NEW.qmin,ht=NEW.ht,cd=NEW.cd,y0=NEW.y0, ysur=NEW.ysur, apond=NEW.apond 
            WHERE node_id=OLD.node_id; 
        END IF;

		RETURN NEW;
        
    ELSIF TG_OP = 'DELETE' THEN
        EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        "data":{"message":"1032", "function":"3136","debug_msg":null}}$$);';
        RETURN NEW;
    
    END IF;
       
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;





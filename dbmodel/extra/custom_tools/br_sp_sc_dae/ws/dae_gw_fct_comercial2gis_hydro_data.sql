/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION gw_saa.gw_fct_comercial2gis_hydrometer_data()
  RETURNS void AS
$BODY$
DECLARE
rec_hydrometer record;
text_category_type varchar;
id_last varchar;
int_count integer;
rec_connec record;
text_sector varchar;
text_dma varchar;
text_hydrometer_category varchar;
counter integer;
int_new_hydrometer integer;
int_real_hydrometer integer;
int_old_hydrometer integer;

/*
EXT_RTC_HYDROMETER
hydrometer_id
code (iptu)
hydrometer_category (id from EXT_RTC_HYDROMETER_CATEGORY)

-- CONNEC
connec_id (iptu)
category_type  (observ from EXT_RTC_HYDROMETER_CATEGORY)

-- ext_urban_propierties
iptu

--EXT_RTC_HYDROMETER_CATEGORY
id
observ

*/

BEGIN

    SET search_path = "gw_saa", public;


-- AUDIT

-- Looking for parameters
SELECT count(*) INTO int_new_hydrometer FROM ext_rtc_hydrometer
WHERE hydrometer_id::integer NOT IN (SELECT hydrometer_id::integer FROM rtc_hydrometer);

SELECT count(*) INTO int_real_hydrometer FROM ext_rtc_hydrometer
JOIN ext_urban_propierties ON ext_urban_propierties.iptu=ext_rtc_hydrometer.code
WHERE hydrometer_id::integer NOT IN (SELECT hydrometer_id::integer FROM rtc_hydrometer);

SELECT count(*) INTO int_old_hydrometer FROM rtc_hydrometer
WHERE hydrometer_id::integer NOT IN (SELECT hydrometer_id::integer FROM ext_rtc_hydrometer);

-- Inserting on table
INSERT INTO daescs_comercial2gis_hydro_log (new_hydrometer,real_hydrometer,old_hydrometer,tstamp) 
VALUES (int_new_hydrometer,int_real_hydrometer,int_old_hydrometer,now());



-- INSERT NEW HYDROMETER (AND CONNEC IF NOT EXISTS)

FOR rec_hydrometer IN SELECT 
connec_id,
category_type,
connec.the_geom as c_the_geom,
ext_rtc_hydrometer.code,
ext_hydrometer_category.observ,
hydrometer_id,
hydrometer_category,
ext_urban_propierties.the_geom as v_the_geom
FROM ext_rtc_hydrometer 
JOIN connec ON connec.connec_id = ext_rtc_hydrometer.code 
JOIN ext_urban_propierties ON ext_urban_propierties.iptu=ext_rtc_hydrometer.code
JOIN ext_hydrometer_category ON ext_hydrometer_category.id=ext_rtc_hydrometer.hydrometer_category::text
WHERE hydrometer_id::integer NOT IN (SELECT hydrometer_id::integer FROM rtc_hydrometer)
LOOP
    IF rec_hydrometer.connec_id IS NULL THEN

        text_sector:= (SELECT sector_id FROM sector WHERE ST_DWithin(rec_hydrometer.v_the_geom.the_geom, sector.the_geom,0.001) LIMIT 1);
        text_dma:= (SELECT dma_id FROM dma WHERE ST_DWithin(rec_hydrometer.v_the_geom.the_geom, sector.the_geom,0.001) LIMIT 1);
        	
        INSERT INTO connec (connec_id, sector_id, dma_id, category_type, to_review, the_geom) 
        VALUES (rec_hydrometer.code, text_sector, text_dma, rec_hydrometer.observ, 'A VERIFICAR', st_centroid (rec_hydrometer.v_the_geom));
    END IF;

    UPDATE connec SET state='EM_SERVIÇO' WHERE connec_id=id_last;
    INSERT INTO rtc_hydrometer (hydrometer_id) VALUES (rec_hydrometer.hydrometer_id);
    INSERT INTO rtc_hydrometer_x_connec (hydrometer_id, connec_id) VALUES (rec_hydrometer.hydrometer_id, rec_hydrometer.connec_id);

    IF rec_hydrometer.observ <> rec_hydrometer.category_type THEN
        UPDATE connec SET category_type='MISTA' WHERE connec_id=rec_hydrometer.connec_id;
    END IF;

END LOOP;




-- DELETE OLD HYDROMETER AND UPDATE CONNEC OR DELETE CONNEC IF THERE IS NOT MORE HYDROMETERS ASSOCIATED WITH

FOR rec_hydrometer IN SELECT * FROM rtc_hydrometer 
WHERE hydrometer_id::integer NOT IN (SELECT hydrometer_id::integer FROM ext_rtc_hydrometer)
LOOP

    DELETE FROM rtc_hydrometer WHERE hydrometer_id=rec_hydrometer.hydrometer_id;
    DELETE FROM rtc_hydrometer_x_connec WHERE hydrometer_id=rec_hydrometer.hydrometer_id RETURNING connec_id INTO id_last;

    IF id_last NOT IN (SELECT connec_id FROM rtc_hydrometer_x_connec) THEN
        UPDATE connec SET state='DESATIVADO' WHERE connec_id=id_last;
    ELSE
        counter=0;
        FOR rec_connec IN SELECT * FROM rtc_hydrometer_x_connec WHERE connec_id=id_last
        LOOP
            SELECT observ INTO text_hydrometer_category FROM ext_rtc_hydrometer 
            JOIN ext_hydrometer_category ON ext_hydrometer_category.id=ext_rtc_hydrometer.hydrometer_category;
            counter=counter+1;
            IF counter=1 THEN
                rec_connec.category_type=text_hydrometer_category;
            ELSE
		    IF rec_connec.category_type <> text_hydrometer_category THEN
                      rec_connec.category_type='MISTA';
                    END IF;
            END IF;
        END LOOP;
        UPDATE connec SET category_type= rec_connec.category_type;
	
    END IF;
END LOOP;

    RETURN;
            
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
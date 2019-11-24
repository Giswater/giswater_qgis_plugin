/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--22/11/2019
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_curve_id", "column":"isdoublen2a", "dataType":"boolean"}}$$);


--23/11/2019
CREATE TABLE inp_virtualvalve(
  arc_id character varying(16) NOT NULL,
  valv_type character varying(18),
  pressure numeric(12,4),
  diameter numeric(12,4),
  flow numeric(12,4),
  coef_loss numeric(12,4),
  curve_id character varying(16),
  minorloss numeric(12,4),
  status character varying(12),
  to_arc character varying(16),
  CONSTRAINT inp_virtualvalve_pkey PRIMARY KEY (arc_id),
  CONSTRAINT inp_virtualvalve_curve_id_fkey FOREIGN KEY (arc_id)
      REFERENCES inp_curve_id (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_virtualvalve_arc_id_fkey FOREIGN KEY (arc_id)
      REFERENCES arc (arc_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_virtualvalve_to_arc_fkey FOREIGN KEY (to_arc)
      REFERENCES arc (arc_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT inp_virtualvalve_status_check CHECK (status::text = ANY (ARRAY['ACTIVE'::character varying, 'CLOSED'::character varying, 'OPEN'::character varying]::text[])),
  CONSTRAINT inp_virtualvalve_valv_type_check CHECK (valv_type::text = ANY (ARRAY['FCV'::character varying, 'GPV'::character varying, 'PBV'::character varying, 
  'PRV'::character varying, 'PSV'::character varying, 'TCV'::character varying]::text[])));

  
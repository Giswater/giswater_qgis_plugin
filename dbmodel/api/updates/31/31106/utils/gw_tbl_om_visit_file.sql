

CREATE TABLE ws_sample.om_visit_file
(
  id bigserial NOT NULL,
  visit_id bigint NOT NULL,
  tstamp timestamp(6) without time zone DEFAULT now(),
  value text,
  text text,
  compass double precision,
  CONSTRAINT om_visit_file_pkey PRIMARY KEY (id),
  CONSTRAINT om_visit_file_visit_id_fkey FOREIGN KEY (visit_id)
      REFERENCES ws_sample.om_visit (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
);
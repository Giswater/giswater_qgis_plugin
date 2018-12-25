CREATE TABLE SCHEMA_NAME.selector_lot
(
  id serial PRIMARY KEY ,
  lot_id integer,
  cur_user text,
  CONSTRAINT selector_workcat_workcat_id_fkey FOREIGN KEY (lot_id)
      REFERENCES SCHEMA_NAME.om_visit_lot (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT selector_lot_lot_id_cur_user_unique UNIQUE (lot_id, cur_user)
);
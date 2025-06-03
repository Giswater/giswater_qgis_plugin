/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

-- Create tables and views related with cat_feature
DO $$
DECLARE
  parent_s   CONSTANT text := 'PARENT_SCHEMA';
  new_s      CONSTANT text := 'SCHEMA_NAME';
  rec        RECORD;
  tbl_name   text;
  view_name  text;
  feature_col text;
  constraint_name text;
BEGIN

  -- Create one empty table per feature, cloning structure of the view/table
    FOR rec IN
    SELECT id, child_layer, feature_type
      FROM   PARENT_SCHEMA.cat_feature
    LOOP
    tbl_name := format('%I.%I_%s',
                       new_s,
                       parent_s,
                       lower(rec.id));
    feature_col := lower(rec.feature_type) || '_id';
    constraint_name := tbl_name || '_pkey';

    EXECUTE format(
      'CREATE TABLE IF NOT EXISTS %s (
           lot_id integer,
           LIKE %I.%I INCLUDING ALL);',
      tbl_name,
      parent_s, rec.child_layer
    );

    EXECUTE format(
      'ALTER TABLE %s ADD CONSTRAINT %I PRIMARY KEY (lot_id, %I);',
      tbl_name, constraint_name, feature_col
    );
    END LOOP;

  -- Create corresponding empty views named ve_<PARENT>_lot_<feature_id>
    FOR rec IN
    SELECT id
      FROM   PARENT_SCHEMA.cat_feature
    LOOP
    view_name := format('%I.ve_%s_lot_%s',
                        new_s,
                        parent_s,
                        lower(rec.id));

    tbl_name := format('%I.%I_%s',
                       new_s,
                       parent_s,
                       lower(rec.id));

    IF NOT EXISTS (
    SELECT 1
    FROM information_schema.views
    WHERE table_schema = new_s
      AND table_name = lower(format('ve_%s_lot_%s', parent_s, rec.id))
    ) THEN
        EXECUTE format(
          'CREATE VIEW %s AS
             SELECT * FROM %s
             join selector_lot sl using (lot_id)
             WHERE sl.cur_user = current_user;',
          view_name,
          tbl_name
        );
    END IF;

    END LOOP;

END
$$;

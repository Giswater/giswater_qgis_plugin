/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = cm, public, pg_catalog;

-- Create tables and views related with cat_feature
DO $$

DECLARE

  parent_s CONSTANT text := 'PARENT_SCHEMA';
  new_s CONSTANT text := 'cm';
  rec RECORD;
  tbl_name text;
  view_name text;
  feature_col text;
  constraint_name text;
  v_cols text;
  v_cols_no_lot text;

BEGIN

  -- Create one empty table per feature, cloning structure of the view/table
    FOR rec IN
      SELECT id, child_layer, feature_type FROM PARENT_SCHEMA.cat_feature
    LOOP

      tbl_name := format('%I_%s', parent_s, lower(rec.id));
      feature_col := lower(rec.feature_type) || '_id';
      constraint_name := tbl_name || '_uq';

      EXECUTE format(
        'CREATE TABLE IF NOT EXISTS %s (
            id serial4 primary key,
            lot_id integer,
            LIKE %I.%I);',
      tbl_name,
      parent_s, rec.child_layer
      );

      EXECUTE format('ALTER TABLE %s ADD CONSTRAINT %I UNIQUE (lot_id,%I);', tbl_name, constraint_name, feature_col);

      EXECUTE format('ALTER TABLE %s ADD CONSTRAINT %I FOREIGN KEY (lot_id) REFERENCES om_campaign_lot (lot_id) ON UPDATE CASCADE ON DELETE CASCADE;',
        tbl_name,
        tbl_name || '_lot_id_fkey'
      );

      EXECUTE format('GRANT ALL ON TABLE %s TO role_cm_field', tbl_name);

    END LOOP;

  -- Create corresponding empty views named ve_<PARENT>_lot_<feature_id>
    FOR rec IN
      SELECT id, feature_type FROM PARENT_SCHEMA.cat_feature WHERE feature_type <> 'ELEMENT'
    LOOP

      view_name := format('ve_%s_lot_%s', parent_s, lower(rec.id));
      tbl_name := format('%I_%s', parent_s, lower(rec.id));

      -- Get columns for dynamic view creation (excluding id, lot_id and the_geom)
      SELECT array_to_string(array_agg('a.' || column_name ORDER BY ordinal_position), ', ')
      INTO v_cols_no_lot
      FROM information_schema.columns
      WHERE table_schema = 'cm'
        AND table_name = lower(tbl_name)
        AND column_name NOT IN ('id','lot_id','the_geom');

      EXECUTE format(
        'CREATE OR REPLACE VIEW %s AS
          WITH sel_lot AS (
              SELECT selector_lot.lot_id FROM selector_lot
              WHERE selector_lot.cur_user = current_user
          )
          SELECT a.id, c.campaign_id, a.lot_id, %s b.status, c.the_geom
          FROM %s a
          LEFT JOIN om_campaign_lot ocl ON a.lot_id = ocl.lot_id
          LEFT JOIN om_campaign_lot_x_%s b ON a.lot_id = b.lot_id AND a.%s_id = b.%s_id
          LEFT JOIN om_campaign_x_%s c ON ocl.campaign_id = c.campaign_id AND a.%s_id = c.%s_id
          WHERE EXISTS (
            SELECT 1 
            FROM sel_lot 
            WHERE sel_lot.lot_id = a.lot_id
        );',
      view_name,
      CASE WHEN v_cols_no_lot IS NULL THEN '' ELSE v_cols_no_lot || ', ' END,
      tbl_name,
      lower(rec.feature_type),
      lower(rec.feature_type),
      lower(rec.feature_type),
      lower(rec.feature_type),
      lower(rec.feature_type)
      );

      EXECUTE format('GRANT ALL ON TABLE %s TO role_cm_field', view_name);
      EXECUTE format('GRANT ALL ON TABLE %s TO role_cm_manager', view_name);

    END LOOP;

END
$$;

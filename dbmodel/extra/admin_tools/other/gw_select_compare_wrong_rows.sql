SELECT row_number() OVER (ORDER BY id) AS rid,
    id,
    v_audit_schema_foreign_table.table_name
   FROM ws_data.audit_cat_table
     LEFT JOIN ws_data.v_audit_schema_foreign_table ON v_audit_schema_foreign_table.table_name::text = id
  WHERE v_audit_schema_foreign_table.table_name IS NULL

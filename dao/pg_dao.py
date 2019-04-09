from __future__ import print_function

# -*- coding: utf-8 -*-
try:
    from qgis.core import Qgis
except ImportError:
    from qgis.core import QGis as Qgis

if Qgis.QGIS_VERSION_INT < 29900:
    pass
else:
    from builtins import object

import psycopg2         #@UnusedImport
import psycopg2.extras


class PgDao(object):

    def __init__(self):
        self.last_error = None
        
        
    def init_db(self):
        """ Initializes database connection """

        try:
            self.conn = psycopg2.connect(self.conn_string)
            self.cursor = self.conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
            status = True
        except psycopg2.DatabaseError as e:
            # fix_print_with_import
            print('{pg_dao} Error %s' % e)
            self.last_error = e            
            status = False
        return status

    
    def close_db(self):
        """ Close database connection """
        
        try:
            status = True
            if self.cursor:
                self.cursor.close()
            if self.conn:
                self.conn.close()
            del self.cursor
            del self.conn
        except Exception as e:
            self.last_error = e            
            status = False
            
        return status
        

    def get_conn_encoding(self):
        return self.conn.encoding


    def set_params(self, host, port, dbname, user, password):
        """ Set database parameters """

        self.host = host
        self.port = port
        self.dbname = dbname
        self.user = user
        self.password = password
        self.conn_string = "host="+self.host+" port="+self.port
        self.conn_string += " dbname="+self.dbname+" user="+self.user
        if self.password is not None:
            self.conn_string += " password="+self.password
        
        
    def mogrify(self, sql, params):
        """ Return a query string after arguments binding """

        query = sql
        try:
            query = self.cursor.mogrify(sql, params)
        except Exception as e:
            self.last_error = e
            print(str(e))
        finally:
            return query

        
    def get_rows(self, sql, commit=False):
        """ Get multiple rows from selected query """

        self.last_error = None
        rows = None
        try:
            self.cursor.execute(sql)
            rows = self.cursor.fetchall()     
            if commit:
                self.commit()             
        except Exception as e:
            self.last_error = e
            if commit:
                self.rollback()
        finally:
            return rows
    
    
    def get_row(self, sql, commit=False):
        """ Get single row from selected query """

        self.last_error = None
        row = None
        try:
            self.cursor.execute(sql)
            row = self.cursor.fetchone()
            if commit:
                self.commit()
        except Exception as e:
            self.last_error = e
            if commit:
                self.rollback()
        finally:
            return row


    def get_column_name(self, index):
        """ Get column name of selected index """

        name = None
        try:
            name = self.cursor.description[index][0]
        except Exception as e:
            # fix_print_with_import
            print("get_column_name: {0}".format(e))        
        finally:
            return name
        
        
    def get_columns_length(self):
        """ Get number of columns of current query """

        total = None
        try:
            total = len(self.cursor.description)
        except Exception as e:
            # fix_print_with_import
            print("get_columns_length: {0}".format(e))        
        finally:
            return total


    def execute_sql(self, sql, commit=True):
        """ Execute selected query """

        self.last_error = None         
        status = True
        try:
            self.cursor.execute(sql) 
            if commit:
                self.commit()
        except Exception as e: 
            self.last_error = e               
            status = False
            if commit:
                self.rollback() 
        finally:
            return status 


    def execute_returning(self, sql, autocommit=True):
        """ Execute selected query and return RETURNING field """

        self.last_error = None
        value = None
        try:
            self.cursor.execute(sql)
            value = self.cursor.fetchone()
            if autocommit:
                self.commit()
        except Exception as e:
            self.last_error = e
            self.rollback()
        finally:
            return value


    def get_rowcount(self):       
        """ Returns number of rows of current query """         
        return self.cursor.rowcount      
 
 
    def commit(self):
        """ Commit current database transaction """
        self.conn.commit()
        
        
    def rollback(self):
        """ Rollback current database transaction """
        self.conn.rollback()
        
        
    def check_schema(self, schemaname):
        """ Check if selected schema exists """

        exists = True
        schemaname = schemaname.replace('"', '')        
        sql = "SELECT nspname FROM pg_namespace WHERE nspname = '" + schemaname + "'";
        self.cursor.execute(sql)         
        if self.cursor.rowcount == 0:      
            exists = False
        return exists    
    
    
    def check_table(self, schemaname, tablename):
        """ Check if selected table exists in selected schema """

        exists = True
        schemaname = schemaname.replace('"', '')         
        sql = ("SELECT * FROM pg_tables"
               " WHERE schemaname = '" + schemaname + "' AND tablename = '" + tablename + "'")
        self.cursor.execute(sql)         
        if self.cursor.rowcount == 0:      
            exists = False
        return exists         
    
    
    def check_view(self, schemaname, viewname):
        """ Check if selected view exists in selected schema """

        exists = True
        schemaname = schemaname.replace('"', '') 
        sql = ("SELECT * FROM pg_views"
               " WHERE schemaname = '"+schemaname+"' AND viewname = '" + viewname + "'")
        self.cursor.execute(sql)         
        if self.cursor.rowcount == 0:      
            exists = False
        return exists                    
    
    
    def check_column(self, schemaname, tablename, columname):
        """ Check if @columname exists table @schemaname.@tablename """

        exists = True
        schemaname = schemaname.replace('"', '') 
        sql = ("SELECT * FROM information_schema.columns"
               " WHERE table_schema = '" + schemaname + "' AND table_name = '" + tablename + "'"
               " AND column_name = '" + columname + "'")    
        self.cursor.execute(sql)         
        if self.cursor.rowcount == 0:      
            exists = False
        return exists                    


    def copy_expert(self, sql, csv_file):
        """ Dumps contents of the query to selected CSV file """

        try:
            self.cursor.copy_expert(sql, csv_file)
            return None
        except Exception as e:
            return e   
        
        
    def get_srid(self, schema_name, table_name):
        """ Find SRID of selected schema """
        
        srid = None
        schema_name = schema_name.replace('"', '')        
        sql = "SELECT Find_SRID('"+schema_name+"', '"+table_name+"', 'the_geom');"
        row = self.get_row(sql)
        if row:
            srid = row[0]   
            
        return srid        


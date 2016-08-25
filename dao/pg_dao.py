# -*- coding: utf-8 -*-
import psycopg2         #@UnusedImport
import psycopg2.extras


class PgDao():

    def __init__(self):
        self.last_error = None
        
        
    def init_db(self):
        try:
            self.conn = psycopg2.connect(self.conn_string)
            self.cursor = self.conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
            status = True
        except psycopg2.DatabaseError, e:
            print '{pg_dao} Error %s' % e
            self.last_error = e            
            status = False
        return status


    def set_params(self, host, port, dbname, user, password):
        self.host = host
        self.port = port
        self.dbname = dbname
        self.user = user
        self.password = password
        self.conn_string = "host="+self.host+" port="+self.port+" dbname="+self.dbname+" user="+self.user+" password="+self.password       
        
        
    def get_rows(self, sql):
        
        self.last_error = None           
        rows = None
        try:
            self.cursor.execute(sql)
            rows = self.cursor.fetchall()     
        except Exception as e:
            print "get_rows: {0}".format(e)
            self.last_error = e               
            self.rollback()             
        finally:
            return rows            
    
    
    def get_row(self, sql):
        
        self.last_error = None           
        row = None
        try:
            self.cursor.execute(sql)
            row = self.cursor.fetchone()
        except Exception as e:
            print "get_row: {0}".format(e)
            self.last_error = e               
            self.rollback()             
        finally:
            return row     
        
        
    def get_column_name(self, index):
        
        name = None
        try:
            name = self.cursor.description[index][0]
        except Exception as e:
            print "get_column_name: {0}".format(e)        
        finally:
            return name
        
        
    def get_columns_length(self):
        
        total = None
        try:
            total = len(self.cursor.description)
        except Exception as e:
            print "get_columns_length: {0}".format(e)        
        finally:
            return total


    def execute_sql(self, sql, autocommit=True):
        
        self.last_error = None         
        status = True
        try:
            self.cursor.execute(sql) 
            self.commit()
        except Exception as e:
            print "execute_sql: {0}".format(e)   
            self.last_error = e               
            status = False
            self.rollback() 
        finally:
            return status 


    def get_rowcount(self):        
        return self.cursor.rowcount      
 
 
    def commit(self):
        self.conn.commit()
        
        
    def rollback(self):
        self.conn.rollback()
        
        
    def check_schema(self, schemaName):
        
        exists = True
        sql = "SELECT schema_name FROM information_schema.schemata WHERE schema_name = '"+schemaName+"'"    
        self.cursor.execute(sql)         
        if self.cursor.rowcount == 0:      
            exists = False
        return exists         
    
    
    def check_table(self, schemaName, tableName):
        
        exists = True
        sql = "SELECT * FROM pg_tables WHERE schemaname = '"+schemaName+"' AND tablename = '"+tableName+"'"    
        self.cursor.execute(sql)         
        if self.cursor.rowcount == 0:      
            exists = False
        return exists         
    
    
    def check_view(self, schemaName, viewName):
        
        exists = True
        sql = "SELECT * FROM pg_views WHERE schemaname = '"+schemaName+"' AND viewname = '"+viewName+"'"    
        self.cursor.execute(sql)         
        if self.cursor.rowcount == 0:      
            exists = False
        return exists                    


    def copy_expert(self, sql, csv_file):
        
        try:
            self.cursor.copy_expert(sql, csv_file)
            return None
        except Exception as e:
            return e        
        

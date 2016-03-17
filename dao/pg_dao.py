# -*- coding: utf-8 -*-
#import logging
import psycopg2
import psycopg2.extras


class PgDao():

    def __init__(self):
        #self.logger = logging.getLogger('dbsync') 
        pass

    def get_host(self):
        return self.host
    
    def init_db(self):
        try:
            self.conn = psycopg2.connect(self.conn_string)
            self.cursor = self.conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
            status = True
        except psycopg2.DatabaseError, e:
            #self.logger.warning('{pg_dao} Error %s' % e)
            print '{pg_dao} Error %s' % e
            status = False
        return status

    def set_params(self, host, port, dbname, user, password):
        self.host = host
        self.port = port
        self.dbname = dbname
        self.user = user
        self.password = password
        self.conn_string = "host="+self.host+" port="+self.port+" dbname="+self.dbname+" user="+self.user+" password="+self.password

    def set_schema_name(self, schema_name):
        self.schema_name = schema_name
        
    def get_schema_name(self):
        return self.schema_name        
        
    def get_rows(self, sql):
        self.cursor.execute(sql)
        rows = self.cursor.fetchall()              
        return rows
    
    def get_row(self, sql):
        row = None
        try:
            self.cursor.execute(sql)
            row = self.cursor.fetchone()
        except Exception as e:
            print "get_row: {0}".format(e)
            self.rollback()             
        finally:
            return row            

    def execute_sql(self, sql, autocommit=True):
        status = True
        try:
            self.cursor.execute(sql) 
            self.commit()
        except Exception as e:
            print "execute_sql: {0}".format(e)      
            status = False
            self.rollback() 
        finally:
            return status

    def commit(self):
        self.conn.commit()
        
    def rollback(self):
        self.conn.rollback()
        
    def checkTable(self, schemaName, tableName):
        exists = True
        sql = "SELECT * FROM pg_tables WHERE schemaname = '"+schemaName+"' AND tablename = '"+tableName+"'"    
        self.cursor.execute(sql)         
        if self.cursor.rowcount == 0:      
            exists = False
        return exists             


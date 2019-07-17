"""
This file is part of Giswater 3.1
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import psycopg2
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
            self.last_error = e
            print("get_column_name: {0}".format(e))        
        finally:
            return name
        
        
    def get_columns_length(self):
        """ Get number of columns of current query """

        total = None
        try:
            total = len(self.cursor.description)
        except Exception as e:
            self.last_error = e
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


    def execute_returning(self, sql, commit=True):
        """ Execute selected query and return RETURNING field """

        self.last_error = None
        value = None
        try:
            self.cursor.execute(sql)
            value = self.cursor.fetchone()
            if commit:
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
        
        
    def copy_expert(self, sql, csv_file):
        """ Dumps contents of the query to selected CSV file """

        try:
            self.cursor.copy_expert(sql, csv_file)
            return None
        except Exception as e:
            return e   
        
        
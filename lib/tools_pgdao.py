"""
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
"""
# -*- coding: utf-8 -*-
import psycopg2
import psycopg2.extras


class GwPgDao(object):

    def __init__(self):

        self.last_error = None
        self.set_search_path = None
        self.conn = None
        self.cursor = None
        self.pid = None


    def init_db(self):
        """ Initializes database connection """

        try:
            self.conn = psycopg2.connect(self.conn_string)
            self.cursor = self.get_cursor()
            self.pid = self.conn.get_backend_pid()
            status = True
        except psycopg2.DatabaseError as e:
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


    def get_cursor(self, aux_conn=None):

        if aux_conn:
            cursor = aux_conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        else:
            cursor = self.conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        return cursor


    def reset_db(self):
        """ Reset database connection """

        if self.init_db():
            if self.set_search_path:
                self.execute_sql(self.set_search_path)


    def check_cursor(self):
        """ Check if cursor is closed """

        status = True
        if self.cursor.closed:
            self.reset_db()
            status = not self.cursor.closed

        return status


    def cursor_execute(self, sql):
        """ Check if cursor is closed before execution """

        if self.check_cursor():
            self.cursor.execute(sql)


    def get_poll(self):
        """ Check if the connection is established """

        status = True
        try:
            if self.check_cursor():
                self.conn.poll()
        except psycopg2.InterfaceError:
            self.reset_db()
            status = False
        except psycopg2.OperationalError:
            self.reset_db()
            status = False
        finally:
            return status


    def set_params(self, host, port, dbname, user, password, sslmode):
        """ Set database parameters """

        self.host = host
        self.port = port
        self.dbname = dbname
        self.user = user
        self.password = password
        self.conn_string = f"host={self.host} port={self.port} dbname={self.dbname} user='{self.user}'"
        if sslmode:
            self.conn_string += f" sslmode={sslmode}"
        if self.password is not None:
            self.conn_string += f" password={self.password}"


    def set_conn_string(self, conn_string):
        """ Set connection string """
        self.conn_string = conn_string


    def set_service(self, service, sslmode=None):
        """ Set service """
        self.conn_string = f"service={service}"
        if sslmode:
            self.conn_string += f" sslmode={sslmode}"


    def mogrify(self, sql, params):
        """ Return a query string after arguments binding """

        query = sql
        try:
            cursor = self.get_cursor()
            query = cursor.mogrify(sql, params)
        except Exception as e:
            self.last_error = e
        finally:
            return query


    def get_rows(self, sql, commit=False):
        """ Get multiple rows from selected query """

        self.last_error = None
        rows = None
        try:
            cursor = self.get_cursor()
            cursor.execute(sql)
            rows = cursor.fetchall()
            if commit:
                self.commit()
        except Exception as e:
            self.last_error = e
            if commit:
                self.rollback()
        finally:
            return rows


    def get_row(self, sql, commit=False, aux_conn=None):
        """ Get single row from selected query """

        self.last_error = None
        row = None
        try:
            if aux_conn is not None:
                cursor = self.get_cursor(aux_conn)
                cursor.execute(sql)
                row = cursor.fetchone()
            else:
                self.cursor_execute(sql)
                row = self.cursor.fetchone()
            if commit:
                self.commit(aux_conn)
        except Exception as e:
            self.last_error = e
            if commit:
                self.rollback(aux_conn)
        finally:
            return row


    def execute_sql(self, sql, commit=True):
        """ Execute selected query """

        self.last_error = None
        status = True
        try:
            cursor = self.get_cursor()
            cursor.execute(sql)
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
            cursor = self.get_cursor()
            cursor.execute(sql)
            value = cursor.fetchone()
            if commit:
                self.commit()
        except Exception as e:
            self.last_error = e
            self.rollback()
        finally:
            return value


    def commit(self, aux_conn=None):
        """ Commit current database transaction """

        try:
            if aux_conn is not None:
                aux_conn.commit()
                return
            self.conn.commit()
        except Exception:
            pass


    def rollback(self, aux_conn=None):
        """ Rollback current database transaction """

        try:
            if aux_conn is not None:
                aux_conn.rollback()
                return
            self.conn.rollback()
        except Exception:
            pass


    def export_to_csv(self, sql, csv_file):
        """ Dumps contents of the query to selected CSV file """

        try:
            cursor = self.get_cursor()
            cursor.export_to_csv(sql, csv_file)
            return None
        except Exception as e:
            return e


    def cancel_pid(self, pid):
        """ Cancel one process by pid """

        # Create an auxiliary connection with the intention of being able to cancel processes of the main connection
        last_error = None
        try:
            aux_conn = psycopg2.connect(self.conn_string)
            cursor = self.get_cursor(aux_conn)
            cursor.execute(f"SELECT pg_cancel_backend({pid})")
            status = True
            cursor.close()
            aux_conn.close()
            del cursor
            del aux_conn
        except Exception as e:
            last_error = e
            status = False

        return {'status': status, 'last_error': last_error}


    def get_aux_conn(self):

        try:
            aux_conn = psycopg2.connect(self.conn_string)
            cursor = self.get_cursor(aux_conn)
            if self.set_search_path:
                cursor.execute(self.set_search_path)
            return aux_conn
        except Exception as e:
            last_error = e
            status = False

        return {'status': status, 'last_error': last_error}


    def delete_aux_con(self, aux_conn):

        try:
            aux_conn.close()
            del aux_conn
            return
        except Exception as e:
            last_error = e
            status = False
        return {'status': status, 'last_error': last_error}

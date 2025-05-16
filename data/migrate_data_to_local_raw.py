import psycopg2
import os
from dotenv import load_dotenv

load_dotenv()

Dlytica_postgres = {
    'host': os.getenv('dlytica_host'),
    'port' : os.getenv('dlytica_port'),
    'dbname' : os.getenv('dlytica_dbname'),
    'user': os.getenv('dlytica_user'),
    'password' : os.getenv('dlytica_pass')
}

local_postgres = {
    'host': os.getenv('local_host'),
    'port' : os.getenv('local_port'),
    'dbname' : os.getenv('local_dbname'),
    'user': os.getenv('local_user'),
    'password' : os.getenv('local_pass')
}


def create_schema():
    conn = psycopg2.connect(**local_postgres)
    print("Connected to DB:", conn.get_dsn_parameters()['dbname']) 
    cursor = conn.cursor()

    cursor.execute("CREATE SCHEMA IF NOT EXISTS raw;")
    cursor.execute("CREATE SCHEMA IF NOT EXISTS staging;")
    print("Schemas created succesfully")

    conn.commit()
    cursor.close()
    conn.close()

def main():
    create_schema()
    

if __name__ == '__main__':
    main()
import psycopg2
import os
from dotenv import load_dotenv
from sqlalchemy import create_engine, text
import pandas as pd
from urllib.parse import quote_plus

load_dotenv()

password = quote_plus(os.getenv('local_pass'))

dlytica_postgres_url = f"postgresql://{os.getenv('dlytica_user')}:{os.getenv('dlytica_pass')}@{os.getenv('dlytica_host')}:{os.getenv('dlytica_port')}/{os.getenv('dlytica_dbname')}"
local_postgres_url = f"postgresql://{os.getenv('local_user')}:{password}@{os.getenv('local_host')}:{os.getenv('local_port')}/{os.getenv('local_dbname')}"

tables = ['transaction', 'account', 'customer', 'cards', 'product']


def fetch_and_load_sql_table():
    local_engine = create_engine(local_postgres_url)

    with local_engine.begin() as conn:
        conn.execute(text("CREATE SCHEMA IF NOT EXISTS raw;"))
        conn.execute(text("CREATE SCHEMA IF NOT EXISTS staging;"))
        print("Schemas created succesfully")

    dlytica_engine = create_engine(dlytica_postgres_url)

    for table in tables:
        df = pd.read_sql_table(table,dlytica_engine)

        df.to_sql(table,
                con=local_engine,
                schema='raw',
                if_exists='replace',
                index=False)
        print(f"Data of table:{table} migrated")


if __name__ == '__main__':
    fetch_and_load_sql_table()
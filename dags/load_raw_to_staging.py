from airflow import DAG
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
# from airflow.providers.postgres.operators.postgres import PostgresOperator
from datetime import datetime, timedelta


tables = ['transaction', 'account', 'customer', 'cards', 'product']

default_args = {
    'owner':'airflow',
    'start_date':datetime(2025,5,17),
    'depends_on_past':False,
    'retries':2,
    'retry_delay':timedelta(minutes=1),
    'catchup':False
}

dag =  DAG(
    dag_id='load_raw_to_staging',
    default_args=default_args,
    schedule='@daily',
    description='Load tables from raw to staging',
    tags=['postgres','etl','raw','staging']
)

for table in tables:

    create_table = SQLExecuteQueryOperator(
        task_id=f"create_{table}_staging",
        conn_id='banking_data_postgres',
        sql=f"""
            RAISE NOTICE 'Creating staging.{table}...';
            DROP TABLE IF EXISTS staging.{table};
            CREATE TABLE staging.{table}
            (LIKE raw.{table} INCLUDING ALL);
        """,
        dag=dag
    )

    load_table = SQLExecuteQueryOperator(
        task_id=f"load_{table}_staging",
        conn_id='banking_data_postgres',
        sql=f"""
            RAISE NOTICE 'Loading data from raw.{table} to staging.{table}...';
            INSERT INTO staging.{table}
            SELECT * FROM raw.{table};
        """,
        dag=dag
    )

    create_table >> load_table
from airflow import DAG
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from datetime import datetime, timedelta
from airflow.providers.standard.operators.bash import BashOperator


tables = ['transaction', 'account', 'customer', 'cards', 'product']

DBT_PROJ_DIR = "/opt/banking_data_dbt/"

default_args = {
    'owner':'airflow',
    'start_date':datetime(2025,5,17),
    'depends_on_past':False,
    'retries':2,
    'retry_delay':timedelta(minutes=1),
    'catchup':False
}

dag =  DAG(
    dag_id='banking_data_pipeline',
    default_args=default_args,
    schedule='@daily',
    description='Pipeline to ingest & transform',
    tags=['postgres','etl','raw','staging','dbt']
)

data_ingest_tasks = []

for table in tables:

    create_table = SQLExecuteQueryOperator(
        task_id=f"create_{table}_staging",
        conn_id='banking_data_postgres',
        sql=f"""
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
            INSERT INTO staging.{table}
            SELECT * FROM raw.{table};
        """,
        dag=dag
    )

    create_table >> load_table
    data_ingest_tasks.append(load_table)

dbt_run_staging = BashOperator(
    task_id='dbt_run_stag_models',
    bash_command=f'cd {DBT_PROJ_DIR} && dbt run -s staging',
    dag=dag,
)

dbt_run_intermedtiate = BashOperator(
    task_id='dbt_run_intermedtiate_models',
    bash_command=f'cd {DBT_PROJ_DIR} && dbt run -s intermeditate',
    dag=dag,
)

dbt_run_final_marts = BashOperator(
    task_id='dbt_run_final_marts_models',
    bash_command=f'cd {DBT_PROJ_DIR} && dbt run -s final_marts',
    dag=dag,
)

data_ingest_tasks >> dbt_run_staging >> dbt_run_intermedtiate >> dbt_run_final_marts
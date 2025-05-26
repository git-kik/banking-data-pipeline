FROM apache/airflow:3.0.1-python3.10

COPY requirements.txt .

RUN pip install --no-cache-dir --quiet -r requirements.txt  


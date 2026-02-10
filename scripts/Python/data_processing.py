import pandas as pd
from sqlalchemy import create_engine
import os
from dotenv import load_dotenv

load_dotenv()

db_user = os.getenv('DB_USER')
db_password = os.getenv('DB_PASSWORD')
db_host = os.getenv('DB_HOST')
db_port = os.getenv('DB_PORT')
db_name = os.getenv('DB_NAME')

db_url = f'postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}'
data_folder = 'datasets' 

def clean_dataframe(df): #функція для обробки данних
    df.columns = df.columns.str.lower().str.replace(' ', '_').str.strip() #преведення в нижній регістр, без пробілів
    df = df.drop_duplicates() #видалення дублікатів
    time_keywords = ['timestamp', 'date'] # всі назви колонок з цими частками міняють тип значень на timestap
    time_related_cols = [
        col for col in df.columns 
        if any(key in col for key in time_keywords)
    ]
    for col in time_related_cols:
        df[col] = pd.to_datetime(df[col], errors='raise')
    return df

engine = create_engine(db_url) #керування зєднанням
files = [f for f in os.listdir(data_folder) if f.endswith('.csv')] #список всіх файлів з роширенням .csv
for file_name in files: 
    file_path = os.path.join(data_folder, file_name) #формуємо підключення
    df = pd.read_csv(file_path)
    df = clean_dataframe(df)
    table_name = file_name.replace('.csv', '').replace('olist_', '').replace('_dataset', '') #форматуємо назви таблиць
    df.to_sql(table_name, con=engine, if_exists='replace', index=False, method='multi') #записуємо в sql
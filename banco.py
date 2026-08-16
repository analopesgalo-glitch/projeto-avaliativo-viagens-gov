import os
import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT
from sqlalchemy import create_engine
from config import (
    DATABASE_URL,
    DB_HOST,
    DB_PORT,
    DB_NAME,
    DB_USER,
    DB_PASSWORD
)

# Força o driver do PostgreSQL a responder em UTF-8 no Windows
os.environ["PGCLIENTENCODING"] = "utf-8"

def criar_banco_se_nao_existir():
    """Conecta ao PostgreSQL e cria o banco 'viagens_gov' automaticamente caso nao exista."""
    try:
        conexao = psycopg2.connect(
            host=DB_HOST,
            port=DB_PORT,
            user=DB_USER,
            password=DB_PASSWORD,
            dbname="postgres"
        )
        conexao.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
        cursor = conexao.cursor()

        cursor.execute(f"SELECT 1 FROM pg_catalog.pg_database WHERE datname = '{DB_NAME}';")
        existe = cursor.fetchone()

        if not existe:
            cursor.execute(f"CREATE DATABASE {DB_NAME};")
            print(f"Banco de dados '{DB_NAME}' criado com sucesso!")
        else:
            print(f"Banco de dados '{DB_NAME}' ja existe.")

        cursor.close()
        conexao.close()
    except Exception as e:
        msg = str(e).encode("utf-8", errors="replace").decode("utf-8", errors="replace")
        print(f"Aviso ao verificar banco: {msg}")

def get_engine():
    """Retorna a engine do SQLAlchemy para conexão com o banco do projeto."""
    return create_engine(DATABASE_URL)

def testar_conexao():
    """Valida a conexão com o banco do projeto."""
    criar_banco_se_nao_existir()
    
    try:
        engine = get_engine()
        with engine.connect() as conexao:
            print(f"Conexao com o banco '{DB_NAME}' realizada com sucesso via SQLAlchemy!")
    except Exception as e:
        msg = str(e).encode("utf-8", errors="replace").decode("utf-8", errors="replace")
        print(f"Erro ao conectar ao banco '{DB_NAME}': {msg}")

if __name__ == "__main__":
    testar_conexao()
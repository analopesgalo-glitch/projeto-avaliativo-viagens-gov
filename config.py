import os
from urllib.parse import quote_plus
from dotenv import load_dotenv

# Carrega as variáveis garantindo a codificação UTF-8
load_dotenv(encoding="utf-8")

# Configurações do Banco de Dados PostgreSQL
DB_HOST = os.getenv("DB_HOST", "localhost")
DB_PORT = os.getenv("DB_PORT", "5432")
DB_NAME = os.getenv("DB_NAME", "viagens_gov")
DB_USER = os.getenv("DB_USER", "postgres")
DB_PASSWORD = os.getenv("DB_PASSWORD", "")

# Codifica caracteres especiais da senha para formato de URL
PASSWORD_ENCODED = quote_plus(DB_PASSWORD)

# String de Conexao com o SQLAlchemy
DATABASE_URL = f"postgresql://{DB_USER}:{PASSWORD_ENCODED}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

# ID do arquivo .zip no Google Drive
DRIVE_FILE_ID = "15vGhmvT0Ux2crqHy_YeRoRiaiCkdB88A"
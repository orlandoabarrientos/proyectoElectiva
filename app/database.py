import os

db = {
    'user': os.getenv("DB_USER", "root"),
    'password': os.getenv("DB_PASSWORD", ""),
    'host': os.getenv("DB_HOST", "localhost"),
    'database': os.getenv("DB_NAME", "flutter_2-2024"),
}


import mysql.connector
from config import config

try:
    conn = mysql.connector.connect(**config)
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM usuari")
    for row in cursor.fetchall():
        print(row)
except mysql.connector.Error as e:
    print("Error: ", e)
    
finally:
    cursor.close()
    conn.close()
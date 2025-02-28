# Proyecto Electiva

## Descripción
El objetivo de este proyecto es desarrollar una API que será consumida por una interfaz creada con Flutter. Se emplearán tecnologías como Python con `mysql.connector` y el framework `ApiFast` para garantizar una integración rápida y eficiente.

### Tecnologías Utilizadas
- ![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white&height=25)
- ![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white&height=25)
- ![ApiFast](https://img.shields.io/badge/ApiFast-FF5733?style=for-the-badge&logo=fastapi&logoColor=white&height=25)
- ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white&height=25)

## Configuración del Entorno Virtual

### 1. Crear el Entorno Virtual
Ejecuta el siguiente comando para crear el entorno virtual (puedes cambiar el nombre si lo deseas):

```bash
python -m venv .venv
```

### 2. Activar el Entorno Virtual
En Windows, usa:

```bash
.\.venv\Scripts\activate
```

⚠ **Si encuentras un error de permisos, sigue estos pasos:**

#### a) Desactivar restricciones de ejecución
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### b) Activar el entorno virtual nuevamente
```bash
.\.venv\Scripts\activate
```

#### c) Restaurar restricciones después de la activación
```powershell
Set-ExecutionPolicy -ExecutionPolicy Restricted -Scope CurrentUser
```

### 3. Instalar Dependencias
Una vez activado el entorno virtual, instala las dependencias del proyecto con:

```bash
pip install -r requirements.txt

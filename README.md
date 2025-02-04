# proyectoElectiva
## Pasos 

1. Crean el enterno virtual

2. Activalo con '.\.venv\Scripts\activate'

## En el caso de haber un error, usa: 

### Desactiva permisos de entorno virtual con:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

### Activalo en venv 
.\.venv\Scripts\activate

### Activalos nuevamente con:
Set-ExecutionPolicy -ExecutionPolicy Restricted -Scope CurrentUser 

## Usar las dependencias para el entorno virtual: 
pip install -r requirements.txt

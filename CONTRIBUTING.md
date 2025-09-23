# ¿Cómo contribuir?
Hay 2 maneras en las que puedes contribuir: siendo colaborador oficial del proyecto o creando tu propio fork y enviando solicitudes de cambios. En ambas debes tener [Git](https://git-scm.com/) instalado.

Para ser colaborador oficial debes enviar al dueño del repositorio tu email o nombre de usuario de GitHub, notificar de tu solicitud de inclusión y luego clonar el repositorio en tu directorio de trabajo local. Si por el contrario quieres trabajar independientemente, debes crear un [fork](https://docs.github.com/es/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo) del proyecto (presionar el botón fork en la pestaña principal de la página del proyecto en GitHub), trabajar en tu copia personal del proyecto y enviar los cambios al original mediante un **Pull Request**.

# ¿Cómo puedo trabajar localmente con el proyecto?

Si eres colaborador oficial, inserta el siguiente comando en tu directorio de trabajo usando Git. Este comando creará una copia local del repositorio para que puedas trabajar en él:

    git clone https://github.com/sandredev/Proyecto-de-base-de-datos.git
    
Antes de introducir cualquier cambio, crea una rama con el comando: 

    git checkout -b nombre-de-rama
Las ramas son líneas de versiones independientes a la línea que se utiliza en producción (**main**). Es una buena práctica generar versiones en una rama diferente a **main** antes de introducir cualquier cambio.
Cuando quieras introducir un cambio al proyecto, en Git inserta la línea de comandos: 


    git add .
    git commit
    git push origin nombre-de-rama


Dicha línea implementará los cambios que hayas realizado en tu directorio de trabajo local al repositorio remoto. En el proceso te pedirá una contraseña y un mensaje que resuma los cambios que se han producido. Cuando tengas que ingresar la contraseña no intentes hacerlo con la de tu usuario pues eso no te servirá (al intentarlo aparecerá un error de autenticación), debes ingresar un token de acceso que te permita hacer cambios en el proyecto.
Puedes generar un token en `Settings -> Developer settings -> Personal access tokens -> Tokens (classic)`.

Para mantener tu directorio de trabajo local actualizado con los cambios implementados en el repositorio remoto, ejecuta en Git el comando:

    git pull origin main
    
En caso de no ser colaborador oficial, recomiendo seguir la [guía de la documentación oficial de GitHub](https://docs.github.com/es/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo) sobre forks de repositorios.

# Apollo API
Para probarla se puede instalar la aplicación [Postman](https://www.getpostman.com/) e importar la colección *"Apollo.postman_collection.json"*. En el panel de la izquierda aparecerá la colección *Apollo* con ejemplos de todas las acciones que la aplicación soporta actualmente.

## Requisitos
* Ruby 2.4.1
* Rails 5.1
* PostgreSQL 9.6
* PostGIS 2.3
* Redis 3.2

## API REST
### General
Método HTTP | URI | Autenticación | Descripción
----------- | --- | ------------- | -----------
GET | / | Público | Muestra un mensaje de bienvenida.

### Login
Método HTTP | URI | Autenticación | Descripción
----------- | --- | ------------- | -----------
GET | /auth/google_oauth2 | Público | Autentica al usuario con su cuenta de Google.
GET | /auth/validate | Público | Devuelve información sobre el token de acceso.

### Usuarios
En este endpoint, *:id* se puede sustituir por el username del usuario o por *'me'* para referenciar al usuario logueado.

Método HTTP | URI | Autenticación | Descripción
----------- | --- | ------------- | -----------
GET | /users/:id | Público | Devuelve el usuario.
PUT | /users/:id | Usuarios | Actualiza el usuario logueado.
GET | /users/:id/posts | Público | Devuelve las últimas publicaciones del usuario.
GET | /users/:id/followers | Público | Devuelve los seguidores del usuario.
POST | /users/:id/followers| Usuarios | Sigue al usuario.
DELETE | /users/:id/followers | Usuarios | Deja de seguir al usuario.
GET | /users/:id/followings | Público | Devuelve los seguidos por el usuario.
GET | /users/:id/travels | Público | Devuelve los viajes del usuario.
GET | /users/:id/favorites | Público | Devuelve los favoritos del usuario.
GET | /users/:id/authorizations | Usuarios | Devuelve las autorizaciones del usuario.
GET | /users/:id/image | Público | Devuelve la imagen de perfil del usuario.
PUT | /users/:id/image | Usuarios | Actualiza la imagen de perfil del usuario.
GET | /users/search | Público | Busca usuarios.

### Últimas publicaciones
Método HTTP | URI | Autenticación | Descripción
----------- | --- | ------------- | -----------
GET | /home | Usuarios | Devuelve las últimas publicaciones de la pantalla principal.

### Viajes
Método HTTP | URI | Autenticación | Descripción
----------- | --- | ------------- | -----------
POST | /travels | Usuarios | Crea un viaje.
GET | /travels/:id | Público | Devuelve el viaje.
GET | /travels/search | Público | Busca viajes.
DELETE | /travels/:id | Usuarios | Borra el viaje.
GET | /travels/:id/favorites | Público | Devuelve los favoritos del viaje.
POST | /travels/:id/favorites | Usuarios | Marca al viaje como favorito.
DELETE | /travels/:id/favorites | Usuarios | Desmarca al viaje como favorito.
GET | /travels/:id/comments | Público | Devuelve los comentarios del viaje.
POST | /travels/:id/comments | Usuarios | Crea un comentario.
GET | /travels/:id/authorizations | Usuarios | Devuelve las autorizaciones del viaje.

### Comentarios
Método HTTP | URI | Autenticación | Descripción
----------- | --- | ------------- | -----------
GET | /comments/:id | Público | Devuelve el comentario.
GET | /comments/search | Público | Busca comentarios.

### Notificaciones
Método HTTP | URI | Autenticación | Descripción
----------- | --- | ------------- | -----------
GET | /notifications | Usuarios | Devuelve todas las notificaciones.
GET | /notifications?readed=false | Usuarios | Devuelve las notificaciones no leídas.
POST | /notifications/read | Usuarios | Marca todas las notificaciones como leídas.

### Notas
* Todos los endpoints que devuelven multiples recursos permiten la paginación a traves de los parametros *'page'* y *'per_page'*. Si no se utilizan se devuelven los primeros 20 recursos por defecto.

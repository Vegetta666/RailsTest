
# Proyecto de pruebas Rails

## Creación inicial

Pasos:

* Copiar carpeta baseproject a proyecto (railstest ejemplo)
* En la carpeta railstest
  * Si es necesario ajustar docker/Dockerfile
  * Si es necesario  docker/docker-compose.yml

## Instalación de Rails

(tal como está instalará la última versión de Rails)

Instalar el proyecto Rails:

En un terminal:

```bash
cd railstest #(entrar en la carpeta del proyecto)
make console
gem install rails #no sobre escribir fichero database.yml cuando lo pregunte
#Si no está creado el proyecto
rails new .
añadir a Gemfile gema de base de datos `gem "mysql2"` o si se us postgres `gem "pg"`(este último requerirá otros cambios)
make console
bundle install
```

## Puesta en marcha Rails

En un terminal:

```bash
make dev #(manternerlo abierto)
```

ir a [http://localhost:3000](http://localhost:3000) con el navegador.
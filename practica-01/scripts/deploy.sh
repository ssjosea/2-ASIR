
set -x 

# Accedemos a un directorio temporal /tmp
cd /tmp

# Eliminamos el directorio de instalaciones previas
rm -rf iaw-practica-lamp

# Clonamos repositorio con la pagina web
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git
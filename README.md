#  Proyecto Instalador Automatizado de Paquetes en Terminal --Debian 13

![Shell](https://img.shields.io/badge/shell-bash-4EAA25?logo=gnubash&logoColor=white)
![Debian](https://img.shields.io/badge/OS-Debian%2013-A81D33?logo=debian&logoColor=white)

Script Bash que lee una lista de paquetes desde  un archivo de texto  plano y los instala con apt, verificando dependencias y registrando exitos y fallos en un achivo de log.Es util para el aprovisionamiento de entornos. 

Desarrollado y probado sobre Debian 13 usando visual studio code dentro la maquina virtual. 


# Tabla de contenido
1. [Requisitos previos](#requisitos-previos)
2.  [Instalación](#instalación)
3. [Estructura del proyecto](#estructura-del-proyecto)
4. [Formato de la lista de paquetes](#formato-lista-paquetes)
5. [Ejecucion de los paquetes](#ejecucion-paquetes)
6. [Listado de scripts](#listado-de-scripts)
7. [Ejecución de los scripts](#ejecución-de-los-scripts)
8. [Ejecución de pruebas](#ejecución-de-pruebas)
9. [Autor](#autor)

## Requisitos previos

- Máquina virtual con **Debian 13 (Trixie)** instalada.
- Intérprete **Bash** (incluido por defecto en Debian). Verificar versión:
  
  ```bash
  bash --version
  ```

- Permisos de administrador (`sudo`), porque `apt` necesita privilegios para instalar paquetes.
- Conexión a internet para descargar los paquetes de los repositorios.
## Instalación
 
Clonar el repositorio en la máquina virtual Debian:
 
```bash
git clone https://github.com/mnahiun/Instalador-automatizado-de-paquetes--debian--13.git
cd Instalador-automatizado-de-paquetes--debian--13
```
 
Otorgar permiso de ejecución al script:
 
```bash
chmod +x Instalador_automatizado_de_paquetes.sh
```
 
Comprobar que el permiso quedó aplicado (deben aparecer las `x`):
 
```bash
ls -l Instalador_automatizado_de_paquetes.sh
```
 
Resultado esperado: `-rwxr-xr-x`.
 
## Estructura del proyecto
 
```
Instalador-automatizado-de-paquetes--debian--13/
├── Instalador_automatizado_de_paquetes.sh   # script principal
├── paquetes.txt                             # lista de paquetes a instalar
├── instalacion.log                          # registro generado por el script
└── README.md
```
 
> **Nota:** el archivo `instalacion.log` **no se crea manualmente**: el script lo genera automáticamente en la primera ejecución.
 
## Formato de la lista de paquetes
 
El archivo `paquetes.txt` contiene **un paquete por línea**. Las líneas que empiezan con `#` son comentarios y el script las ignora.
 
```
# Lista de paquetes a instalar por medio del script
 
git
curl
htop
tree
duma
tmux
nano
ace-of-penguins
DOM
```
 
`DOM` **no es un paquete de Debian**: se incluye a propósito para demostrar que el script detecta y registra los fallos.
 
> Los nombres de paquetes deben escribirse exactamente como aparecen en [packages.debian.org](https://packages.debian.org).
 
## Ejecucion paquetes
 
| Paquete | Descripción | Comando para ejecutarlo |
|---|---|---|
| `git` | Sistema de control de versiones. | `git --version` |
| `curl` | Descarga o consulta datos desde internet. | `curl --version` y `curl https://example.com` |
| `htop` | Monitor de procesos en tiempo real. | `htop` (salir con `q`) |
| `tree` | Muestra carpetas y archivos en forma de árbol. | `tree` |
| `duma` | Detecta errores de memoria en programas C/C++. | `duma ls` |
| `tmux` | Varias sesiones y paneles en una sola terminal. | `tmux` |
| `nano` | Editor de texto para la terminal. | `nano archivo.txt` |
| `ace-of-penguins` | Colección de juegos de cartas (requiere entorno gráfico). | `ace-freecell` |
| `DOM` | No existe en los repositorios; provoca un fallo a propósito. | No aplica. |
 
### Ejemplos de uso
 
**`tmux`**: dividir la pantalla y ejecutar dos programas a la vez.
 
```bash
tmux
```
 
1. `Ctrl + b` y luego `%`: divide la pantalla en dos paneles.
2. Ejecutar `htop` en un panel.
3. `Ctrl + b` y luego la flecha derecha para cambiar de panel, y ejecutar `tree`.
4. `Ctrl + b` y luego `d` deja la sesión en segundo plano (se recupera con `tmux attach`); `exit` la cierra.
**`nano`**: editar la lista de paquetes.
 
```bash
nano paquetes.txt
```
 
**`ace-of-penguins`**: para ver el juego del solitario:
 
```bash
ace-freecell
```
 
> `nano` suele venir preinstalado en Debian. En ese caso, `apt` termina sin error y el script lo registra igual como `[INSTALADO]`.
 
## Funcionamiento del script
 
1. Recibe el archivo de lista como argumento (`$1`). Si no se indica, muestra el modo de uso y termina.
2. Registra el inicio de la ejecución con fecha y hora en `instalacion.log`.
3. Actualiza el índice de paquetes con `apt-get update`.
4. Recorre la lista ignorando los comentarios (`grep -v '^#'`). Por cada paquete:
   - **Verificación:** simula la instalación con `apt-get install -s`, que comprueba que el paquete exista y que sus dependencias se puedan resolver, sin instalar nada.
   - Si la simulación falla, registra `[FALLO]` y continúa con el siguiente paquete.
   - **Instalación:** si la simulación pasa, instala con `apt-get install -y`.
   - Registra `[INSTALADO]` si salió bien o `[FALLO]` si no.
5. Muestra y guarda un resumen con el total de instalados y fallidos.
### Conceptos utilizados
 
| Elemento | Uso en el script |
|---|---|
| `#!/bin/bash` | Indica que el archivo se ejecuta con Bash. |
| `$1`, `$0` | Primer argumento y nombre del script. |
| `$?` | Resultado del último comando (`0` = éxito). |
| `-ne` / `-eq` | Comparación numérica: distinto de / igual a. |
| `>>` | Agrega texto al final de un archivo (el log). |
| `> /dev/null 2>&1` | Oculta la salida y los errores de un comando. |
| `for` ... `done` | Repite el bloque por cada paquete de la lista. |
| `continue` | Salta al siguiente paquete tras un fallo. |
| `chmod +x` | Da permiso de ejecución al archivo. |
 
## Ejecución del script
 
Desde la carpeta del proyecto, en la terminal de Debian 13 (o en la terminal integrada de VS Code):
 
1. Verificar el permiso de ejecución:
```bash
ls -l Instalador_automatizado_de_paquetes.sh
```
2. Si no lo tiene, otorgarlo:
```bash
chmod +x Instalador_automatizado_de_paquetes.sh
```
3. Ejecutar el script con `sudo`, indicando la lista de paquetes:
```bash
sudo ./Instalador_automatizado_de_paquetes.sh paquetes.txt
```
4. Revisar el registro generado:
```bash
cat instalacion.log
```
 
### Ejemplo de salida (`instalacion.log`)
 
```
=== Inicio: mar 17 nov 2026 18:33:22 -05 ===
[INSTALADO] git
[INSTALADO] curl
[INSTALADO] htop
[INSTALADO] tree
[INSTALADO] duma
[INSTALADO] tmux
[INSTALADO] nano
[INSTALADO] ace-of-penguins
[FALLO] DOM
Resumen: 8 instalados, 1 fallidos
```
 
> El log usa `>>`, por lo que **acumula** las ejecuciones. Para obtener un registro limpio: `rm instalacion.log` antes de volver a ejecutar.
 
## Ejecución de pruebas

### 1. Probar los programas instalados
 
Usar los comandos de la tabla [Ejecucion de los paquetes](#ejecucion-paquetes). Por ejemplo:
 
```bash
git --version
curl --version
tree
htop
duma ls
tmux
nano archvo.txt
ace-of-penguins` ace-freecell
```
 
### 2. Probar el manejo de errores
 
Sin argumentos, el script debe mostrar el modo de uso:
 
```bash
sudo ./Instalador_automatizado_de_paquetes.sh
```
 
Con `DOM` en la lista, el log debe registrar un `[FALLO]`.

## Autor
 
**Nahin Alfonso Duarte Mateus, Bryan Steban Ariza, Richard Andres Useche**
 

 



  



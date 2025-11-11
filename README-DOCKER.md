# 🐳 Guía Simple de Docker - Hotel Premier

## 📋 Configuración Ultra Simplificada

Esta es la versión definitiva y simple. **Sin perfiles, sin hot-reload mágico, sin complicaciones.**

## 🚀 Comandos Básicos

### Primera vez - Compilar y levantar todo

```powershell
# 1. Compilar el JAR
cd hotel-premier
./mvnw clean package -DskipTests
cd ..

# 2. Construir imagen de Docker (solo primera vez)
docker-compose build

# 3. Levantar servicios
docker-compose up -d
```

### Después de cambiar código Java

```powershell
# Opción A: Usar el script
.\rebuild.ps1

# Opción B: Comandos manuales
cd hotel-premier
./mvnw clean package -DskipTests
cd ..
docker-compose restart hotel-premier
```

**Tiempo total: ~30 segundos**

### Ver logs

```powershell
# Ver logs de hotel-premier
docker-compose logs -f hotel-premier

# Ver logs de todos los servicios
docker-compose logs -f
```

### Detener servicios (conserva datos)

```powershell
docker-compose down
```

### Limpiar TODO y empezar de cero

```powershell
# Detener y borrar volúmenes
docker-compose down -v

# Borrar imagen
docker rmi tp-dsi-2025-hotel-premier

# Volver a compilar y levantar
cd hotel-premier
./mvnw clean package -DskipTests
cd ..
docker-compose build
docker-compose up -d
```

## 📊 Cómo Funciona

1. **Maven compila en tu máquina** → Genera `hotel-premier/target/hotel-premier-0.0.1-SNAPSHOT.jar`
2. **Docker monta el JAR como volumen** → No lo copia, solo lo lee
3. **Cuando cambias código** → Recompilas el JAR → Reinicias el contenedor → ¡Listo!

## ✅ Ventajas de Esta Configuración

- ✅ **Simple**: Sin perfiles, sin etapas múltiples
- ✅ **Rápido**: Compilación local es más rápida que en Docker
- ✅ **Funciona**: No hay hot-reload que falle, solo compilar y reiniciar
- ✅ **Datos persisten**: La base de datos NO se borra al reiniciar
- ✅ **Sin surpresas**: Lo que funciona hoy funcionará mañana

## 🎯 Flujo de Trabajo Diario

### Al empezar el día
```powershell
docker-compose up -d
```

### Durante el desarrollo
1. Editas código Java
2. Ejecutas `.\rebuild.ps1`
3. Recargas el navegador
4. Repites

### Al terminar
```powershell
docker-compose down
```
*La base de datos queda guardada para mañana*

## 🔧 Servicios Disponibles

- **Aplicación**: http://localhost:8080
- **PgAdmin**: http://localhost:5050
  - Email: admin@hotelpremier.com
  - Password: admin
- **PostgreSQL**: localhost:5432
  - Database: hotel_premier_db
  - User: hotel_user
  - Password: hotel_password

## ❓ Solución de Problemas

### "No hay JAR"
```powershell
cd hotel-premier
./mvnw clean package -DskipTests
cd ..
```

### "El contenedor no inicia"
```powershell
# Ver qué pasa
docker-compose logs hotel-premier

# Si es error de código, corrígelo y:
.\rebuild.ps1
```

### "Puerto 8080 ocupado"
```powershell
# Ver qué usa el puerto
netstat -ano | findstr :8080

# Detener otros servicios o cambiar el puerto en .env
```

### "Base de datos vacía"
```powershell
# El init.sql se ejecuta solo la primera vez
# Para re-ejecutarlo:
docker-compose down -v
docker-compose up -d
```

## 📝 Variables de Entorno (opcional)

Crea un archivo `.env` en la raíz si quieres cambiar valores:

```env
POSTGRES_DB=hotel_premier_db
POSTGRES_USER=hotel_user
POSTGRES_PASSWORD=hotel_password
POSTGRES_PORT=5432
PGADMIN_PORT=5050
APP_PORT=8080
```

## 🎓 Conceptos Clave

- **Volumen**: Docker lee el JAR desde tu máquina, no lo copia
- **Restart**: Reiniciar un contenedor tarda ~5 segundos
- **Down**: Detiene contenedores pero conserva volúmenes (datos)
- **Down -v**: Detiene contenedores Y borra volúmenes (datos)

## 🚫 Lo Que NO Hay Que Hacer

- ❌ No borres `hotel-premier/target/` manualmente
- ❌ No uses `docker-compose down -v` a menos que quieras perder datos
- ❌ No intentes hot-reload, simplemente recompila

## ✨ Esto Es Todo

No hay más archivos, no hay más scripts complicados. Solo:
- `docker-compose.yml`
- `rebuild.ps1` (opcional, para tu comodidad)
- Este README

**Simple. Funcional. Confiable.**

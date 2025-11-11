# 🐳 Guía de Uso de Docker para Desarrollo

## 📋 Resumen de Cambios

Se han realizado mejoras significativas en la configuración de Docker para solucionar el problema de tener que borrar los volúmenes cada vez que se introduce un cambio en el servicio `hotel-premier`.

### 🔧 Cambios Realizados

1. **Dockerfile multi-stage mejorado**:
   - Etapa `development`: Para desarrollo con hot-reload usando Maven
   - Etapa `production`: Para producción con JAR optimizado
   - Etapa `build`: Para compilar la aplicación

2. **Spring DevTools agregado**: Permite la recarga automática de cambios sin reiniciar el contenedor

3. **Volúmenes optimizados**: Solo se montan los archivos fuente necesarios, en modo read-only

4. **Configuración separada**: `docker-compose.dev.yml` para desarrollo y `docker-compose.yml` para producción

## 🚀 Comandos de Uso

### Primera vez - Construir todo
```powershell
docker-compose --profile dev up -d --build
```

### Después de cambios en código Java
**¡Ya NO necesitas borrar volúmenes!** El contenedor detectará los cambios automáticamente:

```powershell
# Opción 1: Recarga automática (Spring DevTools)
# Solo guarda el archivo - los cambios se recargarán automáticamente en ~10 segundos

# Opción 2: Reiniciar solo el servicio hotel-premier (si necesitas)
docker-compose --profile dev restart hotel-premier

# Opción 3: Rebuild solo hotel-premier (si cambias dependencias en pom.xml)
docker-compose --profile dev up -d --build hotel-premier
```

### Después de cambios en pom.xml (dependencias)
Si agregas o modificas dependencias en `pom.xml`, necesitas rebuild:

```powershell
docker-compose --profile dev up -d --build hotel-premier
```

### Ver logs
```powershell
# Ver logs de hotel-premier
docker-compose --profile dev logs -f hotel-premier

# Ver logs de todos los servicios
docker-compose --profile dev logs -f
```

### Detener servicios (SIN borrar datos)
```powershell
docker-compose --profile dev down
```

### Detener y borrar TODO (incluyendo base de datos) - ⚠️ CUIDADO
```powershell
docker-compose --profile dev down -v
```

## 🎯 Flujo de Trabajo Típico

### Día a día (Desarrollo normal)
```powershell
# 1. Levantar servicios (primera vez del día)
docker-compose --profile dev up -d

# 2. Trabajar normalmente - los cambios se recargan solos

# 3. Ver logs si necesitas debug
docker-compose --profile dev logs -f hotel-premier

# 4. Al terminar el día (opcional - conserva datos)
docker-compose --profile dev down
```

### Cambios en código Java
```powershell
# 1. Edita tu código Java
# 2. Guarda el archivo
# 3. Espera ~10 segundos
# 4. Recarga tu navegador
# ¡Listo! No necesitas hacer nada más
```

### Cambios en dependencias (pom.xml)
```powershell
# 1. Edita pom.xml
# 2. Rebuild solo hotel-premier
docker-compose --profile dev up -d --build hotel-premier
```

### Reset completo (cuando algo falla)
```powershell
# 1. Detener y borrar todo
docker-compose --profile dev down -v

# 2. Limpiar imágenes (opcional)
docker-compose --profile dev build --no-cache hotel-premier

# 3. Levantar todo de nuevo
docker-compose --profile dev up -d --build
```

## 🔍 Solución de Problemas

### El contenedor hotel-premier no inicia
```powershell
# Ver logs para identificar el error
docker-compose --profile dev logs hotel-premier

# Errores comunes:
# - Base de datos no está lista: Espera 30 segundos más
# - Error en código Java: Revisa los logs y corrige el error
# - Puerto 8080 ocupado: Detén otros servicios en ese puerto
```

### Los cambios no se reflejan
```powershell
# 1. Verifica que Spring DevTools esté activo en los logs
docker-compose --profile dev logs hotel-premier | Select-String "devtools"

# 2. Reinicia el servicio
docker-compose --profile dev restart hotel-premier

# 3. Si persiste, rebuild
docker-compose --profile dev up -d --build hotel-premier
```

### Base de datos tiene datos viejos
```powershell
# Borrar SOLO el volumen de postgres (conserva otros servicios)
docker volume rm tp-dsi-2025_postgres_dev_data

# Luego reinicia postgres
docker-compose --profile dev up -d postgres-db
```

## 📊 Estado de Servicios

### Ver servicios activos
```powershell
docker-compose --profile dev ps
```

### Ver volúmenes
```powershell
docker volume ls
```

### Inspeccionar un contenedor
```powershell
docker inspect hotel-premier-dev
```

## 🎓 Notas Técnicas

### Hot Reload (Recarga Automática)
- **Funciona con**: Cambios en clases Java, resources, templates
- **NO funciona con**: Cambios en pom.xml, Dockerfile, application.yml (requiere restart)
- **Tiempo**: ~10 segundos después de guardar

### Volúmenes
- **postgres_dev_data**: Datos de la base de datos (persiste)
- **./hotel-premier/src**: Código fuente (montado en read-only)
- **./hotel-premier/logs**: Logs de la aplicación (persiste)

### Perfiles Docker Compose
- **dev**: Desarrollo local con hot-reload
- **prod** (futuro): Producción optimizada

## 🆘 Comandos de Emergencia

```powershell
# Detener TODO (todos los perfiles)
docker-compose down

# Borrar TODAS las imágenes del proyecto
docker-compose down --rmi all

# Limpiar TODO Docker (⚠️ EXTREMO - afecta otros proyectos)
docker system prune -a --volumes
```

## ✅ Ventajas del Nuevo Setup

- ✅ **No necesitas borrar volúmenes** cada vez que cambias código
- ✅ **Hot reload automático** - cambios visibles en ~10 segundos
- ✅ **Base de datos persiste** entre reinicios
- ✅ **Builds más rápidos** gracias al cache de Maven
- ✅ **Logs persistentes** en `./hotel-premier/logs`
- ✅ **Menos tiempo esperando** - solo rebuild cuando cambias dependencias


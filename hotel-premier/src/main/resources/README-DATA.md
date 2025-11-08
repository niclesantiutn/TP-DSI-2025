# 🗄️ Población Automática de Datos - Argentina

## 📋 Descripción

Este archivo SQL (`data.sql`) se ejecuta automáticamente cuando la aplicación Spring Boot se inicia, poblando las tablas con datos iniciales de Argentina.

## 🎯 Datos Incluidos

### 1. **País**
- Argentina

### 2. **Provincias** (24 provincias)
- Buenos Aires
- Ciudad Autónoma de Buenos Aires (CABA)
- Catamarca
- Chaco
- Chubut
- Córdoba
- Corrientes
- Entre Ríos
- Formosa
- Jujuy
- La Pampa
- La Rioja
- Mendoza
- Misiones
- Neuquén
- Río Negro
- Salta
- San Juan
- San Luis
- Santa Cruz
- Santa Fe
- Santiago del Estero
- Tierra del Fuego
- Tucumán

### 3. **Localidades** (~150 ciudades principales)
Incluye las ciudades más importantes de cada provincia:
- **Buenos Aires**: La Plata, Mar del Plata, Bahía Blanca, Tandil, etc.
- **CABA**: Palermo, Recoleta, Belgrano, Caballito, etc.
- **Córdoba**: Córdoba Capital, Villa Carlos Paz, Río Cuarto, etc.
- **Santa Fe**: Rosario, Santa Fe, Rafaela, etc.
- **Mendoza**: Mendoza Capital, San Rafael, Godoy Cruz, etc.
- Y todas las ciudades capitales y principales de cada provincia...

### 4. **Nacionalidades**
- Argentina
- Extranjera

## ⚙️ Configuración

### Archivo: `application-dev.yml`
```yaml
spring:
  sql:
    init:
      mode: always                      # Ejecutar siempre
      data-locations: classpath:data.sql # Ubicación del archivo
      continue-on-error: false          # Fallar si hay errores
```

### Opciones de `mode`:
- **`always`**: Ejecuta el script siempre (ideal para desarrollo)
- **`never`**: Nunca ejecuta el script
- **`embedded`**: Solo para bases de datos embebidas (H2, HSQL)

## 🔄 Comportamiento

### Primera Ejecución
1. Spring Boot valida el esquema (`ddl-auto: validate`)
2. Ejecuta `data.sql` e inserta todos los datos
3. La aplicación inicia con datos precargados

### Ejecuciones Posteriores
- **`ON CONFLICT DO NOTHING`**: Si los datos ya existen, no hace nada
- No se duplican registros
- Puedes reiniciar la app sin problemas

## 🚀 Uso

### Al iniciar la aplicación:
```bash
# Las tablas se poblarán automáticamente
mvn spring-boot:run
```

### Verificar datos en PostgreSQL:
```sql
-- Ver países
SELECT * FROM paises;

-- Ver provincias de Argentina
SELECT p.nombre, pa.nombre as pais 
FROM provincias p 
JOIN paises pa ON p.pais_id = pa.id;

-- Ver localidades de Buenos Aires
SELECT l.nombre, p.nombre as provincia
FROM localidades l
JOIN provincias p ON l.provincia_id = p.id
WHERE p.nombre = 'Buenos Aires';

-- Ver nacionalidades
SELECT * FROM nacionalidades;

-- Contar registros
SELECT 
    (SELECT COUNT(*) FROM paises) as paises,
    (SELECT COUNT(*) FROM provincias) as provincias,
    (SELECT COUNT(*) FROM localidades) as localidades,
    (SELECT COUNT(*) FROM nacionalidades) as nacionalidades;
```

## 📝 Notas Importantes

### ✅ Ventajas
- ✅ Datos listos al iniciar la app
- ✅ No requiere scripts manuales
- ✅ Idempotente (se puede ejecutar múltiples veces)
- ✅ Fácil de mantener y versionar

### ⚠️ Consideraciones
- **Desarrollo**: `mode: always` es perfecto
- **Producción**: Cambiar a `mode: never` y usar migraciones (Flyway/Liquibase)
- **Performance**: ~150 inserts, tarda menos de 1 segundo

### 🔧 Personalización

Para agregar más localidades, edita `data.sql`:

```sql
-- Agregar una nueva localidad
INSERT INTO localidades (nombre, provincia_id) VALUES 
    ('Nueva Localidad', (SELECT id FROM provincias WHERE nombre = 'Provincia'))
ON CONFLICT DO NOTHING;
```

Para agregar más nacionalidades:

```sql
INSERT INTO nacionalidades (nombre) VALUES ('Brasil') ON CONFLICT DO NOTHING;
INSERT INTO nacionalidades (nombre) VALUES ('Chile') ON CONFLICT DO NOTHING;
INSERT INTO nacionalidades (nombre) VALUES ('Uruguay') ON CONFLICT DO NOTHING;
```

## 🔍 Troubleshooting

### Error: "relation does not exist"
**Problema**: Las tablas no existen
**Solución**: Asegúrate que `init.sql` haya creado las tablas primero

### Error: "duplicate key value"
**Problema**: Datos duplicados
**Solución**: El script usa `ON CONFLICT DO NOTHING`, esto no debería pasar

### Los datos no se cargan
**Problema**: Configuración incorrecta
**Solución**: Verifica `application-dev.yml` tenga `mode: always`

## 🎯 Testing

Para probar que los datos se cargaron correctamente:

```java
@SpringBootTest
class DataLoadTest {
    
    @Autowired
    private PaisDAO paisDAO;
    
    @Autowired
    private ProvinciaDAO provinciaDAO;
    
    @Autowired
    private LocalidadDAO localidadDAO;
    
    @Autowired
    private NacionalidadDAO nacionalidadDAO;
    
    @Test
    void testDatosArgentinaLoaded() {
        // Verificar país
        assertTrue(paisDAO.existsByNombre("Argentina"));
        
        // Verificar provincias (24 provincias)
        assertTrue(provinciaDAO.count() >= 24);
        
        // Verificar localidades
        assertTrue(localidadDAO.count() >= 100);
        
        // Verificar nacionalidades
        assertTrue(nacionalidadDAO.count() >= 2);
    }
}
```

---

**Fecha de creación**: 8 de noviembre de 2025  
**Mantenedor**: Equipo de Desarrollo Hotel Premier

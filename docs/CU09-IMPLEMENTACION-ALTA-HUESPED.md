# Implementación - Alta de Huésped (CU09)

## 📋 Resumen

Se ha implementado toda la lógica para dar de alta un huésped en el sistema, siguiendo los lineamientos del proyecto y el patrón establecido en el registro de conserje.

## 🏗️ Arquitectura Implementada

### 1. **Capa de Datos (DAO)**

#### Nuevos DAOs creados:
- **DireccionDAO** - `dao/DireccionDAO.java`
  - Operaciones CRUD para direcciones
  
- **LocalidadDAO** - `dao/LocalidadDAO.java`
  - Operaciones CRUD para localidades
  
- **NacionalidadDAO** - `dao/NacionalidadDAO.java`
  - Operaciones CRUD para nacionalidades

#### DAO actualizado:
- **HuespedDAO** - `dao/HuespedDAO.java`
  - Agregado método: `boolean existsByDocumento(String documento)`
  - Verifica si un documento ya está registrado

### 2. **Capa de Servicio (Service)**

#### Interfaz: GestorPersonas
```java
public interface GestorPersonas {
    HuespedDTOResponse registrarHuesped(HuespedDTORequest request);
    boolean existeDocumento(String documento);
}
```

#### Implementación: GestorPersonasImp
**Método principal: `registrarHuesped()`**

Flujo de registro:
1. ✅ Valida que el documento no exista
2. 🔍 Busca y valida la Localidad (por ID)
3. 🔍 Busca y valida la Nacionalidad (por ID)
4. 🏠 Crea y guarda la Dirección con:
   - Datos de dirección del DTO
   - Referencia a la Localidad encontrada
5. 👤 Convierte DTO a entidad Huesped usando HuespedMapper
6. 🔗 Asigna las entidades relacionadas:
   - Direccion (guardada)
   - Nacionalidad (encontrada)
7. 💾 Guarda el huésped completo
8. ✨ Retorna DTO de respuesta con todos los datos

**Manejo de errores:**
- `IllegalArgumentException` para validaciones de negocio:
  - Documento duplicado
  - Localidad no encontrada
  - Nacionalidad no encontrada
- `RuntimeException` para errores inesperados

**Transaccionalidad:**
- `@Transactional` en el método de registro
- `@Transactional(readOnly = true)` para verificación de existencia

### 3. **Capa de Presentación (Controller)**

#### Controller: PersonaController

**Endpoints implementados:**

##### POST `/huesped/registro`
- Procesa el formulario de registro
- Valida datos con `@Valid`
- Delega la lógica al servicio
- Maneja errores y redirige con mensajes flash
- Éxito → redirige a `/menu-principal`
- Error → redirige a `/huesped/registro` con mensaje

##### GET `/huesped/registro`
- Muestra el formulario HTML de registro
- Retorna la vista `registro-huesped`

**Características:**
- ✅ Validación automática con `@Valid` y `BindingResult`
- ✅ Mensajes flash para feedback al usuario
- ✅ Logging completo de operaciones
- ✅ Manejo de excepciones diferenciado
- ✅ Documentación Swagger/OpenAPI

## 🔄 Flujo Completo del Registro

```
Usuario → Formulario HTML
    ↓
Controller (validación)
    ↓
Service (lógica de negocio)
    ↓
1. Validar documento único
2. Buscar Localidad (DB)
3. Buscar Nacionalidad (DB)
4. Crear Direccion
5. Guardar Direccion (DB)
6. Mapper: DTO → Entity
7. Asignar relaciones
8. Guardar Huesped (DB)
9. Mapper: Entity → DTO Response
    ↓
Controller (redirige con mensaje)
    ↓
Usuario ve confirmación
```

## 📦 Dependencias entre Componentes

```
PersonaController
    ↓
GestorPersonas (interface)
    ↓
GestorPersonasImp (implementation)
    ↓
├── HuespedDAO
├── DireccionDAO
├── LocalidadDAO
├── NacionalidadDAO
└── HuespedMapper
```

## 🎯 Comparación con Registro de Conserje

| Aspecto | Registro Conserje | Registro Huésped |
|---------|------------------|------------------|
| **Validación única** | `existsByUsername()` | `existsByDocumento()` |
| **Mapper** | ConserjeMapper | HuespedMapper |
| **Entidades relacionadas** | Ninguna | Direccion, Localidad, Nacionalidad |
| **Transformación especial** | Hasheo de contraseña | Construcción de Direccion |
| **Complejidad** | Baja | Alta (relaciones anidadas) |
| **Transaccionalidad** | Simple | Múltiples inserts |

## 🔐 Validaciones Implementadas

### A nivel de DTO (Jakarta Validation):
- ✅ Campos obligatorios con `@NotBlank` / `@NotNull`
- ✅ Longitudes máximas con `@Size`
- ✅ Fecha de nacimiento en el pasado con `@Past`
- ✅ Validación de enums (TipoDocumento, PosicionFrenteAlIVA)

### A nivel de Servicio (Lógica de negocio):
- ✅ Documento único en el sistema
- ✅ Localidad existente
- ✅ Nacionalidad existente

### A nivel de Base de Datos (Constraints):
- ✅ Documento único (constraint en DB)
- ✅ Relaciones obligatorias (foreign keys)
- ✅ Campos not null

## 📝 Logging Implementado

- **INFO**: Operaciones exitosas y puntos clave del flujo
- **WARN**: Intentos de registro con datos duplicados
- **ERROR**: Entidades no encontradas y errores inesperados
- **DEBUG**: Operaciones de visualización de formularios

## 🎨 Patrón de Diseño Aplicado

**Patrón: Service Layer + DTO Pattern + Repository Pattern**

1. **DTOs** separan la capa de presentación de la lógica de negocio
2. **Services** contienen la lógica de negocio transaccional
3. **DAOs** encapsulan el acceso a datos
4. **Mappers** convierten entre DTOs y entidades
5. **Controllers** coordinan y delegan, no contienen lógica

## ✅ Cumplimiento de Lineamientos

- ✅ Inyección de dependencias por constructor
- ✅ Uso de interfaces para contratos de servicio
- ✅ Transaccionalidad explícita con `@Transactional`
- ✅ Logging con SLF4J (`@Slf4j`)
- ✅ Validación con Jakarta Validation
- ✅ Manejo de excepciones estructurado
- ✅ Documentación Swagger completa
- ✅ Mensajes flash para feedback de usuario
- ✅ Código limpio y bien comentado

## 🚀 Próximos Pasos Sugeridos

1. **Crear la vista HTML**: `templates/registro-huesped.html`
2. **Agregar endpoints REST** para consumo desde frontend moderno
3. **Implementar validaciones adicionales** (mayoría de edad, formato CUIT, etc.)
4. **Tests unitarios** para el servicio y controlador
5. **Tests de integración** para el flujo completo

## 📚 Archivos Modificados/Creados

### Creados:
- `dao/DireccionDAO.java`
- `dao/LocalidadDAO.java`
- `dao/NacionalidadDAO.java`

### Modificados:
- `dao/HuespedDAO.java`
- `service/GestorPersonas.java`
- `service/GestorPersonasImp.java`
- `controller/PersonaController.java`
- `mapper/HuespedMapper.java`

---
**Fecha de implementación**: 7 de noviembre de 2025
**Feature branch**: feature/CU09-AltaHuesped

# Ejemplo de Uso - API de Registro de Huésped

## 📋 Endpoint de Registro

### POST `/huesped/registro`

Registra un nuevo huésped en el sistema.

---

## 🔧 Ejemplo de Request (Form Data)

```http
POST /huesped/registro HTTP/1.1
Host: localhost:8080
Content-Type: application/x-www-form-urlencoded

cuit=20123456789
&telefono=+54 9 11 1234-5678
&info=Cliente preferencial
&calle=Av. Corrientes
&numero=1234
&piso=5
&departamento=A
&codigoPostal=C1043
&localidadId=1
&nombre=Juan
&apellido=Pérez
&tipoDocumento=DNI
&documento=12345678
&fechaNacimiento=1990-05-15
&email=juan.perez@example.com
&ocupacion=Ingeniero
&posicionFrenteAlIVA=RESPONSABLE_INSCRIPTO
&nacionalidadId=1
```

---

## ✅ Respuesta Exitosa

**HTTP Status**: `302 Found` (Redirect)  
**Location**: `/menu-principal`  
**Flash Attribute**: `success = "Huésped Juan Pérez registrado exitosamente"`

---

## ❌ Respuestas de Error

### Error: Documento Duplicado

**HTTP Status**: `302 Found` (Redirect)  
**Location**: `/huesped/registro`  
**Flash Attribute**: `error = "El documento ya está registrado"`

### Error: Localidad No Encontrada

**HTTP Status**: `302 Found` (Redirect)  
**Location**: `/huesped/registro`  
**Flash Attribute**: `error = "La localidad especificada no existe"`

### Error: Nacionalidad No Encontrada

**HTTP Status**: `302 Found` (Redirect)  
**Location**: `/huesped/registro`  
**Flash Attribute**: `error = "La nacionalidad especificada no existe"`

### Error: Validación de Campos

**HTTP Status**: `302 Found` (Redirect)  
**Location**: `/huesped/registro`  
**Flash Attribute**: `error = "Error en los datos ingresados. Verifica los campos."`

---

## 🎯 Modelo de Datos - HuespedDTORequest

### Campos Obligatorios

| Campo | Tipo | Validación | Ejemplo |
|-------|------|------------|---------|
| `cuit` | String | @NotBlank, @Size(max=10) | "20123456789" |
| `telefono` | String | @NotBlank, @Size(max=30) | "+54 9 11 1234-5678" |
| `info` | String | @NotBlank, @Size(max=100) | "Cliente preferencial" |
| `calle` | String | @NotBlank, @Size(max=100) | "Av. Corrientes" |
| `numero` | String | @NotBlank, @Size(max=10) | "1234" |
| `piso` | String | @NotBlank, @Size(max=10) | "5" |
| `departamento` | String | @NotBlank, @Size(max=10) | "A" |
| `codigoPostal` | String | @NotBlank, @Size(max=10) | "C1043" |
| `localidadId` | Long | - | 1 |
| `nombre` | String | @NotBlank, @Size(max=100) | "Juan" |
| `apellido` | String | @NotBlank, @Size(max=100) | "Pérez" |
| `tipoDocumento` | Enum | @NotNull | DNI, PASAPORTE, etc. |
| `documento` | String | @NotBlank, @Size(max=10) | "12345678" |
| `fechaNacimiento` | LocalDate | @NotNull, @Past | "1990-05-15" |
| `ocupacion` | String | @NotBlank, @Size(max=100) | "Ingeniero" |
| `posicionFrenteAlIVA` | Enum | @NotNull | RESPONSABLE_INSCRIPTO, etc. |
| `nacionalidadId` | Long | - | 1 |

### Campos Opcionales

| Campo | Tipo | Validación | Ejemplo |
|-------|------|------------|---------|
| `email` | String | @Size(max=100) | "juan.perez@example.com" |

---

## 🔍 Flujo de Validación

### 1. Validación de Formato (Jakarta Validation)
- Verifica tipos de datos
- Valida longitudes máximas
- Verifica campos obligatorios
- Valida fecha en el pasado

### 2. Validación de Negocio (Service)
- Verifica que el documento no esté registrado
- Valida existencia de Localidad
- Valida existencia de Nacionalidad

### 3. Validación de Base de Datos
- Constraints de unicidad
- Foreign keys
- Not null constraints

---

## 📊 Estructura de Respuesta - HuespedDTOResponse

```json
{
  "id": 1,
  "cuit": "20123456789",
  "telefono": "+54 9 11 1234-5678",
  "info": "Cliente preferencial",
  "calle": "Av. Corrientes",
  "numero": "1234",
  "piso": "5",
  "departamento": "A",
  "codigoPostal": "C1043",
  "localidadId": 1,
  "nombreLocalidad": "Buenos Aires",
  "provinciaId": 1,
  "nombreProvincia": "Buenos Aires",
  "paisId": 1,
  "nombrePais": "Argentina",
  "nombre": "Juan",
  "apellido": "Pérez",
  "tipoDocumento": "DNI",
  "documento": "12345678",
  "fechaNacimiento": "1990-05-15",
  "email": "juan.perez@example.com",
  "ocupacion": "Ingeniero",
  "posicionFrenteAlIVA": "RESPONSABLE_INSCRIPTO",
  "nacionalidadId": 1,
  "nombreNacionalidad": "Argentina"
}
```

---

## 🧪 Testing Manual con cURL

### Registro Exitoso

```bash
curl -X POST http://localhost:8080/huesped/registro \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "cuit=20123456789" \
  -d "telefono=+54 9 11 1234-5678" \
  -d "info=Cliente preferencial" \
  -d "calle=Av. Corrientes" \
  -d "numero=1234" \
  -d "piso=5" \
  -d "departamento=A" \
  -d "codigoPostal=C1043" \
  -d "localidadId=1" \
  -d "nombre=Juan" \
  -d "apellido=Pérez" \
  -d "tipoDocumento=DNI" \
  -d "documento=12345678" \
  -d "fechaNacimiento=1990-05-15" \
  -d "email=juan.perez@example.com" \
  -d "ocupacion=Ingeniero" \
  -d "posicionFrenteAlIVA=RESPONSABLE_INSCRIPTO" \
  -d "nacionalidadId=1" \
  -L
```

### Verificar Documento Duplicado

```bash
curl -X POST http://localhost:8080/huesped/registro \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "cuit=20987654321" \
  -d "telefono=+54 9 11 9876-5432" \
  -d "info=Otro cliente" \
  -d "calle=Av. Santa Fe" \
  -d "numero=5678" \
  -d "piso=10" \
  -d "departamento=B" \
  -d "codigoPostal=C1425" \
  -d "localidadId=1" \
  -d "nombre=María" \
  -d "apellido=González" \
  -d "tipoDocumento=DNI" \
  -d "documento=12345678" \
  -d "fechaNacimiento=1985-03-20" \
  -d "email=maria.gonzalez@example.com" \
  -d "ocupacion=Arquitecta" \
  -d "posicionFrenteAlIVA=MONOTRIBUTISTA" \
  -d "nacionalidadId=1" \
  -L
```

---

## 🎨 Integración con Frontend

### Ejemplo de Formulario HTML

```html
<form action="/huesped/registro" method="POST">
  <!-- Datos de Persona -->
  <input type="text" name="cuit" placeholder="CUIT" required maxlength="10">
  <input type="text" name="telefono" placeholder="Teléfono" required maxlength="30">
  <input type="text" name="info" placeholder="Información adicional" required maxlength="100">
  
  <!-- Datos de Dirección -->
  <input type="text" name="calle" placeholder="Calle" required maxlength="100">
  <input type="text" name="numero" placeholder="Número" required maxlength="10">
  <input type="text" name="piso" placeholder="Piso" required maxlength="10">
  <input type="text" name="departamento" placeholder="Departamento" required maxlength="10">
  <input type="text" name="codigoPostal" placeholder="Código Postal" required maxlength="10">
  <select name="localidadId" required>
    <option value="">Seleccione Localidad</option>
    <!-- Opciones cargadas dinámicamente -->
  </select>
  
  <!-- Datos de Huésped -->
  <input type="text" name="nombre" placeholder="Nombre" required maxlength="100">
  <input type="text" name="apellido" placeholder="Apellido" required maxlength="100">
  <select name="tipoDocumento" required>
    <option value="DNI">DNI</option>
    <option value="PASAPORTE">Pasaporte</option>
  </select>
  <input type="text" name="documento" placeholder="Documento" required maxlength="10">
  <input type="date" name="fechaNacimiento" required>
  <input type="email" name="email" placeholder="Email" maxlength="100">
  <input type="text" name="ocupacion" placeholder="Ocupación" required maxlength="100">
  <select name="posicionFrenteAlIVA" required>
    <option value="RESPONSABLE_INSCRIPTO">Responsable Inscripto</option>
    <option value="MONOTRIBUTISTA">Monotributista</option>
    <option value="EXENTO">Exento</option>
  </select>
  <select name="nacionalidadId" required>
    <option value="">Seleccione Nacionalidad</option>
    <!-- Opciones cargadas dinámicamente -->
  </select>
  
  <button type="submit">Registrar Huésped</button>
</form>
```

---

## 📝 Notas Importantes

1. **Localidad y Nacionalidad**: Deben existir previamente en la base de datos
2. **Documento único**: El sistema valida que no exista otro huésped con el mismo documento
3. **Transaccionalidad**: Si falla alguna parte del proceso, se hace rollback completo
4. **Fecha de nacimiento**: Debe ser una fecha en el pasado
5. **Email**: Es opcional pero si se provee, debe tener formato válido

---

## 🔗 Endpoints Relacionados

- `GET /huesped/registro` - Mostrar formulario de registro
- `POST /huesped/registro` - Procesar registro de huésped
- `GET /menu-principal` - Menú principal (destino tras registro exitoso)

# 🚀 Guía Rápida de Ejecución - Sistema de Autenticación

## ⚡ Comandos Rápidos

### 1️⃣ Iniciar Base de Datos (PostgreSQL con Docker)

```powershell
# Desde la raíz del proyecto
cd c:\dev\TP-DSI-2025
docker-compose up -d
```

**Verificar que esté corriendo:**
```powershell
docker-compose ps
```

Deberías ver algo como:
```
NAME                SERVICE    STATUS       PORTS
tp-dsi-2025-db-1    postgres   Up          0.0.0.0:5432->5432/tcp
```

---

### 2️⃣ Compilar el Proyecto

```powershell
cd hotel-premier
./mvnw clean install
```

O en Windows:
```powershell
mvnw.cmd clean install
```

---

### 3️⃣ Ejecutar la Aplicación

```powershell
./mvnw spring-boot:run
```

O en Windows:
```powershell
mvnw.cmd spring-boot:run
```

**La aplicación iniciará en:** `http://localhost:8080`

---

### 4️⃣ Verificar que Todo Funciona

Deberías ver en los logs:
```
Started HotelPremierApplication in X.XXX seconds
```

---

## 🧪 Pruebas del Sistema de Autenticación

### **Test 1: Registrar un Nuevo Usuario**

1. **Abrir navegador:** `http://localhost:8080/registro`
2. **Completar formulario:**
   - Username: `test`
   - Password: `test123`
3. **Click:** "Registrarse"
4. **Resultado esperado:** 
   - Redirige a `/login`
   - Mensaje: "Registro exitoso. Por favor, inicia sesión."

---

### **Test 2: Login con Usuario de Prueba**

1. **Abrir:** `http://localhost:8080/login`
2. **Credenciales de prueba:**
   - Username: `admin`
   - Password: `admin123`
3. **Click:** "Sign in"
4. **Resultado esperado:**
   - Redirige a `/menu-principal`
   - Se muestra: "Bienvenido, **admin**"

---

### **Test 3: Login con Usuario Registrado**

1. **Abrir:** `http://localhost:8080/login`
2. **Usar credenciales del Test 1:**
   - Username: `test`
   - Password: `test123`
3. **Click:** "Sign in"
4. **Resultado esperado:**
   - Acceso exitoso a `/menu-principal`

---

### **Test 4: Intentar Acceder Sin Autenticación**

1. **Cerrar sesión** (si estás logueado)
2. **Intentar acceder:** `http://localhost:8080/menu-principal`
3. **Resultado esperado:**
   - Automáticamente redirige a `/login`

---

### **Test 5: Logout**

1. **Estando autenticado en `/menu-principal`**
2. **Click:** "Cerrar Sesión"
3. **Resultado esperado:**
   - Redirige a `/login?logout`
   - Ya no se puede acceder a rutas protegidas

---

### **Test 6: Intentar Registrar Username Duplicado**

1. **Abrir:** `http://localhost:8080/registro`
2. **Usar username existente:**
   - Username: `admin`
   - Password: `cualquiera123`
3. **Click:** "Registrarse"
4. **Resultado esperado:**
   - Se queda en `/registro`
   - Mensaje de error: "El nombre de usuario ya existe"

---

### **Test 7: Validación de Password Corto**

1. **Abrir:** `http://localhost:8080/registro`
2. **Intentar con password corto:**
   - Username: `nuevo`
   - Password: `123` (menos de 6 caracteres)
3. **Click:** "Registrarse"
4. **Resultado esperado:**
   - Error: "La contraseña debe tener al menos 6 caracteres"

---

## 🗄️ Verificar en Base de Datos

### Conectar a PostgreSQL

```powershell
# Opción 1: Desde Docker
docker exec -it tp-dsi-2025-db-1 psql -U postgres -d hoteldb

# Opción 2: Desde cliente local (si tienes psql instalado)
psql -h localhost -p 5432 -U postgres -d hoteldb
```

**Password:** `postgres` (según tu configuración)

---

### Consultas SQL Útiles

```sql
-- Ver todos los usuarios registrados
SELECT id, username, role, created_at 
FROM conserjes 
ORDER BY created_at DESC;

-- Ver el hash de password de un usuario específico
SELECT username, password 
FROM conserjes 
WHERE username = 'admin';

-- Verificar cuántos usuarios hay
SELECT COUNT(*) as total_usuarios 
FROM conserjes;

-- Ver últimos usuarios registrados
SELECT username, created_at 
FROM conserjes 
ORDER BY created_at DESC 
LIMIT 5;
```

---

## 📊 Logs Importantes a Verificar

### En los logs de la aplicación deberías ver:

**Al iniciar:**
```
UserDetailsServiceImpl : Intentando cargar usuario: admin
```

**Al registrar un usuario:**
```
AuthController : Intentando registrar nuevo conserje: test
AuthController : Conserje registrado exitosamente: test
```

**Al hacer login:**
```
UserDetailsServiceImpl : Intentando cargar usuario: test
```

**Si hay error:**
```
UserDetailsServiceImpl : Usuario no encontrado: inexistente
```

---

## 🐛 Solución de Problemas Comunes

### ❌ Error: "Connection refused" al iniciar la app

**Causa:** La base de datos no está corriendo

**Solución:**
```powershell
docker-compose up -d
# Esperar 10-15 segundos para que PostgreSQL inicie completamente
./mvnw spring-boot:run
```

---

### ❌ Error: "Table 'conserjes' doesn't exist"

**Causa:** El script SQL no se ejecutó

**Solución:**
```powershell
# Recrear la base de datos
docker-compose down -v
docker-compose up -d

# Esperar y volver a ejecutar la app
./mvnw spring-boot:run
```

---

### ❌ Error: "Bad credentials" al hacer login

**Posibles causas:**
1. Password incorrecto
2. Usuario no existe
3. Hash de password corrupto

**Solución:**
```sql
-- Verificar que el usuario existe
SELECT * FROM conserjes WHERE username = 'admin';

-- Si no existe, insertarlo manualmente
INSERT INTO conserjes (username, password, role) 
VALUES ('admin', '$2a$10$xBwSJz5PdKvF5YX9WKQm5OqJ8yZWZzJ5Lb6XvY8qYvC0vQXZvH5Vm', 'ROLE_CONSERJE');
```

---

### ❌ La aplicación no inicia en el puerto 8080

**Causa:** Puerto ocupado

**Solución:**
```powershell
# Ver qué proceso usa el puerto 8080
netstat -ano | findstr :8080

# Matar el proceso (reemplaza PID con el número que aparece)
taskkill /PID [número] /F

# O cambiar el puerto en application.yml
# server.port: 8081
```

---

## 🔍 Verificación de Seguridad

### ✅ Checklist de Seguridad Implementada

- [x] **Passwords hasheadas con BCrypt** (no texto plano)
- [x] **Validación de username único**
- [x] **Validación de longitud de password** (mínimo 6)
- [x] **Sesiones seguras con Spring Security**
- [x] **Protección CSRF automática**
- [x] **Invalidación de sesión en logout**
- [x] **Control de acceso a rutas protegidas**
- [x] **Logging de intentos de autenticación**

---

## 📈 Próximos Pasos de Desarrollo

1. **Crear más controladores** para:
   - Gestión de reservas
   - Gestión de habitaciones
   - Gestión de huéspedes

2. **Implementar DTOs** para transferencia de datos

3. **Agregar validación con Bean Validation**
   ```java
   @NotBlank(message = "Username requerido")
   @Size(min = 3, max = 50)
   private String username;
   ```

4. **Implementar roles múltiples**
   ```java
   @PreAuthorize("hasRole('ADMIN')")
   public void deleteUser() { }
   ```

5. **Agregar auditoría**
   ```java
   @EntityListeners(AuditingEntityListener.class)
   public class Conserje {
       @CreatedBy
       private String createdBy;
   }
   ```

---

## 📚 Estructura del Proyecto

```
hotel-premier/
├── src/main/java/.../hotelpremier/
│   ├── config/
│   │   └── SecurityConfig.java          ✅ Configuración de seguridad
│   ├── controller/
│   │   └── AuthController.java          ✅ Login y registro
│   ├── entity/
│   │   └── Conserje.java                ✅ Entidad usuario
│   ├── repository/
│   │   └── ConserjeRepository.java      ✅ Acceso a BD
│   └── service/
│       └── UserDetailsServiceImpl.java  ✅ Lógica autenticación
│
├── src/main/resources/
│   ├── templates/
│   │   ├── registro.html                ✅ Vista registro
│   │   └── menu-principal.html          ✅ Vista menú
│   └── application.yml
│
└── infra/database/
    └── init.sql                          ✅ Schema BD
```

---

## 🎯 Objetivos Cumplidos

✅ **CU01 - Autenticar Usuario** completamente implementado:
- Login funcional
- Registro funcional
- Seguridad robusta
- Buenas prácticas aplicadas
- Documentación completa

---

## 💡 Tips Adicionales

### Para desarrollo más rápido:

**1. Hot Reload con Spring DevTools** (ya incluido en pom.xml):
   - Los cambios en código se recargan automáticamente
   - No necesitas reiniciar la app constantemente

**2. Logging en modo DEBUG:**
```yaml
# En application-dev.yml
logging:
  level:
    com.losmergeconflicts.hotelpremier: DEBUG
    org.springframework.security: DEBUG
```

**3. Deshabilitar seguridad temporalmente** (solo para testing):
```java
// NO USAR EN PRODUCCIÓN
http.authorizeHttpRequests(auth -> auth.anyRequest().permitAll());
```

---

## 📞 Soporte

Si encuentras problemas:
1. Revisa los logs de la aplicación
2. Verifica que la BD esté corriendo
3. Consulta la documentación en `/docs`
4. Revisa este archivo para troubleshooting

---

**🎉 Sistema de Autenticación Implementado Exitosamente! 🎉**

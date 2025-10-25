# 🔐 Sistema de Autenticación - Hotel Premier

## 📋 Descripción General

Se ha implementado un sistema de autenticación y autorización robusto y seguro utilizando **Spring Security** con las siguientes características:

- ✅ Registro de nuevos usuarios (Conserjes)
- ✅ Login con formulario de usuario y contraseña
- ✅ Passwords hasheados con BCrypt
- ✅ Control de acceso basado en roles
- ✅ Sesiones seguras
- ✅ Logout funcional

---

## 🏗️ Arquitectura Implementada

### **1. Base de Datos** (`init.sql`)
```sql
CREATE TABLE conserjes (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,  -- BCrypt hash
    role VARCHAR(50) NOT NULL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);
```

**Usuario de prueba:**
- Username: `admin`
- Password: `admin123`

---

### **2. Entidad `Conserje`** 

**Ubicación:** `com.losmergeconflicts.hotelpremier.entity.Conserje`

**Anotaciones Lombok Utilizadas:**

| Anotación | Descripción |
|-----------|-------------|
| `@Data` | Genera getters, setters, `toString()`, `equals()` y `hashCode()` automáticamente |
| `@NoArgsConstructor` | Genera constructor sin argumentos (requerido por JPA) |
| `@AllArgsConstructor` | Genera constructor con todos los argumentos |
| `@Builder` | Implementa el patrón Builder para crear objetos de forma fluida |

**Ejemplo de uso del Builder:**
```java
Conserje conserje = Conserje.builder()
    .username("juan")
    .password(encodedPassword)
    .role("ROLE_CONSERJE")
    .build();
```

**Implementa `UserDetails`:**
- `getAuthorities()`: Retorna los roles del usuario
- `isAccountNonExpired()`: Indica si la cuenta no expiró
- `isAccountNonLocked()`: Indica si la cuenta no está bloqueada
- `isCredentialsNonExpired()`: Indica si las credenciales no expiraron
- `isEnabled()`: Indica si el usuario está habilitado

---

### **3. Repositorio `ConserjeRepository`**

**Ubicación:** `com.losmergeconflicts.hotelpremier.repository.ConserjeRepository`

```java
public interface ConserjeRepository extends JpaRepository<Conserje, Long> {
    Optional<Conserje> findByUsername(String username);
    boolean existsByUsername(String username);
}
```

**Spring Data JPA** genera automáticamente la implementación de estos métodos.

---

### **4. Servicio `UserDetailsServiceImpl`**

**Ubicación:** `com.losmergeconflicts.hotelpremier.service.UserDetailsServiceImpl`

**Anotaciones Lombok:**
- `@RequiredArgsConstructor`: Genera constructor con todos los campos `final`, permitiendo inyección de dependencias automática
- `@Slf4j`: Genera automáticamente un logger (`log.info()`, `log.debug()`, `log.error()`)

**Función:** Puente entre Spring Security y la base de datos. Carga el usuario durante la autenticación.

---

### **5. Configuración `SecurityConfig`**

**Ubicación:** `com.losmergeconflicts.hotelpremier.config.SecurityConfig`

**Beans configurados:**

#### **a) `PasswordEncoder`**
```java
@Bean
public PasswordEncoder passwordEncoder() {
    return new BCryptPasswordEncoder();
}
```
- **BCrypt** es un algoritmo de hash específicamente diseñado para contraseñas
- Incluye "salt" aleatorio (previene rainbow table attacks)
- Es computacionalmente costoso (previene brute force)
- Realiza 2^10 = 1024 rondas de hashing por defecto

#### **b) `SecurityFilterChain`**
Define las reglas de acceso:

| Ruta | Acceso |
|------|--------|
| `/css/**`, `/js/**`, `/img/**` | Público |
| `/registro` | Público |
| Todas las demás | Requieren autenticación |

**Configuración de Login:**
- URL de éxito: `/menu-principal`
- Spring Security genera automáticamente el formulario en `/login`

**Configuración de Logout:**
- URL de éxito: `/login?logout`
- Invalida la sesión HTTP
- Elimina cookies de autenticación

---

### **6. Controlador `AuthController`**

**Ubicación:** `com.losmergeconflicts.hotelpremier.controller.AuthController`

**Endpoints:**

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/registro` | Muestra formulario de registro |
| POST | `/registro` | Procesa el registro de nuevo conserje |
| GET | `/menu-principal` | Página principal post-login |

**Validaciones implementadas:**
- Username único
- Username no vacío
- Password mínimo 6 caracteres

---

## 🔒 Seguridad Implementada

### **1. Hash de Contraseñas con BCrypt**

**¿Qué hace BCrypt?**
```
Password: "admin123"
↓ BCrypt Hash ↓
$2a$10$xBwSJz5PdKvF5YX9WKQm5OqJ8yZWZzJ5Lb6XvY8qYvC0vQXZvH5Vm
```

**Componentes del hash:**
- `$2a$`: Versión del algoritmo
- `10$`: Factor de costo (2^10 iteraciones)
- Siguientes 22 caracteres: Salt aleatorio
- Resto: Hash real de la contraseña

**Ventajas:**
- ✅ Imposible revertir el hash a la contraseña original
- ✅ Cada usuario tiene un salt único
- ✅ Resistente a ataques de fuerza bruta
- ✅ No se puede usar rainbow tables

### **2. Protección CSRF**

Spring Security incluye protección CSRF automática para formularios POST.

### **3. Sesiones Seguras**

- Las sesiones se invalidan al hacer logout
- Las cookies se eliminan apropiadamente
- Control de acceso por rol

---

## 🚀 Flujo de Autenticación

### **Proceso de Registro:**

```
1. Usuario → GET /registro
2. Servidor → Muestra formulario HTML
3. Usuario → Ingresa username y password → POST /registro
4. AuthController:
   ├─ Valida username único
   ├─ Valida password >= 6 caracteres
   ├─ Hash password con BCrypt
   ├─ Crea entidad Conserje
   ├─ Asigna rol "ROLE_CONSERJE"
   └─ Guarda en BD
5. Redirige a /login con mensaje de éxito
```

### **Proceso de Login:**

```
1. Usuario → GET /login
2. Spring Security → Muestra formulario de login
3. Usuario → Ingresa username y password → POST /login
4. Spring Security:
   ├─ Llama a UserDetailsServiceImpl.loadUserByUsername()
   ├─ Busca usuario en BD
   ├─ Compara password con BCrypt
   └─ Si coincide:
       ├─ Crea sesión autenticada
       └─ Redirige a /menu-principal
5. Usuario autenticado accede al sistema
```

### **Proceso de Logout:**

```
1. Usuario → POST /logout
2. Spring Security:
   ├─ Invalida sesión HTTP
   ├─ Elimina cookie JSESSIONID
   └─ Redirige a /login?logout
```

---

## 🎨 Vistas HTML Creadas

### **1. `registro.html`**
- Formulario de registro con validación HTML5
- Diseño moderno con gradientes
- Mensajes de error/éxito
- Link a login

### **2. `menu-principal.html`**
- Dashboard principal del sistema
- Muestra nombre del usuario autenticado
- Botón de logout
- Grid de opciones del menú

---

## 📦 Anotaciones Lombok - Explicación Detallada

### **¿Qué es Lombok?**

Lombok es una biblioteca que reduce código boilerplate mediante anotaciones que generan código automáticamente en tiempo de compilación.

### **Anotaciones Utilizadas:**

#### **1. `@Data`**
```java
@Data
public class Conserje {
    private Long id;
    private String username;
}
```

**Genera automáticamente:**
- `getId()`, `setId(Long id)`
- `getUsername()`, `setUsername(String username)`
- `toString()`
- `equals(Object o)` y `hashCode()`

**Sin Lombok necesitarías ~50 líneas de código.**

---

#### **2. `@NoArgsConstructor`**
```java
@NoArgsConstructor
public class Conserje {
    // ...
}
```

**Genera:**
```java
public Conserje() {
}
```

**Necesario para JPA**, que requiere un constructor sin argumentos.

---

#### **3. `@AllArgsConstructor`**
```java
@AllArgsConstructor
public class Conserje {
    private Long id;
    private String username;
    private String password;
}
```

**Genera:**
```java
public Conserje(Long id, String username, String password) {
    this.id = id;
    this.username = username;
    this.password = password;
}
```

---

#### **4. `@Builder`**
```java
@Builder
public class Conserje {
    // ...
}
```

**Permite crear objetos de forma fluida:**
```java
Conserje conserje = Conserje.builder()
    .username("juan")
    .password("hash123")
    .role("ROLE_CONSERJE")
    .build();
```

**Ventajas:**
- Código más legible
- No importa el orden de los parámetros
- Puedes omitir campos opcionales

---

#### **5. `@RequiredArgsConstructor`**
```java
@RequiredArgsConstructor
public class AuthController {
    private final ConserjeRepository repository;
    private final PasswordEncoder encoder;
}
```

**Genera constructor con todos los campos `final`:**
```java
public AuthController(ConserjeRepository repository, PasswordEncoder encoder) {
    this.repository = repository;
    this.encoder = encoder;
}
```

**Spring usa este constructor para inyección de dependencias.**

---

#### **6. `@Slf4j`**
```java
@Slf4j
public class AuthController {
    public void metodo() {
        log.info("Mensaje de información");
        log.debug("Mensaje de debug");
        log.error("Mensaje de error", exception);
    }
}
```

**Genera automáticamente:**
```java
private static final Logger log = LoggerFactory.getLogger(AuthController.class);
```

---

## 🧪 Cómo Probar el Sistema

### **1. Iniciar la Base de Datos**
```bash
docker-compose up -d
```

### **2. Ejecutar la Aplicación**
```bash
cd hotel-premier
./mvnw spring-boot:run
```

### **3. Probar el Registro**
1. Navega a: `http://localhost:8080/registro`
2. Ingresa:
   - Username: `test`
   - Password: `test123`
3. Click en "Registrarse"
4. Deberías ser redirigido a `/login`

### **4. Probar el Login**
1. En `/login` ingresa:
   - Username: `admin` (o `test` si registraste)
   - Password: `admin123` (o `test123`)
2. Click en "Sign in"
3. Deberías acceder a `/menu-principal`

### **5. Probar el Logout**
1. En el menú principal, click en "Cerrar Sesión"
2. Deberías volver a `/login`

---

## 🔍 Verificación en Base de Datos

```sql
-- Ver todos los conserjes registrados
SELECT id, username, role, created_at FROM conserjes;

-- El password debe verse como hash BCrypt
SELECT username, password FROM conserjes WHERE username = 'admin';
-- Password: $2a$10$xBwSJz5PdKvF5YX9WKQm5OqJ8yZWZzJ5Lb6XvY8qYvC0vQXZvH5Vm
```

---

## 📚 Buenas Prácticas Implementadas

✅ **Nunca almacenar passwords en texto plano**
✅ **Usar BCrypt para hash de contraseñas**
✅ **Validar inputs del usuario**
✅ **Usar HTTPS en producción** (configurar SSL)
✅ **Logging apropiado** (con @Slf4j)
✅ **Separación de responsabilidades** (Controller, Service, Repository)
✅ **Inyección de dependencias** (con constructores)
✅ **Transacciones** (@Transactional en operaciones de BD)
✅ **Manejo de excepciones** (try-catch con mensajes apropiados)
✅ **Mensajes flash** (RedirectAttributes para feedback al usuario)

---

## 🎯 Próximos Pasos Sugeridos

1. **Agregar validación con Bean Validation** (@Valid, @NotBlank, etc.)
2. **Crear DTOs** para transferencia de datos
3. **Implementar "Remember Me"** para sesiones persistentes
4. **Agregar verificación de email**
5. **Implementar roles múltiples** (ADMIN, CONSERJE, etc.)
6. **Agregar recuperación de contraseña**
7. **Implementar rate limiting** para prevenir brute force
8. **Agregar auditoría** (quién modificó qué y cuándo)

---

## 🐛 Troubleshooting

### **Error: "Bad credentials"**
- Verifica que el password sea correcto
- Verifica que el usuario exista en la BD
- Verifica que el hash BCrypt sea correcto

### **Error: "Access Denied"**
- Verifica que el usuario tenga el rol correcto
- Verifica la configuración de SecurityConfig

### **Error: "Username already exists"**
- El username debe ser único
- Elige otro nombre de usuario

---

## 📖 Referencias

- [Spring Security Documentation](https://docs.spring.io/spring-security/reference/)
- [BCrypt Explained](https://en.wikipedia.org/wiki/Bcrypt)
- [Lombok Documentation](https://projectlombok.org/)
- [Spring Data JPA](https://docs.spring.io/spring-data/jpa/reference/)

---

**Desarrollado con ❤️ para Hotel Premier**

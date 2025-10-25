# 🎯 Guía Completa de Anotaciones Lombok

## 📖 ¿Qué es Lombok?

**Project Lombok** es una biblioteca de Java que elimina código repetitivo (boilerplate) mediante anotaciones que generan código automáticamente en tiempo de compilación.

### **Ventajas:**
- ✅ Código más limpio y legible
- ✅ Menos errores (el código es generado automáticamente)
- ✅ Ahorro de tiempo de desarrollo
- ✅ Facilita el mantenimiento

### **¿Cómo funciona?**
```
Tu código con @Data
       ↓
Compilador Java
       ↓
Lombok Annotation Processor
       ↓
Genera getters, setters, toString, etc.
       ↓
Archivo .class completo
```

---

## 🔧 Anotaciones Utilizadas en el Proyecto

### 1️⃣ **@Data**

**Ubicación:** Clase `Conserje`

**¿Qué hace?**
Genera automáticamente:
- `getters` para todos los campos
- `setters` para todos los campos no-final
- `toString()`
- `equals(Object o)`
- `hashCode()`
- Constructor requerido (para campos final)

**Sin Lombok (código manual):**
```java
public class Conserje {
    private Long id;
    private String username;
    private String password;
    
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    @Override
    public String toString() {
        return "Conserje{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", password='" + password + '\'' +
                '}';
    }
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Conserje conserje = (Conserje) o;
        return Objects.equals(id, conserje.id) &&
               Objects.equals(username, conserje.username) &&
               Objects.equals(password, conserje.password);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(id, username, password);
    }
}
```

**Con Lombok:**
```java
@Data
public class Conserje {
    private Long id;
    private String username;
    private String password;
}
```

**¡De 50+ líneas a 5 líneas! 🎉**

---

### 2️⃣ **@NoArgsConstructor**

**Ubicación:** Clase `Conserje`

**¿Qué hace?**
Genera un constructor sin argumentos.

**Generado automáticamente:**
```java
public Conserje() {
}
```

**¿Por qué es necesario?**
- **JPA/Hibernate lo requiere** para crear instancias de la entidad
- Necesario para la serialización/deserialización
- Frameworks de inyección de dependencias lo usan

**Ejemplo de uso:**
```java
Conserje conserje = new Conserje();
conserje.setUsername("admin");
conserje.setPassword("hash123");
```

---

### 3️⃣ **@AllArgsConstructor**

**Ubicación:** Clase `Conserje`

**¿Qué hace?**
Genera un constructor con TODOS los argumentos.

**Generado automáticamente:**
```java
public Conserje(Long id, String username, String password, String role, 
                LocalDateTime createdAt, LocalDateTime updatedAt) {
    this.id = id;
    this.username = username;
    this.password = password;
    this.role = role;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
}
```

**Ejemplo de uso:**
```java
Conserje conserje = new Conserje(
    1L, 
    "admin", 
    "hash123", 
    "ROLE_CONSERJE",
    LocalDateTime.now(),
    LocalDateTime.now()
);
```

---

### 4️⃣ **@Builder**

**Ubicación:** Clase `Conserje`

**¿Qué hace?**
Implementa el **patrón Builder** para construcción fluida de objetos.

**Código generado (simplificado):**
```java
public static class ConserjeBuilder {
    private Long id;
    private String username;
    private String password;
    private String role;
    
    public ConserjeBuilder id(Long id) {
        this.id = id;
        return this;
    }
    
    public ConserjeBuilder username(String username) {
        this.username = username;
        return this;
    }
    
    public ConserjeBuilder password(String password) {
        this.password = password;
        return this;
    }
    
    public ConserjeBuilder role(String role) {
        this.role = role;
        return this;
    }
    
    public Conserje build() {
        return new Conserje(id, username, password, role, ...);
    }
}

public static ConserjeBuilder builder() {
    return new ConserjeBuilder();
}
```

**Ejemplo de uso en AuthController:**
```java
Conserje nuevoConserje = Conserje.builder()
    .username("admin")
    .password(passwordEncoder.encode("admin123"))
    .role("ROLE_CONSERJE")
    .build();
```

**Ventajas del Builder:**
- ✅ Código más legible
- ✅ No importa el orden de los parámetros
- ✅ Puedes omitir campos opcionales
- ✅ Evita constructores con muchos parámetros

**Comparación:**

```java
// Sin Builder (confuso con muchos parámetros)
Conserje c = new Conserje(null, "admin", "hash", "ROLE_CONSERJE", null, null);

// Con Builder (claro y explícito)
Conserje c = Conserje.builder()
    .username("admin")
    .password("hash")
    .role("ROLE_CONSERJE")
    .build();
```

---

### 5️⃣ **@RequiredArgsConstructor**

**Ubicación:** Clases `AuthController`, `UserDetailsServiceImpl`, `SecurityConfig`

**¿Qué hace?**
Genera un constructor con todos los campos **final** y **@NonNull**.

**En AuthController:**
```java
@RequiredArgsConstructor
public class AuthController {
    private final ConserjeRepository conserjeRepository;
    private final PasswordEncoder passwordEncoder;
}
```

**Código generado:**
```java
public AuthController(ConserjeRepository conserjeRepository, 
                      PasswordEncoder passwordEncoder) {
    this.conserjeRepository = conserjeRepository;
    this.passwordEncoder = passwordEncoder;
}
```

**¿Por qué es útil?**
- ✅ **Inyección de dependencias automática** (Spring lo usa)
- ✅ Garantiza que las dependencias no sean null
- ✅ Fomenta inmutabilidad (campos final)

**Cómo funciona con Spring:**
```
Spring detecta el constructor
       ↓
Busca beans del tipo requerido
       ↓
Inyecta automáticamente
       ↓
Tu controlador está listo con dependencias
```

**Alternativa sin Lombok:**
```java
// Opción 1: Constructor manual
public class AuthController {
    private final ConserjeRepository repository;
    
    public AuthController(ConserjeRepository repository) {
        this.repository = repository;
    }
}

// Opción 2: @Autowired (no recomendado)
public class AuthController {
    @Autowired
    private ConserjeRepository repository;
}
```

---

### 6️⃣ **@Slf4j**

**Ubicación:** `AuthController`, `UserDetailsServiceImpl`

**¿Qué hace?**
Genera automáticamente un logger de SLF4J.

**Código generado:**
```java
private static final org.slf4j.Logger log = 
    org.slf4j.LoggerFactory.getLogger(AuthController.class);
```

**Ejemplo de uso:**
```java
@Slf4j
public class AuthController {
    
    public void registrar(String username) {
        log.info("Registrando usuario: {}", username);
        log.debug("Detalles adicionales...");
        log.error("Error crítico", exception);
        log.warn("Advertencia");
    }
}
```

**Niveles de logging:**
| Nivel | Uso | Ejemplo |
|-------|-----|---------|
| `ERROR` | Errores críticos | `log.error("Error al guardar", e)` |
| `WARN` | Advertencias | `log.warn("Usuario ya existe")` |
| `INFO` | Información general | `log.info("Usuario creado: {}", user)` |
| `DEBUG` | Depuración | `log.debug("Valor de variable: {}", var)` |
| `TRACE` | Rastreo detallado | `log.trace("Entrando al método")` |

**Ventajas:**
- ✅ No necesitas crear el logger manualmente
- ✅ Nombre de la clase automático
- ✅ Compatible con diferentes frameworks de logging

---

## 📊 Comparación Completa

### **Clase Conserje - Con vs Sin Lombok**

**CON LOMBOK (36 líneas):**
```java
@Entity
@Table(name = "conserjes")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Conserje implements UserDetails {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String username;
    private String password;
    private String role;
    
    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of(new SimpleGrantedAuthority(this.role));
    }
    
    @Override
    public boolean isAccountNonExpired() { return true; }
    
    @Override
    public boolean isAccountNonLocked() { return true; }
    
    @Override
    public boolean isCredentialsNonExpired() { return true; }
    
    @Override
    public boolean isEnabled() { return true; }
}
```

**SIN LOMBOK (~150 líneas):**
```java
@Entity
@Table(name = "conserjes")
public class Conserje implements UserDetails {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String username;
    private String password;
    private String role;
    
    // Constructor sin argumentos
    public Conserje() {}
    
    // Constructor con todos los argumentos
    public Conserje(Long id, String username, String password, String role) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.role = role;
    }
    
    // Getters
    public Long getId() { return id; }
    public String getUsername() { return username; }
    public String getPassword() { return password; }
    public String getRole() { return role; }
    
    // Setters
    public void setId(Long id) { this.id = id; }
    public void setUsername(String username) { this.username = username; }
    public void setPassword(String password) { this.password = password; }
    public void setRole(String role) { this.role = role; }
    
    // toString()
    @Override
    public String toString() {
        return "Conserje{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", password='" + password + '\'' +
                ", role='" + role + '\'' +
                '}';
    }
    
    // equals()
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Conserje conserje = (Conserje) o;
        return Objects.equals(id, conserje.id) &&
               Objects.equals(username, conserje.username) &&
               Objects.equals(password, conserje.password) &&
               Objects.equals(role, conserje.role);
    }
    
    // hashCode()
    @Override
    public int hashCode() {
        return Objects.hash(id, username, password, role);
    }
    
    // Builder (versión simplificada)
    public static ConserjeBuilder builder() {
        return new ConserjeBuilder();
    }
    
    public static class ConserjeBuilder {
        private Long id;
        private String username;
        private String password;
        private String role;
        
        public ConserjeBuilder id(Long id) {
            this.id = id;
            return this;
        }
        
        public ConserjeBuilder username(String username) {
            this.username = username;
            return this;
        }
        
        public ConserjeBuilder password(String password) {
            this.password = password;
            return this;
        }
        
        public ConserjeBuilder role(String role) {
            this.role = role;
            return this;
        }
        
        public Conserje build() {
            return new Conserje(id, username, password, role);
        }
    }
    
    // UserDetails methods
    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of(new SimpleGrantedAuthority(this.role));
    }
    
    @Override
    public boolean isAccountNonExpired() { return true; }
    
    @Override
    public boolean isAccountNonLocked() { return true; }
    
    @Override
    public boolean isCredentialsNonExpired() { return true; }
    
    @Override
    public boolean isEnabled() { return true; }
}
```

**Reducción: ~75% menos código! 🚀**

---

## 🎓 Cuándo Usar Cada Anotación

| Anotación | Usar Cuando... | No Usar Cuando... |
|-----------|----------------|-------------------|
| `@Data` | Necesitas getters/setters/toString | Quieres controlar qué métodos generar |
| `@NoArgsConstructor` | Trabajas con JPA/Hibernate | No hay caso donde no usarla con entidades |
| `@AllArgsConstructor` | Quieres constructor completo | Prefieres Builder solo |
| `@Builder` | Tienes muchos campos | La clase es muy simple (<3 campos) |
| `@RequiredArgsConstructor` | Inyección de dependencias | No tienes campos final |
| `@Slf4j` | Necesitas logging | No necesitas logs |

---

## ⚠️ Consideraciones Importantes

### **1. Lombok y tu IDE**

Para que funcione correctamente:
- **IntelliJ IDEA:** Instalar plugin "Lombok"
- **Eclipse:** Instalar Lombok siguiendo instrucciones en projectlombok.org
- **VS Code:** Extensión "Lombok Annotations Support for VS Code"

### **2. @Data y JPA**

```java
@Data  // ⚠️ Cuidado con equals/hashCode en entidades
@Entity
public class Conserje {
    // Mejor usar @EqualsAndHashCode(onlyExplicitlyIncluded = true)
    @EqualsAndHashCode.Include
    private Long id;
}
```

### **3. Evita @ToString en relaciones bidireccionales**

```java
@Data  // ⚠️ Puede causar StackOverflowError
@Entity
public class Usuario {
    @OneToMany
    private List<Pedido> pedidos;  // Si Pedido tiene @ManyToOne Usuario
}

// Solución:
@ToString(exclude = "pedidos")
```

---

## 🔍 Debugging de Código Lombok

### Ver el código generado:

**En IntelliJ IDEA:**
1. `View` → `Tool Windows` → `Structure`
2. Verás todos los métodos generados

**Desde terminal:**
```bash
javac -d output src/Conserje.java
javap -p output/Conserje.class
```

**Plugin Delombok:**
```bash
mvn lombok:delombok
```

---

## 📚 Resumen de Beneficios

✅ **Menos código** → Más fácil de leer
✅ **Menos errores** → Código generado es correcto
✅ **Mantenimiento simple** → Cambias un campo, todo se actualiza
✅ **Estándar en la industria** → Usado por millones de desarrolladores
✅ **Compatible con Spring** → Funciona perfectamente con inyección de dependencias

---

## 🎯 Ejemplo Práctico Completo

```java
// ============================================
// EJEMPLO: Crear y guardar un Conserje
// ============================================

@Service
@RequiredArgsConstructor  // ← Inyecta repository
@Slf4j                    // ← Genera logger
public class ConserjeService {
    
    private final ConserjeRepository repository;
    private final PasswordEncoder encoder;
    
    public Conserje crear(String username, String password) {
        log.info("Creando conserje: {}", username);  // ← @Slf4j
        
        // ← @Builder
        Conserje conserje = Conserje.builder()
            .username(username)
            .password(encoder.encode(password))
            .role("ROLE_CONSERJE")
            .build();
        
        Conserje saved = repository.save(conserje);
        
        log.info("Conserje creado: {}", saved);  // ← @Data genera toString()
        
        return saved;
    }
}
```

---

**🎉 ¡Lombok hace tu código más limpio y profesional! 🎉**

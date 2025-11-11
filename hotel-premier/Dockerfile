# ========================================
# Etapa 1: Build (para producción)
# ========================================
FROM maven:3.9.6-eclipse-temurin-21-alpine AS build

WORKDIR /app

# Copiar archivos de configuración de Maven
COPY pom.xml .
COPY mvnw .
COPY .mvn .mvn

# Descargar dependencias (cache layer)
RUN mvn dependency:go-offline -B

# Copiar código fuente
COPY src ./src

# Compilar la aplicación
RUN mvn clean package -DskipTests

# ========================================
# Etapa 2: Development (con hot-reload)
# ========================================
FROM maven:3.9.6-eclipse-temurin-21-alpine AS development

WORKDIR /app

# Copiar archivos de configuración de Maven
COPY pom.xml .
COPY mvnw .
COPY .mvn .mvn

# Descargar dependencias
RUN mvn dependency:go-offline -B

# Crear directorio de logs
RUN mkdir -p /app/logs

# Exponer el puerto de la aplicación
EXPOSE 8080

# El código fuente se monta como volumen en docker-compose
# Ejecutar con Spring Boot Maven Plugin para hot-reload
CMD ["mvn", "spring-boot:run", "-Dspring-boot.run.jvmArguments='-Dspring.devtools.restart.enabled=true'"]

# ========================================
# Etapa 3: Runtime (para producción)
# ========================================
FROM eclipse-temurin:21-jre-alpine AS production

WORKDIR /app

# Crear usuario no privilegiado
RUN addgroup -S spring && adduser -S spring -G spring

# Crear directorio de logs
RUN mkdir -p /app/logs && chown -R spring:spring /app/logs

USER spring:spring

# Copiar el JAR compilado desde la etapa de build
COPY --from=build /app/target/*.jar app.jar

# Exponer el puerto de la aplicación
EXPOSE 8080

# Comando para ejecutar la aplicación
ENTRYPOINT ["java", "-jar", "app.jar"]

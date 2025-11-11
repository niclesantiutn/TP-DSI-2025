# Script de utilidades para desarrollo con Docker
# Uso: .\docker-dev.ps1 [comando]

param(
    [Parameter(Position=0)]
    [string]$Command = "help"
)

$Profile = "dev"

function Show-Help {
    Write-Host ""
    Write-Host "🐳 Hotel Premier - Docker Development Helper" -ForegroundColor Cyan
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Comandos disponibles:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  start              " -NoNewline
    Write-Host "Iniciar todos los servicios" -ForegroundColor Gray
    Write-Host "  stop               " -NoNewline
    Write-Host "Detener servicios (conserva datos)" -ForegroundColor Gray
    Write-Host "  restart            " -NoNewline
    Write-Host "Reiniciar hotel-premier" -ForegroundColor Gray
    Write-Host "  rebuild            " -NoNewline
    Write-Host "Reconstruir hotel-premier" -ForegroundColor Gray
    Write-Host "  logs               " -NoNewline
    Write-Host "Ver logs de hotel-premier" -ForegroundColor Gray
    Write-Host "  logs-all           " -NoNewline
    Write-Host "Ver logs de todos los servicios" -ForegroundColor Gray
    Write-Host "  status             " -NoNewline
    Write-Host "Ver estado de servicios" -ForegroundColor Gray
    Write-Host "  clean              " -NoNewline
    Write-Host "⚠️  Limpiar todo (BORRA DATOS)" -ForegroundColor Red
    Write-Host "  clean-app          " -NoNewline
    Write-Host "Limpiar solo hotel-premier" -ForegroundColor Gray
    Write-Host "  reset-db           " -NoNewline
    Write-Host "⚠️  Resetear base de datos" -ForegroundColor Red
    Write-Host "  shell              " -NoNewline
    Write-Host "Abrir shell en contenedor hotel-premier" -ForegroundColor Gray
    Write-Host "  help               " -NoNewline
    Write-Host "Mostrar esta ayuda" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Ejemplos:" -ForegroundColor Yellow
    Write-Host "  .\docker-dev.ps1 start" -ForegroundColor Green
    Write-Host "  .\docker-dev.ps1 logs" -ForegroundColor Green
    Write-Host "  .\docker-dev.ps1 rebuild" -ForegroundColor Green
    Write-Host ""
}

function Start-Services {
    Write-Host "🚀 Iniciando servicios de desarrollo..." -ForegroundColor Green
    docker-compose --profile $Profile up -d --build
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Servicios iniciados correctamente" -ForegroundColor Green
        Write-Host "📍 Aplicación: http://localhost:8080" -ForegroundColor Cyan
        Write-Host "📍 PgAdmin: http://localhost:5050" -ForegroundColor Cyan
    } else {
        Write-Host "❌ Error al iniciar servicios" -ForegroundColor Red
    }
}

function Stop-Services {
    Write-Host "🛑 Deteniendo servicios..." -ForegroundColor Yellow
    docker-compose --profile $Profile down
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Servicios detenidos (datos conservados)" -ForegroundColor Green
    } else {
        Write-Host "❌ Error al detener servicios" -ForegroundColor Red
    }
}

function Restart-App {
    Write-Host "🔄 Reiniciando hotel-premier..." -ForegroundColor Yellow
    docker-compose --profile $Profile restart hotel-premier
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ hotel-premier reiniciado" -ForegroundColor Green
    } else {
        Write-Host "❌ Error al reiniciar hotel-premier" -ForegroundColor Red
    }
}

function Rebuild-App {
    Write-Host "🔨 Reconstruyendo hotel-premier..." -ForegroundColor Yellow
    docker-compose --profile $Profile up -d --build hotel-premier
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ hotel-premier reconstruido" -ForegroundColor Green
    } else {
        Write-Host "❌ Error al reconstruir hotel-premier" -ForegroundColor Red
    }
}

function Show-Logs {
    Write-Host "📋 Mostrando logs de hotel-premier..." -ForegroundColor Cyan
    Write-Host "Presiona Ctrl+C para salir" -ForegroundColor Gray
    Write-Host ""
    docker-compose --profile $Profile logs -f hotel-premier
}

function Show-AllLogs {
    Write-Host "📋 Mostrando logs de todos los servicios..." -ForegroundColor Cyan
    Write-Host "Presiona Ctrl+C para salir" -ForegroundColor Gray
    Write-Host ""
    docker-compose --profile $Profile logs -f
}

function Show-Status {
    Write-Host "📊 Estado de servicios:" -ForegroundColor Cyan
    docker-compose --profile $Profile ps
    Write-Host ""
    Write-Host "💾 Volúmenes:" -ForegroundColor Cyan
    docker volume ls | Select-String "tp-dsi-2025"
}

function Clean-All {
    Write-Host "⚠️  ADVERTENCIA: Esto borrará todos los datos de la base de datos" -ForegroundColor Red
    $confirmation = Read-Host "¿Estás seguro? (escribe 'SI' para confirmar)"
    if ($confirmation -eq "SI") {
        Write-Host "🧹 Limpiando todo..." -ForegroundColor Yellow
        docker-compose --profile $Profile down -v
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Todo limpiado (datos borrados)" -ForegroundColor Green
        } else {
            Write-Host "❌ Error al limpiar" -ForegroundColor Red
        }
    } else {
        Write-Host "❌ Operación cancelada" -ForegroundColor Yellow
    }
}

function Clean-App {
    Write-Host "🧹 Limpiando hotel-premier..." -ForegroundColor Yellow
    docker-compose --profile $Profile rm -f -s -v hotel-premier
    docker-compose --profile $Profile build --no-cache hotel-premier
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ hotel-premier limpiado" -ForegroundColor Green
    } else {
        Write-Host "❌ Error al limpiar hotel-premier" -ForegroundColor Red
    }
}

function Reset-Database {
    Write-Host "⚠️  ADVERTENCIA: Esto borrará todos los datos de la base de datos" -ForegroundColor Red
    $confirmation = Read-Host "¿Estás seguro? (escribe 'SI' para confirmar)"
    if ($confirmation -eq "SI") {
        Write-Host "🗃️  Reseteando base de datos..." -ForegroundColor Yellow
        docker-compose --profile $Profile stop postgres-db
        docker volume rm tp-dsi-2025_postgres_dev_data
        docker-compose --profile $Profile up -d postgres-db
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Base de datos reseteada" -ForegroundColor Green
        } else {
            Write-Host "❌ Error al resetear base de datos" -ForegroundColor Red
        }
    } else {
        Write-Host "❌ Operación cancelada" -ForegroundColor Yellow
    }
}

function Open-Shell {
    Write-Host "🐚 Abriendo shell en hotel-premier..." -ForegroundColor Cyan
    Write-Host "Escribe 'exit' para salir" -ForegroundColor Gray
    Write-Host ""
    docker-compose --profile $Profile exec hotel-premier /bin/sh
}

# Ejecutar comando
switch ($Command.ToLower()) {
    "start" { Start-Services }
    "stop" { Stop-Services }
    "restart" { Restart-App }
    "rebuild" { Rebuild-App }
    "logs" { Show-Logs }
    "logs-all" { Show-AllLogs }
    "status" { Show-Status }
    "clean" { Clean-All }
    "clean-app" { Clean-App }
    "reset-db" { Reset-Database }
    "shell" { Open-Shell }
    "help" { Show-Help }
    default {
        Write-Host "❌ Comando no reconocido: $Command" -ForegroundColor Red
        Write-Host ""
        Show-Help
    }
}

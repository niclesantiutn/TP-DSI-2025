package com.losmergeconflicts.hotelpremier.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.losmergeconflicts.hotelpremier.dto.HuespedDTORequest;
import com.losmergeconflicts.hotelpremier.dto.HuespedDTOResponse;
import com.losmergeconflicts.hotelpremier.service.GestorPersonas;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.extern.slf4j.Slf4j;

/**
 * Controlador REST para gestionar peticiones HTTP de gestión de personas.
 * 
 * @RestController: Indica que es un controlador REST (retorna JSON)
 * @Slf4j: Genera logger automático para la clase
 */
@RestController
@RequestMapping("/api/personas")
@Slf4j
@Tag(name = "Gestión de Personas", description = "Endpoints para gestión de personas")
public class PersonaController {

    private final GestorPersonas gestorPersonas;

    @Autowired
    public PersonaController(GestorPersonas gestorPersonas) {
        this.gestorPersonas = gestorPersonas;
    }

    /**
     * Registra un nuevo huésped en el sistema.
     * 
     * @param request DTO con los datos del huésped
     * @return ResponseEntity con el huésped registrado
     */
    @Operation(summary = "Alta de un nuevo huésped",
                description = "Permite dar de alta un nuevo huésped en el sistema.",
                responses = {
                    @ApiResponse(responseCode = "201", description = "Huésped dado de alta correctamente"),
                    @ApiResponse(responseCode = "400", description = "Error de validación en los datos"),
                    @ApiResponse(responseCode = "500", description = "Error interno del servidor")
                })
    @PostMapping("/huesped/alta")
    public ResponseEntity<HuespedDTOResponse> altaHuesped(@Valid @RequestBody HuespedDTORequest request) {
        HuespedDTOResponse nuevoHuesped = gestorPersonas.altaHuesped(request);
        return new ResponseEntity<>(nuevoHuesped, HttpStatus.CREATED);
    }

}

package com.losmergeconflicts.hotelpremier.service;

import com.losmergeconflicts.hotelpremier.dto.HuespedDTORequest;
import com.losmergeconflicts.hotelpremier.dto.HuespedDTOResponse;
import com.losmergeconflicts.hotelpremier.entity.TipoDocumento;

/**
 * Interfaz del servicio de personas.
 * 
 * Define los métodos relacionados con la gestión de personas.
 */
public interface GestorPersonas {

    /**
     * Dar de alta un nuevo huésped en el sistema.
     * 
     * @param request DTO con los datos del huésped (ya validados por @Valid)
     * @return DTO de respuesta con los datos del huésped dado de alta
     * @throws IllegalArgumentException si el tipo y número de documento ya existen o si no se encuentran las entidades relacionadas
     */
    HuespedDTOResponse altaHuesped(HuespedDTORequest request);

    /**
     * Verifica si un tipo y número de documento ya están registrados.
     * 
     * @param tipoDocumento tipo de documento (DNI, PASAPORTE, etc.)
     * @param documento número de documento a verificar
     * @return true si el tipo y documento existen, false si no
     */
    boolean existeDocumento(TipoDocumento tipoDocumento, String documento);

}
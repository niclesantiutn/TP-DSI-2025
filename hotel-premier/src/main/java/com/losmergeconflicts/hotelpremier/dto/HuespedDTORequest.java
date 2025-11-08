package com.losmergeconflicts.hotelpremier.dto;

import java.time.LocalDate;

import com.losmergeconflicts.hotelpremier.entity.PosicionFrenteAlIVA;
import com.losmergeconflicts.hotelpremier.entity.TipoDocumento;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Past;
import jakarta.validation.constraints.Size;

public record HuespedDTORequest(
    @Size(max = 10, message = "El CUIT no puede exceder los 10 caracteres")
    @NotBlank(message = "El CUIT no puede estar vacío")
    String cuit,
    @Size(max = 30, message = "El teléfono no puede exceder los 30 caracteres")
    @NotBlank(message = "El teléfono no puede estar vacío")
    String telefono,
    @Size(max = 100, message = "La info no puede exceder los 100 caracteres")
    @NotBlank(message = "La info no puede estar vacío")
    String info,
    @Size(max = 100, message = "La calle no puede exceder los 100 caracteres")
    @NotBlank(message = "La calle no puede estar vacío")
    String calle,
    @Size(max = 10, message = "El número no puede exceder los 10 caracteres")
    @NotBlank(message = "El número no puede estar vacío")
    String numero,
    @Size(max = 10, message = "El piso no puede exceder los 10 caracteres")
    @NotBlank(message = "El piso no puede estar vacío")
    String piso,
    @Size(max = 10, message = "El departamento no puede exceder los 10 caracteres")
    @NotBlank(message = "El departamento no puede estar vacío")
    String departamento,
    @Size(max = 10, message = "El código postal no puede exceder los 10 caracteres")
    @NotBlank(message = "El código postal no puede estar vacío")
    String codigoPostal,
    Long localidadId,
    @Size(max = 100, message = "El nombre no puede exceder los 100 caracteres")
    @NotBlank(message = "El nombre no puede estar vacío")
    String nombre,
    @Size(max = 100, message = "El apellido no puede exceder los 100 caracteres")
    @NotBlank(message = "El apellido no puede estar vacío")
    String apellido,
    @NotNull(message = "El tipo de documento no puede ser nulo")
    TipoDocumento tipoDocumento,
    @Size(max = 10, message = "El documento no puede exceder los 10 caracteres")
    @NotBlank(message = "El documento no puede estar vacío")
    String documento,
    @Past(message = "La fecha de nacimiento debe ser una fecha pasada")
    @NotNull(message = "La fecha de nacimiento no puede ser nula")
    LocalDate fechaNacimiento,
    @Size(max = 100, message = "El email no puede exceder los 100 caracteres")
    String email,
    @Size(max = 100, message = "La ocupación no puede exceder los 100 caracteres")
    @NotBlank(message = "La ocupación no puede estar vacío")
    String ocupacion,
    @NotNull(message = "La posición frente al IVA no puede ser nula")
    PosicionFrenteAlIVA posicionFrenteAlIVA,
    Long nacionalidadId
) {
}

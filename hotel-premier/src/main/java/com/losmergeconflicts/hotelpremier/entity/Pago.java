package com.losmergeconflicts.hotelpremier.entity;

import java.time.LocalDate;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "pagos")
@Data  // Genera getters, setters, toString, equals y hashCode
@NoArgsConstructor  // Genera constructor sin argumentos (requerido por JPA)
@AllArgsConstructor  // Genera constructor con todos los argumentos
@Builder  // Implementa el patrón Builder para construcción fluida de objetos
public class Pago {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private LocalDate fechaCobro;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TipoMoneda moneda;

    @Column(nullable = false)
    private Float importe;

    private Float cotizacion;

    @OneToOne
    @JoinColumn(name = "factura_id", nullable = false)
    private Factura factura;

    @OneToOne
    @JoinColumn(name = "medio_de_pago_id", nullable = false)
    private MedioDePago medioDePago;
}

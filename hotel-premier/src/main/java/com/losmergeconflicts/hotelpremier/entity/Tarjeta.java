package com.losmergeconflicts.hotelpremier.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Entity
@Table(name = "tarjetas")
@Getter
@Setter
@NoArgsConstructor  // Genera constructor sin argumentos (requerido por JPA)
@AllArgsConstructor  // Genera constructor con todos los argumentos
@EqualsAndHashCode(callSuper = true)  // Incluye los campos de MedioDePago en equals/hashCode
@ToString(callSuper = true)  // Incluye los campos de MedioDePago en toString
public class Tarjeta extends MedioDePago {
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 10)
    private RedDePago redDePago;

    @ManyToOne
    @JoinColumn(name = "banco_id", nullable = false)
    private Banco bancoEmisor;

}

package com.levelog.arena.domain;

import jakarta.persistence.*;
import java.time.OffsetDateTime;

@Entity
@Table(name = "attributes")
public class Attributes {
    @Id
    private java.util.UUID userId;
    private int str;
    @Column(name = "int_")
    private int intStat;
    private int vit;
    private OffsetDateTime updatedAt;
    // getters/setters...
}

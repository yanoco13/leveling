package com.levelog.arena.domain;

import jakarta.persistence.*;
import java.util.UUID;

@Entity
@Table(name = "attributes")
public class Attributes {
    @Id
    private java.util.UUID userId;
    @Column(name = "int_")
    private int intStat;
    // getters/setters...

    public UUID getUserId() {
        return userId;
    }
}

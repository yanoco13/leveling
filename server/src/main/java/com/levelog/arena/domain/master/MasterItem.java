package com.levelog.arena.domain.master;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "master_item")
public class MasterItem {

    @Id
    @GeneratedValue
    private Long id;

    @Column(name = "master_type_id")
    private Long masterTypeId;

    private String code;
    private String labelJa;
    private String labelEn;
    private Integer sortOrder;
    private Boolean isActive;

    @Column(columnDefinition = "jsonb")
    private String attributes; // まずは String でOK

    // getter
    public Long getId() {
        return id;
    }

    public Long getMasterTypeId() {
        return masterTypeId;
    }

    public String getCode() {
        return code;
    }

    public String getLabelJa() {
        return labelJa;
    }

    public String getLabelEn() {
        return labelEn;
    }

    public Integer getSortOrder() {
        return sortOrder;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public String getAttributes() {
        return attributes;
    }

    // setter
    public void setId(Long id) {
        this.id = id;
    }

    public void setMasterTypeId(Long masterTypeId) {
        this.masterTypeId = masterTypeId;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public void setLabelJa(String labelJa) {
        this.labelJa = labelJa;
    }

    public void setLabelEn(String labelEn) {
        this.labelEn = labelEn;
    }

    public void setSortOrder(Integer sortOrder) {
        this.sortOrder = sortOrder;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

    public void setAttributes(String attributes) {
        this.attributes = attributes;
    }

}


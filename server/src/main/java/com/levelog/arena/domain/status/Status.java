package com.levelog.arena.domain.status;

import java.time.ZonedDateTime;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "status")
public class Status {

    @Id
    private String userId;
    private Integer str; // 力
    private Integer agi; // 速さ
    private Integer vit; // 体力
    private Integer intel; // 知力
    private Integer dex; // 器用さ
    private Integer cha; // 魅力
    private Integer luk; // 運
    private Boolean isDeleteFlg = false;
    private ZonedDateTime createTime = ZonedDateTime.now();
    private ZonedDateTime updateTime = ZonedDateTime.now();

    public Status() {}

    public Status(String userId, Integer str, Integer agi, Integer vit, Integer intel, Integer dex,
            Integer cha, Integer luk, Boolean isDeleteFlg) {
        this.userId = userId;
        this.str = str;
        this.agi = agi;
        this.vit = vit;
        this.intel = intel;
        this.dex = dex;
        this.cha = cha;
        this.luk = luk;
        this.isDeleteFlg = isDeleteFlg;
    }

    // getter
    public String getUserId() {
        return userId;
    }

    public Integer getStr() {
        return str;
    }

    public Integer getAgi() {
        return agi;
    }

    public Integer getVit() {
        return vit;
    }

    public Integer getIntel() {
        return intel;
    }

    public Integer getDex() {
        return dex;
    }

    public Integer getCha() {
        return cha;
    }

    public Integer getLuk() {
        return luk;
    }

    public Boolean getIsDeleteFlg() {
        return isDeleteFlg;
    }

    public ZonedDateTime getCreateTime() {
        return createTime;
    }

    public ZonedDateTime getUpdateTime() {
        return updateTime;
    }

    // setter
    public void setStr(Integer str) {
        this.str = str;
    }

    public void setAgi(Integer agi) {
        this.agi = agi;
    }

    public void setVit(Integer vit) {
        this.vit = vit;
    }

    public void setIntel(Integer intel) {
        this.intel = intel;
    }

    public void setDex(Integer dex) {
        this.dex = dex;
    }

    public void setCha(Integer cha) {
        this.cha = cha;
    }

    public void setLuk(Integer luk) {
        this.luk = luk;
    }

    public void setIsDeleteFlg(Boolean isDeleteFlg) {
        this.isDeleteFlg = isDeleteFlg;
    }
}

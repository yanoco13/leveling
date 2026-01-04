package com.levelog.arena.domain.status;

import java.time.ZonedDateTime;
import com.levelog.arena.domain.reward.Reward;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;

@Entity
@Table(name = "status")
public class Status {

    @Id
    @Column(name = "user_id")
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

    private int nz(Integer v) {
        return v == null ? 0 : v;
    }

    public void addStr(int delta) {
        this.str = nz(this.str) + delta;
    }

    public void addIntel(int delta) {
        this.intel = nz(this.intel) + delta;
    }

    public void addAgi(int delta) {
        this.agi = nz(this.agi) + delta;
    }

    public void addDex(int delta) {
        this.dex = nz(this.dex) + delta;
    }

    public void addVit(int delta) {
        this.vit = nz(this.vit) + delta;
    }

    public void addCha(int delta) {
        this.cha = nz(this.cha) + delta;
    }

    public void addLuk(int delta) {
        this.luk = nz(this.luk) + delta;
    }

    @PrePersist
    void onCreate() {
        createTime = ZonedDateTime.now();
        updateTime = createTime;
    }


    @PreUpdate
    void onUpdate() {
        updateTime = ZonedDateTime.now();
    }

    public void applyReward(Reward r) {
        this.str = nz(this.str) + r.str();
        this.agi = nz(this.agi) + r.agi();
        this.vit = nz(this.vit) + r.vit();
        this.intel = nz(this.intel) + r.intel();
        this.dex = nz(this.dex) + r.dex();
        this.cha = nz(this.cha) + r.cha();
        this.luk = nz(this.luk) + r.luk();
    }
}

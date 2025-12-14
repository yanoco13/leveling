package com.levelog.arena.domain.status;

import com.levelog.arena.domain.status.dto.StatusReponse;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.levelog.arena.repo.StatusRepo;

@Service
public class StatusService {

    private final StatusRepo repo;

    public StatusService(StatusRepo repo) {
        this.repo = repo;
    }

    /**
     * ステータス取得（なければ初期作成して返す）
     */
    @Transactional
    public StatusReponse getOrCreate(String userId) {
        Status status = repo.findById(userId).orElseGet(() -> repo.save(new Status()));
        return toDto(status);
    }

    /**
     * ステータス更新（null は変更しない）
     */
    @Transactional
    public StatusReponse update(String userId, Integer str, Integer intel, Integer dex, Integer luk,
            Integer cha, Integer vit, Integer agi) {
        Status status = repo.findById(userId).orElseGet(() -> new Status());

        if (str != null)
            status.setStr(str);
        if (intel != null)
            status.setIntel(intel);
        if (dex != null)
            status.setDex(dex);
        if (luk != null)
            status.setLuk(luk);
        if (cha != null)
            status.setCha(cha);
        if (vit != null)
            status.setVit(vit);
        if (agi != null)
            status.setAgi(agi);

        // 削除フラグは更新では触らない（必要なら別メソッド）
        status = repo.save(status);
        return toDto(status);
    }

    /**
     * 論理削除
     */
    @Transactional
    public void softDelete(String userId) {
        Status status = repo.findById(userId).orElseThrow(
                () -> new IllegalArgumentException("user_status not found: " + userId));
        status.setIsDeleteFlg(true);
        repo.save(status);
    }

    private StatusReponse toDto(Status s) {
        return new StatusReponse(s.getUserId(), s.getStr(), s.getIntel(), s.getDex(), s.getLuk(),
                s.getCha(), s.getVit(), s.getAgi(), s.getIsDeleteFlg());
    }
}

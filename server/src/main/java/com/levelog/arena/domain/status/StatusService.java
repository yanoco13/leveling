package com.levelog.arena.domain.status;

import com.levelog.arena.domain.status.dto.StatusReponse;
import java.util.Optional;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.levelog.arena.repo.StatusRepo;

@Service
public class StatusService {

    private final StatusRepo repo;

    public StatusService(StatusRepo repo) {
        this.repo = repo;
    }

    private Status newInitial(String userId) {
        return new Status(userId, 0, 0, 0, 0, 0, 0, 0, false);
    }

    @Transactional
    public Status getOrCreateEntity(String userId) {
        return repo.findById(userId).orElseGet(() -> repo.save(newInitial(userId)));
    }


    /** ステータス取得（なければ初期作成して返す） */
    @Transactional
    public StatusReponse getOrCreate(String userId) {
        Status status = repo.findById(userId).orElseGet(() -> {
            Status s = new Status(userId, 0, 0, 0, 0, 0, 0, 0, false);
            return repo.save(s);
        });
        return toDto(status);
    }

    /** ステータス更新（null は変更しない） */
    @Transactional
    public StatusReponse update(String userId, Integer str, Integer intel, Integer dex, Integer luk,
            Integer cha, Integer vit, Integer agi) {
        Status status = getOrCreateEntity(userId); // 既存 or 初回作成

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

        // ここは save しなくても更新される（dirty checking）
        return toDto(status);
    }


    @Transactional
    public void softDelete(String userId) {
        Status status = repo.findById(userId).orElseThrow(
                () -> new IllegalArgumentException("user_status not found: " + userId));
        status.setIsDeleteFlg(true);
        // repo.save(status); // これも dirty checking でOK
    }

    private StatusReponse toDto(Status s) {
        return new StatusReponse(s.getUserId(), s.getStr(), s.getIntel(), s.getDex(), s.getLuk(),
                s.getCha(), s.getVit(), s.getAgi(), s.getIsDeleteFlg());
    }

    // @Transactional
    // public Status getOrCreateEntity(String userId) {
    // return repo.findById(userId).orElseGet(() -> {
    // Status s = new Status(userId, 0, 0, 0, 0, 0, 0, 0, false);
    // return repo.save(s); // 作成はここだけ
    // });
    // }

    // @Transactional
    // public Status getOrCreateEntity(String userId) {
    // Optional<Status> found = repo.findById(userId);

    // return found.orElseGet(() -> {
    // Status s = new Status(userId, 0, 0, 0, 0, 0, 0, 0, false);
    // return repo.save(s);
    // });
    // }
}

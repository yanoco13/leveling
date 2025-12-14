package com.levelog.arena.domain.status.dto;

public record CreateStatusRequest (String userId, Integer str, Integer intel, Integer dex, Integer luk,
        Integer cha, Integer vit, Integer agi, Boolean isDeleteFlg){
    
}

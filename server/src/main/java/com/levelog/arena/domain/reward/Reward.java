package com.levelog.arena.domain.reward;

public record Reward(int str, int agi, int vit, int intel, int dex, int cha, int luk) {
    public static Reward zero() {
        return new Reward(0, 0, 0, 0, 0, 0, 0);
    }
}


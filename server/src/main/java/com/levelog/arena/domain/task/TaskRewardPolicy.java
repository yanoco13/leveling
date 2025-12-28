package com.levelog.arena.domain.task;

import org.springframework.stereotype.Service;
import com.levelog.arena.domain.reward.Reward;

@Service
public class TaskRewardPolicy {

    public Reward calculate(Task task) {
        long minutes = calcMinutes(task);

        // 例：30分ごとに1pt（最低1pt、最大10pt）
        int base = (int) Math.min(10, Math.max(1, (minutes + 29) / 30));

        return switch (task.getCategory()) {
            case "study" -> new Reward(0, 0, 0, base, 0, 0, 0); // 勉強→intel
            case "workout" -> new Reward(base, 0, base, 0, 0, 0, 0); // 筋トレ→str+vit
            case "dev" -> new Reward(0, 0, 0, base, base / 2, 0, 0); // 開発→intel+dex
            default -> Reward.zero(); // 未対応カテゴリは加算しない等
        };
    }

    private long calcMinutes(Task task) {
        if (task.getStartDate() == null || task.getEndDate() == null)
            return 0;
        if (task.getEndDate().isBefore(task.getStartDate()))
            return 0; // ルール次第で例外でもOK
        return java.time.Duration.between(task.getStartDate(), task.getEndDate()).toMinutes();
    }
}

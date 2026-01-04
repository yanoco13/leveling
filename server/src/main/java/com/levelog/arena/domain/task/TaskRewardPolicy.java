package com.levelog.arena.domain.task;

import java.util.Random;
import org.springframework.stereotype.Service;
import com.levelog.arena.domain.reward.Reward;

@Service
public class TaskRewardPolicy {

    public Reward calculate(Task task) {
        long minutes = calcMinutes(task);

        // 例：30分ごとに1pt（最低1pt、最大10pt）
        int base = (int) Math.min(10, Math.max(1, (minutes + 29) / 30));
        Random rand = new Random();
        int luck = rand.nextInt(100) + base / 10;
        System.out.println("calc reward base=" + task.getCategory());
        return switch (task.getCategory()) {
            case "筋トレ" -> new Reward(base, base / 3, base / 3, base / 6, base / 8, base / 9, luck);
            case "仕事" -> new Reward(0, 0, base / 4, base / 5, 0, base / 5, luck);
            case "趣味" -> new Reward(0, 0, base, base / 5, base / 5, base / 2, luck);
            case "勉強" -> new Reward(0, 0, 0, base, 0, base / 8, luck);
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

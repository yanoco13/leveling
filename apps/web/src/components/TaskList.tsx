'use client';
import { useEffect, useState } from 'react';
import { apiFetch } from '@/lib/api';

type Task = { id: string; title: string; category: string; createdAt: string };

export default function TaskList({ reload }: { reload: boolean }) {
    const [tasks, setTasks] = useState<Task[]>([]);

    useEffect(() => {
        apiFetch('/api/tasks')
            .then(setTasks)
            .catch(console.error);
    }, [reload]);

    return (
        <ul className="space-y-2 mt-4">
            {tasks.map((t) => (
                <li key={t.id} className="border p-3 rounded-lg bg-white shadow-sm">
                    <div className="font-semibold">{t.title}</div>
                    <div className="text-sm text-gray-500">{t.category}</div>
                </li>
            ))}
        </ul>
    );
}

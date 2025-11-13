'use client';
import { useState } from 'react';
import TaskForm from '@/components/TaskForm';
import TaskList from '@/components/TaskList';

export default function TasksPage() {
    const [reloadFlag, setReloadFlag] = useState(false);
    const refresh = () => setReloadFlag(!reloadFlag);

    return (
        <div className="max-w-2xl mx-auto p-6 space-y-4">
            <h1 className="text-2xl font-bold mb-2">タスク一覧</h1>
            <TaskForm onCreated={refresh} />
            <TaskList reload={reloadFlag} />
        </div>
    );
}

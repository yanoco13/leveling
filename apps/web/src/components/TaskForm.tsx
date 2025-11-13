'use client';
import { useState } from 'react';
import { apiFetch } from '@/lib/api';

export default function TaskForm({ onCreated }: { onCreated: () => void }) {
    const [title, setTitle] = useState('');
    const [category, setCategory] = useState('other');
    const [loading, setLoading] = useState(false);

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!title.trim()) return;
        setLoading(true);
        try {
            await apiFetch('/api/tasks', {
                method: 'POST',
                body: JSON.stringify({ title, category }),
            });
            setTitle('');
            onCreated();
        } finally {
            setLoading(false);
        }
    };

    return (
        <form onSubmit={handleSubmit} className="flex gap-2 bg-white p-4 rounded-xl shadow">
            <input
                value={title}
                onChange={(e) => setTitle(e.target.value)}
                placeholder="新しいタスク..."
                className="flex-1 border p-2 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
            <select
                value={category}
                onChange={(e) => setCategory(e.target.value)}
                className="border p-2 rounded"
            >
                <option value="health">健康</option>
                <option value="study">学習</option>
                <option value="work">仕事</option>
                <option value="life">生活</option>
                <option value="other">その他</option>
            </select>
            <button
                disabled={loading}
                className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 disabled:opacity-50"
            >
                追加
            </button>
        </form>
    );
}

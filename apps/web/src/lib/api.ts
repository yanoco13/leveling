export async function apiFetch(path: string, init: RequestInit = {}) {
  const headers = new Headers(init.headers);
  headers.set('Content-Type', 'application/json');

  const res = await fetch(`http://localhost:8080${path}`, { ...init, headers });
  if (!res.ok) throw new Error(await res.text());
  return res.json();
}

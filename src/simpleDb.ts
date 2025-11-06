export type SelectAllSnapshot = {
  text: string
  timestamp: number
}

const KEY = 'my_rime_select_all_history'

const API_HISTORY = '/api/history'

export async function appendSelectAllSnapshot (text: string): Promise<void> {
  if (!text) return
  // Try server first
  try {
    await fetch(API_HISTORY, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ text })
    })
    try { globalThis.dispatchEvent(new CustomEvent('select-all-snapshots-changed')) } catch {}
    return
  } catch {}
  // Fallback to localStorage if server not reachable
  try {
    const raw = localStorage.getItem(KEY)
    const arr: SelectAllSnapshot[] = raw ? JSON.parse(raw) : []
    arr.push({ text, timestamp: Date.now() })
    localStorage.setItem(KEY, JSON.stringify(arr))
    try { globalThis.dispatchEvent(new CustomEvent('select-all-snapshots-changed')) } catch {}
  } catch {}
}

export async function getSelectAllSnapshots (): Promise<SelectAllSnapshot[]> {
  // Try server first
  try {
    const res = await fetch(API_HISTORY, { method: 'GET' })
    if (res.ok) {
      const data = await res.json()
      return Array.isArray(data) ? data as SelectAllSnapshot[] : []
    }
  } catch {}
  // Fallback
  try {
    const raw = localStorage.getItem(KEY)
    return raw ? JSON.parse(raw) : []
  } catch {
    return []
  }
}

export async function clearSelectAllSnapshots (): Promise<void> {
  // Try server first
  try {
    await fetch(API_HISTORY, { method: 'DELETE' })
    try { globalThis.dispatchEvent(new CustomEvent('select-all-snapshots-changed')) } catch {}
    return
  } catch {}
  // Fallback
  try {
    localStorage.removeItem(KEY)
    try { globalThis.dispatchEvent(new CustomEvent('select-all-snapshots-changed')) } catch {}
  } catch {}
}
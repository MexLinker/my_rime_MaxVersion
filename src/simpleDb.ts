export type SelectAllSnapshot = {
  text: string
  timestamp: number
}

const KEY = 'my_rime_select_all_history'

export function appendSelectAllSnapshot (text: string) {
  if (!text) return
  try {
    const raw = localStorage.getItem(KEY)
    const arr: SelectAllSnapshot[] = raw ? JSON.parse(raw) : []
    arr.push({ text, timestamp: Date.now() })
    localStorage.setItem(KEY, JSON.stringify(arr))
    // Notify listeners (same-tab) that snapshots have changed
    try {
      globalThis.dispatchEvent(new CustomEvent('select-all-snapshots-changed'))
    } catch {}
  } catch (e) {
    // Silently ignore storage errors to avoid affecting typing/selection
  }
}

export function getSelectAllSnapshots (): SelectAllSnapshot[] {
  try {
    const raw = localStorage.getItem(KEY)
    return raw ? JSON.parse(raw) : []
  } catch {
    return []
  }
}

export function clearSelectAllSnapshots () {
  try {
    localStorage.removeItem(KEY)
    try {
      globalThis.dispatchEvent(new CustomEvent('select-all-snapshots-changed'))
    } catch {}
  } catch {}
}
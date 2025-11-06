<script setup lang="ts">
import { NSpace, NButtonGroup, NButton, NIcon, NCheckbox, NCard } from 'naive-ui'
import {
  Cut20Regular,
  Copy20Regular,
  ClipboardLink20Regular
} from '@vicons/fluent'
import { History } from '@vicons/fa'
import { getTextarea } from '../util'
import {
  text,
  loading,
  deployed,
  autoCopy,
  schemaId,
  variant
} from '../control'
import { ref, onMounted, onUnmounted, computed } from 'vue'
import * as simpleDb from '../simpleDb'

const showHistory = ref(true)
const snapshots = ref<simpleDb.SelectAllSnapshot[]>([])
const sortedSnapshots = computed(() => {
  try {
    return [...snapshots.value].sort((a, b) => b.timestamp - a.timestamp)
  } catch {
    return snapshots.value
  }
})

function toggleHistory () {
  if (showHistory.value) {
    showHistory.value = false
  } else {
    showHistory.value = true
  }
}

async function clearHistory () {
  await simpleDb.clearSelectAllSnapshots()
  snapshots.value = []
}

function copy () {
  const textarea = getTextarea()
  textarea.focus()
  return navigator.clipboard.writeText(text.value)
}

async function cut () {
  await copy()
  text.value = ''
}

async function copyLink () {
  const usp = new URLSearchParams({
    schemaId: schemaId.value,
    variantName: variant.value.name
  })
  const url = `${window.location.origin}${window.location.pathname}?${usp}`
  await navigator.clipboard.writeText(url)
  const textarea = getTextarea()
  textarea.focus()
}

async function copySnapshot (t: string) {
  await navigator.clipboard.writeText(t)
  const textarea = getTextarea()
  textarea.focus()
}

async function refreshHistoryList () {
  try {
    snapshots.value = await simpleDb.getSelectAllSnapshots()
  } catch {}
}

let historyPollTimer: number | undefined
onMounted(() => {
  // Poll server for changes to history to auto-refresh UI
  historyPollTimer = window.setInterval(() => {
    refreshHistoryList()
  }, 1000)
  // Initial load
  refreshHistoryList()
})

onUnmounted(() => {
  if (historyPollTimer) {
    clearInterval(historyPollTimer)
    historyPollTimer = undefined
  }
})
</script>

<template>
  <n-space style="align-items: center">
    <n-button-group class="square-group">
      <n-button
        secondary
        @click="cut"
      >
        <n-icon :component="Cut20Regular" />
      </n-button>
      <n-button
        secondary
        @click="copy"
      >
        <n-icon :component="Copy20Regular" />
      </n-button>
      <n-button
        :disabled="loading || deployed"
        secondary
        title="Copy link for current IME"
        @click="copyLink"
      >
        <n-icon :component="ClipboardLink20Regular" />
      </n-button>
      <n-button
        class="history-btn"
        secondary
        round
        strong
        size="large"
        :aria-label="showHistory ? 'Hide input history' : 'Show input history'"
        :title="showHistory ? 'Hide input history' : 'Show input history'"
        @click="toggleHistory"
      >
        <n-icon :component="History" />
      </n-button>
      </n-button-group>
    <!-- Least astonishment: user may explicitly cut, so shouldn't overwrite the clipboard. -->
    <n-checkbox v-model:checked="autoCopy">
      Auto copy on commit
    </n-checkbox>
    <n-card v-show="showHistory" title="Input History" class="history-card">
      <div class="history-panel">
        <div class="history-toolbar">
          <div class="count">{{ snapshots.length }} items</div>
          <div class="actions">
            <n-button secondary size="tiny" @click="clearHistory">Clear</n-button>
            <n-button type="primary" size="tiny" @click="showHistory = false">Hide</n-button>
          </div>
        </div>
        <div v-if="snapshots.length === 0" class="empty">No snapshots yet</div>
        <div v-else class="history-list">
          <div v-for="s in sortedSnapshots" :key="s.timestamp" class="snapshot">
            <div class="snapshot-header">
              <div class="time">{{ new Date(s.timestamp).toLocaleString() }}</div>
              <n-button quaternary size="tiny" title="Copy this snapshot" aria-label="Copy snapshot" @click="copySnapshot(s.text)">
                <n-icon :component="Copy20Regular" />
              </n-button>
            </div>
            <div class="text">{{ s.text }}</div>
          </div>
        </div>
      </div>
    </n-card>
  </n-space>
</template>

<style scoped>
.n-button-group .n-button {
  font-size: 24px;
}
.history-btn {
  font-size: 32px;
}
.history-card {
  margin-top: 8px;
  /* Color tokens for light & dark schemes */
  --history-bg: #f7f8fb;
  --history-toolbar-bg: #eef2f7;
  --history-divider: rgba(0, 0, 0, 0.06);
  --history-item-bg: #ffffff;
  --history-item-border: rgba(0, 0, 0, 0.08);
  --history-item-hover-border: rgba(0, 0, 0, 0.12);
  --history-shadow: 0 1px 2px rgba(0, 0, 0, 0.04);
  --history-shadow-hover: 0 2px 6px rgba(0, 0, 0, 0.08);
  --history-text: #1f2937; /* slate-800 */
  --history-muted: #6b7280; /* gray-500 */
}

@media (prefers-color-scheme: dark) {
  .history-card {
    --history-bg: #0f141a;
    --history-toolbar-bg: #111827; /* gray-900 */
    --history-divider: rgba(255, 255, 255, 0.10);
    --history-item-bg: #0b1220; /* deep slate */
    --history-item-border: rgba(255, 255, 255, 0.10);
    --history-item-hover-border: rgba(255, 255, 255, 0.16);
    --history-shadow: 0 1px 2px rgba(0, 0, 0, 0.25);
    --history-shadow-hover: 0 2px 8px rgba(0, 0, 0, 0.35);
    --history-text: #e5e7eb; /* gray-200 */
    --history-muted: #9ca3af; /* gray-400 */
  }
}
.history-panel {
  max-height: 50vh;
  overflow: auto;
  display: flex;
  flex-direction: column;
  gap: 8px;
  background: var(--history-bg);
  padding: 8px;
}
.history-toolbar {
  position: sticky;
  top: 0;
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: var(--history-toolbar-bg);
  padding: 8px;
  border-bottom: 1px solid var(--history-divider);
}
.snapshot {
  padding: 8px;
  background: var(--history-item-bg);
  border: 1px solid var(--history-item-border);
  border-radius: 8px;
  box-shadow: var(--history-shadow);
  transition: box-shadow 0.15s ease, border-color 0.15s ease;
}
.snapshot:hover {
  border-color: var(--history-item-hover-border);
  box-shadow: var(--history-shadow-hover);
}
.snapshot-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
}
.time {
  font-size: 12px;
  color: var(--history-muted);
}
.text {
  white-space: pre-wrap;
  word-break: break-word;
  color: var(--history-text);
}
.empty {
  color: var(--history-muted);
}
</style>

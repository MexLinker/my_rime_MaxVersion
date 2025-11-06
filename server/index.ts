import { createServer } from 'http'
import { promises as fs } from 'fs'
import path from 'path'

type SelectAllSnapshot = {
  text: string
  timestamp: number
}

const PORT = Number(process.env.API_PORT || 8787)
const DATA_DIR = path.join(process.cwd(), 'server', 'data')
const DATA_FILE = path.join(DATA_DIR, 'history.json')

async function ensureDataDir () {
  try {
    await fs.mkdir(DATA_DIR, { recursive: true })
  } catch {}
}

async function readHistory (): Promise<SelectAllSnapshot[]> {
  try {
    const raw = await fs.readFile(DATA_FILE, 'utf-8')
    return JSON.parse(raw)
  } catch {
    return []
  }
}

async function writeHistory (arr: SelectAllSnapshot[]) {
  await ensureDataDir()
  await fs.writeFile(DATA_FILE, JSON.stringify(arr), 'utf-8')
}

function sendJson (res: any, status: number, body: any) {
  res.writeHead(status, {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET,POST,DELETE,OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type'
  })
  res.end(JSON.stringify(body))
}

createServer(async (req, res) => {
  const url = req.url || '/'
  const method = req.method || 'GET'

  // CORS preflight
  if (method === 'OPTIONS') {
    res.writeHead(204, {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET,POST,DELETE,OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type'
    })
    return res.end()
  }

  if (url === '/api/health') {
    return sendJson(res, 200, { ok: true })
  }

  if (url === '/api/history' && method === 'GET') {
    const arr = await readHistory()
    return sendJson(res, 200, arr)
  }

  if (url === '/api/history' && method === 'POST') {
    try {
      const chunks: Buffer[] = []
      req.on('data', chunk => chunks.push(chunk))
      req.on('end', async () => {
        try {
          const body = JSON.parse(Buffer.concat(chunks).toString('utf-8'))
          const text = (body?.text || '').toString()
          if (!text.trim()) {
            return sendJson(res, 400, { error: 'empty text' })
          }
          const arr = await readHistory()
          arr.push({ text, timestamp: Date.now() })
          await writeHistory(arr)
          return sendJson(res, 200, { ok: true })
        } catch (e: any) {
          return sendJson(res, 400, { error: 'bad request' })
        }
      })
    } catch {
      return sendJson(res, 500, { error: 'server error' })
    }
    return
  }

  if (url === '/api/history' && method === 'DELETE') {
    try {
      await writeHistory([])
      return sendJson(res, 200, { ok: true })
    } catch {
      return sendJson(res, 500, { error: 'server error' })
    }
  }

  sendJson(res, 404, { error: 'not found' })
}).listen(PORT, () => {
  console.log(`[api] listening on http://localhost:${PORT}`)
})
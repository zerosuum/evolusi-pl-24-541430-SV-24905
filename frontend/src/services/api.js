const apiUrl = import.meta.env.VITE_API_URL

export async function fetchKanjiCards() {
  if (!apiUrl) {
    throw new Error('VITE_API_URL belum diatur')
  }

  const baseUrl = apiUrl.replace(/\/$/, '')
  const response = await fetch(`${baseUrl}/api/kanji`)

  if (!response.ok) {
    throw new Error(`gagal mengambil data kanji (${response.status})`)
  }

  const payload = await response.json()

  return payload.data ?? []
}

import { describe, expect, it } from 'vitest'
import { filterKanjiCards } from './kanji'

const cards = [
  {
    id: 1,
    character: '日',
    meaning: 'hari / matahari',
    onyomi: 'ニチ・ジツ',
    kunyomi: 'ひ',
    example: '日本 (にほん) — Jepang',
  },
  {
    id: 2,
    character: '山',
    meaning: 'gunung',
    onyomi: 'サン',
    kunyomi: 'やま',
    example: '富士山 (ふじさん) — Gunung Fuji',
  },
]

describe('filterKanjiCards', () => {
  it('returns all cards when query is empty', () => {
    expect(filterKanjiCards(cards, '')).toHaveLength(2)
  })

  it('filters cards using visible card text', () => {
    const result = filterKanjiCards(cards, 'gunung')

    expect(result).toHaveLength(1)
    expect(result[0].character).toBe('山')
  })
})

export function filterKanjiCards(cards, query) {
  const keyword = query.trim()

  if (!keyword) {
    return cards
  }

  return cards.filter((card) =>
    [card.character, card.meaning, card.onyomi, card.kunyomi, card.example]
      .filter(Boolean)
      .some((value) => String(value).includes(keyword)),
  )
}

<script setup>
import { computed, onMounted, ref } from 'vue'
import { fetchKanjiCards } from '../services/api'
import { filterKanjiCards } from '../utils/kanji'

const cards = ref([])
const query = ref('')
const loading = ref(true)
const errorMessage = ref('')

const filteredCards = computed(() => filterKanjiCards(cards.value, query.value))

onMounted(async () => {
  try {
    cards.value = await fetchKanjiCards()
  } catch (error) {
    errorMessage.value = error instanceof Error ? error.message : 'gagal mengambil data kanji'
  } finally {
    loading.value = false
  }
})
</script>

<template>
  <main class="page">
    <div class="page-heading">
      <div>
        <p class="eyebrow">laravel api → vue</p>
        <h1>daftar kanji</h1>
        <p class="lead">Data pada halaman ini diambil dari endpoint JSON Laravel.</p>
      </div>

      <label class="search-field">
        <span>cari kanji</span>
        <input v-model="query" type="search" placeholder="contoh: gunung" />
      </label>
    </div>

    <p v-if="loading" class="status-message">mengambil data...</p>
    <p v-else-if="errorMessage" class="status-message error-message">{{ errorMessage }}</p>
    <p v-else-if="filteredCards.length === 0" class="status-message">data tidak ditemukan.</p>

    <section v-else class="kanji-grid">
      <article v-for="card in filteredCards" :key="card.id" class="kanji-card">
        <div class="character">{{ card.character }}</div>
        <div class="card-content">
          <strong>{{ card.meaning }}</strong>
          <p><span>onyomi</span>{{ card.onyomi || '-' }}</p>
          <p><span>kunyomi</span>{{ card.kunyomi || '-' }}</p>
          <p><span>contoh</span>{{ card.example || '-' }}</p>
        </div>
      </article>
    </section>
  </main>
</template>

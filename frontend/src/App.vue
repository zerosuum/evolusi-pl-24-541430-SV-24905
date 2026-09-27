<template>
  <div class="app-shell">
    <header class="topbar">
      <RouterLink class="brand" to="/">kanji bites</RouterLink>

      <nav class="navigation" aria-label="Navigasi utama">
        <RouterLink to="/">beranda</RouterLink>
        <RouterLink to="/kanji">daftar kanji</RouterLink>
      </nav>
    </header>

    <RouterView />
  </div>
</template>

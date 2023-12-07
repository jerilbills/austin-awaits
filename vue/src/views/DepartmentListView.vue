<template>
  <div>
    <!-- Include the Navbar component -->
    <Navbar />

    <div class="main-layout">
      <!-- Include the Sidebar component -->
      <Sidebar />

      <!-- KanbanBoard component goes here -->
      <KanbanBoard />

    </div>
  </div>
</template>

<script>
import Navbar from "../components/Navbar.vue";
import KanbanBoard from "../components/KanbanBoard.vue";
import Sidebar from "../components/Sidebar.vue";

export default {
  components: {
    Navbar,
    KanbanBoard,
    Sidebar,
  },
};
</script>

<style scoped>
.main-layout {
  display: flex;
}

/* Adjust the styles based on your specific design requirements */
</style>
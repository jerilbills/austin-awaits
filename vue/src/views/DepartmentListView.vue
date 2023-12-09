<template>
  <div id="page">
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

#page {
  height:100vh;
  background-image: url('../assets/austin-background.png');
  background-color: #FFFFFF;
  background-position: right bottom;
  background-repeat: no-repeat;
}

/* Adjust the styles based on your specific design requirements */
</style>
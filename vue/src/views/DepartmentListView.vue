<template>
  <div id="page">
    <!-- Include the Navbar component -->
    <Navbar />

    <div class="main-layout">
      <!-- Include the Sidebar component -->
      <AdminSidebar v-show="$store.state.user.role === 'admin'" :key="$store.state.sideBarRefreshKey" />
      <Sidebar v-show="$store.state.user.role !== 'admin'" :key="$store.state.sideBarRefreshKey" />
      
      
      <KanbanBoard />

    </div>
  </div>
</template>

<script>
import Navbar from "../components/Navbar.vue";
import KanbanBoard from "../components/KanbanBoard.vue";
import Sidebar from "../components/Sidebar.vue";
import AdminSidebar from "../components/AdminSidebar.vue";

export default {
  components: {
    Navbar,
    KanbanBoard,
    Sidebar,
    AdminSidebar,
  },
  methods: {
    beforeWindowUnload(e) {
      this.$store.commit('LOGOUT');
    }
  },
  created() {
    window.addEventListener('beforeunload', this.beforeWindowUnload);
  }
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

</style>
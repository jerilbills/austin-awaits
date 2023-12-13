<template>
    <div id="page">
        <!-- Include the Navbar component -->
        <Navbar />

        <div class="main-layout">
            <!-- Include the Sidebar component -->
            <AdminSidebar :key="$store.state.sideBarRefreshKey" />

            <!-- KanbanBoard component goes here -->
            <KanbanBoard />

        </div>
    </div>
</template>
  
<script>
import Navbar from "../components/Navbar.vue";
import AdminKanbanBoard from "../components/AdminKanbanBoard.vue";
import AdminSidebar from "../components/AdminSidebar.vue";
import KanbanBoard from "../components/KanbanBoard.vue";

export default {
    components: {
        Navbar,
        AdminKanbanBoard,
        AdminSidebar,
        KanbanBoard
    },
};
</script>
  
<style scoped>
.main-layout {
    display: flex;
}

#page {
    height: 100vh;
    background-image: url('../assets/austin-background.png');
    background-color: #FFFFFF;
    background-position: right bottom;
    background-repeat: no-repeat;
}
</style>
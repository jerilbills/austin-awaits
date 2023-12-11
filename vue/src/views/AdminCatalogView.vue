<template>
    <div id="page">
        <!-- Include the Navbar component -->
        <Navbar />

        <div class="main-layout">
            <!-- Include the Sidebar component -->
            <AdminSidebar :key="$store.state.sideBarRefreshKey" />
        </div>
        <div id="catalog">
            <Navbar />
            <SidebarCompletedList />
            <div class="content">
                <h1>Item Catalog</h1>
                <!-- Display loading overlay when loading is true -->

                <div class="table-container">
                    <div class="table-buttons">
                        <input class="input" type="text" v-model="searchTerm" placeholder="Search..." />
                        <button class="button is-primary">Add New Item</button>
                    </div>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Item Name</th>
                                <th>Item Image</th>
                                <th>Item Description</th>
                                <!-- Add more columns as needed -->
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(item, index) in filteredData" :key="index">
                                <td @click="navigateTo(item.listId)">{{ item.name }}</td>
                                <td>
                                    <img :src="item.itemImage" alt="Item Image"
                                        style="max-width: 100px; max-height: 100px;">
                                </td>
                                <td>{{ item.itemDescription }}</td>
                                <!-- Add more columns as needed -->
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

    </div>
</template>
  
<script>
import Navbar from "../components/Navbar.vue";
import KanbanBoard from "../components/KanbanBoard.vue";
import Sidebar from "../components/Sidebar.vue";
import AdminKanbanBoard from "../components/AdminKanbanBoard.vue";
import AdminSidebar from "../components/AdminSidebar.vue";
import LoadingOverlay from "../components/LoadingOverlay.vue";


export default {
    components: {
        Navbar,
        // KanbanBoard,
        // Sidebar,
        // AdminKanbanBoard,
        AdminSidebar,
        LoadingOverlay
    },
    data() {
        return {
            items: [
                {
                    name: 'Item 1',
                    itemImage: 'https://via.placeholder.com/150x150',
                    itemDescription: 'This is the first item in the catalog'
                },
                {
                    name: 'Item 2',
                    itemImage: 'https://via.placeholder.com/150x150',
                    itemDescription: 'This is the second item in the catalog'

                },
                {
                    name: 'Item 3',
                    itemImage: 'https://via.placeholder.com/150x150',
                    itemDescription: 'This is the third item in the catalog'
                },
                {
                    name: 'Item 4',
                    itemImage: 'https://via.placeholder.com/150x150',
                    itemDescription: 'This is the fourth item in the catalog'

                },
                {
                    name: 'Item 5',
                    itemImage: 'https://via.placeholder.com/150x150',
                    itemDescription: 'This is the fifth item in the catalog'
                },
                {
                    name: 'Item 6',
                    itemImage: 'https://via.placeholder.com/150x150',
                    itemDescription: 'This is the sixth item in the catalog'

                },
                {
                    name: 'Item 7',
                    itemImage: 'https://via.placeholder.com/150x150',
                    itemDescription: 'This is the seventh item in the catalog'
                },
                {
                    name: 'Item 8',
                    itemImage: 'https://via.placeholder.com/150x150',
                    itemDescription: 'This is the eighth item in the catalog'

                },
            ],
            searchTerm: '',
            loading: false
        }
    },
    computed: {
        filteredData() {
            return this.items.filter(item =>
                item.name.toLowerCase().includes(this.searchTerm.toLowerCase())
            );
        }
    },
    methods: {

    },
    created() {

    }
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

.table-buttons {
    display: flex;
    justify-content: space-between;
}

.content {
    margin: 85px 0 0 270px;
    flex: 1;
}

.table-container {
    margin-top: 30px;
}

.input {
    width: 300px;
    margin-bottom: 10px;
}

.table th,
.table td {
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.table tbody tr:nth-child(odd) {
    background-color: #f4f4f4;
}

.table tbody tr:nth-child(even) {
    background-color: rgba(255, 255, 255, 0.2);
}
</style>
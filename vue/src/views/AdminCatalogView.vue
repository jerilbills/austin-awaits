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
            <div class="content">
                <h1>Item Catalog</h1>
                <!-- Display loading overlay when loading is true -->

                <div class="table-container">
                    <div class="table-buttons">
                        <input class="input" type="text" v-model="searchTerm" placeholder="Search..." />
                        <button class="button is-primary" @click="showModal">Add New Item</button>
                    </div>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Item Name</th>
                                <th>Item Image</th>
                                <th>Item Description</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(item, index) in paginatedItems" :key="index">
                                <td @click="showModalWithItem(item)">{{ item.name }}</td>
                                <td>
                                    <img :src="item.itemImage" alt="Item Image"
                                        style="max-width: 100px; max-height: 100px;" />
                                </td>
                                <td>{{ item.itemDescription }}</td>
                            </tr>
                        </tbody>
                    </table>

                    <!-- Pagination Controls -->
                    <div class="pagination">
                        <button @click="prevPage" :disabled="currentPage === 1" class="button is-primary is-small">Previous</button>
                        <span>{{ currentPage }} of {{ totalPages }}</span>
                        <button @click="nextPage" :disabled="currentPage === totalPages" class="button is-primary is-small">Next</button>
                    </div>

                    <div>
                        <AddItemModal 
                        :showModal="modalVisible"
                        :hideModal="hideModal"
                        :addNewItem="addNewItem"/>
                    </div>
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
import AddItemModal from "../components/AddItemModal.vue";
import ImageService from "../services/ImageService.js";


export default {
    components: {
        Navbar,
        // KanbanBoard,
        // Sidebar,
        // AdminKanbanBoard,
        AdminSidebar,
        LoadingOverlay,
        AddItemModal
    },
    data() {
        return {
            searchTerm: '',
            loading: false,
            itemsPerPage: 12,
            currentPage: 1,
            modalVisible: false,
            selectedItem: null,
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
                {
                    name: 'Item 9',
                    itemImage: 'https://via.placeholder.com/150x150',
                    itemDescription: 'This is the ninth item in the catalog'
                },
                {
                    name: 'Item 10',
                    itemImage: 'https://via.placeholder.com/150x150',
                    itemDescription: 'This is the tenth item in the catalog'

                },
                {
                    name: 'Item 11',
                    itemImage: 'https://via.placeholder.com/150x150',
                    itemDescription: 'This is the eleventh item in the catalog'
                },
                {
                    name: 'Item 12',
                    itemImage: 'https://via.placeholder.com/150x150',
                    itemDescription: 'This is the twelfth item in the catalog'

                },
                {
                    name: 'Item 13',
                    itemImage: 'https://via.placeholder.com/150x150',
                    itemDescription: 'This is the thirteenth item in the catalog'
                },
                {
                    name: 'Item 14',
                    itemImage: 'https://via.placeholder.com/150x150',
                    itemDescription: 'This is the fourteenth item in the catalog'

                },
                {
                    name: 'Item 15',
                    itemImage: 'https://via.placeholder.com/150x150',
                    itemDescription: 'This is the fifteenth item in the catalog'
                },
                {
                    name: 'Item 16',
                    itemImage: 'https://via.placeholder.com/150x150',
                    itemDescription: 'This is the sixteenth item in the catalog'

                },
            ],
        }
    },
    computed: {
        filteredItems() {
            return this.items.filter(item =>
                item.name.toLowerCase().includes(this.searchTerm.toLowerCase())
            );
        },
        totalPages() {
            return Math.ceil(this.filteredItems.length / this.itemsPerPage);
        },
        paginatedItems() {
            const startIndex = (this.currentPage - 1) * this.itemsPerPage;
            const endIndex = startIndex + this.itemsPerPage;
            return this.filteredItems.slice(startIndex, endIndex);
        },

    },
    methods: {
        addNewItem() {

        },
        prevPage() {
            if (this.currentPage > 1) {
                this.currentPage--;
            }
        },
        nextPage() {
            if (this.currentPage < this.totalPages) {
                this.currentPage++;
            }
        },
        showModal(item) {
            this.selectedItem = item;
            this.modalVisible = true;
        },
        showModalWithItem(item) {
            this.selectedItem = item;
            this.modalVisible = true;
        },
        hideModal() {
            this.modalVisible = false;
        }
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
    overflow-x: hidden;
}

.table-buttons {
    display: flex;
    justify-content: space-between;
}

.content {
    margin: 85px 0 0 270px;
    flex: 1;
    width: auto;
}

.table-container {
    margin-top: 30px;
    overflow-x: hidden;
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

.pagination {
    margin-top: 10px;
}

.pagination button {
    margin-right: 15px;
    margin-left: 15px
}
</style>
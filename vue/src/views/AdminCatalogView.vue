<template>
    <div id="page">
        <!-- Include the Navbar component -->
        <Navbar />

        <div class="main-layout">
            <!-- Include the Sidebar component -->
            <AdminSidebar :key="$store.state.sideBarRefreshKey" />
        </div>
        <LoadingOverlay :loading="loading" />
        <div id="catalog">
            <div class="content">
                <h1>Item Catalog</h1>
                <!-- Display loading overlay when loading is true -->

                <div class="table-container">
                    <div class="table-buttons">
                        <input class="input" type="text" v-model="searchTerm" placeholder="Search..." />
                        <button class="button is-primary" @click="showModal" style="margin-right:10px">Add New Item</button>
                    </div>
                    <table class="table" style="width: 100%; height: 100%;">
                        <thead>
                            <tr>
                                <th>Item Name</th>
                                <th>Item Image</th>
                                <th>Item Description</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(item, index) in paginatedItems" :key="index" style="height: 100px;" @click="showModalWithItem(item)">
                                <td>{{ item.name }}</td>
                                <td>
                                    <img :src="item.imgUrl" alt="Item Image"
                                        style="max-width: 100px; max-height: 80px;" @error="imgPlaceholder" />
                                </td>
                                <td style="word-wrap: break-word;">{{ item.description }}</td>
                            </tr>
                        </tbody>
                    </table>

                    <!-- Pagination Controls -->
                    <div class="pagination">
                        <button @click="prevPage" :disabled="currentPage === 1"
                            class="button is-primary is-small">Previous</button>
                        <span>{{ currentPage }} of {{ totalPages }}</span>
                        <button @click="nextPage" :disabled="currentPage === totalPages"
                            class="button is-primary is-small">Next</button>
                    </div>

                    <div>
                        <AddItemModal :showModal="modalVisible" :hideModal="hideModal" :addNewItem="addNewItem" />
                        <EditCatalogItemModal :showModal="modalVisibleEdit" :hideModal="hideModalEdit" :selectedItem="selectedItem"/>
                    </div>
                </div>         
            </div>

        </div>
                    <!-- SNACKBAR ALERTS-->
                    <div id="snackbar-item-added">Item added to catalog.</div>
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
import EditCatalogItemModal from "../components/EditCatalogItemModal.vue";
import ImageService from "../services/ImageService.js";
import ItemService from "../services/ItemService";

export default {
    components: {
        Navbar,
        // KanbanBoard,
        // Sidebar,
        // AdminKanbanBoard,
        AdminSidebar,
        LoadingOverlay,
        AddItemModal,
        EditCatalogItemModal
    },
    data() {
        return {
            searchTerm: '',
            loading: true,
            itemsPerPage: 5,
            currentPage: 1,
            modalVisible: false,
            modalVisibleEdit: false,
            selectedItem: null,
            items: [],
            
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
            this.modalVisibleEdit = true;
        },
        hideModal(item) {
            this.modalVisible = false;
            if(item) {
                this.items.unshift(item);
                this.showItemAddedSnackbar();
            }
        },
        hideModalEdit(updatedItem) {
            this.modalVisibleEdit = false;
            this.selectedItem = null;          
            if (updatedItem) {
                let foundIndex = this.items.findIndex(existing => existing.itemId == updatedItem.itemId);
                this.items[foundIndex] = Object.assign({}, updatedItem);
            }
        },
        imgPlaceholder(e) {
        e.target.src = "/src/assets/blank-pixel.png"
        },
        showItemAddedSnackbar() {
            let x = document.getElementById("snackbar-item-added");
            x.className = "show";
            setTimeout(function () {
                x.className = x.className.replace("show", "");
            }, 4000);
        },
        beforeWindowUnload(e) {
            this.$store.commit('LOGOUT');
        }
    },
    created() {
        setTimeout(() => {

            ItemService.getAllItems()
            .then(response => {
                this.items = response.data;
            })
            .catch(error => {
                console.error("Error retrieving items", error);
            })
            .finally(() => {
                this.loading = false;
            });
        },500);
          
        

        window.addEventListener('beforeunload', this.beforeWindowUnload);
    },
};
</script>
  
<style scoped>
.main-layout {
    display: flex;
}

#page {
    height: 100vh;
    background-color: #FFFFFF;
    overflow-x: hidden;
    overflow-y: auto;
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
    white-space: word-wrap;
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

.content::-webkit-scrollbar {
    width: 12px; /* Set the width of the scrollbar */
}

.content::-webkit-scrollbar-thumb {
    background-color: #666; /* Set the color of the scrollbar thumb */
    border-radius: 6px; /* Set the border radius of the scrollbar thumb */
}

.content::-webkit-scrollbar-track {
    background-color: #333; /* Set the color of the scrollbar track */
    border-radius: 8px; /* Set the border radius of the scrollbar track */
}

.content::-webkit-scrollbar-thumb:hover {
    background-color: #555; /* Set the color of the scrollbar thumb on hover */
}

.content::-webkit-scrollbar-corner {
    background-color: #000; /* Set the color of the scrollbar corner (between vertical and horizontal scrollbar) */
}

#snackbar-item-added {
    visibility: hidden;
    min-width: 250px;
    margin-left: -125px;
    /* Divide value of min-width by 2 */
    background-color: #333;
    color: #fff;
    text-align: center;
    border-radius: 2px;
    padding: 16px;
    position: fixed;
    z-index: 1;
    left: 50%;
    bottom: 30px;
}

#snackbar-item-added.show {
    visibility: visible;
    /* Show the snackbar */
    /* Add animation: Take 0.5 seconds to fade in and out the snackbar.
  Delay the fade out process for 3.5 seconds */
    -webkit-animation: fadein 0.5s, fadeout 0.5s 3.5s;
    animation: fadein 0.5s, fadeout 0.5s 3.5s;
}

</style>
<template>
    <div id="page">
        <Navbar />
        <AdminSidebar />

        <div class="content">
            <h1>Create New List</h1>
            <!-- Display loading overlay when loading is true -->

            <div class="form-container">
                <div class="field">
                    <label class="label">Employee Name</label>
                    <div class="control">
                        <input class="input" type="text" v-model="employeeName" required>
                    </div>
                </div>

                <div class="field">
                    <label class="label">Department</label>
                    <div class="control">
                        <div class="select">
                            <select v-model="selectedDepartment" required>
                                <option v-for="dept in departments" :key="dept.departmentId" :value="dept.departmentId">
                                    {{ dept.departmentName }}
                                </option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="field">
                    <label class="label">Due Date</label>
                    <div class="control">
                        <input class="input" type="date" v-model="dueDate" required>
                    </div>
                </div>

                <div class="field">
                    <button class="button is-primary" @click="openModal">Add Item</button>
                </div>
            </div>


            <ListAddItemModal :isModalOpen="isModalOpen" :closeModal="closeModal" :availableItems="availableItems"
                @item-added="handleItemAdded" />


            <table v-if="addedItems.length > 0" class="table">
                <thead>
                    <tr>
                        <th>Item Name</th>
                        <th>Quantity Needed</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="(item, index) in addedItems" :key="index">
                        <td>{{ item.name }}</td>
                        <td>{{ item.quantity }}</td>
                        <td>
                            <button class="button is-danger is-small" @click="deleteItem(index)">Delete</button>
                        </td>
                    </tr>
                </tbody>
            </table>
            <div class="buttons">
                <button class="button is-info" @click="saveAsDraft">Save as Draft</button>
                <button class="button is-success" @click="submitList">Submit List</button>
            </div>
        </div>
    </div>
</template>

<script>
import Navbar from "../components/Navbar.vue";
import SidebarCompletedList from "../components/SidebarCompletedList.vue";
import departmentService from '../services/DepartmentService';
import ShoppingListService from '../services/ShoppingListService';
import LoadingOverlay from "../components/LoadingOverlay.vue";
import AdminSidebar from "../components/AdminSidebar.vue";
import DepartmentService from "../services/DepartmentService";
import ListAddItemModal from "../components/ListAddItemModal.vue";

export default {
    components: {
        Navbar,
        SidebarCompletedList,
        LoadingOverlay,
        AdminSidebar,
        ListAddItemModal,
    },
    data() {
        return {
            data: [],
            searchTerm: "",
            userDepartmentName: "",
            departments: [],
            employeeName: "",
            dueDate: "",
            isModalOpen: false,
            addedItems: [],
            availableItems: [],
        };
    },
    computed: {

    },
    methods: {
        getUserDepartment() {
            if (!this.userDepartmentName) {
                departmentService
                    .getDepartments()
                    .then((response) => {
                        response.data.forEach((dept) => {
                            if (dept.departmentId == this.$store.state.user.departmentId) {
                                this.userDepartmentName = dept.departmentName;
                            }
                        });
                    })
                    .catch((error) => {
                        console.log("Could not retrieve departments");
                    });
            }
        },
        formatDate(dateString) {
            const date = new Date(dateString);
            return date.toLocaleDateString();
        },
        openModal() {
            this.isModalOpen = true;
        },
        closeModal() {
            this.isModalOpen = false;
        },
        addItems() {
            const newItem = {
                name: this.itemName,
                quantity: this.itemQuantity,
            }
            this.addedItems.push(newItem);

            this.itemName = "";
            this.itemQuantity = "";

            this.closeModal();
        },
        deleteItem(index) {
            this.addedItems.splice(index, 1);
        },
        fetchAvailableItems() {
            this.availableItems = [
                { itemId: 1, itemName: 'Item A' },
                { itemId: 2, itemName: 'Item B' },
            ]
        },
        handleItemAdded(item) {
            this.addedItems.push(item);
        },

    },
    created() {
        this.loading = true;

        setTimeout(() => {
            ShoppingListService.getCompletedListsByDepartment(this.$store.state.user.departmentId)
                .then((response) => {
                    this.data = response.data;
                })
                .catch((error) => {
                    console.error('Error fetching completed lists:', error);
                })
                .finally(() => {
                    this.loading = false;
                });
        }, 500);

        departmentService.getDepartments()
            .then((response) => {
                this.departments = response.data.sort((a, b) => (a.departmentName > b.departmentName) ? 1 : -1);
            })
            .catch((error) => {
                console.log("Could not retrieve departments");
            })

        this.fetchAvailableItems();
    },
}

</script>

<style scoped>
#page {
    height: 100vh;
    background-image: url('../assets/austin-background.png');
    background-color: #FFFFFF;
    background-position: right bottom;
    background-repeat: no-repeat;
    display: flex;
    flex-direction: column;
}

.content {
    margin: 85px 0 0 270px;
    flex: 1;
}

.form-container {
    max-width: 400px;

}

.field {
    margin-bottom: 1em;
}

.modal-content {
    max-width: 400px;
    margin: 0 auto;
}
</style>

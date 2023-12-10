<template>
    <div id="page">
        <Navbar />
        <SidebarCompletedList />
        <div class="content">
            <h1>Completed Lists for the {{ userDepartmentName }} Department</h1>
            <div class="table-container">
                <input class="input" type="text" v-model="searchTerm" placeholder="Search..." />
                <table class="table">
                    <thead>
                        <tr>
                            <th>Employee Name</th>
                            <th>List Owner</th>
                            <th>Number of Items</th>
                            <th>Due Date</th>
                            <th>Completed Date</th>
                            <!-- Add more columns as needed -->
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(item, index) in filteredData" :key="index">
                            <td @click="navigateTo()">{{ item.name }}</td>
                            <td>{{ item.ownerId }}</td>
                            <td>{{ item.numberOfItems }}</td>
                            <td>{{ formatDate(item.dueDate) }}</td>
                            <td>{{ formatDate(item.lastModified) }}</td>
                            <!-- Add more columns as needed -->
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</template>
  
<script>
import Navbar from "../components/Navbar.vue";
import SidebarCompletedList from "../components/SidebarCompletedList.vue";
import departmentService from '../services/DepartmentService';
import ShoppingListService from '../services/ShoppingListService';

export default {
    components: {
        Navbar,
        SidebarCompletedList,
    },
    data() {
        return {
            data: [
            ],
            searchTerm: "",
            userDepartmentName: "",
        };
    },
    computed: {
        filteredData() {
            // Map the properties accordingly
            return this.data.map((item) => ({
                name: item.name,
                ownerId: item.ownerId,
                numberOfItems: item.numberOfItems,
                dueDate: item.dueDate,
                lastModified: item.lastModified,
                listId: item.listId, // Adding listId for the navigateTo method
            })).filter((item) =>
                Object.values(item).some(
                    (value) =>
                        typeof value === "string" &&
                        value.toLowerCase().includes(this.searchTerm.toLowerCase())
                )
            );
        },
    },
    methods: {
        getUserDepartment() {
            if (!this.userDepartmentName) {
                departmentService
                    .getDepartments()
                    .then((response) => {
                        response.data.forEach((dept) => {
                            console.log(dept.departmentId);
                            if (dept.departmentId == this.$store.state.user.departmentId) {
                                this.userDepartmentName = dept.departmentName;
                            }
                        });
                    })
                    .catch((error) => {
                        console.log("Could not retrieve departments");
                    })
            }
        },
        formatDate(dateString) {
            const date = new Date(dateString);
            return date.toLocaleDateString();
        },
    },
    created() {
        this.getUserDepartment();
        ShoppingListService.getCompletedListsByDepartment(this.$store.state.user.departmentId)
            .then((response) => {
                this.data = response.data;
            })
            .catch((error) => {
                console.log("Could not retrieve completed lists");
            });
    }
};
</script>
  
<style>
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
    background-color: #ffffff;
}
</style>
  
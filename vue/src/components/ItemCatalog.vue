<template>
    <div id="page">
        <Navbar />
        <SidebarCompletedList />
        <div class="content">
            <h1>Completed Lists for the {{ userDepartmentName }} Department</h1>
            <!-- Display loading overlay when loading is true -->
            <LoadingOverlay :loading="loading"/>

            <div class="table-container" v-if="!loading">
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
                            <td @click="navigateTo(item.listId)">{{ item.name }}</td>
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

   
</script>

<style scoped>


</style>

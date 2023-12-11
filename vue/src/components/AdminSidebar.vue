<template>
    <div class="sidebar is-dark">
        <span class="sidebar-header"><span class="icon"><i class="fa fa-home"></i></span> Active Lists</span>
        <div v-for="(department, index) in departments" :key="index">
            <p><em>{{ department.departmentName }}</em></p>
            <ul>
                <li v-for="list in inProgressListsByDepartment(department.departmentName)" :key="list.listId"
                    @click="navigateTo(department.departmentId, list.listId)">
                    {{ list.name }} ({{ list.numberOfItems }})
                </li>
            </ul>
        </div>
        <div class="drafts">
            <em>Draft Lists</em>
            <li style="list-style: none; margin-left:10px;">Nothing to see here....</li>
        </div>
        <div>
            <!-- <li class="add-list-button" @click="addListModal">Create New List</li> -->
            <button class="button is-secondary is-small"  style="margin-top:20px; margin-bottom: 20px;">Create New List</button>
        </div>

        <div class="admin">
            <em>ADMIN</em>
            <ul>
                <router-link to="">
                    <li class="completed">View Completed Lists</li>
                </router-link>
            </ul>
            <ul>
                <router-link to="/testing/catalog">
                    <li class="completed">View Item Catalog</li>
                </router-link>
            </ul>
            <ul>
                <router-link to="testing">
                    <li class="completed">View Purchased Items</li>
                </router-link>
            </ul>
        </div>


        

        <div>&nbsp;</div>
    </div>
</template>
  
<script>
import ShoppingListService from '../services/ShoppingListService';
import DepartmentService from '../services/DepartmentService';

export default {
    data() {
        return {
            lists: [],
            invitedLists: [],
            selectedOption: null,
            departments: [],
        };
    },

    computed: {
        inProgressLists() {
            return this.lists.filter((list) => list.status == 2);
        },
    },

    created() {
        DepartmentService.getDepartments()
            .then((response) => {
                this.departments = response.data;
            })
            .catch((error) => {
                console.error('Error fetching departments:', error);
            });
        ShoppingListService.getListsInProgress(this.$store.state.user.departmentId)
            .then((response) => {
                this.lists = response.data.sort((a, b) => (a.name > b.name ? 1 : -1));
            })
            .catch((error) => {
                console.error('Error fetching lists:', error);
            });

        ShoppingListService.getInvitedListsInProgress(this.$store.state.user)
            .then((response) => {
                this.invitedLists = response.data.sort((a, b) => (a.name > b.name ? 1 : -1));
            })
            .catch((error) => {
                console.error('Error fetching invited lists:', error);
            });
    },

    methods: {
        navigateTo(departmentId, listId) {
            let activeList = null;
            ShoppingListService.getSpecificList(departmentId, listId)
                .then((response) => {
                    this.$store.commit('SET_ITEMS', response.data);
                    if (this.lists.find((element) => element.listId == listId)) {
                        activeList = this.lists.find((element) => element.listId == listId);
                    } else if (this.invitedLists.find((element) => element.listId == listId)) {
                        activeList = this.invitedLists.find((element) => element.listId == listId);
                    }
                    this.$store.commit('SET_ACTIVE_LIST', activeList);
                })
                .catch((error) => {
                    console.error('Error fetching list:', error);
                });
            this.selectedOption = 'all';
        },
        filterByClaimed() {
            ShoppingListService.getListFilteredByClaimed(this.$store.state.activeList.listId, this.$store.state.user.userId, this.$store.state.activeList.departmentId)
                .then((response) => {
                    this.$store.commit('SET_ITEMS', response.data);
                })
                .catch((error) => {
                    console.error('Error filtering list:', error);
                });
            this.selectedOption = 'claimed';
        },
        filterByUnassigned() {
            ShoppingListService.getListFilteredByUnassigned(this.$store.state.activeList.listId, this.$store.state.activeList.departmentId)
                .then((response) => {
                    this.$store.commit('SET_ITEMS', response.data);
                })
                .catch((error) => {
                    console.error('Error filtering list:', error);
                });
            this.selectedOption = 'unassigned';
        },
        inProgressListsByDepartment(department) {
            return this.lists.filter((list) => list.departmentName === department && list.status == 2);
        },
    },
};
</script>
    
<style scoped>
.sidebar {
    width: 250px;
    background-color: #4C8077;
    color: #FFF;
    padding: 25px;
    position: fixed;
    /* Set position to fixed */
    top: 25px;
    /* Pin to the top of the viewport */
    left: 0;
    height: 100%;
    font-family: 'Barlow', sans-serif;
    border-right: 1px solid #e0e0e0;
    /* Faint border on the right side */
    box-shadow: 10px 0px 5px rgba(0, 0, 0, 0.1);
    /* Drop shadow on the right side */
}

ul {
    list-style: none;
    padding: 0px 0px 10px 0px;
    margin: 0;
}

li {
    cursor: pointer;
    padding: 5px;
    border-radius: 5px;
    font-size: small;
}

li:hover {
    background-color: #C4FCF0;
    color: hsl(27.3, 100%, 37.5%);
    font-weight: bold;

}

.active {
    background-color: #C4FCF0;
    color: hsl(27.3, 100%, 37.5%);
    font-weight: bold;
}

.sidebar-header {
    font-weight: bold;
    padding: 15px 0px 0px 0px;
    display: block;
    margin-bottom: 5px;
}

.completed {
    color: #fff
}

.add-list-button {
    list-style: none;
    font-style: italic;
    margin-left: 10px;
    margin-bottom: 20px;

}

.drafts {
    margin-top: 30px;
}

em {
    font-size: medium;
    font-weight: bold;
    font-style: normal;
}
</style>
    
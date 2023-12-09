<template>
  <div class="sidebar is-dark">
    <span class="sidebar-header"><span class="icon"><i class="fa fa-home"></i></span>My Department</span>
    <ul>
      <li v-for="list in inProgressLists" :key="list.listId" @click="navigateTo(this.$store.state.user.departmentId, list.listId)">
        {{ list.name }} ({{ list.numberOfItems }})
      </li>
    </ul>
    <span class="sidebar-header"><span class="icon"><i class="fa fa-envelope"></i></span>Invited Lists</span>
    <div v-if="invitedLists.length > 0">
      <div v-for="(department, index) in departments" :key="index">
        <p><em>{{ department }}</em></p>
        <ul>
          <li v-for="(list, innerIndex) in inProgressListsByDepartment(department)" :key="innerIndex"
            @click="navigateTo(list.departmentId, list.listId)">
            &nbsp;&nbsp;{{ list.name }} ({{ list.numberOfItems }})
          </li>
        </ul>
      </div>
    </div>

    <div v-else>
      No lists to work on
    </div>

    <span class="sidebar-header"><span class="icon"><i class="fa fa-filter"></i></span>Filters</span>
    <ul>
      <li :class="{ 'active': selectedOption === 'all' }"
        @click="navigateTo(this.$store.state.activeList.departmentId, this.$store.state.activeList.listId, 'all')">All
        Items</li>
      <li :class="{ 'active': selectedOption === 'unassigned' }" @click="filterByUnassigned()">Unassigned Items</li>
      <li :class="{ 'active': selectedOption === 'claimed' }" @click="filterByClaimed()">My Claimed Items</li>
    </ul>
    <div>&nbsp;</div>
    <ul>
      <li>Completed Lists</li>
    </ul>
  </div>
</template>
  
<script>
import ShoppingListService from '../services/ShoppingListService';

export default {
  data() {
    return {
      lists: [
      ],
      invitedLists: [
      ],
      selectedOption: null,
    };
  },

  computed: {
    departments() {
      const departments = new Set();
      this.invitedLists.forEach(dept => departments.add(dept.departmentName));
      return Array.from(departments).sort((a, b) => (a.departmentName > b.departmentName) ? 1 : -1);
    },
    inProgressLists() {
      return this.lists.filter(list => list.status == 2);
    },
  },

  created() {
    ShoppingListService.getListsInProgress(this.$store.state.user.departmentId)
      .then(response => {
        // API response data will need to contain array of shopping lists
        this.lists = response.data.sort((a, b) => (a.name > b.name) ? 1 : -1);
      })
      .catch(error => {
        console.error('Error fetching lists:', error);
      })

    ShoppingListService.getInvitedListsInProgress(this.$store.state.user)
      .then(response => {
        this.invitedLists = response.data.sort((a, b) => (a.name > b.name) ? 1 : -1);
      })
      .catch(error => {
        console.error('Error fetching invited lists:', error);
      })

  },

  methods: {
    navigateTo(departmentId, listId) {
      let activeList = null;
      ShoppingListService.getSpecificList(departmentId, listId)
        .then(response => {
          this.$store.commit('SET_ITEMS', response.data);
          if (this.lists.find((element) => element.listId == listId)) {
            activeList = this.lists.find((element) => element.listId == listId)
          } else if (this.invitedLists.find((element) => element.listId == listId)) {
            activeList = this.invitedLists.find((element) => element.listId == listId)
          }
          this.$store.commit('SET_ACTIVE_LIST', activeList)
          
        })
        .catch(error => {
          console.error('Error fetching list:', error);
        });
        this.selectedOption = 'all';
    },
    filterByClaimed() {
      ShoppingListService.getListFilteredByClaimed(this.$store.state.activeList.listId, this.$store.state.user.userId, this.$store.state.activeList.departmentId)
        .then(response => {
          this.$store.commit('SET_ITEMS', response.data);
        })
        .catch(error => {
          console.error('Error filtering list:', error);
        })
        this.selectedOption = 'claimed';
    },
    filterByUnassigned() {
      ShoppingListService.getListFilteredByUnassigned(this.$store.state.activeList.listId, this.$store.state.activeList.departmentId)
        .then(response => {
          this.$store.commit('SET_ITEMS', response.data);
        })
        .catch(error => {
          console.error('Error filtering list:', error);
        })
        this.selectedOption = 'unassigned';
    },
    inProgressListsByDepartment(department) {
      return this.invitedLists.filter(list => list.departmentName === department && list.status == 2);
    },
  }
}
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
}
</style>
  
<template>
  <div class="sidebar is-dark">
    <span class="sidebar-header"><span class="icon"><i class="fa fa-home"></i></span>My Department</span>
    <ul>
      <li v-for="list in lists.sort((a, b) => (a.name > b.name) ? 1 : -1)" :key="list.listId" @click="navigateTo(this.$store.state.user.departmentId, list.listId)">
        {{ list.name }}
      </li>
    </ul>
    <span class="sidebar-header"><span class="icon"><i class="fa fa-envelope"></i></span>Invited Lists</span>
    <ul>
      <li v-for="list in invitedLists.sort((a, b) => (a.name > b.name) ? 1 : -1)" :key="list.listId" @click="navigateTo(list.departmentId, list.listId)">
        {{ list.name }}
      </li>
    </ul>

    <span class="sidebar-header"><span class="icon"><i class="fa fa-filter"></i></span>Filters</span>
    <ul>
      <li>All Items</li>
      <li>Unassigned Items</li>
      <li>My Claimed Items</li>
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

      ]
    };
  },
  created() {
    ShoppingListService.getLists(this.$store.state.user.departmentId)
      .then(response => {
        // API response data will need to contain array of shopping lists
        this.lists = response.data;
      })
      .catch(error => {
        console.error('Error fetching lists:', error);
      })

    ShoppingListService.getInvitedLists(this.$store.state.user)
      .then(response => {
        this.invitedLists = response.data;
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
}

li:hover {
  background-color: #C4FCF0;
  color: hsl(27.3, 100%, 37.5%);
  ;
  font-weight: bold;

}

.sidebar-header {
  font-weight: bold;
  padding: 15px 0px 0px 0px;
  display: block;
}
</style>
  
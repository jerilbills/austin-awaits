<template>
  <div class="sidebar is-dark">
     <span class="sidebar-header"><span class="icon"><i class="fa fa-home"></i></span>My Department</span>
    <ul>
      <li v-for="list in lists" :key="list.id" @click="navigateTo(list.id)">
        {{ list.name }}
      </li>
    </ul>
    <span class="sidebar-header"><span class="icon"><i class="fa fa-envelope"></i></span>Invitations</span>
    <ul>
      <li>No other lists to work on</li>
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
      });
  },


  methods: {
    navigateTo(listId) {
      ShoppingListService.getSpecificList(this.$store.state.user.departmentId, listId)
        .then(response => {
          // this.$store.state.activeItems = response.data;
          this.$store.commit('SET_ITEMS', response.data);
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
  color: hsl(27.3,100%,37.5%);;
  font-weight: bold;

}

.sidebar-header {
  font-weight: bold;
  padding: 15px 0px 0px 0px;
  display: block;
}
</style>
  
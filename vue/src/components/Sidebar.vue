<template>
  <div class="sidebar">
    <ul>
      <li v-for="(list, index) in lists" :key="index" @click="navigateTo('home')">
        {{ list.name }}
      </li>
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
    ShoppingListService.getLists()
      .then(response => {
       // API response data will need to contain array of shopping lists
        this.lists = response.data;
      })
      .catch(error => {
        console.error('Error fetching lists:', error);
  });
},


    methods: {
    navigateTo(route) {
      route
      // vue router to navigate to individual list
      console.log(`Navigating to ${route}`);
    },
  },
};
</script>
  
<style scoped>
.sidebar {
  width: 250px;
  background-color: #ffffff;
  color: rgb(0, 0, 0);
  padding: 20px;
  position: fixed;
  /* Set position to fixed */
  top: 100px;
  /* Pin to the top of the viewport */
  left: 0;
  height: 100%;
  font-family: 'Barlow', sans-serif;
  border-right: 1px solid #e0e0e0;
  /* Faint border on the right side */
  box-shadow: 5px 0px 10px rgba(0, 0, 0, 0.1);
  /* Drop shadow on the right side */
}

ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

li {
  cursor: pointer;
  margin-bottom: 10px;
}

li:hover {
  color: #bf5700;
  font-weight: bold;
  font-size: large;

}</style>
  
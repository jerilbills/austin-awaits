<template>
  <div class="kanban-board">
    <div class="container mt-0 pt-3 mb-5">
      <div class="columns">
        <div class="column is-4" v-for="(column, key) in status" :key="key">
          <div class="box custom-box" style="width: 350px; height: auto;">
            <h6 class="title is-6">{{ column.title }}</h6>
            <draggable class="draggable-list" :list="column.items" group="tasks" item-key="id">
              <!-- Use v-for to dynamically render TaskCard components -->
              <template #item="{ element }">
                <div v-for="(item, index) in element" :key="index">
                  <task-card :item="item" />
                </div>
              </template>
            </draggable>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import draggable from "vuedraggable";
import TaskCard from "../components/TaskCard.vue"; // Adjust the path based on your project structure
import ShoppingListService from "@/path/to/ShoppingListService.js"; // Adjust the path as needed

export default {
  components: {
    draggable,
    TaskCard,
  },
  data() {
    return {
      items: [
        { title: "Items Needed", items: [] },
        { title: "Claimed", items: [] },
        { title: "Purchased", items: [] },
        // Add more columns as needed
      ],
    };
  },
  methods: {
    // Function to load shopping list items
    loadShoppingList() {
      // Simulating API call or any other logic to fetch shopping list items
      // Replace this with actual API call or data loading logic
      ShoppingList.getLists()
        .then(response => {
          // Assuming your API response contains an array of tasks for each status
          this.status.forEach((column, index) => {
            column.items = response.data[index].tasks;
          });
        })
        .catch(error => {
          console.error('Error fetching shopping list:', error);
        });
    },
  },
  created() {
    // Load shopping list items when the component is created
    this.loadShoppingList();
  },
};
</script>


<style scoped>
.avatar {
    width: 35px;
    height: 35px;
    border-radius: 50%;
  }
  .custom-box {
    width: 100%;
  }
  
  .draggable-list {
    min-height: 10vh;
  }
  
  .draggable-list>div {
    cursor: pointer;
  }
  
  .kanban-board {
    margin-left: 100px;
    font-family: 'Barlow', sans-serif;
    position: fixed; /* Set position to fixed */
    top: 100px; /* Pin to the top of the viewport */
    left: 200px; /* Pin to the left of the viewport */
    height: 100%; 
  }

  .columns {
    background-color: rgb(249, 249, 249);
  }
  


  </style>

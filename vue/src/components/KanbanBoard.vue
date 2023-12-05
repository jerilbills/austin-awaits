<template>
  <div class="kanban-board">
    <div class="container mt-0 pt-3 mb-5">
      <div class="columns">
        <div class="column is-4">
          <div class="box custom-box" style="width: 350px; height: auto;">
            <h6 class="title is-6">Items Needed</h6>
            <draggable class="draggable-list" :list="status.itemsNeeded" group="tasks" item-key="id">
              <!-- Add the item slot -->
              <template #item="{ element, index }">
                <div>
                  <task-card :item="element" />
                </div>
              </template>
            </draggable>
          </div>
        </div>
        <div class="column is-4">
          <div class="box custom-box" style="width: 350px; height: auto;">
            <h6 class="title is-6">Claimed</h6>
            <draggable class="draggable-list" :list="status.claimed" group="tasks" item-key="id">
              <!-- Add the item slot -->
              <template #item="{ element, index }">
                <div>
                  <task-card :item="element" />
                </div>
              </template>
            </draggable>
          </div>
        </div>
        <div class="column is-4">
          <div class="box custom-box" style="width: 350px; height: auto;">
            <h6 class="title is-6">Purchased</h6>
            <draggable class="draggable-list" :list="status.inProgress" group="tasks" item-key="id">
              <!-- Add the item slot -->
              <template #item="{ element, index }">
                <div>
                  <task-card :item="element" />
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

export default {
  components: {
    draggable,
    TaskCard,
  },
  data() {
    return {
      status: {
        itemsNeeded: [
          { id: 1, text: "Cowboy boots", avatar: "" },
          // Add more items with unique IDs
        ],
        claimed: [
          { id: 2, text: "Denim", avatar: "https://api.dicebear.com/7.x/bottts/svg" },
          { id: 3, text: "Big Truck", avatar: "https://api.dicebear.com/7.x/bottts/svg" },
          // Add more items with unique IDs
        ],
        inProgress: [
          { id: 4, text: "Keep Austin Weird Tshirt", avatar: "https://api.dicebear.com/7.x/bottts/svg" },
          { id: 5, text: "Cowboy boots", avatar: "https://api.dicebear.com/7.x/bottts/svg" },
          // Add more items with unique IDs
        ],
      },
    };
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

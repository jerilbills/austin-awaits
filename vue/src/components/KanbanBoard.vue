<template>
  <div class="kanban-board">
    <div class="container mt-0 pt-3 mb-5">
      <div class="columns">
        <div class="column is-4" v-for="(column, key) in columns" :key="key">
          <div class="box custom-box" style="width: 350px; height: auto;">
            <h6 class="title is-6">{{ column.title }}</h6>
            <draggable class="draggable-list" :list="column.items" group="tasks" item-key="id">
              <template #item="{ element }">
                <div :key="element.id">
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
import TaskCard from "../components/TaskCard.vue";

export default {
  components: {
    draggable,
    TaskCard,
  },
  computed:{
    myItems() {
      return this.$store.state.activeItems;
    }
  },

  data() {
    return {
      columns: [
        { title: "Items Needed", items: [] },
        { title: "Claimed", items: [] },
        { title: "Purchased", items: [] },
      ],
      activeItems: [],
    };
  },
  methods: {
    // Function to load list items
    loadShoppingList() {
      this.clearScreen();
      this.myItems.forEach((item) => {
        const columnIndex = item.statusId - 1;
        if (this.columns[columnIndex]) {
          this.columns[columnIndex].items.push(item);
        }
      });
    },
    clearScreen(){
      this.columns = [
        { title: "Items Needed", items: [] },
        { title: "Claimed", items: [] },
        { title: "Purchased", items: [] },
      ];
    }
  },
  created() {
      this.loadShoppingList();
  },
  updated(){
    this.loadShoppingList();
  },
  watch:{
    myItems: 'loadShoppingList'
  }
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
  position: fixed;
  top: 100px;
  left: 200px;
  height: 100%;
}

.columns {
  background-color: rgb(249, 249, 249);
}
</style>

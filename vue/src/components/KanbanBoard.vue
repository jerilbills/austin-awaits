<template>
  <div class="kanban-board">
      <div class="column is-4" v-for="(column, index) in columns" :key="index" :class="{ over: isDraggedOver }"
          @drop.prevent="drop(column)" @dragover.prevent="dragOver" @dragenter.prevent="dragEnter" @dragleave="dragLeave">

          <div class="box custom-box" style="width: 350px; height: auto;" @dragstart="dragStart(column.title)"
              draggable="true">
              <h6 class="title is-6">{{ column.title }}</h6>
              <div class="items">
                  <div class="item" v-for="item in column.items" :key="item.itemId" @dragstart="dragStartItem(item)"
                      draggable="true">
                      <div class="header">
                          <h3>{{ item.name }}</h3>
                      </div>
                  </div>
              </div>
          </div>
      </div>
  </div>
</template>

<script>
import ShoppingListService from '../services/ShoppingListService';

export default {
  name: 'HTMLDraggable',
  props: ['title', 'cards', 'boardID'],
  data() {
      return {
          dragCounter: 0,

      };
  },
  computed: {
      isDraggedOver() {
          return this.dragCounter > 0;
      },
      myItems() {
          return this.$store.state.activeItems;
      },
      columns() {
          return [
              { statusId: 1, title: "Items Needed", items: this.myItems.filter((item) => item.listItemStatusId === 1) },
              { statusId: 2, title: "Claimed", items: this.myItems.filter((item) => item.listItemStatusId === 2) },
              { statusId: 3, title: "Purchased", items: this.myItems.filter((item) => item.listItemStatusId === 3) },
          ]
      }
  },
  methods: {
      dragStart(columnTitle) {
          this.draggedColumn = columnTitle;
      },
      dragStartItem(item) {
          this.draggedItem = item;
      },
      dragOver(event) {
          event.preventDefault();
      },
      drop(column) {
          const date = new Date();
          if (this.draggedItem && this.draggedColumn) {
              const columnStatusId = column.statusId;

              switch (columnStatusId) {
                  case 1:
                      this.draggedItem.claimedBy = null;
                      this.draggedItem.listItemStatusId = 1;
                      this.draggedItem.lastModifiedDate = date;
                      this.draggedItem.lastModifiedBy = this.$store.state.user.userId;
                      ShoppingListService.updateItem(this.draggedItem);
                      break;
                  case 2:
                      this.draggedItem.claimedBy = this.$store.state.user.userId;
                      this.draggedItem.listItemStatusId = 2;
                      this.draggedItem.lastModifiedDate = date;
                      this.draggedItem.lastModifiedBy = this.$store.state.user.userId;
                      ShoppingListService.updateItem(this.draggedItem);
                      break;
                  case 3:
                      this.draggedItem.listItemStatusId = 3;
                      this.draggedItem.lastModifiedDate = date;
                      this.draggedItem.lastModifiedBy = this.$store.state.user.userId;
                      ShoppingListService.updateItem(this.draggedItem);
                      break;


              }
          }
      },
      dragLeave() {

      },
      filteredItems(statusId) {
          return this.myItems.filter(item => item.itemListStatusId === statusId);
      },
      updated() {
          // This hook is called after the component is updated.
          // You can perform actions here that need to run after an update.
          console.log('Component updated');
      },

  }
}
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

.kanban-board {
  margin-left: 210px;
  font-family: 'Barlow', sans-serif;
  position: fixed;
  top: 100px;
  height: 100%;
  display: flex;
  background-color: rgb(252, 252, 252);
}

.column {
  margin-right: 20px;
  transition: margin-right 0.3s;
}

.column.is-4 {
  width: 350px;
}

.item {
  background: #fff;
  border-radius: 0.25rem;
  padding: 10px;
  border: 1px;
  box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
  margin-bottom: 10px;
  cursor: pointer;
}
.item:last-child {
  margin-bottom: 0px;
}
.item h3 {
  margin-top: 0px;
  font-size: 0.875rem;
}
.item .header {
  display: flex;
  justify-content: space-between;
}
.item .header img {
  border-radius: 9999px;
  width: 32px;
  align-self: flex-start;
}
.item .footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin: 20px 0 10px 0;
  font-size: 0.75rem;
}
.pill {
  padding: 8px;
  border-radius: 20px;
  font-size: 0.7rem;
}
.design {
  background-color: #faf5ff;
  color: #6b46c1;
}
.qa {
  background-color: #f0fff4;
  color: #2c7a7b;
}

.feature {
  background-color: #e6fffa;
  color: #2c7a7b;
}
</style>

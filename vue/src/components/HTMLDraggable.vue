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
                        <div class="footer">
                            <!-- Additional content if needed -->
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
    props: ['title', 'cards', 'boardId'],
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
                console.log("Dropped");
                const columnStatusId = column.statusId;
                console.log(columnStatusId);
                console.log(this.draggedItem);

                switch (columnStatusId) {
                    case 1:
                        this.draggedItem.claimedBy = 0;
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
    /* Adjust or remove margin-left as needed */
    margin-left: 260px;
    font-family: 'Barlow', sans-serif;
    position: fixed;
    top: 180px;
    height: 100%;
    display: flex;
    /* You might not need this depending on your layout */
}

.column {
    margin-right: 20px;
    transition: margin-right 0.3s;
    /* Add a transition for a smoother effect */
}

.column.is-4 {
    width: 350px;
}
</style>
  
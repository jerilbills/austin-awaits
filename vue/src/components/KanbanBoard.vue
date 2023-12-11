<template>
  <div class="kanban-board-header">
    <div class="page-title" v-if="$store.state.activeList.name">{{ $store.state.activeList.name }} (Due {{ dueDate }})
    </div>
    <div class="page-title" v-else>Please select a list to work on. Austin Awaits!</div>
        
    <div class="invites" v-if="$store.state.activeList.name">
      <div class="is-size-7">List Owner</div>
      <div><img src="https://api.dicebear.com/7.x/initials/svg?seed=JB" class="avatar"></div>
      <div>&nbsp;&nbsp;</div>
      <div class="is-size-7">List Members</div>
      <div>
        <img src="https://api.dicebear.com/7.x/initials/svg?seed=JB" class="avatar">
        <img src="https://api.dicebear.com/7.x/initials/svg?seed=DM" class="avatar">
        <img src="https://api.dicebear.com/7.x/initials/svg?seed=NH" class="avatar">
        <img src="https://api.dicebear.com/7.x/initials/svg?seed=JF" class="avatar">
      </div>
      <div>
        <i class="fa fa-user-plus fa-lg" @click="openInviteUserToListModal()"></i>
      </div>
    </div>

  </div>

  <div class="kanban-board"  v-if="$store.state.activeList.name">
    <div class="column is-4" v-for="(column, index) in columns" :key="index" :class="{ over: isDraggedOver }"
      @drop.prevent="drop(column)" @dragover.prevent="dragOver" @dragenter.prevent="dragEnter" @dragleave="dragLeave">

      <div class="box custom-box" style="width: 350px; height: auto;" @dragstart="dragStart(column.title)"
        draggable="true">
        <h6 class="title is-6">
          <i v-if="column.title == 'Items Needed'" class="fa fa-hat-cowboy fa-lg"></i>
          <i v-if="column.title == 'Claimed'" class="fa fa-horse-head fa-lg"></i>
          <i v-if="column.title == 'Purchased'" class="fa fa-star fa-lg"></i>
          {{ column.title }}
        </h6>
        <div class="items">
          <div class="item" v-for="item in column.items" :key="item.itemId" @dragstart="dragStartItem(item)"
            draggable="true" @click="openItemModal(item)">
            <div class="header">
              <h3>{{ item.name }}</h3>
              <span v-if="item.claimedBy && item.claimedByUser" class="has-tooltip-above has-tooltip-primary"
                :data-tooltip="claimedByUserTooltip(item)">
                <img :src="item.claimedByUser.avatarUrl" class="avatar" />
              </span>
            </div>
          </div>
        </div>

        <!-- SNACKBAR ALERTS-->
        <div id="snackbar-purchased">Items cannot be removed from Purchased.</div>
        <div id="snackbar-claimed">You are not the owner of this item.</div>
        <div id="snackbar-needed">Items must be claimed before they can be purchased.</div>
        <div id="snackbar-completed">All items on the list have been purchased. Well done, partner!</div>

        <!-- ITEM DETAILS MODAL -->
        <ItemDetailsModal v-if="showItemModal" :item="selectedItem" @close="closeItemModal"  />
        <InviteUserToListModal v-if="showInviteUserToListModal" @close="closeInviteUserToListModal" />
      </div>
    </div>
  </div>
</template>

<script>
import ShoppingListService from '../services/ShoppingListService';
import ItemDetailsModal from './ItemDetailsModal.vue';
import InviteUserToListModal from './InviteUserToListModal.vue';

export default {
  name: 'KanbanBaord',
  components: {
    ItemDetailsModal,
    InviteUserToListModal
  },
  data() {
    return {
      showItemModal: false,
      showInviteUserToListModal: false,
      selectedItem: null,
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
    },
    dueDate() {
      let dueDate = new Date(this.$store.state.activeList.dueDate);
      return dueDate.toLocaleDateString();
    },
    areAllItemsComplete() {
      const unfinishedItems = this.myItems.filter((item) => { return (item.listItemStatusId === 1 || item.listItemStatusId === 2)});
      return unfinishedItems.length === 0;
    },
  },
  methods: {
    dragStart(columnTitle) {
      this.draggedColumn = columnTitle;
      console.log(this.draggedColumn);
      if (this.draggedColumn === 'Items Needed') {
        return
      }
    },
    dragStartItem(item) {
      this.draggedItem = item;
    },
    dragOver(event) {
      event.preventDefault();
    },
    drop(column) {
      console.log(this.draggedColumn);
      if (this.draggedItem && this.draggedColumn) {
        const columnStatusId = column.statusId;
        if (this.draggedColumn === "Purchased") {
          this.showPurchasedSnackbar();
          return;
        } else if (this.draggedColumn === "Claimed" && this.$store.state.user.userId != this.draggedItem.claimedBy) {
          this.showClaimedSnackbar();
          return;
        } else if (this.draggedColumn === "Items Needed" && columnStatusId === 3) {
          console.log("Needed Snackbar")
          this.showNeededSnackbar();
          return;
        } else {
          this.updateItemStatus(columnStatusId);
        }
      }
      if (this.areAllItemsComplete) {
        this.completeList();
      }
    },
    completeList() {
      this.showListCompletedSnackbar();
          this.$store.state.activeList.status = 3;
          ShoppingListService
            .updateList(this.$store.state.activeList)
            .then(response => {
              this.$store.commit('CLEAR_ACTIVE_LIST');
              this.$store.commit('CLEAR_ITEMS');
              this.$store.commit('REFRESH_SIDE_BAR');       
            })
            .catch(error => {
              console.error('Error updating list:', error);
            })
    },
    updateItemStatus(columnStatusId) {
      const formattedDate = new Date().toISOString();

      switch (columnStatusId) {
        case 1:
          this.draggedItem.claimedBy = null;
          this.draggedItem.claimedByUser = null;
          this.draggedItem.listItemStatusId = 1;
          this.draggedItem.lastModifiedDate = formattedDate;
          this.draggedItem.lastModifiedBy = this.$store.state.user.userId;
          ShoppingListService.updateItem(this.draggedItem);
          break;
        case 2:
          this.draggedItem.claimedBy = this.$store.state.user.userId;
          this.draggedItem.listItemStatusId = 2;
          this.draggedItem.lastModifiedDate = formattedDate;
          this.draggedItem.lastModifiedBy = this.$store.state.user.userId;
          ShoppingListService.updateItem(this.draggedItem);
          // need to update the item's claimed by user info here (mainly for avatar but doing everything)
          // since we're not getting the item back from the server following the change
          this.setClaimedByUserToCurrentUser()
          break;
        case 3:
          if (this.draggedColumn === "Items Needed") {
            break;
          }
          this.draggedItem.listItemStatusId = 3;
          this.draggedItem.lastModifiedDate = formattedDate;
          this.draggedItem.lastModifiedBy = this.$store.state.user.userId;
          ShoppingListService.updateItem(this.draggedItem);
          break;
      }
    },
    setClaimedByUserToCurrentUser() {
      this.draggedItem.claimedByUser = {
        userId: this.$store.state.user.userId,
        username: this.$store.state.user.username,
        role: this.$store.state.user.role,
        firstName: this.$store.state.user.firstName,
        lastName: this.$store.state.user.lastName,
        avatarUrl: this.$store.state.user.avatarUrl,
        departmentId: this.$store.state.user.departmentId
      }
    },
    showPurchasedSnackbar() {
      let x = document.getElementById("snackbar-purchased");
      x.className = "show";
      setTimeout(function () {
        x.className = x.className.replace("show", "");
      }, 4000);
    },
    showClaimedSnackbar() {
      let x = document.getElementById("snackbar-claimed");
      x.className = "show";
      setTimeout(function () {
        x.className = x.className.replace("show", "");
      }, 4000);
    },
    showNeededSnackbar() {
      let x = document.getElementById("snackbar-needed");
      x.className = "show";
      setTimeout(function () {
        x.className = x.className.replace("show", "");
      }, 4000);
    },
    showListCompletedSnackbar() {
      let x = document.getElementById("snackbar-completed");
      x.className = "show";
      setTimeout(function () {
        x.className = x.className.replace("show", "");
      }, 4000);
    },
    openItemModal(item) {
      this.selectedItem = item;
      this.showItemModal = true;
    },
    closeItemModal() {
      this.showItemModal = false;
      this.selectedItem = null;
    },
    openInviteUserToListModal(item) {
      this.showInviteUserToListModal = true;
    },
    closeInviteUserToListModal() {
      this.showInviteUserToListModal = false;
    },
    dragLeave(columnTitle) {

    },
    filteredItems(statusId) {
      return this.myItems.filter(item => item.itemListStatusId === statusId);
    },
    claimedByUserTooltip(item) {
      return item.claimedByUser.firstName + " " + item.claimedByUser.lastName;
    },    
  },
}
</script>

<style scoped>
.avatar {
  width: 25px;
  height: 25px;
  border-radius: 50%;
  margin-left: 3px;
}

.custom-box {
  width: 100%;
}

h6 {
  color: hsl(27.3, 100%, 37.5%);
}

.kanban-board,
.kanban-board-header {
  margin-left: 275px;
  position: fixed;
  top: 100px;
  height: 100%;
  display: flex;
}

.kanban-board-header {
  top: 65px;
  padding-left: 15px;
  justify-content: space-between;
  width: 100%;
  position: relative;
}

.invites {
  flex-grow: 3;
  flex-shrink: 1;
  flex-basis: 3;
  margin-right: 25px;
  margin-left: auto;
  text-align: right;
  margin-bottom: auto;
  display: flex;
  flex-direction: row;
  justify-content: flex-end;
  align-items: center;
  gap: 10px;
}


.page-title {
  font-weight: bold;
  font-size: larger;
  flex-grow: 1;
  flex-shrink: 2;
  font-family: Rye, Cutive, Georgia, 'Times New Roman', Times, serif;
  font-size: 1.5rem;
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
  font-size: 1rem;
  box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
  margin-bottom: 10px;
  cursor: pointer;
}

.item:last-child {
  margin-bottom: 0px;
}

.item h3 {
  margin-top: 0px;
  font-size: 0.885rem;
  font-family: 'Barlow', sans-serif;
}

.item .header {
  display: flex;
  justify-content: space-between;
}

.item .header img {
  border-radius: 9999px;
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

.fa-user-plus {
  color: hsl(27.3, 100%, 37.5%);
}

.fa-user-plus:hover {
  cursor: pointer;
}
#snackbar-purchased, #snackbar-claimed, #snackbar-needed, #snackbar-completed {
  visibility: hidden;
  min-width: 250px;
  margin-left: -125px;
  /* Divide value of min-width by 2 */
  background-color: #333;
  color: #fff;
  text-align: center;
  border-radius: 2px;
  padding: 16px;
  position: fixed;
  z-index: 1;
  left: 50%;
  bottom: 30px;
}

#snackbar-completed {
  background-color: #4C8077;
  bottom: 450px;
}

#snackbar-purchased.show, #snackbar-claimed.show, #snackbar-needed.show {
  visibility: visible;
  /* Show the snackbar */
  /* Add animation: Take 0.5 seconds to fade in and out the snackbar.
  Delay the fade out process for 3.5 seconds */
  -webkit-animation: fadein 0.5s, fadeout 0.5s 3.5s;
  animation: fadein 0.5s, fadeout 0.5s 3.5s;
}

#snackbar-completed.show {
  visibility: visible;
  /* Show the snackbar */
  /* Add animation: Take 0.5 seconds to fade in and out the snackbar.
  Delay the fade out process for 3.5 seconds */
  -webkit-animation: fadeintall 0.5s, fadeouttall 0.5s 3.7s;
  animation: fadeintall 0.5s, fadeouttall 0.5s 3.7s;
}

/* Animations to fade the snackbar in and out */
@-webkit-keyframes fadein {
  from {
    bottom: 0;
    opacity: 0;
  }

  to {
    bottom: 30px;
    opacity: 1;
  }
}

@keyframes fadein {
  from {
    bottom: 0;
    opacity: 0;
  }

  to {
    bottom: 30px;
    opacity: 1;
  }
}

@-webkit-keyframes fadeout {
  from {
    bottom: 30px;
    opacity: 1;
  }

  to {
    bottom: 0;
    opacity: 0;
  }
}

@keyframes fadeout {
  from {
    bottom: 30px;
    opacity: 1;
  }

  to {
    bottom: 0;
    opacity: 0;
  }
}

/* animations for a tall snackbar */

@-webkit-keyframes fadeintall {
  from {
    bottom: 0;
    opacity: 0;
  }

  to {
    bottom: 450px;
    opacity: 1;
  }
}

@keyframes fadeintall {
  from {
    bottom: 0;
    opacity: 0;
  }

  to {
    bottom: 450px;
    opacity: 1;
  }
}

@-webkit-keyframes fadeouttall {
  from {
    bottom: 450px;
    opacity: 1;
  }

  to {
    bottom: 0;
    opacity: 0;
  }
}

@keyframes fadeouttall {
  from {
    bottom: 450px;
    opacity: 1;
  }

  to {
    bottom: 0;
    opacity: 0;
  }
}
</style>

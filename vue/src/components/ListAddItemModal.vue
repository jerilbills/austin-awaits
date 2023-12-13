<template>
  <div class="modal" :class="{ 'is-active': isModalOpen }">
    <div class="modal-background" @click="closeModal"></div>
    <div class="modal-content" style="background-color: #ffffff; max-width: 500px; padding: 20px;">
      <button class="delete is-large" aria-label="close" @click="closeModal"
        style="position: absolute; top: 10px; right: 10px;"></button>
      <div class="field">
        <label class="item-name">Item Name</label>
        <select class="select" v-model="selectedItemId" required>
          <option v-for="item in availableItems" :key="item.itemId" :value="item.itemId">
            {{ item.name }}
          </option>
        </select>
      </div>
      <div class="field">
        <label class="quantity">Quantity Needed</label>
        <input class="input" type="number" v-model="itemQuantity" required>
      </div>
      <button class="button is-primary" @click="addItem" style="margin-right: 5px;">Save Item</button>
      <button class="button is-link" @click="closeModal">Cancel</button>
    </div>
  </div>
</template>

<script>
import ItemService from '../services/ItemService';

export default {
  props: {
    isModalOpen: Boolean,
    closeModal: Function,
    availableItems: Array,
  },
  data() {
    return {
      selectedItem: null,
      itemQuantity: "",
    };
  },
  methods: {
    addItem() {
      if (!this.selectedItemId) {
        return;
      }
      const selectedItem = this.availableItems.find(item => item.itemId === this.selectedItemId);
      const newItem = {
        listId: this.$store.state.activeList.listId,
        itemId: selectedItem.itemId,
        name: selectedItem.name,
        description: selectedItem.description,
        imgUrl: selectedItem.imgUrl,
        listItemStatusId: 1,
        createdBy: this.$store.state.user.userId,
        lastModifiedBy: this.$store.state.user.userId,
        quantity: this.itemQuantity,
        claimedBy: null,
        isActive: true,
      };

      ItemService.addItemToList(this.$store.state.user.departmentId, this.$store.state.activeList.listId, newItem)
      .then(response => {
        this.$emit("item-added", newItem);
      })
      .catch(error => {
        console.error("Error adding item to list", error);
      });
      this.closeModal();
    },
  },
};
</script>

<style scoped>
.item-name {
  display: flex;
  flex-direction: column;
}
</style>

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
        name: selectedItem.name,
        quantity: this.itemQuantity,
      };
      this.$emit("item-added", newItem);
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

<template>
  <div class="modal" :class="{ 'is-active': isModalOpen }">
    <div class="modal-background" @click="closeModal"></div>
    <div class="modal-content" style="background-color: #ffffff; max-width: 500px; padding: 20px;">
      <button class="delete is-large" aria-label="close" @click="closeModal"
        style="position: absolute; top: 10px; right: 10px;"></button>

      <div class="field is-horizontal" style="padding-top: 40px;">
          <div class="field-label is-normal">
            <label for="item" class="label">Item&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
          </div>
          <div class="field-body">
            <div class="field">
              <div class="control is-expanded">
                <div class="select">
                  <select id="item" name="item" v-model="selectedItemId" required>
                    <option v-for="item in availableItems" :key="item.itemId" :value="item.itemId">
                      {{ item.name }}
                    </option>
                  </select>                
                </div>
              </div>
            </div>
          </div>
        </div>
      <div class="field is-horizontal">
          <div class="field-label is-normal">
            <label for="quantity" class="label">Quantity</label>
          </div>
          <div class="field-body">
            <div class="field">
              <p class="control is-expanded">
                <input id="quantity" name="quantity" class="input" type="number" v-model="itemQuantity" required min="1" :disabled="!selectedItemId">
              </p>
            </div>
          </div>
        </div>
      <button class="button is-primary" @click="addItem" style="margin-right: 5px;" :disabled="!hasRequiredFields">Save Item</button>
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
      selectedItemId: null,
      itemQuantity: 1,
    };
  },
  computed: {
    hasRequiredFields() {
      return this.selectedItemId && this.itemQuantity > 0;
    }
  },
  methods: {
    addItem() {
      if (!this.selectedItemId && !this.itemQuantity > 0) {
        return;
      }
      // const selectedItem = this.availableItems.find(item => item.itemId === this.selectedItemId);
      const newItem = {
        itemId: this.selectedItemId,
        quantity: this.itemQuantity,
      };
      this.$emit("item-added", newItem);
      this.closeModal();
    },
  },
};
</script>

<style scoped>

</style>

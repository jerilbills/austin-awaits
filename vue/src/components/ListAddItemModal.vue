<template>
  <div class="modal" :class="{ 'is-active': isModalOpen }">
    <div class="modal-background" @click="closeModal"></div>
    <div class="modal-content" style="background-color: #ffffff; max-width: 500px; padding: 20px;">
      <button class="delete is-large" aria-label="close" @click="close"
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
                    <option v-for="item in itemsThatCanBeAdded" :key="item.itemId" :value="item.itemId">
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
      <button class="button is-link" @click="close">Cancel</button>
    </div>
  </div>
</template>

<script>
import ItemService from '../services/ItemService';

export default {
  props: {
    isModalOpen: Boolean,
    closeModal: Function,
    itemsThatCanBeAdded: Array,
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
      const newItem = {
        listId: this.$store.state.activeList.listId,
        itemId: this.selectedItemId,
        quantity: this.itemQuantity
      };

      ItemService.addItemToList(this.$store.state.user.departmentId, this.$store.state.activeList.listId, newItem)
      .then(response => {
        this.$emit("item-added", response.data);
      })
      .catch(error => {
        console.error("Error adding item to list", error);
      });
      this.itemQuantity = 1;
      this.selectedItemId = null;
      this.closeModal();
    },
    close() {
      this.itemQuantity = 1;
      this.selectedItemId = null;
      this.closeModal();
    }
  },
};
</script>

<style scoped>

</style>

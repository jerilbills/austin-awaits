<template>
    <div class="modal-container">
      <div class="modal-content">
        <div class="flex-container">
          <img :src="item.imgUrl" alt="{{ item.name }}" class="modal-image">
          <div class="text-container">
            <p class="item-name">{{ item.name }}</p>
            <p class="item-status"><strong>Status: </strong>{{ showItemStatus(item) }}</p>
            <p class="item-quantity" v-if="item.quantity > 1"><strong>Quantity: </strong>{{ item.quantity }}</p>
            <p class="item-description">{{ item.description }}</p>
            <p class="last-modified">Last modified: {{ item.lastModifiedDate }}</p>
          </div>
        </div>
  
        <div class="button-container">
          <button type="button" class="close-button" @click="closeItemModal">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    props: ['item'],
    data() {
      return {};
    },
    methods: {
      closeItemModal() {
        this.$emit('close');
      },
      showItemStatus(item) {
        if(item.listItemStatusId === 1) {
            return 'Needed';
        } else if (item.listItemStatusId === 2) {
            return "Claimed";
      } else if (item.listItemStatusId === 3) {
        return "Purchased";
      }
    }
    },
  };
  </script>
  
  <style scoped>
  .modal-container {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.5);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 999;
    /* Ensure it appears above other content */
  }
  
  .modal-content {
    background-color: #fff;
    padding: 20px;
    border-radius: 5px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
    max-width: 900px;
    width: 100%;
    position: relative;
  }
  
  .flex-container {
    display: flex;
  }
  
  .modal-image {
    width: 250px; 
    height: auto; 
    margin-right: 30px; 
  }
  
  .text-container {
    flex: 1;
  }
  
  .button-container {
    position: absolute;
    top: 10px;
    right: 10px;
  }
  
  .close-button {
    background-color: #bf5700;
    color: #fff;
  }

  .item-name {
    font-size: 24px;
    font-weight: 600;
    margin-bottom: 15px;
  }

  .item-status {
    font-size: 14px;
    font-weight: 400;
    margin-bottom: 15px;
  }

  .item-quantity {
    font-size: 14px;
    font-weight: 400;
    margin-bottom: 15px;
  }

  .item-description {
    font-size: 16px;
    margin-bottom: 60px;
  }
  .last-modified {
    font-size: 10px;
    font-weight: 400;
    margin-bottom: 15px;
  }
  button:hover {
    cursor: pointer;
  }
  </style>
  
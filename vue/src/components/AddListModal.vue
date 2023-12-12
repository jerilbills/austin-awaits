
<template>
    <div class="modal">
      <div class="modal-content">
        <p>This is a placeholder content for the modal</p>
        <button @click="closeModal">Close</button>
      </div>
    </div>
  </template>
  
  
  <script>
  export default {
    props: ['showListModal'], 
    methods: {
      closeModal() {
        this.$emit('close-modal');
      },
    },
  };
  </script>
  
  <style scoped>
  .modal {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.5);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 9999;
    /* Ensure it appears above other content */
  }
  
  .modal-content {
    background: #fff;
    padding: 20px;
    width: 300px;
    margin: 10% auto;
  }
  </style>
  
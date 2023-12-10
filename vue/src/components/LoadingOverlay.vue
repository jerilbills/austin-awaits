<template>
    <div v-if="loading" class="loading-overlay">
      {{ message }}
    </div>
  </template>
  
  <script>
  export default {
    props: {
      loading: Boolean,
      message: {
        type: String,
        default: "Loading...",
      },
    },
  };
  </script>
  
  <style scoped>
  .loading-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(255, 255, 255, 0.8);
    /* Semi-transparent white background */
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 999;
    /* Ensure it's on top of other elements */
  }
  </style>
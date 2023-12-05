<template>
    <div class="sidebar">
      <ul>
        <li @click="navigateTo('home')">Henry Edwards</li>
        <li @click="navigateTo('about')">Mimi Malone</li>
        <li @click="navigateTo('contact')">Bobby Tables</li>
      </ul>
    </div>
  </template>
  
  <script>
  export default {
    methods: {
      navigateTo(route) {
        // You can use Vue Router or other navigation methods here
        console.log(`Navigating to ${route}`);
      },
    },
  };
  </script>
  
  <style scoped>
  .sidebar {
  width: 250px;
  background-color: #ffffff;
  color: rgb(0, 0, 0);
  padding: 20px;
  position: fixed; /* Set position to fixed */
  top: 100px; /* Pin to the top of the viewport */
  left: 0;
  height: 100%;
  font-family: 'Barlow', sans-serif;
  border-right: 1px solid #e0e0e0; /* Faint border on the right side */
  box-shadow: 5px 0px 10px rgba(0, 0, 0, 0.1); /* Drop shadow on the right side */
}
  
  ul {
    list-style: none;
    padding: 0;
    margin: 0;
  }
  
  li {
    cursor: pointer;
    margin-bottom: 10px;
  }
  
  li:hover {
    color: #bf5700;
    font-weight: bold;
    font-size: large;
    
  }
  </style>
  
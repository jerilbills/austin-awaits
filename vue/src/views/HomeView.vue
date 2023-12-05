<template>
  <div class="home">
    <h1>Home</h1>
    <p>You must be authenticated to see this</p>
    <create-group-button></create-group-button>
  </div>
</template>

<script>
import CreateGroupButton from '../components/CreateGroupButton.vue';

export default {
  components: {
    CreateGroupButton
  }
};
</script>

<template>
  <div class="card">
    <div class="bg-white shadow rounded px-3 pt-3 pb-5 border border-white">
      <!-- Displaying item information -->
      <div class="media is-justify-content-space-between">
        <div class="media-left">
          <p class="text-gray-700 font-semibold font-sans tracking-wide text-sm">{{ item.text }}</p>
        </div>
        <div class="media-right">
          <img v-if="item.avatar" class="image is-32x32" :src="getAvatarUrl(item.avatar)" alt="Avatar">
          <badge v-if="item.type" :color="badgeColor">{{ item.type }}</badge>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Badge from "./Badge.vue";

export default {
  components: {
    Badge,
  },
  props: {
    item: {
      type: Object,
      default: () => ({}),
    },
  },
  methods: {
    getAvatarUrl() {
      // Directly use the avatar property from the item prop
      return this.item.avatar;
    },
    handleAvatarError(event) {
      // Handle avatar loading errors
      console.error('Error loading avatar:', event.target.src);
      // basically set a default avatar image
      event.target.src = '../assets/AvatarMaker.png';
    },
  },
  computed: {
    badgeColor() {
      const mappings = {
        Design: "purple",
        "Feature Request": "teal",
        Backend: "blue",
        QA: "green",
        default: "teal",
      };
      return mappings[this.item.type] || mappings.default;
    },
  },
};
</script>

<style scoped>
.card {
  font-family: 'Barlow', sans-serif;
  border-right: 1px solid #e0e0e0; /* Faint border on the right side */
  box-shadow: 5px 0px 10px rgba(0, 0, 0, 0.1); /* Drop shadow on the right side */
}
</style>

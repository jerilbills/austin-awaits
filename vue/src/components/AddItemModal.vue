<template>
  <div class="modal" :class="{ 'is-active': showModal }">
    <div class="modal-background" @click="hideModal"></div>
    <div class="modal-content">
      <div class="modal-close-div"><button class="modal-close is-large" aria-label="close" @click="closeModalWithoutItem"></button></div>
      <div class="box">
        <h2>Add New Item</h2>
        <form @submit.prevent="addItem">

          <!-- Item Name -->
          <div class="field">
            <label class="label">Item Name:</label>
            <div class="control">
              <input class="input" name="itemname" v-model="newItemName" @blur="getImages(newItemName)" required />
            </div>
          </div>

          <!-- Item Description -->
          <div class="field">
            <label class="label">Item Description:</label>
            <div class="control">
              <textarea class="textarea" name="description" v-model="newItemDescription" required></textarea>
            </div>
          </div>

          <!-- Item Image -->
          <div class="item-image">
            <div class="field">
              <label class="label">Select Item Image:</label>
              <div class="images-not-loaded" v-if="!potentialImages.images && !loadingItems"><p>Please enter an <u>Item Name</u> to display potential images.</p><p>Be as specific and descriptive as possible.</p></div>
              <div><progress class="progress is-small is-primary" max="100" v-if="loadingItems"></progress></div>
              <div class="control image-options" v-if="potentialImages.images && !loadingItems">
                <div v-for="(image, index) in displayedImages" :key="image.id" class="image-option">
                  <img :src="image" alt="Potential Image" @click="selectImage(image)"
                    :class="{ 'selected': image === newImgUrl }" @error="imgPlaceholder"/>
                </div>
              </div>
            </div>

            <!-- Pagination Controls -->
            <div class="pagination" v-if="totalPages > 1">
              <button @click="prevPage" :disabled="currentPage === 1" class="button is-primary is-small">
                Previous
              </button>
              <span v-if="totalPages > 0">{{ currentPage }} of {{ totalPages }}</span>
              <button @click="nextPage" :disabled="currentPage === totalPages" class="button is-primary is-small"
                type="button">
                Next
              </button>
            </div>
          </div>
          

          <!-- Submit and Cancel Buttons -->
          <div class="field is-grouped">
            <div class="control">
              <button type="submit" class="button is-primary" @click="addNewItem()" :disabled="!newItemName || !newItemDescription">Submit</button>
            </div>
            <div class="control">
              <button @click="closeModalWithoutItem" class="button is-link">Cancel</button>
            </div>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>
  
<script>
import ImageService from '../services/ImageService';
import ItemService from '../services/ItemService';

export default {
  props: {
    showModal: Boolean,
    hideModal: Function,
    addNewItem: Function
  },
  data() {
    return {
      newItemName: "",
      newItemDescription: "",
      newImgUrl: "",
      potentialImages: [],
      itemsPerPage: 3,
      currentPage: 1,
      numberOfPages: 0,
      loadingItems: false
    };
  },
  computed: {
    totalPages() {
      return Math.ceil((this.potentialImages.images || []).length / this.itemsPerPage);
    },
    displayedImages() {
      const startIndex = (this.currentPage - 1) * this.itemsPerPage;
      const endIndex = startIndex + this.itemsPerPage;

      if (this.potentialImages && this.potentialImages.images) {
        return this.potentialImages.images.slice(startIndex, endIndex);
      } else {
        return [];
      }
    },
  },
  methods: {
    addItem() {
      if(!this.newItemName || !this.newItemDescription || !this.newImgUrl) {
        console.error("All fields are required");
      }
      
      const newItem = {
        name: this.newItemName,
        imgUrl: this.newImgUrl,
        description: this.newItemDescription,
        createdBy: this.$store.state.user.userId,
      };
      
      ItemService.addItemToCatalog(newItem)
      .then(response => {
        this.clearData();
        this.hideModal(response.data);
      })
      .catch(error => {
        console.error("Error adding item", error);
      });
    },
    closeModalWithoutItem() {
        this.clearData();
        this.hideModal();
    },
    clearData() {
      this.newItemName = "";
        this.newItemDescription = "";
        this.newImgUrl = "";
        this.potentialImages = [];
        this.currentPage = 1;
        this.numberOfPages = 0;
        this.loadingItems = false;
    },
    selectImage(imageUrl) {
      this.newImgUrl = imageUrl;
    },
    prevPage() {
      if (this.currentPage > 1) {
        this.currentPage--;
      }
    },
    nextPage() {
      if (this.currentPage < this.totalPages) {
        this.currentPage++;
      }
    },
    getImages(itemName) {
      const payload = {
        "itemName": itemName
      };
      this.loadingItems = true;
      ImageService.getPotentialImages(payload)
        .then(response => {
          this.potentialImages = response.data;
          this.loadingItems = false;
        })
        .catch(error => {
          console.error('Error fetching potential images:', error);
        });
    },
    imgPlaceholder(e) {
        e.target.src = "/src/assets/blank-pixel.png"
    }
  },
};
</script>
  
<style scoped>
.modal {
}
.modal-content {
  max-width: 800px;
  margin: 0 auto;
}

.modal-close {
  position: absolute;
  top: 10px; 
  right: 10px;
  background-color: rgba(10, 10, 10, 0.2);
}

.modal-close:active, .modal-close:hover {
  background-color: rgba(10, 10, 10, 0.4);

}

.images-not-loaded {
  color: #bf5700;
}
.image-options {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
}

.image-option {
  margin-right: 10px;
}

.image-option img {
  cursor: pointer;
  border: 2px solid transparent;
  max-width: 180px;
  height: 150px;
  cursor: pointer;
}

.image-option img.selected {
  border: 3px solid #bf5700;
}
.item-image {
  height:260px;
}
</style>
  
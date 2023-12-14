<template>
  <div class="modal" :class="{ 'is-active': showModal }">
    <div class="modal-background" @click="hideModal"></div>
    <div class="modal-content">
      <div class="modal-close-div"><button class="modal-close is-large" aria-label="close" @click="closeModalWithoutItem"></button></div>
      <div class="box">
        <h2>Edit Item</h2>
        <form @submit.prevent="addItem">

          <!-- Item Name -->
          <div class="field">
            <label class="label">Item Name:</label>
            <div class="control">
              <input class="input" name="itemname" id="name" v-model="itemUnderEdit.name" required />
            </div>
          </div>

          <!-- Item Description -->
          <div class="field">
            <label class="label">Item Description:</label>
            <div class="control">
              <textarea class="textarea" name="description" id="description" v-model="itemUnderEdit.description" required></textarea>
            </div>
          </div>

          <!-- Existing Item Image -->
          <div class="field" v-if="existingImage">
            <label class="label">Item Image: <div class="button is-primary is-small" @click="clearImage">Change Image</div></label>
            <div class="control">
              <img id='existing-image' :src="itemUnderEdit.imgUrl" :alt="itemUnderEdit.name" @error="imgPlaceholder" style="max-height: 250px;"/>
            </div>
          </div>

          

          <!-- Submit and Cancel Buttons -->
          <div class="field is-grouped">
            <div class="control">
              <button type="submit" class="button is-primary" @click="addEditedItem()" :disabled="!hasRequiredFields">Save</button>
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
    addNewItem: Function,
    selectedItem: Object
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
      loadingItems: false,
      itemUnderEdit: {},
      existingImage: false
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
    hasRequiredFields() {
      // return this.itemUnderEdit.name && this.itemUnderEdit.description;

      // TODO - complete POST and then turn this functionality on
      return false;
    }
  },
  methods: {
    hasItemChanged() {
      return this.itemUnderEdit.name != this.selectedItem.name || 
      this.itemUnderEdit.description != this.selectedItem.description || 
      (this.existingImage && this.itemUnderEdit.imgUrl != this.selectedItem.imgUrl) || 
      !this.existingImage;
    },
    addItem() {
      if (this.hasItemChanged()) {
        // create item to put
        const updatedItem = {
          itemId: this.itemUnderEdit.itemId,
          name: this.itemUnderEdit.name,
          description: this.itemUnderEdit.description,
          imgUrl: this.existingImage ? this.itemUnderEdit.imgUrl : this.newImgUrl,
          lastModifiedBy: this.$store.state.user.userId
        };

        console.log(updatedItem);
        /*
        // TODO - change from post to put  
        ItemService.addItemToCatalog(updatedItem)
          .then(response => {
            this.clearData();

            // TODO - passing back updated info on the return function  so grid gets updated 
            this.hideModal(response.data);
          })
          .catch(error => {
            console.error("Error adding item", error);
          });
          */
      }
      else {
        // item hasn't changed - just do a normal close
        this.closeModalWithoutItem();
      }
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
        this.itemUnderEdit = {};
        this.existingImage = false;
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
    },
    clearImage() {
      this.existingImage = false;
    }
  },
  updated() {
    if (!this.itemUnderEdit.itemId) {
      this.itemUnderEdit = Object.assign({}, this.selectedItem);
      if (this.itemUnderEdit.imgUrl) {
        this.existingImage = true;
      }
    }

  }
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
  
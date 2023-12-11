<template>
    <div class="modal" :class="{ 'is-active': showModal }">
        <div class="modal-background" @click="hideModal"></div>
        <div class="modal-content">
            <div class="box">
                <h2>Add New Item</h2>
                <form @submit.prevent="addItem">

                    <!-- Item Name -->
                    <div class="field">
                        <label class="label">Item Name:</label>
                        <div class="control">
                            <input class="input" v-model="newItemName" required />
                        </div>
                    </div>

                    <!-- Item Image -->
                    <div class="field">
                        <label class="label">Select Item Image:</label>
                        <div class="control image-options">
                            <div v-for="(image, index) in displayedImages" :key="image.id" class="image-option">
                                <img :src="image.url" alt="Potential Image" @click="selectImage(image.url)"
                                    :class="{ 'selected': image.url === newItemImage }" />
                            </div>
                        </div>

                        <!-- Pagination Controls -->
                        <div class="pagination">
                            <button @click="prevPage" :disabled="currentPage === 1"
                                class="button is-primary is-small">Previous</button>
                            <span>{{ currentPage }} of {{ totalPages }}</span>
                            <button @click="nextPage" :disabled="currentPage === totalPages"
                                class="button is-primary is-small">Next</button>
                        </div>
                    </div>

                    <!-- Item Description -->
                    <div class="field">
                        <label class="label">Item Description:</label>
                        <div class="control">
                            <textarea class="textarea" v-model="newItemDescription" required></textarea>
                        </div>
                    </div>

                    <!-- Submit and Cancel Buttons -->
                    <div class="field is-grouped">
                        <div class="control">
                            <button type="submit" class="button is-primary">Submit</button>
                        </div>
                        <div class="control">
                            <button @click="hideModal" class="button is-link">Cancel</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
        <button class="modal-close is-large" aria-label="close" @click="hideModal"></button>
    </div>
</template>
  
<script>
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
            newItemImage: "",
            potentialImages: [
                { id: 1, url: 'https://cdn-wholeearth.celerantwebservices.com/prodimages/13863-DEFAULT-l.jpg' },
                { id: 2, url: 'https://store.bullockmuseum.org/mas_assets/cache/image/1/a/6/3/6755.Jpg' },
                { id: 3, url: 'https://cdn-wholeearth.celerantwebservices.com/prodimages/24034-DEFAULT-l.jpg' },
                { id: 4, url: 'https://i.pinimg.com/originals/7c/b6/06/7cb606b10afefc7ec2f5e3a3dd74edd9.jpg' },
                { id: 5, url: 'https://ih1.redbubble.net/image.1720266979.3814/ssrco,slim_fit_t_shirt,mens,101010:01c5ca27c6,front,square_product,600x600.jpg' },
                { id: 6, url: 'https://ih1.redbubble.net/image.775751043.5242/ssrco,classic_tee,mens,9ec0d5:0d26d5c715,front_alt,square_product,600x600.u1.jpg' },
                { id: 7, url: 'https://i.pinimg.com/originals/ec/96/cc/ec96ccdd045887ef33df946831896984.jpg' },
                { id: 8, url: 'https://i.pinimg.com/originals/4a/ce/66/4ace66bae474fb40a893c5b44749bfe6.jpg' },
                { id: 9, url: 'https://via.placeholder.com/150x150' },
                { id: 10, url: 'https://via.placeholder.com/150x150' },
                { id: 11, url: 'https://via.placeholder.com/150x150' },
            ],
            itemsPerPage: 6,
            currentPage: 1,
        };
    },
    computed: {
        totalPages() {
            return Math.ceil(this.potentialImages.length / this.itemsPerPage);
        },
        displayedImages() {
            const startIndex = (this.currentPage - 1) * this.itemsPerPage;
            const endIndex = startIndex + this.itemsPerPage;
            return this.potentialImages.slice(startIndex, endIndex);
        }
    },
    methods: {
        addItem() {
            // Add logic to handle the form submission and add a new item
            const newItem = {
                name: this.newItemName,
                itemImage: this.newItemImage,
                itemDescription: this.newItemDescription
            };

            // Clear the form fields
            this.newItemName = "";
            this.newItemDescription = "";
            this.newItemImage = "";

            // Hide the modal
            this.hideModal();
        },
        selectImage(imageUrl) {
            this.newItemImage = imageUrl;
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
        }
    }
};
</script>
  
<style scoped>
.modal-content {
    max-width: 800px;
    margin: 0 auto;
}
.image-options {
    display: flex;
    flex-wrap: wrap;
    justify-content: flex-start;
}

.image-option {
    margin-right: 10px;
}

.image-option img {
    cursor: pointer;
    border: 2px solid transparent;
    width: 150px;
    height: auto;
    cursor: pointer;
}

.image-option img.selected {
    border: 2px solid #bf5700;
}
</style>
  
  
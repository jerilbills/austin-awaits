<template>
    <div class="modal-container">
        <div class="modal-content">
            <label for="name">Name</label>
            <input id="name" v-model="editedItem.Name" required>

            <label for="description">Description</label>
            <textarea id="description" v-model="editedItem.Description" required></textarea>

            <div class="button-container">
                <button class="save-button" @click="saveChanges">Save Changes</button>
                <button class="cancel-button" @click="cancelEdit">Cancel</button>
            </div>
        </div>
    </div>
</template>

<script>

export default {
    props: ['item'],
    data() {
        return {
            editedItem: { ...this.item }
        }
    },
    methods: {
        // async saveChanges(editedItem) {
        //     try {
        //         const success = editedItem.id ? await API_PUT_METHOD(editedItem) : await API_POST_METHOD(editedItem);

        //         if (success) {
        //             this.showEditModal = false;
        //             await this.getItemMethod(); // need method to get new item I think??
        //         } else {
        //             console.log('Failed to save changes');
        //         }
        //     } catch (error) {
        //         console.log(error);

        //     }
        // }
    }
}
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
    max-width: 400px;
    width: 100%;
}

.label {
    margin-bottom: 5px;
}

textarea {
    height: 100px;
    /* Adjust as needed */
    resize: vertical;
    margin-bottom: 10px;
}

.button-container {
    display: flex;
    justify-content: space-between;
    margin-top: 10px;
}

.save-button,
.cancel-button {
    padding: 10px;
    border: none;
    cursor: pointer;
}

.save-button {
    background-color: #4caf50;
    color: #fff;
}

.cancel-button {
    background-color: #f44336;
    color: #fff;
}
</style>
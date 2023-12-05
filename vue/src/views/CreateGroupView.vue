<template>
    <form>
        <label for="group-name">Group Name (required)</label>
        <input id="group-name" type="text">
        <label for="group-description">Description</label>
        <textarea name="group-description" id="group-description" cols="30" rows="10"></textarea>
        <input type="submit">
    </form> 
</template>

<script>
export default {
    methods: {
        handleErrorResponse(error, verb) {
            if (error.response) {
            if (error.response.status == 404) {
                this.$router.push({name: 'NotFoundView'});
            } else {
                this.$store.commit('SET_NOTIFICATION',
                ` Error ${verb} topic. Response received was "${error.response.statusText}".`);
            }
            } else if (error.request) {
                this.$store.commit('SET_NOTIFICATION', `Error ${verb} topic. Server could not be reached.`);
            } else {
                this.$store.commit('SET_NOTIFICATION', `Error ${verb} topic. Request could not be created.`);
            }
        },
        validateForm() {
            let msg = '';
            if (this.editCard.title.length === 0) {
                msg += 'The new card must have a title. ';
            }
            if (this.editCard.status.length === 0) {
                msg += 'The new card must have a status.';
            }
            if (msg.length > 0) {
                this.$store.commit('SET_NOTIFICATION', msg);
                return false;
            }
            return true;
        }
    }
}
</script>
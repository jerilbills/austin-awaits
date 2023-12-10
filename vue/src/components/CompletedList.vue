<template>
    <div class="kanban-board-header">
        <div class="page-title">{{ "List Name Here" }}
        </div>
        <div class="invites">
            <div class="is-size-7">List Owner</div>
            <div><img src="https://api.dicebear.com/7.x/initials/svg?seed=JB" class="avatar"></div>
            <div>&nbsp;&nbsp;</div>
            <div class="is-size-7">List Members</div>
            <div>
                <img src="https://api.dicebear.com/7.x/initials/svg?seed=JB" class="avatar">
                <img src="https://api.dicebear.com/7.x/initials/svg?seed=DM" class="avatar">
                <img src="https://api.dicebear.com/7.x/initials/svg?seed=NH" class="avatar">
                <img src="https://api.dicebear.com/7.x/initials/svg?seed=JF" class="avatar">
            </div>
            <div><i class="fa fa-user-plus fa-lg"></i></div>
        </div>
    </div>
    <div>
        <h6>Items Purchased</h6>
    </div>
</template>

<script>
export default {
computed: {
    
}
}
</script>

<style>
</style>
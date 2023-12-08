<template>
    <nav class="navbar" role="navigation" aria-label="main navigation">
      <div class="navbar-brand">
        <a class="navbar-item" href="#">
          <img src="../assets/austin-awaits-logo.png" width="auto" height="300%">
        </a>
      </div>
  
      <div id="navbar" class="navbar-menu">
        <div class="navbar-start">
          <div class="navbar-brand-text"></div>
        </div>

            <div class="navbar-end">
                <div class="navbar-item">
                    <div class="buttons">
                        <a class="navbar-item">
                            HOME
                        </a>
                        <p> | </p>
                        <a class="navbar-item">
                            INVITES
                        </a>
                        <p> | </p>
                        <a class="navbar-item" href="/logout">
                            LOGOUT
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </nav>
</template>
  
<script>
export default {
    data() {
        return {
            isNavbarActive: false,
        };
    },
    methods: {
        toggleNavbar() {
            this.isNavbarActive = !this.isNavbarActive;
        },
    },
};
</script>
  
<style scoped>
.navbar {
  background-color: #fff;
  border-bottom: 1px solid #ddd;
  position: fixed;
  width: 100%;
  height: 100px;
  top: 0;
  left: 0;
  z-index: 1000;
  display: flex;
  justify-content: space-between; /* Align items to the start and end of the navbar */
  align-items: center; /* Center items vertically */
  font-family: 'Barlow', sans-serif;
}

.navbar-brand {
  padding: 0 1rem;
}

.navbar-menu {
  margin-right: 1rem;
}

.navbar-brand-text {
  font-size: 1.2rem; 
  font-weight: bold; 
  margin-top: 0.6rem;
}

.navbar-brand-text:hover {
  font-weight: bold;
}

</style>
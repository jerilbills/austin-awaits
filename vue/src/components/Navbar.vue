<template>
  <nav class="navbar is-dark is-fixed-top" role="navigation" aria-label="main navigation">


    <div id="navbar" class="navbar-menu">
      <div class="navbar-brand">
        <router-link class="navbar-item" :to="{ name: 'home' }">
          <img id="logo" src="../assets/austin-awaits-logo.png" width="auto" height="200%">
        </router-link>
      </div>
      <div class="navbar-end ">
        <div class="navbar-item">
          <div class="buttons">
            <span class="is-size-7 welcome">Welcome, {{ $store.state.user.firstName }} {{ $store.state.user.lastName }} {{
              userDepartmentName ? "(" + userDepartmentName + ")" : "" }}</span>
            <a class="navbar-item" href="/">
              My Account
            </a>
            <router-link class="navbar-item" :to="{ name: 'logout' }">
              Logout
            </router-link>
          </div>
        </div>
      </div>
    </div>
  </nav>
</template>
  
<script>
import departmentService from '../services/DepartmentService';

export default {
  data() {
    return {
      isNavbarActive: false,
      userDepartmentName: ""
    };
  },
  methods: {
    toggleNavbar() {
      this.isNavbarActive = !this.isNavbarActive;
    },
    getUserDepartment() {
      if (!this.userDepartmentName) {
        departmentService
          .getDepartments()
          .then((response) => {
            response.data.forEach((dept) => {
              if (dept.departmentId == this.$store.state.user.departmentId) {
                this.userDepartmentName = dept.departmentName;
              }
            });
          })
          .catch((error) => {
            console.log("Could not retrieve departments");
          })
      }
    }
  },
  created() {
    this.getUserDepartment();
  }
};
</script>
  
<style scoped>
.navbar-item img {
  max-height: 42px;
  width: auto;
  padding: 0px;
  border: 0px;
}

.navbar-brand>a.navbar-item:hover, .navbar-brand>a.navbar-item:visited, .navbar-brand>a.navbar-item:focus  {
  background-color: #BF5700 !important;
}

.navbar-item {
  display: flex;
}

.navbar a {
  color: white;
  padding: 5px;
  margin-right: 10px;
}

.navbar a:hover, a:focus {
  color: #BF5700;
}
.navbar  {
  color: #BF5700;
}

.navbar,
.navbar-menu,
.navbar-start,
.navbar-end {
  align-items: stretch;
  display: flex;
  padding: 0;
  color: white;
  background-color: #BF5700;
  position: fixed;
  width: 100%;
  height: 50px;
  top: 0;
  left: 0;
  justify-content: space-between;
  align-items: center;
}

.navbar-start {
  justify-content: flex-start;
  margin-right: auto;
}

.navbar-end {
  justify-content: flex-end;
  margin-left: auto;
  z-index: -1;
}

.navbar-brand {
  padding: 0 1rem;
}

.navbar-menu {
  margin-right: 1rem;
}

.welcome {
  padding: 2px 20px 0px 0px;
  color: white;
}
</style>
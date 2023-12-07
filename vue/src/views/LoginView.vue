<template>
  <div id="login" class="columns">
    <div class="column spacer"></div>
    <div class="column is-narrow">
      <div id="logo"><img src="/src/assets/austin-awaits-logo.png" alt="Austin Awaits" width="400"></div>
      <form v-on:submit.prevent="login" class="box">
        <h1 class="is-size-3">Login</h1>
        <div role="alert" v-if="invalidCredentials" class="has-text-danger">
          Invalid username and password.
        </div>
        <div role="alert" v-if="this.$route.query.registration" class="has-text-success">
          Thank you for registering, please sign in.
        </div>
        <div class="field">
          <label for="username" class="label">Username</label>
          <p class="control has-icons-left">
            <input type="text" id="username" v-model="user.username" required autofocus placeholder="Username"
              autocomplete="off" autocapitalize="off" class="input" />
            <span class="icon is-small is-left">
              <i class="fas fa-user"></i>
            </span>
          </p>
        </div>
        <div class="field">
          <label for="password" class="label">Password</label>
          <p class="control has-icons-left has-icons-right">
            <input type="password" id="password" v-model="user.password" required placeholder="Password"
              autocomplete="off" autocapitalize="off" class="input" />
            <span class="icon is-small is-left">
              <i class="fas fa-lock"></i>
            </span>
            <span class="icon is-small is-right is-clickable" @click="togglePassword()"
              @mouseover="isHoveringOnPasswordToggle = true" @mouseout="isHoveringOnPasswordToggle = false">
              <i class="fas fa-eye" v-if="!showingPassword" :class="{ hovering: isHoveringOnPasswordToggle }"></i>
              <i class="fas fa-eye-slash" v-if="showingPassword" :class="{ hovering: isHoveringOnPasswordToggle }"></i>
            </span>
          </p>
        </div>
        <div class="field">
          <p class="control">
            <button type="submit" class="button is-rounded is-primary is-fullwidth"
              :disabled="(!user.username || !user.password)">
              Login
            </button>
          </p>
        </div>
        <div id="register">
          <router-link v-bind:to="{ name: 'register' }">Need an account? Sign up.</router-link>
        </div>
      </form>
    </div>
    <div class="column spacer"></div>
  </div>
</template>

<script>
import authService from "../services/AuthService";

export default {
  components: {},
  data() {
    return {
      user: {
        username: "",
        password: ""
      },
      invalidCredentials: false,
      showingPassword: false,
      isHoveringOnPasswordToggle: false
    };
  },
  methods: {
    login() {

      authService
        .login(this.user)
        .then(response => {
          if (response.status == 200) {
            this.$store.commit("SET_AUTH_TOKEN", response.data.token);
            this.$store.commit("SET_USER", response.data.user);
            this.$router.push("/");
          }
        })
        .catch(error => {
          const response = error.response;

          if (response.status === 401) {
            this.invalidCredentials = true;
            this.$router.push("/");
          }
        });
    },
    togglePassword() {
      var x = document.getElementById("password");
      if (x.type === "password") {
        x.type = "text";
        this.showingPassword = true;
      } else {
        x.type = "password";
        this.showingPassword = false;
      }
    }
  }
};
</script>

<style scoped>
#login {
  background-color: #BF5700;
  position: fixed;
  width: 100%;
  height: 100vh;
  margin: 0px;
  padding: 0px;
}

.has-text-danger,
.has-text-success {
  margin: 0px 0px 20px 0px;
  font-weight: bold;
}

#register {
  padding: 20px 0px 0px 0px;
}

#logo {
  padding: 80px 0px 20px 0px;
  width:100%;
  text-align: center;
  margin: auto
}

h1 {
  padding: 0px 0px 20px 0px;
}

label {
  margin-right: 0.5rem;
}

.hovering {
  color: #000000;
}
</style>
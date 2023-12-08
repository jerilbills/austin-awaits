<template>
  <div id="register" class="columns">
    <div class="column spacer"></div>
    <div class="column is-narrow ">
      <div id="logo"><img src="/src/assets/austin-awaits-logo.png" alt="Austin Awaits" width="400"></div>
      <form v-on:submit.prevent="register" class="box">
        <h1 class="is-size-3">Create Account</h1>
        <div role="alert" v-if="registrationErrors" class="has-text-danger">
          <span id="alert">{{ registrationErrorMsg }}</span>
        </div>

        <div class="field is-horizontal">
          <div class="field-label is-normal">
            <!-- Using &nbsp; to keep lines from wrapping throughout - hack -->
            <label for="firstName" class="label">First&nbsp;Name&nbsp;&nbsp;</label>
          </div>
          <div class="field-body">
            <div class="field">
              <p class="control is-expanded">
                <input type="text" id="firstName" v-model="user.firstName" required autofocus class="input"
                  placeholder="First Name" />
              </p>
            </div>
          </div>
        </div>

        <div class="field is-horizontal">
          <div class="field-label is-normal">
            <label for="lastName" class="label">Last&nbsp;Name&nbsp;&nbsp;&nbsp;</label>
          </div>
          <div class="field-body">
            <div class="field">
              <p class="control is-expanded">
                <input type="text" id="lastName" v-model="user.lastName" required class="input" placeholder="Last Name" />
              </p>
            </div>
          </div>
        </div>

        <div class="field is-horizontal" >
          <div class="field-label is-normal">
            <label for="department" class="label">Department</label>
          </div>
          <div class="field-body">
            <div class="field">
              <div class="control is-expanded has-icons-left">
                <div class="select">
                  <select id="department" name="department" v-model="user.departmentId" required>
                    <option v-for="dept in departments" :key="dept.departmentId" :value="dept.departmentId">
                      {{ dept.departmentName }}
                    </option>
                  </select>
                </div>
                <span class="icon is-small is-left">
                  <i class="fas fa-briefcase"></i>
                </span>
              </div>
            </div>
          </div>
        </div>


        <div class="field is-horizontal">
          <div class="field-label is-normal">
            <label for="username" class="label">Username&nbsp;&nbsp;&nbsp;&nbsp;</label>
          </div>
          <div class="field-body">
            <div class="field">
              <p class="control is-expanded has-icons-left">
                <input type="text" id="username" v-model="user.username" required autofocus placeholder="Username"
                  autocomplete="off" autocapitalize="off" class="input" />
                <span class="icon is-small is-left">
                  <i class="fas fa-user"></i>
                </span>
              </p>
            </div>
          </div>
        </div>

        <div class="field is-horizontal">
          <div class="field-label is-normal">
            <label for="password" class="label">Password&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
          </div>
          <div class="field-body">
            <div class="field">
              <p class="control has-icons-left has-icons-right">
                <input type="password" id="password" v-model="user.password" required placeholder="Password"
                  autocomplete="off" autocapitalize="off" class="input" />
                <span class="icon is-small is-left">
                  <i class="fas fa-lock"></i>
                </span>
                <span class="icon is-small is-right is-clickable" @click="togglePassword()"
                  @mouseover="isHoveringOnPasswordToggle = true" @mouseout="isHoveringOnPasswordToggle = false">
                  <i class="fas fa-eye" v-if="!showingPassword" :class="{ hovering: isHoveringOnPasswordToggle }"></i>
                  <i class="fas fa-eye-slash" v-if="showingPassword"
                    :class="{ hovering: isHoveringOnPasswordToggle }"></i>
                </span>
              </p>
            </div>
          </div>
        </div>

        <div class="field is-horizontal">
          <div class="field-label">
            <label for="confirmPassword" class="label ">Confirm Password&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
          </div>
          <div class="field-body">
            <div class="field">
              <p class="control has-icons-left has-icons-right">
                <input type="password" id="confirmPassword" v-model="user.confirmPassword" required
                  placeholder="Confirm Password" autocomplete="off" autocapitalize="off" class="input" />
                <span class="icon is-small is-left">
                  <i class="fas fa-lock"></i>
                </span>
                <span class="icon is-small is-right is-clickable" @click="toggleConfirmPassword()"
                  @mouseover="isHoveringOnConfirmPasswordToggle = true"
                  @mouseout="isHoveringOnConfirmPasswordToggle = false">
                  <i class="fas fa-eye" v-if="!showingConfirmPassword"
                    :class="{ hovering: isHoveringOnConfirmPasswordToggle }"></i>
                  <i class="fas fa-eye-slash" v-if="showingConfirmPassword"
                    :class="{ hovering: isHoveringOnConfirmPasswordToggle }"></i>
                </span>
              </p>
            </div>
          </div>
        </div>

        <div class="field">
          <p class="control">
            <button type="submit" class="button is-rounded is-primary is-fullwidth" :disabled="(!hasRequiredFields)">Create Account</button>
          </p>
        </div>

        <div id="login"><router-link v-bind:to="{ name: 'login' }">Already have an account? Log in.</router-link></div>
      </form>
    </div>
    <div class="column spacer"></div>
  </div>
</template>

<script>
import authService from '../services/AuthService';
import departmentService from '../services/DepartmentService';

export default {
  data() {
    return {
      user: {
        username: '',
        password: '',
        firstName: '',
        lastName: '',
        departmentId: 0,
        confirmPassword: '',
        role: 'user',
      },
      departments: [],
      registrationErrors: false,
      registrationErrorMsg: 'There were problems registering this user.',
      showingPassword: false,
      isHoveringOnPasswordToggle: false,
      showingConfirmPassword: false,
      isHoveringOnConfirmPasswordToggle: false
    };
  },
  computed: {
    hasRequiredFields() {
      return this.user.firstName && this.user.lastName && this.user.username && (this.departments.length == 0 || this.user.departmentId) && this.user.password && this.user.confirmPassword;
    }
  },
  methods: {
    register() {
      this.clearErrors();
      if (this.user.password != this.user.confirmPassword) {
        this.registrationErrors = true;
        this.registrationErrorMsg = 'Password & Confirm Password do not match.';
      } 
      else if (!this.isPasswordComplexEnough()) {
        this.registrationErrors = true;
        this.registrationErrorMsg = 'Password must have at least one capital letter, one lowercase letter, one number, and a minimum of 8 characters.';
      }
      else {
        authService
          .register(this.user)
          .then((response) => {
            if (response.status == 201) {
              this.$router.push({
                path: '/login',
                query: { registration: 'success' },
              });
            }
          })
          .catch((error) => {
            const response = error.response;
            this.registrationErrors = true;
            if (response.status === 400) {
              this.registrationErrorMsg = 'Bad Request: Validation Errors';
            }
            if (response.status === 409) {
              this.registrationErrorMsg = 'Username already taken. Please choose a different username.';
            }
          });
      }
    },
    clearErrors() {
      this.registrationErrors = false;
      this.registrationErrorMsg = 'There were problems registering this user.';
    },
    loadDepartmentList() {
      departmentService
        .getDepartments()
        .then((response) => {
          response.data.forEach((dept) => {
            this.departments.push(dept);
          });
        })
        .catch((error) => {          
          this.registrationErrorMsg = 'There were problems registering this user.';
        })
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
    },
    toggleConfirmPassword() {
      var x = document.getElementById("confirmPassword");
      if (x.type === "password") {
        x.type = "text";
        this.showingConfirmPassword = true;
      } else {
        x.type = "password";
        this.showingConfirmPassword = false;
      }
    },
    isPasswordComplexEnough() {
      let passwordRequirements = new RegExp('(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.{8,})');
      return passwordRequirements.test(this.user.password);
    }
  },
  created() {
    this.loadDepartmentList();
  },
};
</script>

<style scoped>
#register {
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

#alert {
  display: block;
  width: 600px; 
 white-space: normal;
}

#login {
  padding: 20px 0px 0px 0px;
}

#logo {
  padding: 80px 0px 20px 0px;
  width:100%;
  text-align: center;
  margin: auto;
}

h1 {
  padding: 0px 0px 20px 0px;
}

label {
  margin-right: 0.5rem;
  text-align: left;
}

.hovering {
  color: #000000;
}

.select,
.select select {
  width: 100%;
}</style>
<template>
  <div class="modal-container">
    <div class="modal-content">

      <div class="text-container">
        <p class="list-name"><strong>List: </strong>{{ $store.state.activeList.name }} ({{$store.state.activeList.departmentName}})</p>
        <p class="list-description">Invite a user to collaborate on the list...</p>
      </div>

      <div class="form-container">
      <form v-on:submit.prevent="register">
        <div class="options-container">
        <div class="field is-horizontal" >
          <div class="field-label is-normal">
            <label for="department" class="label">Department</label>
          </div>
          <div class="field-body">
            <div class="field">
              <div class="control is-expanded has-icons-left">
                <div class="select">
                  <select id="department" name="department" v-model="departmentToSearch.departmentId" required @change="loadDepartmentUsersList" >
                    <option v-for="dept in departmentsOtherThanListDepartment" :key="dept.departmentId" :value="dept.departmentId" >
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

      <div class="field is-horizontal" v-if="departmentUsers.length > 0">
        <div class="field-label is-normal">
          <label for="department" class="label">User&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
        </div>
        <div class="field-body">
          <div class="field">
            <div class="control is-expanded has-icons-left">
              <div class="select">
                <select id="user" name="user" v-model="selectedUserId" required>
                  <option v-for="user in departmentUsers" :key="user.userId" :value="user.userId">
                    {{ user.firstName }} {{ user.lastName }}
                  </option>
                </select>
              </div>
              <span class="icon is-small is-left">
                <i class="fas fa-person"></i>
              </span>
            </div>
          </div>
        </div>
      </div>
      <div v-else class="has-text-link"><BR />{{ errorMessage }}</div>
      </div>
      <div class="field">
          <p class="control">
            <button type="submit" class="button is-rounded is-primary" @click="addUser" :disabled="(!hasRequiredFields)">Invite User</button>
            <button type="button" class="button is-rounded is-dark" @click="closeInviteUserToListModal">Cancel</button>
          </p>
        </div>
      </form>
    </div>

      <div class="close-button-container">
        <button type="button" class="close-button" @click="closeInviteUserToListModal">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>     
  </div>
</div>
</template>

<script>
import DepartmentService from '../services/DepartmentService';
import UserService from '../services/UserService';
import InviteService from '../services/InviteService';

  export default {
    data() {
      return {
      departments:[],
      departmentToSearch: {},
      selectedUserId: {},
      departmentUsers: [],
      errorMessage: null
      };
    },
    computed: {
      departmentsOtherThanListDepartment() {
        return this.departments.filter(dept => dept.departmentId != this.$store.state.activeList.departmentId);
      },
      hasRequiredFields() {
        return this.departmentUsers.length > 0 && this.selectedUserId > 0;
      },
      selectedUser() {
        return this.departmentUsers.find(user => user.userId === this.selectedUserId);
      }
    },
    methods: {
      closeInviteUserToListModal() {
        this.$emit('close');
      },

      loadDepartmentList() {
        DepartmentService
          .getDepartments()
          .then((response) => {
            this.departments = response.data.sort((a, b) => (a.departmentName > b.departmentName) ? 1 : -1);
          })
          .catch((error) => {          
            console.log("There were problems loading the department list");
            this.closeInviteUserToListModal();
          })
    },
    loadDepartmentUsersList() {
      this.departmentUsers = [];
      this.selectedUserId = {};
      this.errorMessage = null;
      console.log(this.departmentToSearch.departmentId);
      UserService
        .getActiveUsersByDepartmentId(this.departmentToSearch.departmentId)
        .then((response) => {
          if(response.data == "") {
            this.errorMessage = "There are no users in this department";
            return;
          }
          this.departmentUsers = response.data.sort((a, b) => ((a.lastName + ", " + a.firstName) > (b.lastName + ", " + b.firstName)) ? 1 : -1);
        })
        .catch((error) => {          
          console.log("There were problems loading the user list for department Id " + this.departmentToSearch.departmentId);
        })
    },
    addUser() {
      const inviteToAdd = {
        listId: this.$store.state.activeList.listId,
        invitedUser: this.selectedUser
      }
      console.log(JSON.stringify(inviteToAdd));
      InviteService
        .addInvite(this.$store.state.activeList.departmentId, this.$store.state.activeList.listId, inviteToAdd)
        .then((response) => {
          this.closeInviteUserToListModal();
        })
        .catch((error) => {
          console.log("There were problems adding this user invite: " + JSON.stringify(inviteToAdd));
        })
    }
  },
        
    created() {
    this.loadDepartmentList();
  },
  }
  </script>
  
  <style>
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
    max-width: 600px;
    width: 100%;
    position: relative;
  }
  
  .flex-container {
    display: flex;

  }
 
  .text-container {
    flex: 1;
  }

  .close-button-container {
    position: absolute;
    top: 10px;
    right: 10px;
  }
  
  .close-button {
    background-color: #bf5700;
    color: #fff;
  }

  .list-name {
    font-size: 20px;
    margin-bottom: 10px;
  }

  .list-description {
    font-size: 16px;
    margin-bottom: 20px;
  }

  .options-container {
    height: 130px;
  }

  .field button {
    margin-top: 20px;
    margin-right: 20px;
    width: 45%;
  }

  button:hover {
    cursor: pointer;
  }
  </style>
  
import axios from 'axios';

export default {

    getActiveUsersByDepartmentId(departmentIdToSearch) {
      console.log('in axios with dept id' + departmentIdToSearch);
    return axios.get(`/department/${departmentIdToSearch}/user`)
  },

}

import axios from 'axios';

export default {

    getActiveUsersByDepartmentId(departmentIdToSearch) {
    return axios.get(`/department/${departmentIdToSearch}/user`)
  },

}

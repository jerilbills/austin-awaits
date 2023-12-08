import axios from 'axios';

export default {

  getUsersByDepartmentId(departmentId) {
    return axios.get('/department')
  },

}

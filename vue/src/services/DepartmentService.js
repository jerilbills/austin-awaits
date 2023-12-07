import axios from 'axios';

export default {

  getDepartments() {
    return axios.get('/department')
  },

}

import axios from 'axios';

export default {

    getLists(user) {
        return axios.get('/departments/{{user.departmentid}}/lists')
    }
  
  }
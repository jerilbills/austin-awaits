import axios from 'axios';

export default {

    getLists(departmentId) {
        return axios.get('/department/'+departmentId+'/list')
    },

    getSpecificList(departmentId, listId){
        return axios.get('/department/'+departmentId+'/list/' + listId + '/listitem')
    }


  
  }
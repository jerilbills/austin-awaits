import axios from 'axios';

export default {

    getListsInProgress(departmentId) {
        return axios.get('/department/'+departmentId+'/list?status=2')
    },

    getSpecificList(departmentId, listId){
        return axios.get('/department/'+departmentId+'/list/' + listId + '/listitem')
    },

    updateItem(item) {
        return axios.put('/department/'+item.departmentId+'/list/' + item.listId + '/listitem/' + item.itemId, item);
    },

    getInvitedListsInProgress(user) {
        return axios.get('/user/' + user.userId + '/list?status=2')
    },

    getListFilteredByClaimed(listId, userId, departmentId) {
        return axios.get('/department/' + departmentId + '/list/' + listId + '/listitem/claimed/' + userId)
    },
    getListFilteredByUnassigned(listId, departmentId) {
        return axios.get('/department/' + departmentId + '/list/' + listId + '/listitem/unassigned')
    },

    updateList(list) {
        return axios.put('/department/'+list.departmentId+'/list/' + list.listId, list);
    }
  
  }
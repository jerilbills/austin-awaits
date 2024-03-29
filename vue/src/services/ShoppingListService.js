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
    },

    getCompletedListsByDepartment(departmentId) {
        return axios.get('/department/' + departmentId + '/list?status=3')
    },
    
    getAllActiveLists(){
        return axios.get('/list/active')
    },

    createNewList(departmentId, newList) {
        return axios.post('/department/'+ departmentId + '/list', newList)
    },
    getAllDraftLists() {
        return axios.get('/list/draft')
    },
    getAllCompletedLists() {
        return axios.get('/list/completed')
    },
  
  }
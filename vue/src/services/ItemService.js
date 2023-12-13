import axios from 'axios';

export default {

    // TEAM 1 BELOW THIS LINE
    addItemToCatalog(newItem) {
        return axios.post('/item', newItem)
    },
    
    getAllItems() {
        return axios.get('/item')
    },
    
    addItemToList(departmentId, listId, newListItem){
        return axios.post('/department/'+departmentId+'/list/'+listId+'/listitem', newListItem)
    }
    
    
    
    
    
    
    // TEAM 2 BELOW THIS LINE





}
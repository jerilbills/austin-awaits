import axios from 'axios';

export default {

    addItemToCatalog(newItem) {
        return axios.post('/item', newItem)
    },

    updateItemInCatalog(updatedItem) {
        return axios.put('/item/' + updatedItem.itemId, updatedItem)
    },
    
    getAllItems() {
        return axios.get('/item')
    },
    
    addItemToList(departmentId, listId, newListItem){
        return axios.post('/department/'+departmentId+'/list/'+listId+'/listitem', newListItem)
    }
}
import axios from 'axios';

export default {

    // TEAM 1 BELOW THIS LINE
    addItemToCatalog(newItem) {
        return axios.post('/item', newItem)
    },
    
    getAllItems() {
        return axios.get('/item')
    },
    
    
    
    
    
    
    
    
    // TEAM 2 BELOW THIS LINE





}
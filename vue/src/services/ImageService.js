import axios from 'axios';

export default {

    getPotentialImages(searchTerm) {
        return axios.post('/potentialimage', searchTerm)
    },
}
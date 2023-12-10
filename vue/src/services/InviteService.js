import axios from 'axios';

export default {

  addInvite(departmentId, listId, invite) {
    return axios.post(`/department/${departmentId}/list/${listId}/invite`, invite);
  },

}

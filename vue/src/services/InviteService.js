import axios from 'axios';

export default {
  addInvite(departmentId, listId, invite) {
    return axios.post(
      `/department/${departmentId}/list/${listId}/invite`,
      invite
    );
  },
  getListInvites(departmentId, listId) {
    return axios.get(`/department/${departmentId}/list/${listId}/invite`);
  },
};

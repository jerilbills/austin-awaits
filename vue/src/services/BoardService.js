import axios from 'axios';

export default {

  getBoards() {
    return axios.get('/boards');
  },

  getCards(boardID) {
    return axios.get(`/boards/${boardID}`)
  },

  getCard(cardID) {
    return axios.get(`/cards/${cardID}`)
  },

  addCard(card) {
    return axios.post('/cards', card);
  },

  updateCard(card) {
    return axios.put(`/cards/${card.id}`, card);
  },

  deleteCard(cardID) {
    return axios.delete(`/cards/${cardID}`);
  },

  addBoard(board) {
    return axios.post(`/boards`, board);
  },

  deleteBoard(boardId) {
    return axios.delete(`/boards/${boardId}`);
  }

}

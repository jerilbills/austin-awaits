import { createStore as _createStore } from "vuex";
import axios from "axios";
const NOTIFICATION_TIMEOUT = 6000;

export function createStore(currentToken, currentUser) {
  let store = _createStore({
    state: {
      token: currentToken || "",
      user: currentUser || {},
      activeItems: [
        
      ],
      activeList: {},
      sideBarRefreshKey: 0,
      listInvitesRefreshKey: 0
    },
    mutations: {
      SET_AUTH_TOKEN(state, token) {
        state.token = token;
        localStorage.setItem("token", token);
        axios.defaults.headers.common["Authorization"] = `Bearer ${token}`;
      },
      SET_USER(state, user) {
        state.user = user;
        localStorage.setItem("user", JSON.stringify(user));
      },
      LOGOUT(state) {
        localStorage.removeItem("token");
        localStorage.removeItem("user");
        state.token = "";
        state.user = {};
        state.activeItems = [];
        state.activeList = {};
        state.sideBarRefreshKey = 0;
        state.listInvitesRefreshKey = 0;
        axios.defaults.headers.common = {};
      },
      SET_NOTIFICATION(state, notification) {
        // Clear the current notification if one exists
        if (state.notification) {
          this.commit("CLEAR_NOTIFICATION");
        }

        if (typeof notification === "string") {
          // If only a string was sent, create a notification object with defaults
          notification = {
            message: notification,
            type: "error",
            timeout: NOTIFICATION_TIMEOUT,
          };
        } else {
          // Else add default values if needed
          notification.type = notification.type || "error";
          notification.timeout = notification.timeout || NOTIFICATION_TIMEOUT;
        }

        // Set the notification in state
        state.notification = notification;

        // Clear the message after timeout (see https://developer.mozilla.org/en-US/docs/Web/API/setTimeout)
        notification.timer = window.setTimeout(() => {
          this.commit("CLEAR_NOTIFICATION");
        }, notification.timeout);
      },
      SET_ITEMS(state, items) {
        state.activeItems = {};
        state.activeItems = items.map(item => item);
      },
      SET_ACTIVE_LIST(state, list) {
        state.activeList = list;
      },
      CLEAR_ACTIVE_LIST(state) {
        state.activeList = {};
      },
      CLEAR_ITEMS(state) {
        state.activeItems = [];
      },
      REFRESH_SIDE_BAR(state) {
        state.sideBarRefreshKey += 1;
      },
      REFRESH_LIST_INVITES(state) {
        state.listInvitesRefreshKey += 1;
      },
      ADD_ACTIVE_ITEM(state, item) {
        state.activeItems.push(item);
      }

    },
    getters:{
      getItems() {
        return this.activeItems;
      }
    }
  });
  return store;
}

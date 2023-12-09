using Capstone.Models;
using Capstone.Exceptions;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;

namespace Capstone.DAO
{
    public interface IListItemDao
    {
        public ListItem UpdateListItemStatusAndClaimant(int listId, int itemId, int updatingUserId, ListItem itemToUpdate);
        public ListItem GetActiveListItemById(int itemId, int listId);

        public List<ListItem> GetActiveListItemsByListId(int listID);
        public List<ListItem> FilterListByClaimant(int listId, int userId);


    }
}

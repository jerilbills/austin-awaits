using Capstone.Models;
using Capstone.Exceptions;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;

namespace Capstone.DAO
{
    public interface IListItemDao
    {
        public ListItem UpdateListItem(int listId, int itemId, int status, int userId);
        public ListItem GetListItemById(int itemId, int listId);

        public List<ListItem> GetListItemsByListId(int listID);


    }
}

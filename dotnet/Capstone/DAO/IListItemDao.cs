using Capstone.Models;

namespace Capstone.DAO
{
    public interface IListItemDao
    {
        public ListItem UpdateListItem(int listId, int itemId, int status);
        public ListItem GetListItemById(int itemId, int listId);

        
    }
}

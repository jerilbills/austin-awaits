using Capstone.Exceptions;
using Capstone.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Net.NetworkInformation;

namespace Capstone.DAO
{
    public class InviteSqlDao : IInviteDao
    {
        private readonly string connectionString;

        public InviteSqlDao(string dbConnectionString)
        {
            connectionString = dbConnectionString;
        }
        public int AddUserToList(Invite userListToAdd)
        {
            int rowsAffected = 0;
            string sql = "INSERT INTO users_lists (user_id, list_id) VALUES (@user_id, @list_id);";

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@user_id", userListToAdd.InvitedUser.UserId);
                    cmd.Parameters.AddWithValue("@list_id", userListToAdd.ListId);

                    rowsAffected = cmd.ExecuteNonQuery();

                }
            }
            catch (SqlException ex)
            {
                throw new DaoException("SQL exception occurred", ex);
            }
            catch (Exception)
            {

            }

            return rowsAffected;
        }

        public List<Invite> GetListOfInvitedActiveUsers(int listId)
        {
            List<Invite> invites = new List<Invite>();
            string sql = @"SELECT UL.list_id, U.user_id, U.username, U.first_name, U.last_name,
                        U.department_id, U.password_hash, salt, U.user_role,
                        U.avatar_url, U.is_active, U.created_date_utc
                        FROM users AS U
                        JOIN users_lists AS UL ON UL.user_id = U.user_id
                        WHERE UL.list_id = @listId AND U.is_active = 1;";

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@listId", listId);

                    SqlDataReader reader = cmd.ExecuteReader();
                    while (reader.Read())
                    {
                        invites.Add(MapRowToInvite(reader));
                    }

                }
            }
            catch (SqlException ex)
            {
                throw new DaoException("SQL exception occurred", ex);
            }
            catch (Exception)
            {

            }

            return invites;
        }

        public Invite MapRowToInvite(SqlDataReader reader)
        {
            Invite invite = new Invite();

            invite.ListId = Convert.ToInt32(reader["list_id"]);
            invite.InvitedUser = new User();
            invite.InvitedUser.UserId = Convert.ToInt32(reader["user_id"]);
            invite.InvitedUser.Username = Convert.ToString(reader["username"]);
            invite.InvitedUser.Role = Convert.ToString(reader["user_role"]);
            invite.InvitedUser.FirstName = Convert.ToString(reader["first_name"]);
            invite.InvitedUser.LastName = Convert.ToString(reader["last_name"]);
            invite.InvitedUser.AvatarUrl = Convert.ToString(reader["avatar_url"]);
            invite.InvitedUser.DepartmentId = Convert.ToInt32(reader["department_id"]);
            invite.InvitedUser.PasswordHash = Convert.ToString(reader["password_hash"]);
            invite.InvitedUser.Salt = Convert.ToString(reader["salt"]);
            invite.InvitedUser.IsActive = Convert.ToBoolean(reader["is_active"]);
            invite.InvitedUser.CreatedDateUtc = Convert.ToDateTime(reader["created_date_utc"]);

            return invite;
        }
    }
}

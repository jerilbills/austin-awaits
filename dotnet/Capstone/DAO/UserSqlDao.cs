using System;
using System.Collections;
using System.Collections.Generic;
using System.Data.SqlClient;
using Capstone.Exceptions;
using Capstone.Models;
using Capstone.Security;
using Capstone.Security.Models;
using Microsoft.AspNetCore.SignalR;

namespace Capstone.DAO
{
    public class UserSqlDao : IUserDao
    {
        private readonly string connectionString;

        public UserSqlDao(string dbConnectionString)
        {
            connectionString = dbConnectionString;
        }

        public IList<User> GetActiveUsers()
        {
            IList<User> users = new List<User>();

            string sql = "SELECT user_id, username, first_name, last_name, department_id, password_hash, salt, user_role, avatar_url, " +
                "is_active, created_date_utc FROM users WHERE is_active = 1";

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    SqlCommand cmd = new SqlCommand(sql, conn);
                    SqlDataReader reader = cmd.ExecuteReader();

                    while (reader.Read())
                    {
                        User user = MapRowToUser(reader);
                        users.Add(user);
                    }
                }
            }
            catch (SqlException ex)
            {
                throw new DaoException("SQL exception occurred", ex);
            }

            return users;
        }

        public User GetActiveUserById(int userId)
        {
            User user = null;

            string sql = "SELECT TOP 1 user_id, username, first_name, last_name, department_id, password_hash, salt, user_role, avatar_url, " +
                "is_active, created_date_utc FROM users WHERE user_id = @user_id AND is_active = 1";

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@user_id", userId);
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read()) 
                    {
                        user = MapRowToUser(reader);
                    }
                }
            }
            catch (SqlException ex)
            {
                throw new DaoException("SQL exception occurred", ex);
            }

            return user;
        }

        public User GetActiveUserByUsername(string username)
        {
            User user = null;

            string sql = "SELECT TOP 1 user_id, username, first_name, last_name, department_id, password_hash, salt, user_role, avatar_url, " +
                "is_active, created_date_utc FROM users WHERE username = @username AND is_active = 1";

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@username", username);
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        user = MapRowToUser(reader);
                    }
                }
            }
            catch (SqlException ex)
            {
                throw new DaoException("SQL exception occurred", ex);
            }

            return user;
        }

        public User CreateUser(RegisterUser potentialUser)
        {
            //string username, string password, string role
            User newUser = null;

            IPasswordHasher passwordHasher = new PasswordHasher();
            PasswordHash hash = passwordHasher.ComputeHash(potentialUser.Password);

            string initials = potentialUser.FirstName.Trim().Substring(0, 1) + potentialUser.LastName.Trim().Substring(0, 1);
            string avatarUrl = GetRandomAvatar(initials);

            string sql = "INSERT INTO users (username, first_name, last_name, department_id, password_hash, salt, user_role, avatar_url) " +
                         "OUTPUT INSERTED.user_id " +
                         "VALUES (@username, @first_name, @last_name, @department_id, @password_hash, @salt, @user_role, @avatar_url)";

            int newUserId = 0;
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@username", potentialUser.Username);
                    cmd.Parameters.AddWithValue("@first_name", potentialUser.FirstName);
                    cmd.Parameters.AddWithValue("@last_name", potentialUser.LastName);
                    cmd.Parameters.AddWithValue("@department_id", potentialUser.DepartmentId);
                    cmd.Parameters.AddWithValue("@password_hash", hash.Password);
                    cmd.Parameters.AddWithValue("@salt", hash.Salt);
                    cmd.Parameters.AddWithValue("@user_role", potentialUser.Role);
                    cmd.Parameters.AddWithValue("@avatar_url", avatarUrl);

                    newUserId = Convert.ToInt32(cmd.ExecuteScalar());
                    
                }
                newUser = GetActiveUserById(newUserId);
            }
            catch (SqlException ex)
            {
                throw new DaoException("SQL exception occurred", ex);
            }

            return newUser;
        }

        private User MapRowToUser(SqlDataReader reader)
        {
            User user = new User();
            user.UserId = Convert.ToInt32(reader["user_id"]);
            user.Username = Convert.ToString(reader["username"]);
            user.Role = Convert.ToString(reader["user_role"]);
            user.FirstName = Convert.ToString(reader["first_name"]);
            user.LastName = Convert.ToString(reader["last_name"]);
            user.AvatarUrl = Convert.ToString(reader["avatar_url"]);
            user.DepartmentId = Convert.ToInt32(reader["department_id"]);
            user.PasswordHash = Convert.ToString(reader["password_hash"]);
            user.Salt = Convert.ToString(reader["salt"]);
            user.IsActive = Convert.ToBoolean(reader["is_active"]);
            user.CreatedDateUtc = Convert.ToDateTime(reader["created_date_utc"]);
            return user;
        }

        private string GetRandomAvatar(string initials)
        {
            string baseUrl = "https://api.dicebear.com/7.x";
            string avatarFamily = "initials";
            string seedParamater = "svg?seed=";
            Random random = new Random();
            // Testing found that random numbers between 1000 - 9999 generated the best variation in colors
            int seedSalt = random.Next(1000, 9999);
            return $"{baseUrl}/{avatarFamily}/{seedParamater}{initials}{seedSalt}";
        }

        public User UpdateName(User userToUpdate)
        {
            throw new NotImplementedException();
        }

        public User UpdateAvatar(User userToUpdate)
        {
            throw new NotImplementedException();
        }

        public List<User> GetActiveUsersByDepartmentId(int departmentId)
        {
            List<User> output = new List<User>();
            string sql = "SELECT user_id, username, first_name, last_name, " +
                "department_id, password_hash, salt, user_role, avatar_url, " +
                "is_active, created_date_utc FROM users " +
                "WHERE department_id = @department_id AND is_active = 1;";

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@department_id", departmentId);
                    SqlDataReader reader = cmd.ExecuteReader();

                    while (reader.Read())
                    {
                        User user = MapRowToUser(reader);
                        output.Add(user);
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

            return output;
        }

        public int AddUserToList(UserList userListToAdd)
        {
            int rowsAffected = 0;
            string sql = "INSERT INTO users_lists (user_id, list_id) VALUES (@user_id, @list_id);";

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@user_id", userListToAdd.UserId);
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
    }
}

using System;
using System.Collections;
using System.Collections.Generic;
using System.Data.SqlClient;
using Capstone.Exceptions;
using Capstone.Models;
using Capstone.Security;
using Capstone.Security.Models;

namespace Capstone.DAO
{
    public class DepartmentSqlDao : IDepartmentDao
    {
        private readonly string connectionString;

        public DepartmentSqlDao(string dbConnectionString)
        {
            connectionString = dbConnectionString;
        }

        public List<Department> GetDepartments()
        {
            List<Department> output = new List<Department>();

            string sql = "SELECT department_id, department_name FROM departments WHERE department_id != 0 AND is_active = 1";

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    SqlCommand cmd = new SqlCommand(sql, conn);
                    SqlDataReader reader = cmd.ExecuteReader();

                    while (reader.Read())
                    {
                        Department dept = MapRowToDepartment(reader);
                        output.Add(dept);
                    }
                }
            }
            catch (SqlException ex)
            {
                throw new DaoException("SQL exception occurred", ex);
            }

            return output;
        }

        private Department MapRowToDepartment(SqlDataReader reader)
        {
            Department dept = new Department();
            dept.DepartmentId = Convert.ToInt32(reader["department_id"]);
            dept.DepartmentName = Convert.ToString(reader["department_name"]);
            return dept;
        }
    }
}

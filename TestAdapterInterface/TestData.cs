using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Configuration;


namespace TestAdapterInterface
{
    public partial class TestData : Form
    {
        private SqlConnection m_sqlConn;
        private DataGridView masterDataGridView = new DataGridView();
        private BindingSource masterBindingSource = new BindingSource();
        private DataGridView detailsDataGridView = new DataGridView();
        private BindingSource detailsBindingSource = new BindingSource();

        void TestParameterChanged(object sender, DataGridViewCellEventArgs e)
        {
            var editedCell = this.detailsDataGridView.Rows[e.RowIndex].Cells[e.ColumnIndex];
            DataGridViewRow row = this.detailsDataGridView.Rows[e.RowIndex];
            var method_id = row.Cells["application_method_parameter_id"].Value;
            var newValue = editedCell.Value;

            using (var sqlProc = new SqlCommand())
            {
                sqlProc.Connection = m_sqlConn;
                sqlProc.CommandType = CommandType.StoredProcedure;
                sqlProc.CommandText = "ag_application_method_parameters_upd";
                sqlProc.Parameters.Add(new SqlParameter("application_method_parameter_id", SqlDbType.Int) { Value = method_id });
                sqlProc.Parameters.Add(new SqlParameter("value", SqlDbType.NVarChar) { Value = newValue });
               
                var result = sqlProc.ExecuteNonQuery();
            }

        }

        // Initializes the form.
        public TestData(string sqlConn)
        {
            m_sqlConn = new SqlConnection(sqlConn);
            
            this.Size = new Size(1574, 600);
            this.StartPosition = FormStartPosition.CenterScreen;
            masterDataGridView.Dock = DockStyle.Fill;
            detailsDataGridView.Dock = DockStyle.Fill;

            SplitContainer splitContainer1 = new SplitContainer();
            //splitContainer1.Panel1.ClientSize = new Size(600, 6);
            splitContainer1.SplitterWidth = 6;
            //splitContainer1.Panel1MinSize = 600;
            splitContainer1.Dock = DockStyle.Fill;
            splitContainer1.Orientation = Orientation.Vertical;
            splitContainer1.Panel1.Controls.Add(masterDataGridView);
            splitContainer1.Panel2.Controls.Add(detailsDataGridView);

            this.Controls.Add(splitContainer1);
            this.Load += new System.EventHandler(Form1_Load);
            this.Text = "Shubert API Test Adapter";
            this.detailsDataGridView.CellValueChanged += new DataGridViewCellEventHandler(TestParameterChanged);
            detailsDataGridView.CellValueChanged += TestParameterChanged;

            try
            {
                m_sqlConn.Open();
            }
            catch (Exception ex)
            {
                Console.WriteLine("Unable to connect to database:\t{0}", ex.Message);
            }

        }

        private void Form1_Load(object sender, System.EventArgs e)
        {
            // Bind the DataGridView controls to the BindingSource
            // components and load the data from the database.
            masterDataGridView.DataSource = masterBindingSource;
            detailsDataGridView.DataSource = detailsBindingSource;
            GetData();

            // Resize the master DataGridView columns to fit the newly loaded data.
            masterDataGridView.AutoResizeColumns();

            // Configure the details DataGridView so that its columns automatically
            // adjust their widths when the data changes.
            detailsDataGridView.AutoSizeColumnsMode =
                DataGridViewAutoSizeColumnsMode.AllCells;
        }

        private void GetData()
        {
            try
            {
                String connectionString =
                    "Integrated Security=SSPI;Persist Security Info=False;" +
                    "Initial Catalog=TestAutomation;Data Source=LAPTOP-DHCHDQG6\\SQLEXPRESS";
                SqlConnection connection = new SqlConnection(connectionString);

                // Create a DataSet.
                DataSet data = new DataSet();
                data.Locale = System.Globalization.CultureInfo.InvariantCulture;

                // Add data from the Customers table to the DataSet.
                SqlDataAdapter masterDataAdapter = new
                    SqlDataAdapter("select * from application_method", connection);
                masterDataAdapter.Fill(data, "application_method");

                // Add data from the Orders table to the DataSet.
                SqlDataAdapter detailsDataAdapter = new
                    SqlDataAdapter("select * from application_method_parameters", connection);
                detailsDataAdapter.Fill(data, "application_method_parameters");

                // Establish a relationship between the two tables.+		ItemArray	{object[5]}	object[]

                DataRelation relation = new DataRelation("test_parameters",
                    data.Tables["application_method"].Columns["application_method_id"],
                    data.Tables["application_method_parameters"].Columns["application_method_id"]);
                data.Relations.Add(relation);

                // Bind the master data connector to the Customers table.
                masterBindingSource.DataSource = data;
                masterBindingSource.DataMember = "application_method";

                // Bind the details data connector to the master data connector,
                // using the DataRelation name to filter the information in the 
                // details table based on the current row in the master table. 
                detailsBindingSource.DataSource = masterBindingSource;
                detailsBindingSource.DataMember = "test_parameters";
            }
            catch (SqlException ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

    }


}

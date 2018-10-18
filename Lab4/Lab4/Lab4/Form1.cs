using System;
using System.Data;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace Lab4
{
    public partial class Form1 : Form
    {
        SqlConnection cnn;
        string connetionString = "Data Source=.;Initial Catalog=QLSINHVIEN4;Integrated Security=True";
        DataSet ds;

        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            Init();

            readSqlServerToDataSet();
        }

        private void Init()
        {
            cnn = new SqlConnection(connetionString);
            ds = new DataSet();
        }

        private void readSqlServerToDataSet()
        {
            ds.Clear();
            SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM KHOA", cnn);

            da.Fill(ds);

            dataGridView1.DataSource = ds.Tables[0];
        }

        private void btnWriteDStoXML_Click(object sender, EventArgs e)
        {
            try
            {
                ds.WriteXml("../../Khoa.xml", XmlWriteMode.WriteSchema);
                MessageBox.Show("Ghi thành công!!!");
            }
            catch (Exception ex)
            {
                MessageBox.Show("Ghi thất bại: " + ex.Message);
            }
        }

        private void btnReadXMLToDS_Click(object sender, EventArgs e)
        {
            try
            {
                ds.Clear();
                ds.ReadXml("../../Khoa.xml", XmlReadMode.Auto);
                MessageBox.Show("Đọc thành công!!!");
            }
            catch (Exception ex)
            {
                MessageBox.Show("Đọc thất bại: " + ex.Message);
            }
        }

        private void btnWriteXMLwithDiff_Click(object sender, EventArgs e)
        {
            try
            {
                DataRow r = ds.Tables[0].Rows[0];
                r["NamThanhLap"] = "2000";
                ds.WriteXml("../../KhoaDiff.xml", XmlWriteMode.WriteSchema);
                MessageBox.Show("Ghi thành công!!!");
            }
            catch (Exception ex)
            {
                MessageBox.Show("Ghi thất bại: " + ex.Message);
            }
        }
    }
}

using System;
using System.Data;
using System.Data.SqlClient;
using System.Windows.Forms;

namespace Lab3
{
    public partial class Form1 : Form
    {
        SqlConnection cnn;
        SqlDataAdapter da;
        DataTable dt_KHOA;
        DataTable dt_SINHVIEN;
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            cnn = new SqlConnection("Data Source=.;Initial Catalog=QLSINHVIEN4;Integrated Security=True");

            da = new SqlDataAdapter("Select * from KHOA", cnn);
            dt_KHOA = new DataTable();
            da.Fill(dt_KHOA);

            da.SelectCommand.CommandText = "Select SV.*, K.MaKhoa, K.TenKhoa, L.TenLop"
                                            + " From (SINHVIEN SV inner join LOP L on SV.MaLop = L.MaLop)"
                                            + "inner join KHOA K on L.MaKhoa = K.MaKhoa";
            dt_SINHVIEN = new DataTable();
            da.Fill(dt_SINHVIEN);

            cboMaKhoa.DataSource = dt_KHOA;
            cboMaKhoa.DisplayMember = "TenKhoa";
            cboMaKhoa.ValueMember = "MaKhoa";
            cboMaKhoa.SelectedIndex = -1;
            //cboMaKhoa.Items.Add("All");

            CrystalReport1 rpt = new CrystalReport1();
            rpt.SetDataSource(dt_SINHVIEN.DefaultView);
            crystalReportViewer1.ReportSource = rpt;
        }

        private void btnReport_Click(object sender, EventArgs e)
        {
            CrystalReport1 rpt = new CrystalReport1();
            if (cboMaKhoa.Text.Length > 0)
            {
                dt_SINHVIEN.DefaultView.RowFilter = "MaKhoa = '" + cboMaKhoa.SelectedValue.ToString() + "'";
                rpt.SetDataSource(dt_SINHVIEN.DefaultView);
            }
            else
            {
                rpt.SetDataSource(dt_SINHVIEN.DefaultView);
            }

            crystalReportViewer1.ReportSource = rpt;
        }

        private void btnThoat_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}

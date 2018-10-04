using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using BussinessLogic;

namespace Lab2
{
    public partial class Form1 : Form
    {
        string path = "../../Hinh";
        XL_SINHVIEN Bang_SINHVIEN;
        XL_LOP Bang_LOP;
        BindingManagerBase DSSV;

        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            Bang_SINHVIEN = new XL_SINHVIEN();
            Bang_LOP = new XL_LOP();

            LoadCBOLop();
            loadDGVHocSinh();

            txtMaSV.DataBindings.Add("Text", Bang_SINHVIEN, "MaSV", true);
            txtHoTen.DataBindings.Add("Text", Bang_SINHVIEN, "HoTen", true);
            txtNgaySinh.DataBindings.Add("Text", Bang_SINHVIEN, "NgaySinh", true);
            rdNam.DataBindings.Add("Checked", Bang_SINHVIEN, "GioiTinh", true);
            cboLop.DataBindings.Add("SelectedValue", Bang_SINHVIEN, "MaLop", true);
            txtDiaChi.DataBindings.Add("Text", Bang_SINHVIEN, "DiaChi", true);
            pbHinh.DataBindings.Add("ImageLocation", Bang_SINHVIEN, "Hinh", true);

            DSSV = this.BindingContext[Bang_SINHVIEN];
            enabledNutLenh(false);
        }

        private void enabledNutLenh(bool Cap_nhat)
        {
            btnThem.Enabled = !Cap_nhat;
            btnXoa.Enabled = !Cap_nhat;
            btnSua.Enabled = !Cap_nhat;
            btnThoat.Enabled = !Cap_nhat;
            btnLuu.Enabled = Cap_nhat;
            btnHuy.Enabled = Cap_nhat;
        }

        private void LoadCBOLop()
        {
            cboLop.DataSource = Bang_LOP;
            cboLop.DisplayMember = "TenLop";
            cboLop.ValueMember = "MaLop";
        }

        private void loadDGVHocSinh()
        {
            dgvThongTin.AutoGenerateColumns = true;
            dgvThongTin.DataSource = Bang_SINHVIEN;
        }

        private void rdNam_CheckedChanged(object sender, EventArgs e)
        {
            rdNu.Checked = !rdNam.Checked;
        }

        private void btnThem_Click(object sender, EventArgs e)
        {
            DSSV.AddNew();
            enabledNutLenh(true);
        }

        private void btnLuu_Click(object sender, EventArgs e)
        {
            try
            {
                DSSV.EndCurrentEdit();
                Bang_SINHVIEN.Ghi();
                enabledNutLenh(false);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void btnHuy_Click(object sender, EventArgs e)
        {
            DSSV.CancelCurrentEdit();
            Bang_SINHVIEN.RejectChanges();
            enabledNutLenh(false);
        }

        private void btnXoa_Click(object sender, EventArgs e)
        {
            DSSV.RemoveAt(DSSV.Position);
            if (!Bang_SINHVIEN.Ghi())
            {
                MessageBox.Show("Xóa thất bại!");
            }
        }

        private void btnSua_Click(object sender, EventArgs e)
        {
            try
            {
                DSSV.EndCurrentEdit();
                Bang_SINHVIEN.Ghi();
            }
            catch(Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void btnTimKiem_Click(object sender, EventArgs e)
        {
            try
            {
                DataRow r = Bang_SINHVIEN.Select("MaSV = '" + txtTimKiem.Text + "'")[0];
                DSSV.Position = Bang_SINHVIEN.Rows.IndexOf(r);
            }
            catch(Exception ex)
            {
                MessageBox.Show("Không tìm thấy");
            }
        }

        private void btnChonHinh_Click(object sender, EventArgs e)
        {
            openFileDialog1.Filter = "JPG Files|*.jpg|PNG Files|*.png|All files|*.*";
            if (openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                string fileName = openFileDialog1.SafeFileName;
                string pathFile = path + "/" + fileName;
                if (!File.Exists(pathFile))
                    File.Copy(openFileDialog1.FileName, pathFile);
                pbHinh.ImageLocation = pathFile;
            }
        }

        private void btnThoat_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}

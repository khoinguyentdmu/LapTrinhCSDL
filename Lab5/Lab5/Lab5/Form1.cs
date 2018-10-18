using System;
using System.Data.Linq;
using System.IO;
using System.Linq;
using System.Windows.Forms;

namespace Lab5
{
    public partial class Form1 : Form
    {
        string path = "../../Hinh";
        Table<SINHVIEN> Bang_SINHVIEN;
        Table<LOP> Bang_LOP;
        QLSinhVienDBDataContext db;
        BindingManagerBase DSSV;

        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            db = new QLSinhVienDBDataContext();
            Bang_SINHVIEN = db.SINHVIENs;
            Bang_LOP = db.GetTable<LOP>();

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

        private void loadDGVHocSinh()
        {
            dgvThongTin.AutoGenerateColumns = true;
            dgvThongTin.DataSource = Bang_SINHVIEN;
        }

        private void LoadCBOLop()
        {
            cboLop.DataSource = Bang_LOP;
            cboLop.DisplayMember = "TenLop";
            cboLop.ValueMember = "MaLop";
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
                db.SubmitChanges();
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
            ChangeSet cs = db.GetChangeSet();
            db.Refresh(RefreshMode.OverwriteCurrentValues, cs.Updates);
            enabledNutLenh(false);
        }

        private void btnXoa_Click(object sender, EventArgs e)
        {
            DSSV.RemoveAt(DSSV.Position);
            db.SubmitChanges();
        }

        private void btnSua_Click(object sender, EventArgs e)
        {
            enabledNutLenh(true);
        }

        private void btnTimKiem_Click(object sender, EventArgs e)
        {
            DSSV.Position = Bang_SINHVIEN.ToList().FindIndex(sv => sv.MaSV.Contains(txtTimKiem.Text));
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

        private void txtTimKiem_MouseDown(object sender, MouseEventArgs e)
        {
            txtTimKiem.Text = "";
        }

        private void btnThoat_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}

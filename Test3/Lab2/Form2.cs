using BussinessLogic;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Lab2
{
    public partial class Form2 : Form
    {
        XL_KHACHANG Bang_KHACHHANG;
        XL_DATBAO Bang_DatBao;
        BindingManagerBase ThongTinKhachHang;
        BindingManagerBase ThongTinDatBao;

        public Form2()
        {
            InitializeComponent();
        }

        private void Form2_Load(object sender, EventArgs e)
        {
            Bang_KHACHHANG = new XL_KHACHANG();

            txtTenKhachHang.DataBindings.Add("Text", Bang_KHACHHANG, "TenKH", true);
            txtDiaChi.DataBindings.Add("Text", Bang_KHACHHANG, "DiaChi", true);
            txtSDT.DataBindings.Add("Text", Bang_KHACHHANG, "DienThoai", true);
            ThongTinKhachHang = this.BindingContext[Bang_KHACHHANG];
            LoadCBOKhachHang();

            dtpNgayDat.DataBindings.Add("Value", Bang_DatBao, "NgayDat", true);
            txtTongSoTien.DataBindings.Add("Text", Bang_DatBao, "TongSoTien", true);
            cboSoPhieu.DataBindings.Add("Text", Bang_DatBao, "SoPhieu", true);
            cboKhachHang.DataBindings.Add("Text", Bang_DatBao, "MaKH", true);
            ThongTinDatBao = this.BindingContext[Bang_DatBao];
        }


        private void LoadCBOKhachHang()
        {
            cboKhachHang.DataSource = Bang_KHACHHANG;
            cboKhachHang.DisplayMember = "MaKH";
            cboKhachHang.ValueMember = "MaKH";
        }

        private void cboKhachHang_SelectedIndexChanged(object sender, EventArgs e)
        {
            loadDSMaPhieuDatBao();
        }

        private void loadDSMaPhieuDatBao()
        {
            Bang_DatBao = new XL_DATBAO("select * from PHIEUDATBAO where MAKH = '" + cboKhachHang.Text + "'" );
            cboSoPhieu.DataSource = Bang_DatBao;
            cboSoPhieu.DisplayMember = "SOPHIEU";
            cboSoPhieu.ValueMember = "SOPHIEU";

            loadDataToDataGridViewThongTin();
        }

        private void loadDataToDataGridViewThongTin()
        {

        }

        private void btnTruoc_Click(object sender, EventArgs e)
        {
            if (cboSoPhieu.SelectedIndex > 0)
                cboSoPhieu.SelectedIndex = cboSoPhieu.SelectedIndex - 1;
        }

        private void btnSau_Click(object sender, EventArgs e)
        {
            if (cboSoPhieu.SelectedIndex < cboSoPhieu.Items.Count - 1)
                cboSoPhieu.SelectedIndex = cboSoPhieu.SelectedIndex + 1;
        }

        private void btnThem_Click(object sender, EventArgs e)
        {
            ThongTinDatBao.AddNew();
        }

        private void btnIn_Click(object sender, EventArgs e)
        {
            try
            {
                ThongTinDatBao.EndCurrentEdit();
                Bang_DatBao.Ghi();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
    }
}

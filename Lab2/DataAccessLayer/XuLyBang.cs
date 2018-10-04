using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;

namespace DataAccessLayer
{
    public class XuLyBang : DataTable
    {
        public string connectionString = "Data Source=.;Initial Catalog=QLSINHVIEN4;Integrated Security=True";
        private SqlConnection SqlConnection;
        private SqlDataAdapter SqlDataAdapter;
        private String chuoiSQL;
        private String tenBang;

        public string ChuoiSQL { get => chuoiSQL; set => chuoiSQL = value; }
        public string TenBang { get => tenBang; set => tenBang = value; }
        public int So_Dong { get => this.DefaultView.Count; }

        public XuLyBang() : base() { }

        public XuLyBang(String tenBang)
        {
            this.tenBang = tenBang;
            DocBang();
        }

        public XuLyBang(String tenBang, String chuoiSQL)
        {
            this.tenBang = tenBang;
            this.chuoiSQL = chuoiSQL;
            DocBang();
        }

        private void DocBang()
        {
            if (chuoiSQL == null)
            {
                chuoiSQL = "SELECT * FROM " + this.tenBang;
            }

            if (SqlConnection == null)
            {
                SqlConnection = new SqlConnection(this.connectionString);
            }

            try
            {
                SqlDataAdapter = new SqlDataAdapter(chuoiSQL, SqlConnection);
                SqlDataAdapter.FillSchema(this, SchemaType.Mapped);
                SqlDataAdapter.Fill(this);
                SqlDataAdapter.RowUpdated += new SqlRowUpdatedEventHandler(SqlDataAdapter_RowUpdated);
                SqlCommandBuilder sqlCommandBuilder = new SqlCommandBuilder(SqlDataAdapter);
            }
            catch (SqlException ex)
            {
                throw ex;
            }
        }

        public Boolean Ghi()
        {
            Boolean ket_qua = true;
            try
            {
                SqlDataAdapter.Update(this);
                this.AcceptChanges();
            }
            catch (SqlException ex)
            {
                this.RejectChanges();
                ket_qua = false;
                throw ex;
            }
            return ket_qua;
        }

        public void Loc_du_lieu(String Dieu_kien)
        {
            try
            {
                this.DefaultView.RowFilter = Dieu_kien;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public int Thuc_hien_Lenh(String Lenh)
        {
            try
            {
                SqlCommand Cau_lenh = new SqlCommand(Lenh, SqlConnection);
                SqlConnection.Open();
                int ket_qua = Cau_lenh.ExecuteNonQuery();
                SqlConnection.Close();
                return ket_qua;
            }
            catch
            {
                return -1;
            }
        }

        public Object Thuc_hien_lenh_tinh_toan(String Lenh)
        {
            try
            {
                SqlCommand Cau_lenh = new SqlCommand(Lenh, SqlConnection);
                SqlConnection.Open();
                Object ket_qua = Cau_lenh.ExecuteScalar();
                SqlConnection.Close();
                return ket_qua;
            }
            catch
            {
                return null;
            }
        }

        private void SqlDataAdapter_RowUpdated(Object sender, SqlRowUpdatedEventArgs e)
        {
            if (this.PrimaryKey[0].AutoIncrement)
            {
                if ((e.Status == UpdateStatus.Continue) && (e.StatementType == StatementType.Insert))
                {
                    SqlCommand cmd = new SqlCommand("SELECT @@IDENTITY ", SqlConnection);
                    e.Row.ItemArray[0] = cmd.ExecuteScalar();
                    e.Row.AcceptChanges();
                }
            }
        }
    }
}

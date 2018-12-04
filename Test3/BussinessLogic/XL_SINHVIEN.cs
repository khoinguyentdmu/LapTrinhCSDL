using DataAccessLayer;

namespace BussinessLogic
{
    public class XL_SINHVIEN: XuLyBang
    {
        public XL_SINHVIEN() : base("SINHVIEN") { }
        public XL_SINHVIEN(string chuoiSQL) : base("SINHVIEN", chuoiSQL) { }
    }
}

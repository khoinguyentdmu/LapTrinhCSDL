using DataAccessLayer;

namespace BussinessLogic
{
    public class XL_KHACHANG : XuLyBang
    {
        public XL_KHACHANG() : base("KHACHHANG") { }
        public XL_KHACHANG(string chuoiSQL) : base("KHACHHANG", chuoiSQL) { }
    }
}

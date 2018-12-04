using DataAccessLayer;

namespace BussinessLogic
{
    public class XL_DATBAO : XuLyBang
    {
        public XL_DATBAO() : base("PHIEUDATBAO") { }
        public XL_DATBAO(string chuoiSQL) : base("PHIEUDATBAO", chuoiSQL) { }
    }
}

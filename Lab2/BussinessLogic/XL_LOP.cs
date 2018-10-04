using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DataAccessLayer;

namespace BussinessLogic
{
    public class XL_LOP : XuLyBang
    {
        public XL_LOP() : base("LOP") { }
        public XL_LOP(string chuoiSQL) : base("LOP", chuoiSQL) { }
    }
}

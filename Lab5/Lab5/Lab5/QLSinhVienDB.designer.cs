﻿#pragma warning disable 1591
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.42000
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Lab5
{
	using System.Data.Linq;
	using System.Data.Linq.Mapping;
	using System.Data;
	using System.Collections.Generic;
	using System.Reflection;
	using System.Linq;
	using System.Linq.Expressions;
	using System.ComponentModel;
	using System;
	
	
	[global::System.Data.Linq.Mapping.DatabaseAttribute(Name="QLSINHVIEN4")]
	public partial class QLSinhVienDBDataContext : System.Data.Linq.DataContext
	{
		
		private static System.Data.Linq.Mapping.MappingSource mappingSource = new AttributeMappingSource();
		
    #region Extensibility Method Definitions
    partial void OnCreated();
    partial void InsertSINHVIEN(SINHVIEN instance);
    partial void UpdateSINHVIEN(SINHVIEN instance);
    partial void DeleteSINHVIEN(SINHVIEN instance);
    partial void InsertLOP(LOP instance);
    partial void UpdateLOP(LOP instance);
    partial void DeleteLOP(LOP instance);
    #endregion
		
		public QLSinhVienDBDataContext() : 
				base(global::Lab5.Properties.Settings.Default.QLSINHVIEN4ConnectionString, mappingSource)
		{
			OnCreated();
		}
		
		public QLSinhVienDBDataContext(string connection) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public QLSinhVienDBDataContext(System.Data.IDbConnection connection) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public QLSinhVienDBDataContext(string connection, System.Data.Linq.Mapping.MappingSource mappingSource) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public QLSinhVienDBDataContext(System.Data.IDbConnection connection, System.Data.Linq.Mapping.MappingSource mappingSource) : 
				base(connection, mappingSource)
		{
			OnCreated();
		}
		
		public System.Data.Linq.Table<SINHVIEN> SINHVIENs
		{
			get
			{
				return this.GetTable<SINHVIEN>();
			}
		}
		
		public System.Data.Linq.Table<LOP> LOPs
		{
			get
			{
				return this.GetTable<LOP>();
			}
		}
	}
	
	[global::System.Data.Linq.Mapping.TableAttribute(Name="dbo.SINHVIEN")]
	public partial class SINHVIEN : INotifyPropertyChanging, INotifyPropertyChanged
	{
		
		private static PropertyChangingEventArgs emptyChangingEventArgs = new PropertyChangingEventArgs(String.Empty);
		
		private string _MaSV;
		
		private string _HoTen;
		
		private System.Nullable<System.DateTime> _NgaySinh;
		
		private System.Nullable<bool> _GioiTinh;
		
		private string _DiaChi;
		
		private string _MaLop;
		
		private string _Hinh;
		
		private EntityRef<LOP> _LOP;
		
    #region Extensibility Method Definitions
    partial void OnLoaded();
    partial void OnValidate(System.Data.Linq.ChangeAction action);
    partial void OnCreated();
    partial void OnMaSVChanging(string value);
    partial void OnMaSVChanged();
    partial void OnHoTenChanging(string value);
    partial void OnHoTenChanged();
    partial void OnNgaySinhChanging(System.Nullable<System.DateTime> value);
    partial void OnNgaySinhChanged();
    partial void OnGioiTinhChanging(System.Nullable<bool> value);
    partial void OnGioiTinhChanged();
    partial void OnDiaChiChanging(string value);
    partial void OnDiaChiChanged();
    partial void OnMaLopChanging(string value);
    partial void OnMaLopChanged();
    partial void OnHinhChanging(string value);
    partial void OnHinhChanged();
    #endregion
		
		public SINHVIEN()
		{
			this._LOP = default(EntityRef<LOP>);
			OnCreated();
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_MaSV", DbType="VarChar(10) NOT NULL", CanBeNull=false, IsPrimaryKey=true)]
		public string MaSV
		{
			get
			{
				return this._MaSV;
			}
			set
			{
				if ((this._MaSV != value))
				{
					this.OnMaSVChanging(value);
					this.SendPropertyChanging();
					this._MaSV = value;
					this.SendPropertyChanged("MaSV");
					this.OnMaSVChanged();
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_HoTen", DbType="NVarChar(100) NOT NULL", CanBeNull=false)]
		public string HoTen
		{
			get
			{
				return this._HoTen;
			}
			set
			{
				if ((this._HoTen != value))
				{
					this.OnHoTenChanging(value);
					this.SendPropertyChanging();
					this._HoTen = value;
					this.SendPropertyChanged("HoTen");
					this.OnHoTenChanged();
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_NgaySinh", DbType="DateTime")]
		public System.Nullable<System.DateTime> NgaySinh
		{
			get
			{
				return this._NgaySinh;
			}
			set
			{
				if ((this._NgaySinh != value))
				{
					this.OnNgaySinhChanging(value);
					this.SendPropertyChanging();
					this._NgaySinh = value;
					this.SendPropertyChanged("NgaySinh");
					this.OnNgaySinhChanged();
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_GioiTinh", DbType="Bit")]
		public System.Nullable<bool> GioiTinh
		{
			get
			{
				return this._GioiTinh;
			}
			set
			{
				if ((this._GioiTinh != value))
				{
					this.OnGioiTinhChanging(value);
					this.SendPropertyChanging();
					this._GioiTinh = value;
					this.SendPropertyChanged("GioiTinh");
					this.OnGioiTinhChanged();
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_DiaChi", DbType="NVarChar(100)")]
		public string DiaChi
		{
			get
			{
				return this._DiaChi;
			}
			set
			{
				if ((this._DiaChi != value))
				{
					this.OnDiaChiChanging(value);
					this.SendPropertyChanging();
					this._DiaChi = value;
					this.SendPropertyChanged("DiaChi");
					this.OnDiaChiChanged();
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_MaLop", DbType="VarChar(10)")]
		public string MaLop
		{
			get
			{
				return this._MaLop;
			}
			set
			{
				if ((this._MaLop != value))
				{
					if (this._LOP.HasLoadedOrAssignedValue)
					{
						throw new System.Data.Linq.ForeignKeyReferenceAlreadyHasValueException();
					}
					this.OnMaLopChanging(value);
					this.SendPropertyChanging();
					this._MaLop = value;
					this.SendPropertyChanged("MaLop");
					this.OnMaLopChanged();
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_Hinh", DbType="NVarChar(100)")]
		public string Hinh
		{
			get
			{
				return this._Hinh;
			}
			set
			{
				if ((this._Hinh != value))
				{
					this.OnHinhChanging(value);
					this.SendPropertyChanging();
					this._Hinh = value;
					this.SendPropertyChanged("Hinh");
					this.OnHinhChanged();
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.AssociationAttribute(Name="LOP_SINHVIEN", Storage="_LOP", ThisKey="MaLop", OtherKey="MaLop", IsForeignKey=true)]
		public LOP LOP
		{
			get
			{
				return this._LOP.Entity;
			}
			set
			{
				LOP previousValue = this._LOP.Entity;
				if (((previousValue != value) 
							|| (this._LOP.HasLoadedOrAssignedValue == false)))
				{
					this.SendPropertyChanging();
					if ((previousValue != null))
					{
						this._LOP.Entity = null;
						previousValue.SINHVIENs.Remove(this);
					}
					this._LOP.Entity = value;
					if ((value != null))
					{
						value.SINHVIENs.Add(this);
						this._MaLop = value.MaLop;
					}
					else
					{
						this._MaLop = default(string);
					}
					this.SendPropertyChanged("LOP");
				}
			}
		}
		
		public event PropertyChangingEventHandler PropertyChanging;
		
		public event PropertyChangedEventHandler PropertyChanged;
		
		protected virtual void SendPropertyChanging()
		{
			if ((this.PropertyChanging != null))
			{
				this.PropertyChanging(this, emptyChangingEventArgs);
			}
		}
		
		protected virtual void SendPropertyChanged(String propertyName)
		{
			if ((this.PropertyChanged != null))
			{
				this.PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
			}
		}
	}
	
	[global::System.Data.Linq.Mapping.TableAttribute(Name="dbo.LOP")]
	public partial class LOP : INotifyPropertyChanging, INotifyPropertyChanged
	{
		
		private static PropertyChangingEventArgs emptyChangingEventArgs = new PropertyChangingEventArgs(String.Empty);
		
		private string _MaLop;
		
		private string _TenLop;
		
		private string _MaKhoaHoc;
		
		private string _MaKhoa;
		
		private string _MaCT;
		
		private System.Nullable<int> _SoThuTu;
		
		private EntitySet<SINHVIEN> _SINHVIENs;
		
    #region Extensibility Method Definitions
    partial void OnLoaded();
    partial void OnValidate(System.Data.Linq.ChangeAction action);
    partial void OnCreated();
    partial void OnMaLopChanging(string value);
    partial void OnMaLopChanged();
    partial void OnTenLopChanging(string value);
    partial void OnTenLopChanged();
    partial void OnMaKhoaHocChanging(string value);
    partial void OnMaKhoaHocChanged();
    partial void OnMaKhoaChanging(string value);
    partial void OnMaKhoaChanged();
    partial void OnMaCTChanging(string value);
    partial void OnMaCTChanged();
    partial void OnSoThuTuChanging(System.Nullable<int> value);
    partial void OnSoThuTuChanged();
    #endregion
		
		public LOP()
		{
			this._SINHVIENs = new EntitySet<SINHVIEN>(new Action<SINHVIEN>(this.attach_SINHVIENs), new Action<SINHVIEN>(this.detach_SINHVIENs));
			OnCreated();
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_MaLop", DbType="VarChar(10) NOT NULL", CanBeNull=false, IsPrimaryKey=true)]
		public string MaLop
		{
			get
			{
				return this._MaLop;
			}
			set
			{
				if ((this._MaLop != value))
				{
					this.OnMaLopChanging(value);
					this.SendPropertyChanging();
					this._MaLop = value;
					this.SendPropertyChanged("MaLop");
					this.OnMaLopChanged();
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_TenLop", DbType="NVarChar(50)")]
		public string TenLop
		{
			get
			{
				return this._TenLop;
			}
			set
			{
				if ((this._TenLop != value))
				{
					this.OnTenLopChanging(value);
					this.SendPropertyChanging();
					this._TenLop = value;
					this.SendPropertyChanged("TenLop");
					this.OnTenLopChanged();
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_MaKhoaHoc", DbType="VarChar(10)")]
		public string MaKhoaHoc
		{
			get
			{
				return this._MaKhoaHoc;
			}
			set
			{
				if ((this._MaKhoaHoc != value))
				{
					this.OnMaKhoaHocChanging(value);
					this.SendPropertyChanging();
					this._MaKhoaHoc = value;
					this.SendPropertyChanged("MaKhoaHoc");
					this.OnMaKhoaHocChanged();
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_MaKhoa", DbType="VarChar(10)")]
		public string MaKhoa
		{
			get
			{
				return this._MaKhoa;
			}
			set
			{
				if ((this._MaKhoa != value))
				{
					this.OnMaKhoaChanging(value);
					this.SendPropertyChanging();
					this._MaKhoa = value;
					this.SendPropertyChanged("MaKhoa");
					this.OnMaKhoaChanged();
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_MaCT", DbType="VarChar(10)")]
		public string MaCT
		{
			get
			{
				return this._MaCT;
			}
			set
			{
				if ((this._MaCT != value))
				{
					this.OnMaCTChanging(value);
					this.SendPropertyChanging();
					this._MaCT = value;
					this.SendPropertyChanged("MaCT");
					this.OnMaCTChanged();
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.ColumnAttribute(Storage="_SoThuTu", DbType="Int")]
		public System.Nullable<int> SoThuTu
		{
			get
			{
				return this._SoThuTu;
			}
			set
			{
				if ((this._SoThuTu != value))
				{
					this.OnSoThuTuChanging(value);
					this.SendPropertyChanging();
					this._SoThuTu = value;
					this.SendPropertyChanged("SoThuTu");
					this.OnSoThuTuChanged();
				}
			}
		}
		
		[global::System.Data.Linq.Mapping.AssociationAttribute(Name="LOP_SINHVIEN", Storage="_SINHVIENs", ThisKey="MaLop", OtherKey="MaLop")]
		public EntitySet<SINHVIEN> SINHVIENs
		{
			get
			{
				return this._SINHVIENs;
			}
			set
			{
				this._SINHVIENs.Assign(value);
			}
		}
		
		public event PropertyChangingEventHandler PropertyChanging;
		
		public event PropertyChangedEventHandler PropertyChanged;
		
		protected virtual void SendPropertyChanging()
		{
			if ((this.PropertyChanging != null))
			{
				this.PropertyChanging(this, emptyChangingEventArgs);
			}
		}
		
		protected virtual void SendPropertyChanged(String propertyName)
		{
			if ((this.PropertyChanged != null))
			{
				this.PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
			}
		}
		
		private void attach_SINHVIENs(SINHVIEN entity)
		{
			this.SendPropertyChanging();
			entity.LOP = this;
		}
		
		private void detach_SINHVIENs(SINHVIEN entity)
		{
			this.SendPropertyChanging();
			entity.LOP = null;
		}
	}
}
#pragma warning restore 1591
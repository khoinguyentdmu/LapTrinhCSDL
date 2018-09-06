--1----------------------------------------------------------------------
GO
CREATE PROC sp_ThongtinDocGia (@ma_DocGia CHAR(4)) 
AS 
BEGIN
	-- Nếu "mã độc giả" là trẻ em
	IF EXISTS (SELECT 1 FROM TreEm WHERE TreEm.ma_DocGia = @ma_DocGia)
		SELECT * 
		FROM DocGia, TreEm
		WHERE TreEm.ma_DocGia = DocGia.ma_DocGia AND DocGia.ma_DocGia = @ma_DocGia
	ELSE
		SELECT * 
		FROM DocGia, NguoiLon
		WHERE NguoiLon.ma_DocGia = DocGia.ma_DocGia AND DocGia.ma_DocGia = @ma_DocGia
END

GO
EXEC sp_ThongtinDocGia 'D006'

--2----------------------------------------------------------------------
GO
CREATE PROC sp_ThongtinDausach
AS
BEGIN
	SELECT DauSach.isbn, DauSach.ma_tuasach, DauSach.ngonngu, DauSach.bia, DauSach.trangthai, TuaSach.ma_tuasach, TuaSach.tacgia, TuaSach.tomtat, TuaSach.tuasach, COUNT(CuonSach.ma_cuonsach) AS 'SL'
	FROM DauSach, CuonSach, TuaSach
	WHERE DauSach.isbn = CuonSach.isbn AND CuonSach.tinhtrang = 'yes' AND TuaSach.ma_tuasach = DauSach.ma_tuasach
	GROUP BY DauSach.isbn, DauSach.ma_tuasach, DauSach.ngonngu, DauSach.bia, DauSach.trangthai, TuaSach.ma_tuasach, TuaSach.tacgia, TuaSach.tomtat, TuaSach.tuasach
END

GO
EXEC sp_ThongtinDausach

--3----------------------------------------------------------------------
GO
CREATE PROC sp_ThongtinNguoilonDangmuon
AS
BEGIN
	SELECT DocGia.*, NguoiLon.*
	FROM DocGia, NguoiLon
	WHERE DocGia.ma_DocGia = NguoiLon.ma_DocGia AND DocGia.ma_DocGia IN (SELECT Muon.ma_DocGia FROM Muon)
END

GO
EXEC sp_ThongtinNguoilonDangmuon

--4----------------------------------------------------------------------
GO
CREATE PROC sp_ThongtinNguoilonQuahan
AS
BEGIN
	SELECT DocGia.*, NguoiLon.*
	FROM DocGia, NguoiLon
	WHERE DocGia.ma_DocGia = NguoiLon.ma_DocGia 
	AND DocGia.ma_DocGia IN (SELECT Muon.ma_DocGia FROM Muon WHERE Muon.ngay_hethan <= GETDATE())
END

GO
EXEC sp_ThongtinNguoilonQuahan

--5----------------------------------------------------------------------
GO
CREATE PROC sp_DocGiaCoTreEmMuon
AS
BEGIN
	SELECT DocGia.*, NguoiLon.*
	FROM DocGia, NguoiLon
	WHERE DocGia.ma_DocGia = NguoiLon.ma_DocGia 
	AND DocGia.ma_DocGia IN (SELECT Muon.ma_DocGia FROM Muon)	-- DS "mã đọc giả người lớn" mượn
	AND DocGia.ma_DocGia IN (
								-- DS "mã đọc giả người lớn có trẻ em mượn"
								SELECT TreEm.ma_DocGia_nguoilon FROM TreEm
								WHERE TreEm.ma_DocGia IN (
															SELECT Muon.ma_DocGia 
															FROM Muon
														)
							)
END

GO
EXEC sp_DocGiaCoTreEmMuon

--6----------------------------------------------------------------------
GO
CREATE PROC sp_CapnhatTrangthaiDausach (@isbn char(20))
AS
BEGIN
	DECLARE @SZ INT = (SELECT COUNT(*)
					FROM CuonSach
					WHERE CuonSach.isbn = @isbn AND CuonSach.tinhtrang = 'yes')
	-- Nếu không tồn tại cuốn sách nào trong thư viện
	IF @SZ = 0
		UPDATE DauSach
		SET DauSach.trangthai = 'no'
		WHERE DauSach.isbn = @isbn
	ELSE
		UPDATE DauSach
		SET DauSach.trangthai = 'yes'
		WHERE DauSach.isbn = @isbn
END

GO
EXEC sp_CapnhatTrangthaiDausach '5-421-41243-1       '

--7----------------------------------------------------------------------
GO
CREATE PROC sp_ThemTuaSach (@tuasach NVARCHAR(50), @tacgia NVARCHAR(50), @tomtat NVARCHAR(50))
AS
BEGIN

	-- Tìm mã tựa sách rỗng
	DECLARE @val CHAR(4), @index INT = 1
	WHILE (1 = 1)
	BEGIN
		SET @val = 'T' + (SELECT RIGHT('00' + CONVERT (VARCHAR, @index), 3))
		-- Nếu tồn tại mã sách rỗng
		IF NOT EXISTS (SELECT 1 FROM TuaSach WHERE TuaSach.ma_tuasach = @val)
			BREAK
		SET @index = @index + 1
	END

	-- Nếu tồn tại bộ 3 thông tin trong CSDL
	IF EXISTS	(
					SELECT 1
					FROM TuaSach
					WHERE TuaSach.tuasach = @tuasach AND TuaSach.tacgia = @tacgia AND TuaSach.tomtat = @tomtat
				)
		PRINT ('Trùng tựa sách rồi!!')
	ELSE
		INSERT INTO TuaSach VALUES (@val, @tuasach, @tacgia, @tomtat)
END

GO
EXEC sp_ThemTuaSach '22s', '2', '3'

--8----------------------------------------------------------------------
GO
CREATE PROC sp_ThemCuonSach (@isbn char(20))
AS
BEGIN
	-- Nếu không tồn tại mã isbn phù hợp
	IF NOT EXISTS (
					SELECT 1
					FROM DauSach
					WHERE DauSach.isbn = @isbn)
		BEGIN
			PRINT('Không tồn tại mã isbn trong CSDL đầu sách')
			RETURN
		END

	-- Tìm ID rỗng
	DECLARE @val CHAR(4), @index INT = 1
	WHILE (1 = 1)
	BEGIN
		SET @val = 'S' + (SELECT RIGHT('00' + CONVERT (VARCHAR, @index), 3))
		-- Nếu tồn tại cuốn sách rỗng
		IF NOT EXISTS (SELECT 1 FROM CuonSach WHERE CuonSach.ma_cuonsach = @val)
			BREAK
		SET @index = @index + 1
	END

	INSERT INTO CuonSach VALUES (@isbn, @val, 'yes')
	
	UPDATE DauSach
	SET DauSach.trangthai = 'yes'
	WHERE DauSach.isbn = @isbn
END

GO
EXEC sp_ThemCuonSach '0-471-41743-1       '


--9----------------------------------------------------------------------
GO
CREATE PROC sp_ThemNguoiLon (@ho NVARCHAR(20), @tenlot NVARCHAR(30), @ten NVARCHAR(20), 
			@ngaysinh DATETIME, @sonha CHAR(10), @duong NVARCHAR(30), @quan NVARCHAR(20), 
			@dienthoai CHAR(15), @han_sd DATETIME)
AS
BEGIN
	-- Tìm mã đọc giả rỗng
	DECLARE @val CHAR(4), @index INT = 1
	WHILE (1 = 1)
	BEGIN
		SET @val = 'D' + (SELECT RIGHT('00' + CONVERT (VARCHAR, @index), 3))
		-- Nếu tồn tại đọc giả rỗng
		IF NOT EXISTS (SELECT 1 FROM DocGia WHERE DocGia.ma_DocGia = @val)
			BREAK
		SET @index = @index + 1
	END
	
	-- Nếu dưới 18 tuổi
	IF DATEDIFF(YEAR, @ngaysinh, GETDATE()) < 18
	BEGIN
		PRINT('Đọc giả này chưa đủ tuổi. Không thể sử dụng Stored Procedure này')
		RETURN
	END

	-- Thêm đọc giả người lớn
	INSERT INTO DocGia VALUES (@val, @ho, @tenlot, @ten, @ngaysinh)
	INSERT INTO NguoiLon VALUES (@val, @sonha, @duong, @quan, @dienthoai, @han_sd)
END

GO
EXEC sp_ThemNguoiLon 'd', 'd', 'd', '2005-10-10', '2', '2', '2', '4', '2018-10-10'

--10----------------------------------------------------------------------
GO
CREATE PROC sp_ThemTreEm (@ho NVARCHAR(20), @tenlot NVARCHAR(30), @ten NVARCHAR(20), 
			@ngaysinh DATETIME, @ma_DocGia_nguoilon char(4))
AS
BEGIN
	--Tìm mã đọc giả rỗng
	DECLARE @val CHAR(4), @index INT = 1
	WHILE (1 = 1)
	BEGIN
		SET @val = 'D' + (SELECT RIGHT('00' + CONVERT (VARCHAR, @index), 3))
		-- Nếu tồn tại đọc giả rỗng
		IF NOT EXISTS (SELECT 1 FROM DocGia WHERE DocGia.ma_DocGia = @val)
			BREAK
		SET @index = @index + 1
	END

	-- Nếu trên 18 tuổi
	IF DATEDIFF(YEAR, @ngaysinh, GETDATE()) >= 18
	BEGIN
		PRINT('Đọc giả này là người lớn. Không thể sử dụng Stored Procedure này')
		RETURN
	END

	-- Nếu mã đọc giả người lớn không hợp lệ
	IF NOT EXISTS (SELECT 1 FROM NguoiLon WHERE NguoiLon.ma_DocGia = @ma_DocGia_nguoilon)
	BEGIN
		PRINT('Mã đọc giả người lớn không đúng')
		RETURN
	END

	DECLARE @CNT INT = (SELECT COUNT(*) FROM NguoiLon, TreEm WHERE NguoiLon.ma_DocGia = TreEm.ma_DocGia_nguoilon AND NguoiLon.ma_DocGia = @ma_DocGia_nguoilon)

	-- Môi đọc giả chỉ bảo lãnh tối đa 2 trẻ em
	IF (@CNT = 2)
	BEGIN
		PRINT('Một đọc giả người lớn không thể bảo lãnh nhiều hơn 2 trẻ em')
		RETURN
	END
	

	--Thêm đọc giả trẻ em
	INSERT INTO DocGia VALUES (@val, @ho, @tenlot, @ten, @ngaysinh)
	INSERT INTO TreEm VALUES (@val, @ma_DocGia_nguoilon)
END

GO
EXEC sp_ThemTreEm 'd', 'd', 'd', '2006-10-10', 'D011'

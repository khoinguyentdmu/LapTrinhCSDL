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
--EXEC sp_ThongtinDocGia 'D006'

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
--EXEC sp_ThongtinDausach

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
--EXEC sp_ThongtinNguoilonDangmuon

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
--EXEC sp_ThongtinNguoilonQuahan

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
--EXEC sp_DocGiaCoTreEmMuon

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
--EXEC sp_CapnhatTrangthaiDausach '5-421-41243-1       '

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
--EXEC sp_ThemTuaSach '22s', '2', '3'

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
--EXEC sp_ThemCuonSach '0-471-41743-1       '


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
--EXEC sp_ThemNguoiLon 'd', 'd', 'd', '2005-10-10', '2', '2', '2', '4', '2018-10-10'

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
--EXEC sp_ThemTreEm 'd', 'd', 'd', '2006-10-10', 'D011'

--11----------------------------------------------------------------------
GO
CREATE PROC sp_XoaDocGia(@madocgia CHAR(4))
AS
BEGIN
BEGIN TRAN
	DECLARE @temp CHAR(4) -- biến tạm
	-- Kiểm tra độc giả có tồn tại hay không
	IF NOT EXISTS (SELECT 1 FROM dbo.DocGia WHERE ma_DocGia = @madocgia)
	BEGIN
	    PRINT('Đọc giả không tồn tại!')
		RETURN
	END
	-- Kiểm tra đọc giả có mượn sách hay không
	IF EXISTS (SELECT 1 FROM dbo.Muon WHERE ma_DocGia = @madocgia)
	BEGIN
	    PRINT('Đọc giả này đang mượn sách, không thể xóa!')
		ROLLBACK TRAN
		RETURN
	END
	-- Kiểm tra mã đọc giả có phải là người lớn
	IF EXISTS (SELECT 1 FROM dbo.NguoiLon WHERE ma_DocGia = @madocgia)
	BEGIN
		-- Kiểm tra đọc giả có bảo lãnh trẻ em nào hay không
	    IF EXISTS (SELECT 1 FROM dbo.TreEm WHERE ma_DocGia_nguoilon = @madocgia)
		BEGIN
		    WHILE EXISTS (SELECT 1 FROM dbo.TreEm WHERE ma_DocGia_nguoilon = @madocgia)
			BEGIN
				SELECT TOP 1 @temp = ma_DocGia FROM dbo.TreEm WHERE ma_DocGia_nguoilon = @madocgia
			    EXEC dbo.sp_XoaDocGia @madocgia = @temp -- char(4)
			END
		END
		DELETE FROM dbo.NguoiLon WHERE ma_DocGia = @madocgia
	END
	ELSE -- Nếu đọc giả là trẻ em
	BEGIN
	    DELETE FROM dbo.TreEm WHERE ma_DocGia = @madocgia
	END
	-- Xóa dữ liệu các bảng còn lại liên quan
	DELETE FROM dbo.QuaTrinhMuon WHERE ma_DocGia = @madocgia
	DELETE FROM dbo.DangKy WHERE ma_DocGia = @madocgia
	DELETE FROM dbo.DocGia WHERE ma_DocGia = @madocgia
COMMIT
END

GO
-- EXEC dbo.sp_XoaDocGia @madocgia = 'D010' -- char(4)

--12----------------------------------------------------------------------
GO
CREATE PROC sp_MuonSach (@isbn CHAR(20), @ma_cuonsach CHAR(4), @ma_DocGia CHAR(4))
AS
BEGIN
	-- Kiểm tra đọc giả có mượn sách cùng đầu sách
	IF EXISTS (SELECT 1 FROM Muon WHERE Muon.isbn = @isbn AND Muon.ma_DocGia = @ma_DocGia)
	BEGIN
		PRINT('Đọc giả này đã mượn đầu sách này')
		RETURN
	END

	-- Giả sử đọc giả là trẻ em -> tìm mã người bảo lãnh
	DECLARE @ma_DocGia_nguoilon CHAR(4)
	SET @ma_DocGia_nguoilon = (SELECT TreEm.ma_DocGia_nguoilon FROM TreEm WHERE TreEm.ma_DocGia = @ma_DocGia)

	-- Số sách mượn của trẻ em + người bảo lãnh hoặc người lớn
	-- Nếu là người lớn ->  @ma_DocGia_nguoilon = NULL -> chỉ đếm số sách của người lớn @ma_DocGia
	DECLARE @sosachmuon_nguoilon_treem INT = (SELECT COUNT(*) FROM Muon WHERE Muon.ma_DocGia = @ma_DocGia OR Muon.ma_DocGia = @ma_DocGia_nguoilon)
	
	-- Kiểm tra đọc giả có được mượn sách
	IF (@sosachmuon_nguoilon_treem >= 5)
	BEGIN
		PRINT('Người lớn hoặc người bảo lãnh đã mượn đủ số lượng cho phép (tối đa 5 cuốn)')
		RETURN
	END

	IF EXISTS (SELECT 1 FROM TreEm WHERE TreEm.ma_DocGia = @ma_DocGia)
		PRINT('tre em')
	ELSE
		PRINT('nguoi lon')
	-- Nếu là trẻ em
	IF @ma_DocGia_nguoilon IS NULL 
	BEGIN
		IF (SELECT COUNT(*) FROM Muon WHERE Muon.ma_DocGia = @ma_DocGia) > 0
		BEGIN
			PRINT('Trẻ em chỉ mượn đc 1 cuốn')
			RETURN
		END
	END

	-- Nếu còn sách trong thư viện
	IF EXISTS (SELECT 1 FROM CuonSach WHERE CuonSach.isbn = @isbn AND CuonSach.ma_cuonsach = @ma_cuonsach AND CuonSach.tinhtrang = 'yes')
	BEGIN
		-- Thêm record vào bảng Muon
		INSERT INTO Muon VALUES (@isbn, @ma_cuonsach, @ma_DocGia, GETDATE(), DATEDIFF(DAY, -14, GETDATE()))
		
		-- Cập nhật trạng thái cuốn sách
		UPDATE CuonSach
		SET CuonSach.tinhtrang = 'no'
		WHERE CuonSach.isbn = @isbn AND CuonSach.ma_cuonsach = @ma_cuonsach

		-- Cập nhật trạng thái đầu sách
		EXEC sp_CapnhatTrangthaiDausach @isbn

		PRINT('Mượn thành công')
	END
	ELSE
	BEGIN
		PRINT('Sách này đã được mượn. Đã đăng ký chờ mượn sách')
		
		-- Đăng ký chờ mượn sách
		INSERT INTO DangKy VALUES (@isbn, @ma_DocGia, GETDATE(), NULL)
	END
END

GO
--EXEC sp_MuonSach '3-410-41043-1       ', 'S009', 'D008'
GO
--EXEC sp_MuonSach '5-421-41243-1       ', 'S018', 'D002'

--13----------------------------------------------------------------------

GO
CREATE PROC sp_TraSach(@idCuonSach CHAR(4))
AS
BEGIN
    DECLARE @ngayhethan DATETIME
	DECLARE @sotienphat INT
	SET @sotienphat = 0
	SELECT @ngayhethan = ngay_hethan FROM dbo.Muon WHERE ma_cuonsach = @idCuonSach
	IF (@ngayhethan < GETDATE())
	BEGIN
		SET @sotienphat = @sotienphat + DATEDIFF(DAY, @ngayhethan, GETDATE()) * 1000
	END
	INSERT INTO dbo.QuaTrinhMuon
	(
	    isbn,
	    ma_cuonsach,
	    ngay_muon,
	    ma_DocGia,
	    ngay_hethan,
	    ngay_tra,
	    tien_muon,
	    tien_datra,
	    tien_datcoc,
	    ghichu
	)
	VALUES
	(   (SELECT isbn FROM dbo.Muon WHERE ma_cuonsach = @idCuonSach),        -- isbn - char(20)
	    @idCuonSach,        -- ma_cuonsach - char(4)
	    (SELECT ngay_muon FROM dbo.Muon WHERE ma_cuonsach = @idCuonSach), -- ngay_muon - datetime
	    (SELECT ma_DocGia FROM dbo.Muon WHERE ma_cuonsach = @idCuonSach),        -- ma_DocGia - char(4)
	    (SELECT ngay_hethan FROM dbo.Muon WHERE ma_cuonsach = @idCuonSach), -- ngay_hethan - datetime
	    GETDATE(), -- ngay_tra - datetime
	    @sotienphat,         -- tien_muon - int
	    @sotienphat - 1000,         -- tien_datra - int
	    1000,         -- tien_datcoc - int
	    N''        -- ghichu - nvarchar(50)
	    )
	DELETE FROM dbo.Muon WHERE ma_cuonsach = @idCuonSach
END

GO
EXEC dbo.sp_TraSach @idCuonSach = 'S002' -- char(4)

--14-------------------------------------------------------------
GO
CREATE TRIGGER tg_delMuon ON Muon
FOR DELETE 
AS
BEGIN
	DECLARE @ma_cuonsach CHAR(4) = (SELECT deleted.ma_cuonsach FROM deleted)
	UPDATE CuonSach
	SET CuonSach.tinhtrang = 'yes'
	WHERE CuonSach.ma_cuonsach = @ma_cuonsach
END

--15----------------------------------------------------------------------
GO
CREATE TRIGGER tg_insMuon ON Muon
FOR INSERT
AS
BEGIN
	DECLARE @ma_cuonsach CHAR(4) = (SELECT inserted.ma_cuonsach FROM inserted)
	UPDATE CuonSach
	SET CuonSach.tinhtrang = 'no'
	WHERE CuonSach.ma_cuonsach = @ma_cuonsach
END

--16----------------------------------------------------------------------
GO
CREATE TRIGGER tg_updCuonSachUPDATE ON CuonSach
FOR UPDATE
AS
BEGIN
	DECLARE @CNT INT, @isbn CHAR(20) = (SELECT inserted.isbn FROM inserted)
	SET @CNT = (SELECT COUNT(*) FROM CuonSach WHERE CuonSach.isbn = @isbn AND CuonSach.tinhtrang = 'yes')
	IF (@CNT = 0)
		UPDATE DauSach
		SET DauSach.trangthai = 'no'
		WHERE DauSach.isbn = @isbn
	ELSE
		UPDATE DauSach
		SET DauSach.trangthai = 'yes'
		WHERE DauSach.isbn = @isbn
END